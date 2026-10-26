import 'dart:convert';
import 'dart:io';

import 'package:gsh_desktop/app/core/data/claude/claude_files.dart';
import 'package:gsh_desktop/app/core/data/claude/claude_info_parsers.dart';
import 'package:gsh_desktop/app/core/domain/entities/claude_info.dart';
import 'package:gsh_desktop/app/gsh/domain/contracts/harness_source.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/project_harness.dart';
import 'package:path/path.dart' as p;

/// [HarnessSource] do Claude Code, lendo os arquivos direto (sem CLI, rápido):
///
/// - instruções: `CLAUDE.md` do usuário e do projeto para cima (a subida do
///   Claude Code), `CLAUDE.local.md`, e `AGENTS.md` (Codex e outros);
/// - `skills/*/SKILL.md`, `agents/*.md`, `commands/**/*.md` do usuário e do
///   projeto;
/// - hooks e permissões de `settings.json` (usuário e projeto) e
///   `settings.local.json`;
/// - MCP: `.mcp.json` (projeto), `~/.claude.json` (usuário e local por pasta).
class ClaudeHarnessSource implements HarnessSource {
  ClaudeHarnessSource({String? home})
    : _home =
          home ??
          Platform.environment['HOME'] ??
          Platform.environment['USERPROFILE'] ??
          '';

  final String _home;

  String get _userClaude => p.join(_home, '.claude');

  @override
  Future<ProjectHarness> read(String workspace) async {
    final files = ClaudeFiles(_home);
    final proj = p.join(workspace, '.claude');
    return ProjectHarness([
      ...await _memory(files, workspace),
      for (final s in await files.skills(const [], workspace))
        if (s.source != SkillSource.plugin)
          HarnessEntry(
            kind: HarnessKind.skills,
            name: s.name,
            detail: s.description ?? '',
            scope: s.source == SkillSource.user
                ? HarnessScope.user
                : HarnessScope.project,
            path: s.path,
          ),
      ...await _markdowns(
        HarnessKind.agents,
        p.join(proj, 'agents'),
        HarnessScope.project,
      ),
      if (_home.isNotEmpty)
        ...await _markdowns(
          HarnessKind.agents,
          p.join(_userClaude, 'agents'),
          HarnessScope.user,
        ),
      ...await _markdowns(
        HarnessKind.commands,
        p.join(proj, 'commands'),
        HarnessScope.project,
      ),
      if (_home.isNotEmpty)
        ...await _markdowns(
          HarnessKind.commands,
          p.join(_userClaude, 'commands'),
          HarnessScope.user,
        ),
      for (final (path, scope) in [
        (p.join(proj, 'settings.json'), HarnessScope.project),
        (p.join(proj, 'settings.local.json'), HarnessScope.local),
        if (_home.isNotEmpty)
          (p.join(_userClaude, 'settings.json'), HarnessScope.user),
      ])
        ...settingsEntries(await _json(path), path, scope),
      ...mcpEntries(
        await _json(p.join(workspace, '.mcp.json')),
        p.join(workspace, '.mcp.json'),
        HarnessScope.project,
      ),
      if (_home.isNotEmpty) ...await _claudeJsonMcp(workspace),
    ]);
  }

  @override
  Future<String> create(
    String workspace,
    HarnessKind kind, {
    String? name,
  }) async {
    final slug = harnessSlug(name ?? '');
    final proj = p.join(workspace, '.claude');
    final (path, body) = switch (kind) {
      HarnessKind.memory => (p.join(workspace, 'CLAUDE.md'), _claudeMd),
      HarnessKind.skills => (
        p.join(proj, 'skills', slug, 'SKILL.md'),
        _skillMd(slug),
      ),
      HarnessKind.agents => (
        p.join(proj, 'agents', '$slug.md'),
        _agentMd(slug),
      ),
      HarnessKind.commands => (
        p.join(proj, 'commands', '$slug.md'),
        _commandMd,
      ),
      HarnessKind.hooks ||
      HarnessKind.permissions => (p.join(proj, 'settings.json'), '{\n}\n'),
      HarnessKind.mcp => (
        p.join(workspace, '.mcp.json'),
        '{\n  "mcpServers": {}\n}\n',
      ),
    };
    final f = File(path);
    if (!await f.exists()) {
      await f.parent.create(recursive: true);
      await f.writeAsString(body);
    }
    return path;
  }

  Future<List<HarnessEntry>> _memory(
    ClaudeFiles files,
    String workspace,
  ) async {
    final out = [
      for (final m in await files.memoryFiles(workspace))
        HarnessEntry(
          kind: HarnessKind.memory,
          name: _memoryName(m.path, workspace),
          detail: m.path,
          scope: m.scope == MemoryScope.user
              ? HarnessScope.user
              : p.basename(m.path) == 'CLAUDE.local.md'
              ? HarnessScope.local
              : HarnessScope.project,
          path: m.path,
        ),
    ];
    final agents = File(p.join(workspace, 'AGENTS.md'));
    if (await agents.exists()) {
      out.add(
        HarnessEntry(
          kind: HarnessKind.memory,
          name: 'AGENTS.md',
          detail: agents.path,
          scope: HarnessScope.project,
          path: agents.path,
        ),
      );
    }
    return out;
  }

  /// `CLAUDE.md` do próprio workspace aparece só pelo nome; os de pastas
  /// acima, relativos a ele (`../CLAUDE.md`).
  String _memoryName(String path, String workspace) {
    if (p.isWithin(_userClaude, path)) return '~/.claude/${p.basename(path)}';
    final rel = p.relative(path, from: workspace);
    return rel;
  }

