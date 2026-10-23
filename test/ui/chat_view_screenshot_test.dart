import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cockpit/app/cockpit/domain/contracts/chat_engine.dart';
import 'package:cockpit/app/cockpit/domain/entities/chat_attachment.dart';
import 'package:cockpit/app/cockpit/domain/entities/chat_event.dart';
import 'package:cockpit/app/cockpit/ui/viewmodels/chat_viewmodel.dart';
import 'package:cockpit/app/cockpit/ui/widgets/chat/chat_composer.dart';
import 'package:cockpit/app/cockpit/ui/widgets/chat/chat_pane.dart';
import 'package:cockpit/app/core/domain/entities/app_settings.dart';
import 'package:cockpit/app/core/ui/themes/themes.dart';
import 'package:cockpit/i18n/strings.g.dart';
import 'package:flutter/services.dart' show FontLoader;
import 'package:flutter/rendering.dart' show RenderRepaintBoundary;
import 'package:flutter_test/flutter_test.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

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
  @override
  void interrupt() {}
  @override
  Future<void> close() async {}
}

class _Factory implements ChatEngineFactory {
  final engine = _Engine();
  @override
  Future<ChatEngine> start({
    required String cwd,
    String? resumeSessionId,
  }) async => engine;
  @override
  Future<List<ChatEvent>> history({
    required String cwd,
    required String sessionId,
  }) async => const [];
}

/// Fontes reais (cache do google_fonts do app, Material Icons do SDK) para o
/// PNG não sair com caixinhas. Sem os arquivos o teste roda igual.
const _settings = AppSettings(interfaceFont: 'ChatUi', codeFont: 'ChatMono');

Future<void> _loadFonts() async {
  final home = Platform.environment['HOME'] ?? '';
  final flutter = File(Platform.resolvedExecutable).parent.parent.parent.path;
  Future<void> load(String family, Iterable<String> paths) async {
    final loader = FontLoader(family);
    var any = false;
    for (final p in paths) {
      final f = File(p);
      if (!f.existsSync()) continue;
      loader.addFont(Future.value(f.readAsBytesSync().buffer.asByteData()));
      any = true;
    }
    if (any) await loader.load();
  }

  List<String> cached(String prefix) => [
    for (final dir in const [
      '.local/share/work.gorila.gshdesktop',
      '.local/share/work.jacobmoura.cockpit',
    ])
      if (Directory('$home/$dir').existsSync())
        for (final f in Directory('$home/$dir').listSync())
          if (f.path.split('/').last.startsWith(prefix)) f.path,
  ];
  await load('ChatUi', cached('HankenGrotesk_').take(1));
  await load('ChatMono', cached('JetBrainsMono_500').take(1));
  await load('MaterialIcons', [
    '$flutter/artifacts/material_fonts/MaterialIcons-Regular.otf',
    '$home/.local/flutter/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
  ]);
}

Widget _host(Widget child) {
  final tokens = buildTokens(brightness: Brightness.dark, settings: _settings);
  return TranslationProvider(
    child: ShadcnApp(
      debugShowCheckedModeBanner: false,
      // linux: sem isto o shadcn abre o menu como bottom sheet (o teste roda
      // como android).
      theme: buildTheme(
        brightness: Brightness.dark,
        settings: _settings,
      ).copyWith(platform: () => TargetPlatform.linux),
      home: DefaultSelectionStyle(
        selectionColor: tokens.terminal.selection,
        cursorColor: tokens.colors.accent,
        child: CockpitTheme(
          colors: tokens.colors,
          typo: tokens.typo,
          syntax: tokens.syntax,
          terminal: tokens.terminal,
          child: child,
        ),
      ),
    ),
  );
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
    'file_path':
        '/home/dev/GSH-Desktop/lib/app/cockpit/ui/widgets/chat_view.dart',
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

Future<void> _settle(WidgetTester tester) async {
  await tester.pump();
  // Decodifica as imagens de verdade (fora do relógio falso do teste).
  await tester.runAsync(() async {
    for (final e in find.byType(Image).evaluate()) {
      await precacheImage((e.widget as Image).image, e);
    }
  });
  await tester.pump(const Duration(milliseconds: 200));
}

Future<void> _shot(WidgetTester tester, String name) async {
  await _settle(tester);
  final boundary = tester.renderObject<RenderRepaintBoundary>(
    find.byKey(const ValueKey('shot')),
  );
  await tester.runAsync(() async {
    final image = await boundary.toImage();
    final png = await image.toByteData(format: ui.ImageByteFormat.png);
    File('${_scratch()}/$name.png').writeAsBytesSync(png!.buffer.asUint8List());
  });
}

String _scratch() =>
    Platform.environment['CHAT_SHOT_DIR'] ??
    '/tmp/claude-1000/-home-heliodev-projetos-GSH-Desktop/'
        'b713b305-45e6-4007-bc9e-3aa6865ff854/scratchpad';

Uint8List? _png() {
  final f = File('${_scratch()}/../images/1.png');
  return f.existsSync() ? f.readAsBytesSync() : null;
}

void main() {
  setUpAll(() async {
    LocaleSettings.setLocale(AppLocale.ptBr);
    await _loadFonts();
  });

  test('nome curto do modelo', () {
    expect(shortModelName('claude-opus-4-5-20251101'), 'Opus 4.5');
    expect(shortModelName('claude-sonnet-4-20250514'), 'Sonnet 4');
    expect(shortModelName('claude-opus-4-6[1m]'), 'Opus 4.6');
    expect(shortModelName('opus'), 'opus');
    expect(shortModelName(null), 'Claude');
  });

  testWidgets('conversa: edições agrupadas, ferramenta recolhida, modo', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1100, 990);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final (chat, f) = await _script(tester, null);
    await tester.pumpWidget(_host(ChatPane(chat: chat, branch: 'helio')));
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
    Widget pane(ChatController c) => _host(
      RepaintBoundary(
        key: const ValueKey('shot'),
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
    await _shot(tester, 'chat_ui_1');

    await tester.tap(find.text('Roda os testes do chat'));
    await tester.tap(find.text('chat_view.dart'));
    await _settle(tester);
    await _shot(tester, 'chat_ui_2');

    pos().jumpTo(pos().maxScrollExtent * 0.45);
    await _shot(tester, 'chat_ui_3');

    pos().jumpTo(pos().maxScrollExtent);
    if (_png() case final png?) chat.attachPastedImage(png);
    await _shot(tester, 'chat_ui_4');

    final empty = ChatController(_Factory(), cwd: '/home/dev/GSH-Desktop');
    await tester.pumpWidget(pane(empty));
    await _shot(tester, 'chat_ui_5');
    chat.dispose();
    empty.dispose();
  });
}
