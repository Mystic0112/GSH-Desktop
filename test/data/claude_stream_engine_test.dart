import 'dart:async';

import 'package:cockpit/app/cockpit/data/chat/claude_stream_engine.dart';
import 'package:cockpit/app/cockpit/domain/contracts/chat_engine.dart';
import 'package:cockpit/app/cockpit/domain/entities/chat_event.dart';
import 'package:cockpit/app/cockpit/ui/viewmodels/chat_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';

// Formatos reais do `claude -p --output-format stream-json` (2.1.309),
// enxugados.
final _init = {
  'type': 'system',
  'subtype': 'init',
  'session_id': 's-1',
  'model': 'claude-opus-5-5',
};
final _toolUse = {
  'type': 'assistant',
  'message': {
    'content': [
      {'type': 'thinking', 'thinking': ''},
      {
        'type': 'tool_use',
        'id': 'toolu_1',
        'name': 'Bash',
        'input': {'command': 'rm teste.txt', 'description': 'Delete'},
      },
    ],
  },
};
final _ask = {
  'type': 'control_request',
  'request_id': 'req-1',
  'request': {
    'subtype': 'can_use_tool',
    'tool_name': 'Bash',
    'input': {'command': 'rm teste.txt'},
    'description': 'Delete teste.txt file',
  },
};
final _denied = {
  'type': 'user',
  'message': {
    'role': 'user',
    'content': [
      {
        'type': 'tool_result',
        'content': 'Negado pelo usuário no GSH',
        'is_error': true,
        'tool_use_id': 'toolu_1',
      },
    ],
  },
};
final _text = {
  'type': 'assistant',
  'message': {
    'content': [
      {'type': 'text', 'text': 'negado'},
    ],
  },
};
final _result = {
  'type': 'result',
  'subtype': 'success',
  'is_error': false,
  'result': 'negado',
  'session_id': 's-1',
  'total_cost_usd': 0.26,
};

class _FakeEngine implements ChatEngine {
  final ctrl = StreamController<ChatEvent>.broadcast();
  final sent = <String>[];
  final answers = <String, bool>{};

  @override
  Stream<ChatEvent> get events => ctrl.stream;
  @override
  void send(String text) => sent.add(text);
  final always = <String>[];
  @override
  void answerPermission(
    String requestId, {
    required bool allow,
    bool always = false,
  }) {
    answers[requestId] = allow;
    if (always) this.always.add(requestId);
  }

  @override
  void interrupt() {}
  @override
  Future<void> close() async {}

  void emit(Map<String, dynamic> line) {
    for (final e in parseClaudeStreamLine(line)) {
      ctrl.add(e);
    }
  }
}

class _FakeFactory implements ChatEngineFactory {
  final engine = _FakeEngine();
  String? resumed;
  List<ChatEvent> past = const [];
  @override
  Future<List<ChatEvent>> history({
    required String cwd,
    required String sessionId,
  }) async => past;
  @override
  Future<ChatEngine> start({
    required String cwd,
    String? resumeSessionId,
  }) async {
    resumed = resumeSessionId;
    return engine;
  }
}

