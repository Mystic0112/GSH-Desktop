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
  DateTime? lastTs;

  // O Claude grava uma linha por bloco de conteúdo da mesma mensagem, todas
  // com o mesmo `usage`. Conta o `output_tokens` uma vez por mensagem: segura
  // a mensagem corrente e só soma quando o id muda.
  String? _msgId;
  int _msgOut = 0;

  int get totalOutputTokens => outputTokens + _msgOut;

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

    switch (o['type']) {
      case 'custom-title':
        title = _str(o['customTitle']) ?? title;
      case 'agent-name':
        title ??= _str(o['agentName']);
      case 'assistant':
        // Transcript principal de versões antigas trazia o subagente inline.
        if (!isSubagent && o['isSidechain'] == true) return;
        _assistant(o['message']);
      case 'user':
        if (!isSubagent && o['isSidechain'] == true) return;
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
        _msgId = id;
      }
      _msgOut = _int(usage['output_tokens']);
      contextTokens =
          _int(usage['input_tokens']) +
          _int(usage['cache_read_input_tokens']) +
          _int(usage['cache_creation_input_tokens']);
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
        // Ferramenta voltou: o modelo está processando o resultado.
        activity = FarmActivity.thinking;
        tool = null;
      }
    }
  }
}

String? _str(Object? v) => v is String && v.trim().isNotEmpty ? v.trim() : null;

int _int(Object? v) => v is int ? v : (v is num ? v.toInt() : 0);
