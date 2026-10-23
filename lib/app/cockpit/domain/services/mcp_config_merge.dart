import 'dart:convert';

/// Nome da entrada do Cockpit nos configs MCP dos apps desktop. Só ela é
/// escrita; os outros servidores do usuário nunca são tocados.
const String kMcpServerName = 'cockpit';

/// `args` da entrada: `cockpit mcp --agent <app-id>`.
List<String> mcpServerArgs(String appId) => ['mcp', '--agent', appId];

/// Trecho JSON mostrado no dialog: `"cockpit": {...}`.
String jsonMcpEntry({required String command, required List<String> args}) =>
    '"$kMcpServerName": '
    '${const JsonEncoder.withIndent('  ').convert({'command': command, 'args': args})}';

/// Envs que o Codex repassa ao `cockpit mcp` (`env_vars`): sem isto ele limpa
/// o ambiente do servidor MCP. Rodando sob uma aba, o processo herda a
/// identidade e o socket do app daquela aba (o flavor certo); no app desktop
/// elas não existem e o Codex só as ignora.
const List<String> kCodexMcpEnvVars = [
  'COCKPIT_TAB_ID',
  'COCKPIT_STATUS_SOCK',
  'COCKPIT_STATUS_PORT',
  'COCKPIT_STATUS_TOKEN',
];

/// Tabela TOML do Codex (`~/.codex/config.toml`). A mesma entrada serve o app
/// desktop (nó `ext:codex-desktop`) e o Codex CLI das abas: o `cockpit mcp`
/// descobre sozinho se roda sob uma aba.
String tomlMcpEntry({required String command, required List<String> args}) =>
    // String JSON é string básica TOML válida (aspas e `\` escapados).
    '[mcp_servers.$kMcpServerName]\n'
    'command = ${jsonEncode(command)}\n'
    'args = [${args.map(jsonEncode).join(', ')}]\n'
    'env_vars = [${kCodexMcpEnvVars.map(jsonEncode).join(', ')}]\n';

/// Põe `mcpServers.cockpit` = {command, args} no JSON [raw] (`null`/vazio =
/// arquivo novo), preservando todas as outras chaves e a ordem delas. Reindenta
/// com a indentação que o arquivo já usava. Idempotente.
///
/// [FormatException] quando [raw] não é um objeto JSON (JSONC com comentário,
/// lixo): melhor recusar do que reescrever o config do usuário errado.
String mergeJsonMcpServer(
  String? raw, {
  required String command,
  required List<String> args,
}) {
  final blank = raw == null || raw.trim().isEmpty;
  final Object? decoded = blank ? <String, Object?>{} : jsonDecode(raw);
  if (decoded is! Map<String, dynamic>) {
    throw const FormatException('not a JSON object');
  }
  final servers = decoded['mcpServers'] ?? <String, Object?>{};
  if (servers is! Map) {
    throw const FormatException('mcpServers is not an object');
  }
  servers[kMcpServerName] = {'command': command, 'args': args};
  decoded['mcpServers'] = servers;
  final out = JsonEncoder.withIndent(
    blank ? '  ' : _indentOf(raw),
  ).convert(decoded);
  return blank || raw.endsWith('\n') ? '$out\n' : out;
}

/// Indentação da primeira linha indentada; 2 espaços se não houver.
String _indentOf(String raw) {
  for (final line in raw.split('\n').skip(1)) {
    final indent = RegExp(r'^[ \t]+').stringMatch(line);
    if (indent != null) return indent;
  }
  return '  ';
}

final _cockpitHeader = RegExp(
  r'^[ \t]*\[[ \t]*mcp_servers[ \t]*\.[ \t]*"?cockpit"?[ \t]*\][ \t]*(#[^\n]*)?\r?$',
  multiLine: true,
);

// ponytail: linha `[...]` = cabeçalho de tabela; um array multilinha com uma
// linha só `[1, 2]` (sem vírgula) seria confundido — raro em config de MCP.
final _anyHeader = RegExp(
  r'^[ \t]*\[\[?[^\]\n]*\]\]?[ \t]*(#[^\n]*)?\r?$',
  multiLine: true,
);

/// Troca (ou acrescenta no fim) só a tabela `[mcp_servers.cockpit]` do TOML
/// [raw]; todo o resto fica byte a byte igual. Subtabelas do usuário
/// (`[mcp_servers.cockpit.env]`) ficam. Idempotente.
///
/// [FormatException] quando `cockpit` já está definido de outro jeito (chave
/// pontilhada, dentro de `[mcp_servers]`): acrescentar a tabela duplicaria a
/// chave e quebraria o config inteiro.
String mergeTomlMcpServer(
  String? raw, {
  required String command,
  required List<String> args,
}) {
  final text = raw ?? '';
  final table = tomlMcpEntry(command: command, args: args);
  final m = _cockpitHeader.firstMatch(text);
  if (m == null) {
    _rejectOtherDefinitions(text);
    if (text.isEmpty) return table;
    return '$text${text.endsWith('\n') ? '' : '\n'}\n$table';
  }
  final next = _anyHeader.allMatches(text, m.end).firstOrNull;
  final end = _bodyEnd(text, m.end, next?.start ?? text.length);
  return '${text.substring(0, m.start)}$table${text.substring(end)}';
}

/// Fim do corpo da tabela que vai de [from] (fim do cabeçalho) a [to] (próximo
/// cabeçalho): comentários e linhas em branco no fim ficam de fora — são do
/// que vem depois (ex.: o `# >>> cockpit hooks` do bloco de trust, que sumiria
/// e duplicaria o bloco inteiro no próximo boot).
int _bodyEnd(String text, int from, int to) {
  var end = to;
  while (end > from) {
    final lineStart = text.lastIndexOf('\n', end - 2) + 1;
    if (lineStart <= from) break;
    final line = text.substring(lineStart, end).trim();
    if (line.isNotEmpty && !line.startsWith('#')) break;
    end = lineStart;
  }
  return end;
}

void _rejectOtherDefinitions(String text) {
  final dotted = RegExp(
    r'^[ \t]*mcp_servers[ \t]*\.[ \t]*"?cockpit"?[ \t]*[.=]',
    multiLine: true,
  );
  if (dotted.hasMatch(text)) {
    throw const FormatException('mcp_servers.cockpit defined as a dotted key');
  }
  final parent = RegExp(
    r'^[ \t]*\[[ \t]*mcp_servers[ \t]*\][ \t]*(#[^\n]*)?\r?$',
    multiLine: true,
  ).firstMatch(text);
  if (parent == null) return;
  final end = _anyHeader.allMatches(text, parent.end).firstOrNull?.start;
  final body = text.substring(parent.end, end ?? text.length);
  if (RegExp(r'^[ \t]*"?cockpit"?[ \t]*[.=]', multiLine: true).hasMatch(body)) {
    throw const FormatException('cockpit defined inside [mcp_servers]');
  }
}