void main() {
  test('parser traduz as linhas que a conversa usa e ignora o resto', () {
    expect(parseClaudeStreamLine(_init).single, isA<ChatReady>());
    final call = parseClaudeStreamLine(_toolUse).single as ChatToolCall;
    expect(
      (call.id, call.name, call.input['command']),
      ('toolu_1', 'Bash', 'rm teste.txt'),
    );
    final ask = parseClaudeStreamLine(_ask).single as ChatPermissionAsk;
    expect((ask.requestId, ask.toolName), ('req-1', 'Bash'));
    final res = parseClaudeStreamLine(_denied).single as ChatToolResult;
    expect((res.toolUseId, res.isError), ('toolu_1', true));
    final end = parseClaudeStreamLine(_result).single as ChatTurnEnd;
    expect((end.sessionId, end.costUsd), ('s-1', 0.26));
    expect(parseClaudeStreamLine({'type': 'rate_limit_event'}), isEmpty);
    expect(
      parseClaudeStreamLine({'type': 'system', 'subtype': 'hook_started'}),
      isEmpty,
    );
  });

  test('controller: turno com pedido de permissão negado', () async {
    final f = _FakeFactory();
    final chat = ChatController(f, cwd: '/repo');
    await chat.send('apaga o teste.txt');
    expect(chat.busy, isTrue);
    expect(f.engine.sent, ['apaga o teste.txt']);

    for (final l in [_init, _toolUse, _ask]) {
      f.engine.emit(l);
    }
    await Future<void>.delayed(Duration.zero);
    expect(chat.waitingPermission, isTrue);
    final ask = chat.items.whereType<ChatPermissionItem>().single;
    expect(ask.summary, 'rm teste.txt');

    chat.answer(ask, allow: false);
    expect(f.engine.answers, {'req-1': false});
    expect(chat.waitingPermission, isFalse);

    for (final l in [_denied, _text, _result]) {
      f.engine.emit(l);
    }
    await Future<void>.delayed(Duration.zero);
    final tool = chat.items.whereType<ChatToolItem>().single;
    expect((tool.done, tool.isError), (true, true));
    expect(chat.items.last, isA<ChatAssistantItem>());
    expect((chat.busy, chat.sessionId, chat.costUsd), (false, 's-1', 0.26));
  });

  test('texto ao vivo vira um item só, fechado pelo bloco completo', () async {
    final f = _FakeFactory();
    final chat = ChatController(f, cwd: '/repo');
    await chat.send('oi');
    f.engine.emit({
      'type': 'stream_event',
      'event': {
        'type': 'content_block_delta',
        'delta': {'type': 'text_delta', 'text': 'Ol'},
      },
    });
    f.engine.emit({
      'type': 'stream_event',
      'event': {
        'type': 'content_block_delta',
        'delta': {'type': 'text_delta', 'text': 'á!'},
      },
    });
    await Future<void>.delayed(Duration.zero);
    final live = chat.items.whereType<ChatAssistantItem>().single;
    expect((live.text, live.streaming), ('Olá!', true));
    f.engine.emit({
      'type': 'assistant',
      'message': {
        'content': [
          {'type': 'text', 'text': 'Olá!'},
        ],
      },
    });
    await Future<void>.delayed(Duration.zero);
    expect(chat.items.whereType<ChatAssistantItem>().single.streaming, false);
  });

  test(
    'sempre permitir: regra sugerida chega no pedido e na resposta',
    () async {
      final ask =
          parseClaudeStreamLine({
                ..._ask,
                'request': {
                  ...(_ask['request']! as Map),
                  'permission_suggestions': [
                    {
                      'type': 'addRules',
                      'behavior': 'allow',
                      'destination': 'localSettings',
                      'rules': [
                        {'toolName': 'Bash', 'ruleContent': 'rm *'},
                      ],
                    },
                  ],
                },
              }).single
              as ChatPermissionAsk;
      expect(ask.alwaysRule, 'Bash(rm *)');

      final f = _FakeFactory();
      final chat = ChatController(f, cwd: '/repo');
      await chat.send('x');
      f.engine.ctrl.add(ask);
      await Future<void>.delayed(Duration.zero);
      final item = chat.items.whereType<ChatPermissionItem>().single;
      chat.answer(item, allow: true, always: true);
      expect(f.engine.always, ['req-1']);
    expect(item.always, isTrue);
    },
  );

  test('aba restaurada mostra o histórico e retoma a sessão', () async {
    final f = _FakeFactory()
      ..past = const [ChatUserText('antes'), ChatText('resposta antiga')];
    final chat = ChatController(f, cwd: '/repo', resumeSessionId: 's-1');
    await Future<void>.delayed(Duration.zero);
    expect(chat.items.map((i) => i.runtimeType), [
      ChatUserItem,
      ChatAssistantItem,
    ]);
    await chat.send('depois');
    expect(f.resumed, 's-1');
  });
}
