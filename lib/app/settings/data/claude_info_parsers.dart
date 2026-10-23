import 'dart:convert';

import 'package:cockpit/app/settings/domain/claude_info.dart';
import 'package:yaml/yaml.dart';

// Parsers puros da saída da CLI `claude` (testados em
// test/data/claude_info_parsers_test.dart). Formatos observados no 2.1.309.

/// `claude auth status --json`:
/// `{"loggedIn":true,"authMethod":"claude.ai","apiProvider":"firstParty",
/// "email":"…","orgId":"…","orgName":"…","subscriptionType":"team",…}`.
ClaudeAccount parseAuthStatus(String stdout) {
  final o = jsonDecode(stdout);
  if (o is! Map) throw const FormatException('auth status: not an object');
  String? s(String k) => o[k] is String ? o[k] as String : null;
  return ClaudeAccount(
    loggedIn: o['loggedIn'] == true,
    authMethod: s('authMethod'),
    apiProvider: s('apiProvider'),
    email: s('email'),
    orgId: s('orgId'),
    orgName: s('orgName'),
    subscriptionType: s('subscriptionType'),
  );
}

/// Corpo (`response.response`) da resposta ao `control_request` `get_usage`:
/// `{subscription_type, rate_limits_available, rate_limits: {five_hour:
/// {utilization, resets_at}, seven_day: {…}, model_scoped: [{display_name,
/// utilization, resets_at}], …}}`.
ClaudeUsage parseUsageReply(Map<String, dynamic> body) {
  final limits = body['rate_limits'];
  final windows = <UsageWindow>[];
  void add(Object? raw, UsageWindowKind kind, [String? label]) {
    if (raw is! Map) return;
    final u = raw['utilization'];
    final r = raw['resets_at'];
    windows.add(
      UsageWindow(
        kind: kind,
        label: label,
        percent: u is num ? u.toDouble() : null,
        resetsAt: r is String ? DateTime.tryParse(r)?.toLocal() : null,
      ),
    );
  }

  if (limits is Map) {
    add(limits['five_hour'], UsageWindowKind.session);
    add(limits['seven_day'], UsageWindowKind.weekly);
    final scoped = limits['model_scoped'];
    if (scoped is List) {
      for (final m in scoped) {
        if (m is! Map) continue;
        final name = m['display_name'];
        add(m, UsageWindowKind.weeklyModel, name is String ? name : null);
      }
    }
  }
  return ClaudeUsage(
    available: body['rate_limits_available'] == true,
    subscriptionType: body['subscription_type'] as String?,
    windows: windows,
  );
}

/// `claude mcp list` (só texto). Uma linha por servidor:
/// `<nome>: <url ou comando> - <glifo> <status>`. O nome pode ter `:` (ex.:
/// `plugin:x:y`), mas não `": "`; o status vem depois do último `" - "`.
List<McpServerInfo> parseMcpList(String stdout) {
  final out = <McpServerInfo>[];
  for (final line in const LineSplitter().convert(stdout)) {
    final dash = line.lastIndexOf(' - ');
    final colon = line.indexOf(': ');
    if (dash < 0 || colon < 0 || colon > dash) continue;
    final raw = line.substring(dash + 3).trim();
    // Tira o glifo (√ ✓ ! × ✗ ⏸) do começo.
    final space = raw.indexOf(' ');
    final text = space > 0 && space <= 2 ? raw.substring(space + 1) : raw;
    out.add(
      McpServerInfo(
        name: line.substring(0, colon).trim(),
        target: line.substring(colon + 2, dash).trim(),
        status: _mcpStatus(text),
        statusText: text,
      ),
    );
  }
  return out;
}

McpStatus _mcpStatus(String text) {
  final t = text.toLowerCase();
  if (t.startsWith('connected')) return McpStatus.connected;
  if (t.contains('needs authentication')) return McpStatus.needsAuth;
  if (t.contains('failed')) return McpStatus.failed;
  if (t.contains('pending')) return McpStatus.pending;
  return McpStatus.unknown;
}

/// `claude plugin list --json`: `[{id, version, scope, enabled, installPath,
/// …}]`.
List<ClaudePluginInfo> parsePluginList(String stdout) {
  final o = jsonDecode(stdout);
  if (o is! List) throw const FormatException('plugin list: not an array');
  return [
    for (final p in o)
      if (p is Map && p['id'] is String)
        ClaudePluginInfo(
          id: p['id'] as String,
          enabled: p['enabled'] == true,
          version: p['version'] as String?,
          scope: p['scope'] as String?,
          installPath: p['installPath'] as String?,
          updatedAt: p['lastUpdated'] is String
              ? DateTime.tryParse(p['lastUpdated'] as String)?.toLocal()
              : null,
        ),
  ];
}

