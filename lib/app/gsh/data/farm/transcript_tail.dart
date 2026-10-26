import 'dart:convert';

import 'package:gsh_desktop/app/gsh/domain/entities/farm_loop.dart';

/// Estado incremental de **um** transcript JSONL do Claude Code
/// (`~/.claude/projects/<proj>/<sid>.jsonl` ou `.../<sid>/subagents/agent-<id>.jsonl`).
///
/// Só objetos Dart puros: a leitura de um bloco grande roda em `Isolate.run`,
/// que copia este estado de ida e volta.
class TranscriptTail {
  TranscriptTail({required this.isSubagent});

  final bool isSubagent;

  /// Bytes já consumidos do arquivo (sempre num fim de linha).
  int offset = 0;

  String? title;
  String? firstPrompt;
  String? cwd;
  FarmActivity activity = FarmActivity.idle;
  String? tool;
  int outputTokens = 0;
  int contextTokens = 0;
  int inputTokens = 0;
  int cacheReadTokens = 0;
  DateTime? lastTs;

  /// `message.model` da última resposta real (sem as `<synthetic>`).
  String? model;

  /// Time e nome do colega, se esta sessão é de um teammate: no time
  /// implícito do Claude 5 o colega roda numa sessão própria e marca toda
  /// linha com `teamName`/`agentName`.
  String? teamName, agentName;

  /// Time do último colega que esta sessão (o lead) criou, lido do
  /// resultado do spawn (`agent_id: <nome>@<time>`). Cada retomada da sessão
  /// cria um time novo: vale o último (as gerações antigas não ligam mais).
  String? spawnedTeam;

  // O Claude grava uma linha por bloco de conteúdo da mesma mensagem, todas
  // com o mesmo `usage`. Conta o `output_tokens` uma vez por mensagem: segura
  // a mensagem corrente e só soma quando o id muda.
  String? _msgId;
  int _msgOut = 0;
  int _msgIn = 0;
  int _msgCache = 0;

  int get totalOutputTokens => outputTokens + _msgOut;
  int get totalInputTokens => inputTokens + _msgIn;
  int get totalCacheReadTokens => cacheReadTokens + _msgCache;

  /// Consome as linhas completas de [bytes] e avança [offset]. O resto (linha
  /// pela metade, ainda sendo escrita) fica para a próxima leitura.
  void consume(List<int> bytes) {
    final end = bytes.lastIndexOf(0x0A);
    if (end < 0) return;
    final complete = utf8.decode(
      bytes.sublist(0, end + 1),
      allowMalformed: true,
    );
    offset += end + 1;
    for (final line in const LineSplitter().convert(complete)) {
      if (line.isEmpty) continue;
      final Object? o;
      try {
        o = jsonDecode(line);
      } on FormatException {
        continue;
      }
      if (o is Map<String, dynamic>) apply(o);
    }
  }

  /// Aplica uma entrada do transcript.
  void apply(Map<String, dynamic> o) {
    // Só turno conta como atividade: título, anexos e metadados que o Claude
    // regrava no meio de uma espera não podem "acordar" o loop nem apagar um
    // pedido de permissão pendente.
    final type = o['type'];
    final ts = type == 'assistant' || type == 'user'
        ? DateTime.tryParse(o['timestamp'] as String? ?? '')
        : null;
    if (ts != null && (lastTs == null || ts.isAfter(lastTs!))) lastTs = ts;
    final c = o['cwd'];
    if (c is String && c.isNotEmpty) cwd = c;
    final team = type == 'assistant' || type == 'user'
        ? _str(o['teamName'])
        : null;
    if (team != null) {
      teamName = team;
      agentName = _str(o['agentName']) ?? agentName;
    }

    switch (o['type']) {
      case 'custom-title':
        title = _str(o['customTitle']) ?? title;
      case 'agent-name':
        title ??= _str(o['agentName']);
      case 'assistant':
        // Transcript principal de versões antigas trazia o subagente
        // inline; o do teammate é sidechain do começo ao fim (e marcado).
        if (!isSubagent && o['isSidechain'] == true && team == null) return;
        _assistant(o['message']);
      case 'user':
        if (!isSubagent && o['isSidechain'] == true && team == null) return;
        _user(o);
    }
  }