  /// `*.md` de [dir] (comandos: também em subpastas, que viram `pasta:nome`).
  /// Nome e descrição do frontmatter; sem ele, nome do arquivo.
  Future<List<HarnessEntry>> _markdowns(
    HarnessKind kind,
    String dir,
    HarnessScope scope,
  ) async {
    final root = Directory(dir);
    if (!await root.exists()) return const [];
    final out = <HarnessEntry>[];
    try {
      await for (final e in root.list(
        recursive: kind == HarnessKind.commands,
      )) {
        if (e is! File || !e.path.endsWith('.md')) continue;
        final fm = parseFrontmatter(await e.readAsString());
        final base = p
            .withoutExtension(p.relative(e.path, from: dir))
            .replaceAll(p.separator, ':');
        final name = kind == HarnessKind.commands
            ? '/$base'
            : (fm['name'] as String?)?.trim() ?? base;
        out.add(
          HarnessEntry(
            kind: kind,
            name: name,
            detail: (fm['description'] as String?)?.trim() ?? '',
            scope: scope,
            path: e.path,
          ),
        );
      }
    } on FileSystemException {
      return out;
    }
    out.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return out;
  }

  /// `mcpServers` do `~/.claude.json`: do usuário (topo) e os locais desta
  /// pasta (`projects[<workspace>].mcpServers`).
  Future<List<HarnessEntry>> _claudeJsonMcp(String workspace) async {
    final path = p.join(_home, '.claude.json');
    final o = await _json(path);
    if (o is! Map) return const [];
    final projects = o['projects'];
    final local = projects is Map ? projects[workspace] : null;
    return [
      ...mcpEntries(o, path, HarnessScope.user, editable: false),
      ...mcpEntries(local, path, HarnessScope.local, editable: false),
    ];
  }

  static Future<Object?> _json(String path) async {
    try {
      final f = File(path);
      if (!await f.exists()) return null;
      return jsonDecode(await f.readAsString());
    } on Object {
      return null; // JSON inválido ou ilegível: a seção só fica sem ele
    }
  }
}

/// Hooks (`hooks.<Evento>[].hooks[].command`) e permissões
/// (`permissions.allow|ask|deny`) de um `settings.json`.
List<HarnessEntry> settingsEntries(Object? o, String path, HarnessScope scope) {
  if (o is! Map) return const [];
  final out = <HarnessEntry>[];
  final hooks = o['hooks'];
  if (hooks is Map) {
    for (final MapEntry(key: event, value: groups) in hooks.entries) {
      if (groups is! List) continue;
      for (final g in groups.whereType<Map>()) {
        final matcher = (g['matcher'] as String?)?.trim() ?? '';
        for (final h in (g['hooks'] as List? ?? const []).whereType<Map>()) {
          out.add(
            HarnessEntry(
              kind: HarnessKind.hooks,
              name: matcher.isEmpty || matcher == '*'
                  ? '$event'
                  : '$event · $matcher',
              detail: (h['command'] ?? h['url'] ?? h['type'] ?? '').toString(),
              scope: scope,
              path: path,
            ),
          );
        }
      }
    }
  }
  final perms = o['permissions'];
  if (perms is Map) {
    for (final kind in const ['allow', 'ask', 'deny']) {
      for (final rule
          in (perms[kind] as List? ?? const []).whereType<String>()) {
        out.add(
          HarnessEntry(
            kind: HarnessKind.permissions,
            name: rule,
            detail: kind,
            scope: scope,
            path: path,
          ),
        );
      }
    }
  }
  return out;
}

/// Servidores de `mcpServers` (stdio: comando; http/sse: url).
List<HarnessEntry> mcpEntries(
  Object? o,
  String path,
  HarnessScope scope, {
  bool editable = true,
}) {
  final servers = o is Map ? o['mcpServers'] : null;
  if (servers is! Map) return const [];
  return [
    for (final MapEntry(key: name, value: s) in servers.entries)
      if (s is Map)
        HarnessEntry(
          kind: HarnessKind.mcp,
          name: '$name',
          detail: s['url'] is String
              ? '${s['type'] ?? 'http'} · ${s['url']}'
              : [
                  s['command'],
                  ...(s['args'] as List? ?? const []),
                ].whereType<Object>().join(' '),
          scope: scope,
          // ~/.claude.json é o estado do CLI (tokens, histórico): só leitura
          // aqui; mexe-se nele com `claude mcp add/remove`.
          path: editable ? path : null,
        ),
  ];
}

/// Nome digitado → nome de arquivo (`Revisar PR` → `revisar-pr`).
String harnessSlug(String name) {
  final s = name
      .trim()
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9._-]+'), '-')
      .replaceAll(RegExp(r'-+'), '-')
      .replaceAll(RegExp(r'^[-.]+|[-.]+$'), '');
  return s.isEmpty ? 'novo' : s;
}

// Modelos: o mínimo que o Claude Code aceita, com o que preencher.
const _claudeMd = """# Instruções do projeto

Como rodar, testar e o que não fazer neste repositório.
""";

String _skillMd(String name) =>
    """---
name: $name
description: Quando usar esta skill (o agente decide por esta frase).
---

# $name

Passos que o agente segue quando a skill é acionada.
""";

String _agentMd(String name) =>
    """---
name: $name
description: Quando delegar para este subagente.
tools: Read, Grep, Glob
---

Você é o subagente $name. Descreva o papel, o que ele faz e o que devolve.
""";

const _commandMd = """---
description: O que este comando faz.
---

Instruções do comando. Use \$ARGUMENTS para o que vier depois do nome.
""";
