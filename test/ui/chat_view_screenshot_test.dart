import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:gsh_desktop/app/gsh/ui/widgets/chat/chat_slash_menu.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/chat_usage.dart';
import 'package:gsh_desktop/app/gsh/domain/contracts/chat_engine.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/chat_attachment.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/chat_event.dart';
import 'package:gsh_desktop/app/gsh/ui/viewmodels/chat_viewmodel.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/chat/chat_model_usage.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/chat/chat_pane.dart';
import 'package:gsh_desktop/app/core/domain/entities/app_settings.dart';
import 'package:gsh_desktop/i18n/strings.g.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'shot_harness.dart';

class _Engine implements ChatEngine {
  final ctrl = StreamController<ChatEvent>.broadcast();
  final modes = <String>[];
  @override
  Stream<ChatEvent> get events => ctrl.stream;
  @override
  Future<void> send(
    String text, {
    List<ChatAttachment> attachments = const [],
  }) async {}
  @override
  void answerPermission(
    String requestId, {
    required bool allow,
    bool always = false,
    Map<String, dynamic>? input,
    String? message,
  }) {}
  @override
  void setPermissionMode(String mode) => modes.add(mode);

  final models = <String>[];

  @override
  void setModel(String model) => models.add(model);

  @override
  Future<ChatPlanUsage?> planUsage() async => null;
  @override
  void interrupt() {}
  @override
  Future<void> close() async {}
}

class _Factory implements ChatEngineFactory {
  final engine = _Engine();
  @override
  Future<ChatAccountProbe?> probe({bool fresh = false}) async => null;

  @override
  Future<ChatEngine> start({
    required String cwd,
    String? resumeSessionId,
    bool showThinking = false,
    String? model,
  }) async => engine;
  @override
  Future<List<ChatEvent>> history({
    required String cwd,
    required String sessionId,
  }) async => const [];
}

/// Conversa roteirizada: anexos, markdown, ferramentas, duas edições e os
/// três cartões que esperam o usuário.
Future<(ChatController, _Factory)> _script(
  WidgetTester tester,
  Uint8List? png,
) async {
  final f = _Factory();
  final chat = ChatController(f, cwd: '/home/dev/GSH-Desktop')
    ..attachFiles(['/home/dev/GSH-Desktop/notas da reuniao.txt']);
  await chat.send('o chat precisa ficar igual ao print, consegue?');
  void emit(ChatEvent e) => f.engine.ctrl.add(e);
  emit(const ChatReady(sessionId: 's-1', model: 'claude-opus-4-5-20251101'));
  emit(
    const ChatText(
      'Consigo. O que muda no `ChatView`:\n\n'
      '1. Coluna central com **760px** e respiro vertical.\n'
      '2. Ferramentas recolhidas numa linha com `>`.\n'
      '3. Edições agrupadas num cartão só.',
    ),
  );
  var n = 0;
  void tool(String name, Map<String, dynamic> input, {String? result}) {
    final id = 't${n++}';
    emit(ChatToolCall(id: id, name: name, input: input));
    if (result != null) {
      emit(ChatToolResult(toolUseId: id, isError: false, text: result));
    }
  }

  tool('Bash', {
    'command': 'flutter test test/data',
    'description': 'Roda os testes do chat',
  }, result: '00:04 +12: All tests passed!');
  tool('Read', {
    'file_path': '/home/dev/GSH-Desktop/lib/app/gsh/ui/widgets/chat_view.dart',
  }, result: '...');
  tool('Edit', {
    'file_path': '/home/dev/GSH-Desktop/lib/chat_view.dart',
    'old_string': 'a\nb\nc',
    'new_string': 'a\nB\nc\nd\ne',
  }, result: 'ok');
  tool('Write', {
    'file_path': '/home/dev/GSH-Desktop/lib/chat_pane.dart',
    'content': 'class ChatPane {}\n// coluna\n',
  }, result: 'ok');
  emit(const ChatText('Pronto, as duas telas já estão no working tree.'));
  emit(
    const ChatTurnEnd(
      isError: false,
      text: '',
      sessionId: 's-1',
      costUsd: 0.42,
    ),
  );
  await tester.pump();

  if (png != null) chat.attachPastedImage(png);
  await chat.send('entendi, agora faz o resto, igual o print mesmo');
  tool('Bash', {
    'command': 'flutter build linux --debug',
    'description': 'Compila o bundle de debug',
  });
  emit(
    const ChatPermissionAsk(
      requestId: 'r1',
      toolName: 'Write',
      input: {'file_path': '/home/dev/GSH-Desktop/teste.txt', 'content': 'oi'},
      alwaysRule: 'Write(teste.txt)',
    ),
  );
  emit(
    const ChatPermissionAsk(
      requestId: 'p1',
      toolName: 'ExitPlanMode',
      input: {'plan': '## Plano\n\n- Extrair `ChatPane`\n- Agrupar edições'},
    ),
  );
  emit(
    const ChatPermissionAsk(
      requestId: 'q1',
      toolName: 'AskUserQuestion',
      input: {
        'questions': [
          {
            'question': 'Qual modo de permissão por padrão?',
            'header': 'Modo',
            'multiSelect': false,
            'options': [
              {'label': 'Sempre perguntar', 'description': 'Pergunta antes'},
              {'label': 'Editar direto', 'description': 'Só edita direto'},
            ],
          },
        ],
      },
    ),
  );
  await tester.pump();
  return (chat, f);
}

