import 'package:cockpit/app/core/domain/contracts/claude_code_settings.dart';
import 'package:cockpit/app/core/domain/contracts/settings_store.dart';
import 'package:cockpit/app/core/domain/entities/app_settings.dart';
import 'package:cockpit/app/core/domain/result.dart';
import 'package:cockpit/app/core/ui/settings_controller.dart';
import 'package:cockpit/app/core/ui/themes/themes.dart';
import 'package:cockpit/app/settings/domain/claude_info.dart';
import 'package:cockpit/app/settings/ui/claude_code_panel.dart';
import 'package:cockpit/app/settings/ui/claude_info_viewmodel.dart';
import 'package:cockpit/i18n/strings.g.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'shot_harness.dart';

class _Store implements SettingsStore {
  @override
  Future<AppSettings> load() async => const AppSettings();
  @override
  Future<void> save(AppSettings settings) async {}
}

/// `~/.claude/settings.json` em memória.
class _ClaudeSettings implements ClaudeCodeSettings {
  final values = <String, Object>{};
  @override
  Future<bool?> getBool(String key) async => values[key] as bool?;
  @override
  Future<Result<void, String>> setBool(String key, bool? value) =>
      setValue(key, value);
  @override
  Future<Object?> getValue(String key) async => values[key];
  @override
  Future<Result<void, String>> setValue(String key, Object? value) async {
    value == null ? values.remove(key) : values[key] = value;
    return const Success(null);
  }
}

/// O painel só pede os estilos de saída à CLI.
class _NoClaude implements ClaudeInfoSource {
  @override
  Future<List<String>> outputStyles() async => const ['Explanatory'];
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Root extends StatelessWidget {
  const _Root();

  @override
  Widget build(BuildContext context) => TranslationProvider(
    child: ShadcnApp.router(
      debugShowCheckedModeBanner: false,
      theme: buildTheme(
        brightness: Brightness.dark,
        settings: shotSettings,
      ).copyWith(platform: () => TargetPlatform.linux),
      routerConfig: ModularApp.routerConfigOf(context),
    ),
  );
}

Future<(SettingsController, _ClaudeSettings)> _mount(
  WidgetTester tester,
) async {
  final settings = SettingsController(_Store());
  final claude = _ClaudeSettings();
  final module = createModule(
    register: (c) => c
      ..addInstance<ClaudeCodeSettings>(claude)
      ..addInstance<ClaudeInfoSource>(_NoClaude())
      ..route(
        '/',
        provide: (s) =>
            s.addChangeNotifier<ClaudeInfoViewModel>(ClaudeInfoViewModel.new),
        child: (context, state) => shotTheme(
          RepaintBoundary(
            key: shotKey,
            child: Builder(
              builder: (context) => ColoredBox(
                color: context.colors.bg,
                child: const ClaudeCodePanel(),
              ),
            ),
          ),
        ),
      ),
  );
  await tester.pumpWidget(
    ModularApp(
      module: module,
      provide: (s) => s.addChangeNotifier<SettingsController>(() => settings),
      child: const _Root(),
    ),
  );
  await tester.pumpAndSettle();
  return (settings, claude);
}

void main() {
  setUpAll(() async {
    LocaleSettings.setLocale(AppLocale.ptBr);
    await loadShotFonts();
  });

  testWidgets('linhas da aba gravam nas preferências e no settings.json', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1070, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final (settings, claude) = await _mount(tester);

    expect(find.text('Classificar estados das sessões'), findsOneWidget);
    // Dois dropdowns de paleta (claro e escuro), ambos seguindo o tema.
    expect(find.text('Do tema ativo'), findsNWidgets(2));

    await tester.tap(find.text('Raciocínio'));
    await tester.pump();
    expect(settings.settings.transcriptView, TranscriptView.thinking);

    final switches = find.byType(Switch);
    // Geral (2) + Remote Control + Sessões (sugestões, sandbox, estrito) +
    // Navegador.
    expect(switches, findsNWidgets(7));
    // Classificar: GSH, padrão ligado.
    await tester.tap(switches.at(0));
    await tester.pump();
    expect(settings.settings.classifySessionStates, isFalse);
    // switchModelsOnFlag: ausente = ligado; desligar grava false explícito.
    await tester.tap(switches.at(1));
    await tester.pumpAndSettle();
    expect(claude.values, {ClaudeCodeKeys.switchModelsOnFlag: false});
    // Remote Control: liga grava true, desliga remove a chave.
    await tester.tap(switches.at(2));
    await tester.pumpAndSettle();
    expect(claude.values[ClaudeCodeKeys.remoteControlAtStartup], isTrue);
    await tester.tap(switches.at(2));
    await tester.pumpAndSettle();
    expect(
      claude.values.containsKey(ClaudeCodeKeys.remoteControlAtStartup),
      isFalse,
    );

    await tester.enterText(find.byType(TextField), '  Fira Code ');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    expect(settings.settings.codeFont, 'Fira Code');
  });

  test('paleta escolhida vence a do tema e mantém o fundo do tema', () {
    final base = buildTokens(brightness: Brightness.dark).syntax;
    final picked = buildTokens(
      brightness: Brightness.dark,
      settings: const AppSettings(codeThemeDark: 'draculaDark'),
    ).syntax;
    expect(picked.keyword, SyntaxColors.draculaDark.keyword);
    expect(picked.background, base.background);
    // A do outro modo não vaza.
    final light = buildTokens(
      brightness: Brightness.light,
      settings: const AppSettings(codeThemeDark: 'draculaDark'),
    ).syntax;
    expect(light.keyword, isNot(SyntaxColors.draculaDark.keyword));
    final json = const AppSettings(
      codeThemeLight: 'flexokiLight',
      transcriptView: TranscriptView.verbose,
      classifySessionStates: false,
    ).toJson();
    final back = AppSettings.fromJson(json);
    expect(
      (back.codeThemeLight, back.transcriptView, back.classifySessionStates),
      ('flexokiLight', TranscriptView.verbose, false),
    );
  });

  testWidgets('preview: PNG da aba Claude Code', tags: ['preview'], (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1070, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final (settings, _) = await _mount(tester);
    await takeShot(tester, 'settings_cc_1');

    settings
      ..setCodeThemeLight(SyntaxPalette.flexokiLight.name)
      ..setCodeThemeDark(SyntaxPalette.draculaDark.name)
      ..setTranscriptView(TranscriptView.thinking);
    await tester.pumpAndSettle();
    await takeShot(tester, 'settings_cc_2');
  });
}
