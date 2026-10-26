import 'dart:convert';
import 'dart:io';

import 'package:gsh_desktop/app/core/domain/result.dart';
import 'package:gsh_desktop/app/core/data/claude/claude_info_parsers.dart';
import 'package:gsh_desktop/app/core/domain/entities/claude_info.dart';
import 'package:path/path.dart' as p;

/// Leituras do `~/.claude` (e do `.claude` do projeto) que não passam pela
/// CLI: skills, memória, estilos de saída, manifestos de plugin.
class ClaudeFiles {
  const ClaudeFiles(this.home);

  /// `$HOME` (vazio = sem home: nada do usuário é lido).
  final String home;

  String get _claude => p.join(home, '.claude');

  /// `~/.claude/skills`, `<installPath>/skills` de cada plugin habilitado e
  /// `<workspace>/.claude/skills`. Usa o `installPath` da CLI em vez de varrer
  /// `~/.claude/plugins/**`: lá ficam também os clones dos marketplaces e as
  /// versões antigas do cache, que duplicariam a lista.
  Future<List<ClaudeSkillInfo>> skills(
    List<ClaudePluginInfo> plugins,
    String? workspace,
  ) async {
    final out = <ClaudeSkillInfo>[
      if (home.isNotEmpty)
        ...await _skillsIn(p.join(_claude, 'skills'), SkillSource.user),
      for (final pl in plugins)
        if (pl.enabled && pl.installPath != null)
          ...await _skillsIn(
            p.join(pl.installPath!, 'skills'),
            SkillSource.plugin,
            plugin: pl.id,
          ),
      if (workspace != null && workspace.isNotEmpty)
        ...await _skillsIn(
          p.join(workspace, '.claude', 'skills'),
          SkillSource.project,
        ),
    ];
    out.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return out;
  }

  Future<List<ClaudeSkillInfo>> _skillsIn(
    String dir,
    SkillSource source, {
    String? plugin,
  }) async {
    final root = Directory(dir);
    if (!await root.exists()) return const [];
    final out = <ClaudeSkillInfo>[];
    await for (final e in root.list()) {
      final file = File(p.join(e.path, 'SKILL.md'));
      if (!await file.exists()) continue;
      try {
        final fm = parseSkillFrontmatter(await file.readAsString());
        out.add(
          ClaudeSkillInfo(
            name: fm.name ?? p.basename(e.path),
            description: fm.description,
            path: file.path,
            source: source,
            plugin: plugin,
            updatedAt: await file.lastModified(),
          ),
        );
      } on FileSystemException {
        continue;
      }
    }
    return out;
  }

  /// `~/.claude/CLAUDE.md` e, do [workspace] até a raiz, `CLAUDE.md`,
  /// `.claude/CLAUDE.md` e `CLAUDE.local.md` — a mesma subida que o Claude
  /// Code faz ao abrir uma sessão ali.
  Future<List<MemoryFileInfo>> memoryFiles(String? workspace) async {
    final out = <MemoryFileInfo>[];
    final user = userInstructionsPath;
    if (home.isNotEmpty && await File(user).exists()) {
      out.add(MemoryFileInfo(path: user, scope: MemoryScope.user));
    }
    if (workspace == null || workspace.isEmpty) return out;
    var dir = p.normalize(workspace);
    while (true) {
      for (final name in const [
        'CLAUDE.md',
        '.claude/CLAUDE.md',
        'CLAUDE.local.md',
      ]) {
        final f = p.join(dir, name);
        if (f != user && await File(f).exists()) {
          out.add(MemoryFileInfo(path: f, scope: MemoryScope.project));
        }
      }
      final parent = p.dirname(dir);
      if (parent == dir) break;
      dir = parent;
    }
    return out;
  }

  /// Pasta do projeto em `~/.claude/projects`: o cwd com tudo que não é
  /// alfanumérico trocado por `-` (mesma regra do histórico do chat).
  String projectDir(String workspace) => p.join(
    _claude,
    'projects',
    workspace.replaceAll(RegExp('[^A-Za-z0-9]'), '-'),
  );

