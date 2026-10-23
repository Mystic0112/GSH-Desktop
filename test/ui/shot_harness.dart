import 'dart:io';
import 'dart:ui' as ui;

import 'package:cockpit/app/core/domain/entities/app_settings.dart';
import 'package:cockpit/app/core/ui/themes/themes.dart';
import 'package:cockpit/i18n/strings.g.dart';
import 'package:flutter/rendering.dart' show RenderRepaintBoundary;
import 'package:flutter/services.dart' show FontLoader;
import 'package:flutter_test/flutter_test.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

/// Base dos testes de prévia em PNG: fontes reais, tema do app e captura de
/// um `RepaintBoundary` com a chave [shotKey].

/// Fontes reais carregadas por [loadShotFonts] (cache do google_fonts do app).
const shotSettings = AppSettings(interfaceFont: 'ChatUi', codeFont: 'ChatMono');

const shotKey = ValueKey('shot');

/// Fontes reais (cache do google_fonts do app, Material Icons do SDK) para o
/// PNG não sair com caixinhas. Sem os arquivos o teste roda igual.
Future<void> loadShotFonts() async {
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

/// Tema do app (escuro por padrão) em volta de [child], com i18n.
Widget shotHost(Widget child, {Brightness brightness = Brightness.dark}) =>
    TranslationProvider(
      child: ShadcnApp(
        debugShowCheckedModeBanner: false,
        // linux: sem isto o shadcn abre o menu como bottom sheet (o teste roda
        // como android).
        theme: buildTheme(
          brightness: brightness,
          settings: shotSettings,
        ).copyWith(platform: () => TargetPlatform.linux),
        home: shotTheme(child, brightness: brightness),
      ),
    );

/// Só os tokens do Cockpit (para quem já tem o próprio `ShadcnApp`).
Widget shotTheme(Widget child, {Brightness brightness = Brightness.dark}) {
  final tokens = buildTokens(brightness: brightness, settings: shotSettings);
  return DefaultSelectionStyle(
    selectionColor: tokens.terminal.selection,
    cursorColor: tokens.colors.accent,
    child: CockpitTheme(
      colors: tokens.colors,
      typo: tokens.typo,
      syntax: tokens.syntax,
      terminal: tokens.terminal,
      child: child,
    ),
  );
}

Future<void> settleShot(WidgetTester tester) async {
  await tester.pump();
  // Decodifica as imagens de verdade (fora do relógio falso do teste).
  await tester.runAsync(() async {
    for (final e in find.byType(Image).evaluate()) {
      await precacheImage((e.widget as Image).image, e);
    }
  });
  await tester.pump(const Duration(milliseconds: 200));
}

/// Grava o `RepaintBoundary(key: shotKey)` em `<scratch>/<name>.png`.
Future<void> takeShot(WidgetTester tester, String name) async {
  await settleShot(tester);
  final boundary = tester.renderObject<RenderRepaintBoundary>(
    find.byKey(shotKey),
  );
  await tester.runAsync(() async {
    final image = await boundary.toImage();
    final png = await image.toByteData(format: ui.ImageByteFormat.png);
    File('${shotDir()}/$name.png').writeAsBytesSync(png!.buffer.asUint8List());
  });
}

String shotDir() =>
    Platform.environment['CHAT_SHOT_DIR'] ??
    '/tmp/claude-1000/-home-heliodev-projetos-GSH-Desktop/'
        'b713b305-45e6-4007-bc9e-3aa6865ff854/scratchpad';