/// `claude plugin marketplace list --json`: `[{name, source, repo,
/// installLocation}]` → nome → pasta local do clone.
Map<String, String> parseMarketplaceList(String stdout) {
  final o = jsonDecode(stdout);
  if (o is! List) throw const FormatException('marketplace list: not an array');
  return {
    for (final m in o)
      if (m is Map && m['name'] is String && m['installLocation'] is String)
        m['name'] as String: m['installLocation'] as String,
  };
}

/// `marketplace.json` de um marketplace: `{name, owner: {name}, plugins:
/// [{name, description, author: {name}, category, …}]}`. O autor cai no dono
/// do marketplace quando o plugin não traz o seu.
List<MarketplacePlugin> parseMarketplaceManifest(
  String json, {
  required String marketplace,
  Set<String> installed = const {},
}) {
  final o = jsonDecode(json);
  if (o is! Map || o['plugins'] is! List) return const [];
  final owner = _authorName(o['owner']);
  return [
    for (final p in o['plugins'] as List)
      if (p is Map && p['name'] is String)
        MarketplacePlugin(
          name: p['name'] as String,
          marketplace: marketplace,
          description: p['description'] as String?,
          author: _authorName(p['author']) ?? owner,
          category: p['category'] as String?,
          installed: installed.contains('${p['name']}@$marketplace'),
        ),
  ];
}

/// `.claude-plugin/plugin.json` de um plugin instalado.
({String? name, String? description, String? author}) parsePluginManifest(
  String json,
) {
  final o = jsonDecode(json);
  if (o is! Map) return (name: null, description: null, author: null);
  return (
    name: o['name'] as String?,
    description: o['description'] as String?,
    author: _authorName(o['author']),
  );
}

String? _authorName(Object? a) => switch (a) {
  {'name': final String n} => n,
  final String n => n,
  _ => null,
};

/// Índice `MEMORY.md` da memória automática: uma linha por memória,
/// `- [Título](arquivo.md) — gancho`. Linhas fora desse formato são ignoradas.
List<({String title, String file, String? hook})> parseMemoryIndex(
  String text,
) {
  final line = RegExp(
    r'^\s*[-*]\s*\[([^\]]+)\]\(([^)]+)\)\s*(?:[—–-]\s*(.*))?$',
  );
  return [
    for (final l in const LineSplitter().convert(text))
      if (line.firstMatch(l) case final m?)
        (
          title: m.group(1)!.trim(),
          file: m.group(2)!.trim(),
          hook: (m.group(3)?.trim().isEmpty ?? true)
              ? null
              : m.group(3)!.trim(),
        ),
  ];
}

/// `name`/`description` do frontmatter YAML de um `SKILL.md`.
({String? name, String? description}) parseSkillFrontmatter(String content) {
  final fm = parseFrontmatter(content);
  return (name: _clean(fm['name']), description: _clean(fm['description']));
}

/// Tipo de uma memória automática: `type:` no topo ou em `metadata:`.
String? parseMemoryType(String content) {
  final fm = parseFrontmatter(content);
  final meta = fm['metadata'];
  return _clean(fm['type']) ?? (meta is Map ? _clean(meta['type']) : null);
}

String? _clean(Object? v) {
  if (v is! String) return null;
  final s = v.trim();
  return s.isEmpty ? null : s;
}

/// Frontmatter YAML (`---` … `---`) do começo de um markdown. Muito arquivo
/// tem valor com `: ` sem aspas (YAML inválido), então cai num leitor de
/// `chave: valor` por linha (só o nível de cima) quando o YAML falha.
Map<String, Object?> parseFrontmatter(String content) {
  final text = content.replaceAll('\r\n', '\n');
  if (!text.startsWith('---\n')) return const {};
  final end = text.indexOf('\n---', 4);
  if (end < 0) return const {};
  final block = text.substring(4, end);
  try {
    final y = loadYaml(block);
    if (y is Map) return {for (final e in y.entries) '${e.key}': e.value};
  } on YamlException {
    // cai no leitor por linha abaixo
  }
  final out = <String, Object?>{};
  for (final line in block.split('\n')) {
    final i = line.indexOf(':');
    if (i <= 0 || line.startsWith(' ')) continue;
    var v = line.substring(i + 1).trim();
    if (v.length >= 2 &&
        (v.startsWith('"') && v.endsWith('"') ||
            v.startsWith("'") && v.endsWith("'"))) {
      v = v.substring(1, v.length - 1);
    }
    out[line.substring(0, i).trim()] = v;
  }
  return out;
}
