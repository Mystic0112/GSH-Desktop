import 'dart:async';

import 'package:gsh_desktop/app/gsh/data/chat/claude_stream_engine.dart';
import 'dart:io';
import 'dart:typed_data';

import 'package:gsh_desktop/app/gsh/domain/contracts/chat_engine.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/chat_attachment.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/chat_event.dart';
import 'package:gsh_desktop/app/gsh/ui/viewmodels/chat_viewmodel.dart';
import 'package:gsh_desktop/app/core/domain/entities/app_settings.dart';
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
  final sentAttachments = <List<ChatAttachment>>[];
  @override
  Future<void> send(
    String text, {
    List<ChatAttachment> attachments = const [],
  }) async {
    sent.add(text);
    sentAttachments.add(attachments);
  }

  final always = <String>[];
  final inputs = <String, Map<String, dynamic>?>{};
  final messages = <String, String?>{};
  final modes = <String>[];
  @override
  void answerPermission(
    String requestId, {
    required bool allow,
    bool always = false,
    Map<String, dynamic>? input,
    String? message,
  }) {
    answers[requestId] = allow;
    inputs[requestId] = input;
    messages[requestId] = message;
    if (always) this.always.add(requestId);
  }

  @override
  void setPermissionMode(String mode) => modes.add(mode);

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
  bool? thinking;
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
    bool showThinking = false,
  }) async {
    resumed = resumeSessionId;
    thinking = showThinking;
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

  group('raciocínio e estado da sessão', () {
    // Formatos reais (2.1.309, `--thinking-display summarized`), enxugados.
    Map<String, dynamic> thinkingDelta(String t) => {
      'type': 'stream_event',
      'event': {
        'type': 'content_block_delta',
        'delta': {'type': 'thinking_delta', 'thinking': t},
      },
    };
    final thinkingBlock = {
      'type': 'assistant',
      'message': {
        'content': [
          {'type': 'thinking', 'thinking': 'Checando 1009.', 'signature': 'x'},
        ],
      },
    };
    Map<String, dynamic> summary(String category) => {
      'type': 'system',
      'subtype': 'post_turn_summary',
      'summarizes_uuid': 'u-1',
      'status_category': category,
      'status_detail': '1009 é primo ',
      'needs_action': '',
      'session_id': 's-1',
    };

    test('parser: thinking, thinking_delta e post_turn_summary', () {
      expect(
        (parseClaudeStreamLine(thinkingDelta('Che')).single
                as ChatThinkingDelta)
            .text,
        'Che',
      );
      expect(
        (parseClaudeStreamLine(thinkingBlock).single as ChatThinking).text,
        'Checando 1009.',
      );
      // Bloco vazio (sem a flag o CLI manda assim) não vira evento.
      expect(
        parseClaudeStreamLine(_toolUse).whereType<ChatThinking>(),
        isEmpty,
      );
      for (final (raw, state) in [
        ('completed', ChatSessionState.completed),
        ('review_ready', ChatSessionState.reviewReady),
        ('blocked', ChatSessionState.blocked),
        ('need_input', ChatSessionState.blocked),
        ('failed', ChatSessionState.failed),
      ]) {
        final e =
            parseClaudeStreamLine(summary(raw)).single as ChatSessionClassified;
        expect((e.state, e.detail), (state, '1009 é primo'));
      }
      expect(parseClaudeStreamLine(summary('outra_coisa')), isEmpty);
    });

    test('Normal: não pede nem mostra raciocínio', () async {
      final f = _FakeFactory();
      final chat = ChatController(f, cwd: '/repo');
      await chat.send('oi');
      f.engine
        ..emit(thinkingDelta('Che'))
        ..emit(thinkingBlock)
        ..emit(_text);
      await Future<void>.delayed(Duration.zero);
      expect(f.thinking, isFalse);
      expect(chat.items.whereType<ChatThinkingItem>(), isEmpty);
    });

    test('Raciocínio: item ao vivo, fechado pelo bloco completo', () async {
      final f = _FakeFactory();
      final chat = ChatController(
        f,
        cwd: '/repo',
        view: TranscriptView.thinking,
      );
      await chat.send('oi');
      f.engine
        ..emit(thinkingDelta('Che'))
        ..emit(thinkingDelta('cando'));
      await Future<void>.delayed(Duration.zero);
      expect(f.thinking, isTrue);
      final live = chat.items.whereType<ChatThinkingItem>().single;
      expect((live.text, live.streaming), ('Checando', true));
      f.engine
        ..emit(thinkingBlock)
        ..emit(_text);
      await Future<void>.delayed(Duration.zero);
      expect((live.text, live.streaming), ('Checando 1009.', false));
      expect(chat.items.last, isA<ChatAssistantItem>());
    });

    test('estado classificado no fim do turno; some no próximo', () async {
      final f = _FakeFactory();
      final chat = ChatController(f, cwd: '/repo');
      await chat.send('oi');
      f.engine
        ..emit(_result)
        ..emit(summary('review_ready'));
      await Future<void>.delayed(Duration.zero);
      expect(chat.sessionState, ChatSessionState.reviewReady);
      expect(chat.sessionStateDetail, '1009 é primo');
      await chat.send('mais uma');
      expect(chat.sessionState, isNull);
    });
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

  test('pergunta do agente: opções escolhidas voltam em answers', () async {
    final f = _FakeFactory();
    final chat = ChatController(f, cwd: '/repo');
    await chat.send('x');
    f.engine.emit({
      'type': 'control_request',
      'request_id': 'q1',
      'request': {
        'subtype': 'can_use_tool',
        'tool_name': 'AskUserQuestion',
        'input': {
          'questions': [
            {
              'question': 'Qual sua cor favorita?',
              'header': 'Cor',
              'multiSelect': false,
              'options': [
                {'label': 'Azul', 'description': 'Cor azul'},
                {'label': 'Verde', 'description': 'Cor verde'},
              ],
            },
          ],
        },
      },
    });
    await Future<void>.delayed(Duration.zero);
    final q = chat.items.whereType<ChatQuestionItem>().single;
    expect(q.questions.single.options.map((o) => o.$1), ['Azul', 'Verde']);
    expect(chat.waitingPermission, isTrue);
    chat.answerQuestions(q, {'Qual sua cor favorita?': 'Verde'});
    expect(f.engine.answers['q1'], isTrue);
    expect(f.engine.inputs['q1']!['answers'], {
      'Qual sua cor favorita?': 'Verde',
    });
    expect(f.engine.inputs['q1']!['questions'], isNotNull);
    expect(chat.waitingPermission, isFalse);
  });

  test(
    'plano: ajuste recusa com a mensagem; modo plano liga no início',
    () async {
      final f = _FakeFactory();
      final chat = ChatController(f, cwd: '/repo')..setPermissionMode('plan');
      await chat.send('planeje');
      expect(f.engine.modes, ['plan']);
      f.engine.emit({
        'type': 'control_request',
        'request_id': 'p1',
        'request': {
          'subtype': 'can_use_tool',
          'tool_name': 'ExitPlanMode',
          'input': {'plan': '# Plano'},
        },
      });
      await Future<void>.delayed(Duration.zero);
      final plan = chat.items.whereType<ChatPlanItem>().single;
      expect(plan.plan, '# Plano');
      chat.refinePlan(plan, 'use final.txt');
      expect(f.engine.answers['p1'], isFalse);
      expect(f.engine.messages['p1'], 'use final.txt');
      f.engine.emit({
        'type': 'system',
        'subtype': 'status',
        'permissionMode': 'default',
      });
      await Future<void>.delayed(Duration.zero);
      expect(chat.permissionMode, 'default');
    },
  );

  group('anexos', () {
    test(
      'imagem e PDF viram blocos; outros arquivos viram @"caminho"',
      () async {
        final dir = await Directory.systemTemp.createTemp('chat');
        addTearDown(() => dir.delete(recursive: true));
        final pdf = File('${dir.path}/a b.pdf')..writeAsBytesSync([1, 2, 3]);
        final png = Uint8List.fromList([9, 9]);
        final content =
            await buildClaudeUserContent('veja', [
                  ChatAttachment.pastedImage(png, name: 'x.png'),
                  ChatAttachment.file(pdf.path),
                  ChatAttachment.file('/repo/notas da reuniao.txt'),
                ])
                as List;
        expect(content[0], {
          'type': 'text',
          'text': 'veja\n\n@"/repo/notas da reuniao.txt"',
        });
        expect(content[1]['type'], 'image');
        expect(content[1]['source']['media_type'], 'image/png');
        expect(content[1]['source']['data'], 'CQk=');
        expect(content[2]['type'], 'document');
        expect(content[2]['source']['data'], 'AQID');
        expect(await buildClaudeUserContent('só texto', const []), 'só texto');
      },
    );

    test('tipo sai da extensão', () {
      expect(ChatAttachment.file('/a/F.JPG').mediaType, 'image/jpeg');
      expect(ChatAttachment.file('/a/b.pdf').kind, ChatAttachmentKind.pdf);
      expect(ChatAttachment.file('/a/Makefile').kind, ChatAttachmentKind.file);
    });

    test('imagem acima do teto é recusada', () async {
      final big = Uint8List(ChatAttachment.maxImageBytes + 1);
      expect(
        () => buildClaudeUserContent('x', [
          ChatAttachment.pastedImage(big, name: 'grande.png'),
        ]),
        throwsA(isA<ChatAttachmentTooLarge>()),
      );
    });

    test('controller: anexos vão no envio e saem do composer', () async {
      final f = _FakeFactory();
      final chat = ChatController(f, cwd: '/repo')
        ..attachFiles(['/repo/a.txt'])
        ..attachPastedImage(Uint8List.fromList([1]));
      expect(chat.attachments, hasLength(2));
      await chat.send('');
      expect(f.engine.sentAttachments.single, hasLength(2));
      expect(chat.attachments, isEmpty);
      final user = chat.items.whereType<ChatUserItem>().single;
      expect(user.attachments.map((a) => a.name), ['a.txt', 'imagem-1.png']);
    });
  });

  test(
    'handOff: fecha o motor e devolve a sessão; no meio do turno não',
    () async {
      final f = _FakeFactory();
      final chat = ChatController(f, cwd: '/repo');
      expect(chat.canHandOff, isFalse);
      await chat.send('oi');
      f.engine.emit(_init);
      await Future<void>.delayed(Duration.zero);
      expect(await chat.handOff(), isNull); // turno em andamento
      f.engine.emit(_result);
      await Future<void>.delayed(Duration.zero);
      expect(chat.canHandOff, isTrue);
      expect(await chat.handOff(), 's-1');
      expect(chat.items.last, isA<ChatNoticeItem>());
    },
  );
}
