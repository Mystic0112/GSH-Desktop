import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cockpit/app/cockpit/domain/contracts/chat_engine.dart';
import 'package:cockpit/app/cockpit/domain/entities/chat_event.dart';
import 'package:cockpit/app/core/utils/executable_resolver.dart';

/// Claude Code como motor de chat: `claude -p` com entrada e saída em
/// `stream-json`, e os pedidos de permissão respondidos por nós
/// (`--permission-prompts host`), via `control_request`/`control_response`
/// no mesmo stdin/stdout — o mesmo protocolo que o Agent SDK usa.
///
/// Roda com a assinatura/login de quem usa o GSH: nenhuma chave de API passa
/// por aqui.
class ClaudeStreamEngineFactory implements ChatEngineFactory {
  const ClaudeStreamEngineFactory();

  @override
  Future<ChatEngine> start({
    required String cwd,
    String? resumeSessionId,
  }) async {
    final exe = await resolveExecutable('claude');
    final proc = await Process.start(
      exe,
      [
        '-p',
        '--input-format',
        'stream-json',
        '--output-format',
        'stream-json',
        '--verbose',
        '--permission-prompts',
        'host',
        '--permission-prompt-tool',
        'stdio',
        if (resumeSessionId != null) ...['--resume', resumeSessionId],
      ],
      workingDirectory: cwd,
      environment: _withDirOnPath(exe),
    );
    return ClaudeStreamEngine(proc);
  }
}

/// O `claude` do npm é um script `#!/usr/bin/env node`. Aberto pelo launcher
/// (sem o PATH do shell, ex.: nvm), o `env` não acha o `node`: põe a pasta do
/// executável — onde o nvm/npm deixa os dois — na frente do PATH.
Map<String, String> _withDirOnPath(String exe) {
  final sep = Platform.isWindows ? ';' : ':';
  final dir = File(exe).parent.path;
  final path = Platform.environment['PATH'] ?? '';
  return {'PATH': path.isEmpty ? dir : '$dir$sep$path'};
}

class ClaudeStreamEngine implements ChatEngine {
  ClaudeStreamEngine(this._proc) {
    _proc.stdout
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen(_onLine, onDone: _onDone);
    _proc.stderr.transform(utf8.decoder).transform(const LineSplitter()).listen(
      (l) {
        _stderr.add(l);
        if (_stderr.length > 20) _stderr.removeAt(0);
      },
    );
  }

  final Process _proc;
  final _events = StreamController<ChatEvent>.broadcast();
  final _stderr = <String>[];

  /// `allow` precisa devolver o input da ferramenta (`updatedInput`).
  final _asked = <String, Map<String, dynamic>>{};
  var _closed = false;
  var _seq = 0;

  @override
  Stream<ChatEvent> get events => _events.stream;

  void _onLine(String line) {
    if (line.trim().isEmpty) return;
    final Object? o;
    try {
      o = jsonDecode(line);
    } on FormatException {
      return;
    }
    if (o is! Map<String, dynamic>) return;
    for (final e in parseClaudeStreamLine(o)) {
      if (e is ChatPermissionAsk) _asked[e.requestId] = e.input;
      _events.add(e);
    }
  }

  Future<void> _onDone() async {
    final code = await _proc.exitCode;
    if (!_closed) {
      _events.add(ChatEngineFailed(exitCode: code, stderr: _stderr.join('\n')));
    }
    await _events.close();
  }

  void _write(Map<String, dynamic> msg) {
    if (_closed) return;
    _proc.stdin.writeln(jsonEncode(msg));
  }

  @override
  void send(String text) => _write({
    'type': 'user',
    'message': {'role': 'user', 'content': text},
  });

  @override
  void answerPermission(String requestId, {required bool allow}) {
    final input = _asked.remove(requestId) ?? const <String, dynamic>{};
    _write({
      'type': 'control_response',
      'response': {
        'subtype': 'success',
        'request_id': requestId,
        'response': allow
            ? {'behavior': 'allow', 'updatedInput': input}
            : {'behavior': 'deny', 'message': 'Negado pelo usuário no GSH'},
      },
    });
  }

  @override
  void interrupt() => _write({
    'type': 'control_request',
    'request_id': 'gsh-${++_seq}',
    'request': {'subtype': 'interrupt'},
  });

  @override
  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    await _proc.stdin.close();
    _proc.kill();
  }
}

/// Traduz uma linha do `stream-json` do Claude Code em eventos. Tipos que a
/// conversa não mostra (hooks, rate limit, resumos) viram lista vazia.
List<ChatEvent> parseClaudeStreamLine(Map<String, dynamic> o) {
  switch (o['type']) {
    case 'system' when o['subtype'] == 'init':
      return [
        ChatReady(
          sessionId: o['session_id'] as String? ?? '',
          model: o['model'] as String? ?? '',
        ),
      ];
    case 'assistant':
      final content = (o['message'] as Map?)?['content'];
      if (content is! List) return const [];
      return [
        for (final c in content.whereType<Map>())
          if (c['type'] == 'text' && (c['text'] as String? ?? '').isNotEmpty)
            ChatText(c['text'] as String)
          else if (c['type'] == 'tool_use')
            ChatToolCall(
              id: c['id'] as String? ?? '',
              name: c['name'] as String? ?? '',
              input: (c['input'] as Map?)?.cast<String, dynamic>() ?? const {},
            ),
      ];
    case 'user':
      final content = (o['message'] as Map?)?['content'];
      if (content is! List) return const [];
      return [
        for (final c in content.whereType<Map>())
          if (c['type'] == 'tool_result')
            ChatToolResult(
              toolUseId: c['tool_use_id'] as String? ?? '',
              isError: c['is_error'] == true,
              text: _resultText(c['content']),
            ),
      ];
    case 'control_request':
      final req = o['request'];
      if (req is! Map || req['subtype'] != 'can_use_tool') return const [];
      return [
        ChatPermissionAsk(
          requestId: o['request_id'] as String? ?? '',
          toolName: req['tool_name'] as String? ?? '',
          input: (req['input'] as Map?)?.cast<String, dynamic>() ?? const {},
          description: req['description'] as String?,
        ),
      ];
    case 'result':
      final cost = o['total_cost_usd'];
      return [
        ChatTurnEnd(
          isError: o['is_error'] == true,
          text: o['result'] as String? ?? '',
          sessionId: o['session_id'] as String? ?? '',
          costUsd: cost is num ? cost.toDouble() : null,
        ),
      ];
  }
  return const [];
}

String _resultText(Object? content) {
  if (content is String) return content;
  if (content is List) {
    return content
        .whereType<Map>()
        .where((b) => b['type'] == 'text')
        .map((b) => b['text'])
        .join('\n');
  }
  return '';
}
