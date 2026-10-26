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
    final invalid = <String>[];
    Future<Object?> json(String path) => _json(path, invalid);
    final entries = [
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
            issues: [
              if ((s.description ?? '').trim().isEmpty)
                HarnessIssue.noDescription,
            ],
            alwaysOnChars: listingChars(s.name, s.description),
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
        ...settingsEntries(
          await json(path),
          path,
          scope,
          workspace: workspace,
          home: _home,
        ),
      ...mcpEntries(
        await json(p.join(workspace, '.mcp.json')),
        p.join(workspace, '.mcp.json'),
        HarnessScope.project,
      ),
      if (_home.isNotEmpty) ...await _claudeJsonMcp(workspace),
    ];
    return ProjectHarness(entries, invalidFiles: invalid);
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
    final out = <HarnessEntry>[];
    for (final m in await files.memoryFiles(workspace)) {
      final size = await _length(m.path);
      out.add(
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
          issues: [if (size > maxInstructionChars) HarnessIssue.tooLarge],
          // A instrução inteira entra em todo turno.
          alwaysOnChars: size,
        ),
      );
    }
    final agents = File(p.join(workspace, 'AGENTS.md'));
    if (await agents.exists()) {
      final size = await _length(agents.path);
      out.add(
        HarnessEntry(
          kind: HarnessKind.memory,
          name: 'AGENTS.md',
          detail: agents.path,
          scope: HarnessScope.project,
          path: agents.path,
          issues: [if (size > maxInstructionChars) HarnessIssue.tooLarge],
          // O Claude Code não lê o AGENTS.md (é do Codex e outros): não
          // pesa no turno dele.
        ),
      );
    }
    return out;
  }

  static Future<int> _length(String path) async {
    try {
      return await File(path).length();
    } on FileSystemException {
      return 0;
    }
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
        final desc = (fm['description'] as String?)?.trim() ?? '';
        out.add(
          HarnessEntry(
            kind: kind,
            name: name,
            detail: desc,
            scope: scope,
            path: e.path,
            issues: [
              if (kind == HarnessKind.agents && desc.isEmpty)
                HarnessIssue.noDescription,
            ],
            alwaysOnChars: listingChars(name, desc),
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

  /// JSON de [path]; inválido entra em [invalid] (o Claude Code ignora o
  /// arquivo inteiro sem avisar — o painel avisa).
  static Future<Object?> _json(String path, [List<String>? invalid]) async {
    final f = File(path);
    try {
      if (!await f.exists()) return null;
      return jsonDecode(await f.readAsString());
    } on FormatException {
      invalid?.add(path);
      return null;
    } on FileSystemException {
      return null;
    }
  }
}

/// Hooks (`hooks.<Evento>[].hooks[].command`) e permissões
/// (`permissions.allow|ask|deny`) de um `settings.json`.
List<HarnessEntry> settingsEntries(
  Object? o,
  String path,
  HarnessScope scope, {
  String workspace = '',
  String home = '',
}) {
  if (o is! Map) return const [];
  final out = <HarnessEntry>[];
  final hooks = o['hooks'];
  if (hooks is Map) {
    for (final MapEntry(key: event, value: groups) in hooks.entries) {
      if (groups is! List) continue;
      for (final g in groups.whereType<Map>()) {
        final matcher = (g['matcher'] as String?)?.trim() ?? '';
        for (final h in (g['hooks'] as List? ?? const []).whereType<Map>()) {
          final command = h['command'];
          final script = command is String
              ? hookScriptPath(command, workspace: workspace, home: home)
              : null;
          out.add(
            HarnessEntry(
              kind: HarnessKind.hooks,
              name: matcher.isEmpty || matcher == '*'
                  ? '$event'
                  : '$event · $matcher',
              detail: (h['command'] ?? h['url'] ?? h['type'] ?? '').toString(),
              scope: scope,
              path: path,
              issues: [
                if (script != null && !File(script).existsSync())
                  HarnessIssue.missingScript,
              ],
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

/// Acima disto o Claude Code avisa que o CLAUDE.md pesa na performance.
const maxInstructionChars = 40000;

/// O que um item listado (skill, subagente, comando) põe no contexto de
/// todo turno: nome + descrição, mais a moldura da lista.
int listingChars(String name, String? description) =>
    name.length + (description?.length ?? 0) + 12;

/// Arquivo de script que um hook chama, para conferir se existe. `null` =
/// é um programa do PATH (`gsh`, `npx`...) ou não dá para dizer.
String? hookScriptPath(
  String command, {
  required String workspace,
  required String home,
}) {
  var c = command
      .replaceAll(r'${CLAUDE_PROJECT_DIR}', workspace)
      .replaceAll(r'$CLAUDE_PROJECT_DIR', workspace)
      .trim();
  String take() {
    if (c.isEmpty) return '';
    final q = c[0];
    if (q == '"' || q == "'") {
      final end = c.indexOf(q, 1);
      final t = end < 0 ? c.substring(1) : c.substring(1, end);
      c = end < 0 ? '' : c.substring(end + 1).trim();
      return t;
    }
    final sp = c.indexOf(' ');
    final t = sp < 0 ? c : c.substring(0, sp);
    c = sp < 0 ? '' : c.substring(sp + 1).trim();
    return t;
  }

  var token = take();
  // `bash x.sh`, `node x.js`...: o script é o argumento.
  const interpreters = {
    'bash',
    'sh',
    'zsh',
    'node',
    'python',
    'python3',
    'bun',
    'deno',
  };
  if (interpreters.contains(token)) token = take();
  if (token.isEmpty || token.startsWith('-')) return null;
  if (token.startsWith('~/')) return p.join(home, token.substring(2));
  if (p.isAbsolute(token)) return token;
  // Sem barra é comando do PATH; com barra, relativo à pasta do projeto.
  if (!token.contains('/')) return null;
  return p.normalize(p.join(workspace, token));
}