  Future<List<AutoMemoryEntry>> autoMemory(String? workspace) async {
    if (home.isEmpty || workspace == null || workspace.isEmpty) return const [];
    final dir = p.join(projectDir(workspace), 'memory');
    final index = File(p.join(dir, 'MEMORY.md'));
    if (!await index.exists()) return const [];
    final out = <AutoMemoryEntry>[];
    try {
      for (final m in parseMemoryIndex(await index.readAsString())) {
        final file = File(p.join(dir, m.file));
        final exists = await file.exists();
        out.add(
          AutoMemoryEntry(
            title: m.title,
            hook: m.hook,
            path: file.path,
            type: exists ? parseMemoryType(await file.readAsString()) : null,
            updatedAt: exists ? await file.lastModified() : null,
          ),
        );
      }
    } on FileSystemException {
      return out;
    }
    return out;
  }

  /// Embutidos do CLI + `~/.claude/output-styles/*.md` (nome do frontmatter
  /// ou do arquivo).
  Future<List<String>> outputStyles() async {
    final out = <String>['Explanatory', 'Learning'];
    final dir = Directory(p.join(_claude, 'output-styles'));
    if (home.isEmpty || !await dir.exists()) return out;
    await for (final e in dir.list()) {
      if (e is! File || !e.path.endsWith('.md')) continue;
      try {
        final fm = parseFrontmatter(await e.readAsString());
        final name = fm['name'];
        out.add(
          name is String && name.trim().isNotEmpty
              ? name.trim()
              : p.basenameWithoutExtension(e.path),
        );
      } on FileSystemException {
        continue;
      }
    }
    return out;
  }

  /// `enabledPlugins` (`{"id": true}`) de `<workspace>/.claude/settings.json`.
  Future<List<String>> projectPlugins(String workspace) async {
    final file = File(p.join(workspace, '.claude', 'settings.json'));
    try {
      if (!await file.exists()) return const [];
      final o = jsonDecode(await file.readAsString());
      final enabled = o is Map ? o['enabledPlugins'] : null;
      if (enabled is! Map) return const [];
      return [
        for (final e in enabled.entries)
          if (e.value == true) '${e.key}',
      ];
    } on FileSystemException {
      return const [];
    } on FormatException {
      return const [];
    }
  }

  /// Nome/autor/descrição do `.claude-plugin/plugin.json` de cada plugin.
  Future<List<ClaudePluginInfo>> withManifests(
    List<ClaudePluginInfo> plugins,
  ) async => [for (final pl in plugins) await _withManifest(pl)];

  Future<ClaudePluginInfo> _withManifest(ClaudePluginInfo pl) async {
    final dir = pl.installPath;
    if (dir == null) return pl;
    final file = File(p.join(dir, '.claude-plugin', 'plugin.json'));
    try {
      if (!await file.exists()) return pl;
      final m = parsePluginManifest(await file.readAsString());
      return pl.withManifest(
        displayName: m.name,
        author: m.author,
        description: m.description,
      );
    } on FileSystemException {
      return pl;
    } on FormatException {
      return pl;
    }
  }

  /// Plugins dos `marketplace.json` em cada [locations] (nome → pasta).
  Future<List<MarketplacePlugin>> directory(
    Map<String, String> locations,
    Set<String> installed,
  ) async {
    final out = <MarketplacePlugin>[];
    for (final MapEntry(key: name, value: dir) in locations.entries) {
      final file = File(p.join(dir, '.claude-plugin', 'marketplace.json'));
      try {
        if (!await file.exists()) continue;
        out.addAll(
          parseMarketplaceManifest(
            await file.readAsString(),
            marketplace: name,
            installed: installed,
          ),
        );
      } on FileSystemException {
        continue;
      } on FormatException {
        continue;
      }
    }
    return out;
  }

  String get userInstructionsPath => p.join(_claude, 'CLAUDE.md');

  Future<String> readUserInstructions() async {
    final f = File(userInstructionsPath);
    try {
      return await f.exists() ? await f.readAsString() : '';
    } on FileSystemException {
      return '';
    }
  }

  Future<Result<void, ClaudeInfoError>> writeUserInstructions(
    String text,
  ) async {
    if (home.isEmpty) {
      return const Failure(ClaudeInfoError(ClaudeInfoErrorKind.failed));
    }
    final f = File(userInstructionsPath);
    try {
      await f.parent.create(recursive: true);
      // tmp + rename: o Claude Code nunca lê meio arquivo.
      final tmp = File('${f.path}.gsh-$pid.tmp');
      await tmp.writeAsString(text);
      await tmp.rename(f.path);
      return const Success(null);
    } on FileSystemException catch (e) {
      return Failure(ClaudeInfoError(ClaudeInfoErrorKind.failed, e.message));
    }
  }
}