  void _assistant(Object? msg) {
    if (msg is! Map) return;
    final usage = msg['usage'];
    if (usage is Map) {
      final id = msg['id'] as String?;
      if (id != _msgId) {
        outputTokens += _msgOut;
        inputTokens += _msgIn;
        cacheReadTokens += _msgCache;
        _msgId = id;
      }
      _msgOut = _int(usage['output_tokens']);
      _msgIn =
          _int(usage['input_tokens']) +
          _int(usage['cache_creation_input_tokens']);
      _msgCache = _int(usage['cache_read_input_tokens']);
      final ctx =
          _int(usage['input_tokens']) +
          _int(usage['cache_read_input_tokens']) +
          _int(usage['cache_creation_input_tokens']);
      // uso zerado (erro de API, interrupção) não é notícia: não apaga a barra
      if (ctx > 0) contextTokens = ctx;
      final m = msg['model'];
      if (m is String && m.isNotEmpty && !m.startsWith('<')) model = m;
    }
    final content = msg['content'];
    final last = content is List && content.isNotEmpty ? content.last : null;
    if (last is Map && last['type'] == 'tool_use') {
      tool = last['name'] as String? ?? '';
      activity = farmActivityForTool(tool!);
    } else if (msg['stop_reason'] == 'end_turn') {
      tool = null;
      activity = FarmActivity.idle;
    } else {
      tool = null;
      activity = FarmActivity.thinking;
    }
  }

  void _user(Map<String, dynamic> o) {
    final content = (o['message'] as Map?)?['content'];
    if (content is String) {
      if (content.startsWith('[Request interrupted')) {
        activity = FarmActivity.idle;
        tool = null;
        return;
      }
      if (o['isMeta'] != true && !content.startsWith('<')) {
        firstPrompt ??= content.trim();
        activity = FarmActivity.thinking;
        tool = null;
      }
      return;
    }
    if (content is List) {
      final interrupted = content.any(
        (b) =>
            b is Map &&
            b['type'] == 'text' &&
            (b['text'] as String? ?? '').startsWith('[Request interrupted'),
      );
      if (interrupted) {
        activity = FarmActivity.idle;
        tool = null;
      } else if (content.any((b) => b is Map && b['type'] == 'tool_result')) {
        if (!isSubagent) _spawns(content);
        // Ferramenta voltou: o modelo está processando o resultado.
        activity = FarmActivity.thinking;
        tool = null;
      }
    }
  }
}

/// Janela de contexto do modelo do Claude, pelo id (`message.model`). O
/// transcript diz o uso, nunca o limite: `[1m]` no id ou a linha atual
/// (Opus/Sonnet 4.6+, Opus/Sonnet 5.x, Fable, Mythos) têm 1M; Haiku, os
/// antigos e o que não se reconhece ficam com 200k (o [FarmLoop.window]
/// alarga se o contexto passar disso). ponytail: tabela fixa; atualizar
/// quando sair modelo novo com outra janela.
int claudeContextWindow(String? model) {
  if (model == null) return 0;
  final m = model.toLowerCase();
  if (m.contains('[1m]')) return farmLongWindow;
  if (m.contains('haiku')) return farmDefaultWindow;
  return _longLine.hasMatch(m) ? farmLongWindow : farmDefaultWindow;
}

final _longLine = RegExp(
  r'(opus|sonnet)-(4-[6-9]|[5-9])|fable|mythos|^(opus|sonnet)(\[|$)',
);

/// `agent_id: <nome>@<time>` no resultado do spawn de um teammate.
final _spawnedRe = RegExp(r'agent_?id:\s*[^\s@]+@([\w.-]+)');

extension on TranscriptTail {
  /// Lê o time de um spawn de teammate nos resultados de ferramenta (só o
  /// começo de cada um: o spawn é curto, um Read de arquivo não).
  void _spawns(List<Object?> content) {
    for (final b in content) {
      if (b is! Map || b['type'] != 'tool_result') continue;
      final c = b['content'];
      final text = c is String
          ? c
          : c is List
          ? c
                .whereType<Map>()
                .map((x) => x['text'])
                .whereType<String>()
                .join('\n')
          : '';
      final head = text.length > 1200 ? text.substring(0, 1200) : text;
      final m = _spawnedRe.firstMatch(head);
      if (m != null) spawnedTeam = m.group(1);
    }
  }
}

String? _str(Object? v) => v is String && v.trim().isNotEmpty ? v.trim() : null;

int _int(Object? v) => v is int ? v : (v is num ? v.toInt() : 0);