Uint8List? _png() {
  final f = File('${shotDir()}/../images/1.png');
  return f.existsSync() ? f.readAsBytesSync() : null;
}

void main() {
  setUpAll(() async {
    LocaleSettings.setLocale(AppLocale.ptBr);
    await loadShotFonts();
  });

  test('nome curto do modelo', () {
    expect(shortModelName('claude-opus-4-5-20251101'), 'Opus 4.5');
    expect(shortModelName('claude-sonnet-4-20250514'), 'Sonnet 4');
    expect(shortModelName('claude-opus-4-6[1m]'), 'Opus 4.6');
    expect(shortModelName('opus'), 'opus');
    expect(shortModelName(null), 'Claude');
  });

  test('menu do /: ordem e quando some', () {
    const cmds = [
      ChatCommandOption(name: 'escanor', description: 'Backend PHP / Laravel'),
      ChatCommandOption(name: 'agentes-escala', description: 'x'),
      ChatCommandOption(
        name: 'review',
        description: 'Revisa o diff',
        aliases: ['rev'],
      ),
      ChatCommandOption(
        name: 'bulma',
        description: 'Frontend React e escala de UI',
      ),
    ];
    List<String> m(String t, {bool dismissed = false}) => [
      for (final c in slashMatches(t, cmds, dismissed: dismissed)) c.name,
    ];
    expect(m('/esc'), ['escanor', 'agentes-escala', 'bulma']);
    expect(m('/rev'), ['review']);
    expect(m('/'), hasLength(4));
    expect(m('/escanor faz a API'), isEmpty); // já nos argumentos
    expect(m('oi /esc'), isEmpty);
    expect(m('/esc', dismissed: true), isEmpty);
  });

  testWidgets('menu do /: digita, escolhe com seta e Enter completa', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1100, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final chat = ChatController(_Factory(), cwd: '/home/dev/GSH-Desktop')
      ..commands = const [
        ChatCommandOption(
          name: 'escanor',
          description: 'Backend PHP / Laravel',
        ),
        ChatCommandOption(name: 'bulma', description: 'Frontend React'),
        ChatCommandOption(name: 'review', description: 'Revisa o diff'),
      ];
    await tester.pumpWidget(shotHost(ChatPane(chat: chat, branch: 'helio')));
    await tester.pump();
    await tester.tap(find.byType(TextField));
    await tester.enterText(find.byType(TextField), '/');
    await tester.pump();
    expect(find.text('/escanor'), findsOneWidget);
    expect(find.text('/bulma'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.controller!.text, '/bulma ');
    expect(find.text('/escanor'), findsNothing); // menu fechou
    expect(chat.items, isEmpty); // Enter escolheu, não enviou
    chat.dispose();
  });

  testWidgets('conversa: edições agrupadas, ferramenta recolhida, modo', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1100, 990);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final (chat, f) = await _script(tester, null);
    await tester.pumpWidget(shotHost(ChatPane(chat: chat, branch: 'helio')));
    await tester.pump();

    expect(find.text('Editou 2 arquivos'), findsOneWidget);
    expect(find.text('+7'), findsOneWidget); // 5 do Edit + 2 do Write
    expect(find.text('-3'), findsNWidgets(2)); // total e o do Edit
    expect(find.text('Roda os testes do chat'), findsOneWidget);
    expect(find.text('\$ flutter test test/data'), findsNothing);
    await tester.tap(find.text('Roda os testes do chat'));
    await tester.pump();
    expect(find.text('\$ flutter test test/data'), findsOneWidget);

    await tester.tap(find.text('Pedir permissão'));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.text('Planejar').last);
    await tester.pump(const Duration(milliseconds: 300));
    expect(f.engine.modes, ['plan']);
    expect(chat.permissionMode, 'plan');
    chat.dispose();
  });

  testWidgets('preview: PNGs da tela de chat', tags: ['preview'], (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1100, 990);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final (chat, _) = await _script(tester, _png());
    Widget pane(ChatController c) => shotHost(
      RepaintBoundary(
        key: shotKey,
        child: ChatPane(chat: c, branch: 'helio', onRemoteControl: () {}),
      ),
    );
    await tester.pumpWidget(pane(chat));
    final list = find
        .descendant(
          of: find.byType(ListView),
          matching: find.byType(Scrollable),
        )
        .first;
    ScrollPosition pos() => tester.state<ScrollableState>(list).position;

    pos().jumpTo(0);
    await takeShot(tester, 'chat_ui_1');

    await tester.tap(find.text('Roda os testes do chat'));
    await tester.tap(find.text('chat_view.dart'));
    await settleShot(tester);
    await takeShot(tester, 'chat_ui_2');

    pos().jumpTo(pos().maxScrollExtent * 0.45);
    await takeShot(tester, 'chat_ui_3');

    pos().jumpTo(pos().maxScrollExtent);
    if (_png() case final png?) chat.attachPastedImage(png);
    await takeShot(tester, 'chat_ui_4');

    final empty = ChatController(_Factory(), cwd: '/home/dev/GSH-Desktop');
    await tester.pumpWidget(pane(empty));
    await takeShot(tester, 'chat_ui_5');
    chat.dispose();
    empty.dispose();
  });

  testWidgets('preview: raciocínio e estado da sessão', tags: ['preview'], (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1100, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final f = _Factory();
    final chat = ChatController(
      f,
      cwd: '/home/dev/GSH-Desktop',
      view: TranscriptView.thinking,
    );
    await chat.send('1009 é primo?');
    void emit(ChatEvent e) => f.engine.ctrl.add(e);
    emit(const ChatReady(sessionId: 's-1', model: 'claude-opus-5-5'));
    // Texto real do `--thinking-display summarized` (2.1.309).
    emit(
      const ChatThinking(
        'Checking divisibility of 1009 by primes up to its square root — '
        "none of 7, 11, 13, 17, 19, 23 divide evenly, so I'm continuing to "
        'test 29 next.',
      ),
    );
    emit(
      const ChatToolCall(
        id: 't1',
        name: 'Bash',
        input: {
          'command': 'python3 -c "print(all(1009 % p for p in range(2, 32)))"',
          'description': 'Confere com Python',
        },
      ),
    );
    emit(const ChatToolResult(toolUseId: 't1', isError: false, text: 'True'));
    emit(const ChatText('Sim: **1009 é primo**.'));
    emit(const ChatTurnEnd(isError: false, text: '', sessionId: 's-1'));
    emit(
      const ChatSessionClassified(
        ChatSessionState.completed,
        detail: '1009 é primo; conferido até 31',
      ),
    );
    await tester.pump();
    await tester.pumpWidget(
      shotHost(
        RepaintBoundary(
          key: shotKey,
          child: ChatPane(chat: chat, branch: 'helio', showSessionState: true),
        ),
      ),
    );
    expect(find.text('Raciocínio'), findsOneWidget);
    expect(find.text('Concluída'), findsOneWidget);
    await takeShot(tester, 'chat_thinking_1');
    chat.dispose();
  });
}
