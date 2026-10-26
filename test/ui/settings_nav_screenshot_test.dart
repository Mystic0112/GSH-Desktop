import 'package:gsh_desktop/app/core/app_intents.dart' as intents;
import 'package:gsh_desktop/app/core/domain/contracts/claude_code_settings.dart';
import 'package:gsh_desktop/app/core/domain/contracts/neovim_gateway.dart';
import 'package:gsh_desktop/app/core/domain/contracts/settings_store.dart';
import 'package:gsh_desktop/app/core/domain/entities/app_settings.dart';
import 'package:gsh_desktop/app/core/domain/result.dart';
import 'package:gsh_desktop/app/core/ui/keep_awake_controller.dart';
import 'package:gsh_desktop/app/core/ui/settings_controller.dart';
import 'package:gsh_desktop/app/core/ui/themes/themes.dart';
import 'package:gsh_desktop/app/core/domain/entities/claude_info.dart';
import 'package:gsh_desktop/app/settings/ui/claude_info_viewmodel.dart';
import 'package:gsh_desktop/app/settings/ui/neovim_settings_viewmodel.dart';
import 'package:gsh_desktop/app/settings/ui/settings_nav.dart';
import 'package:gsh_desktop/app/settings/ui/settings_page.dart';
import 'package:gsh_desktop/i18n/strings.g.dart';
import 'package:flutter/services.dart' show MethodChannel;
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'shot_harness.dart';

class _Store implements SettingsStore {
  @override
  Future<AppSettings> load() async => const AppSettings();
  @override
  Future<void> save(AppSettings settings) async {}
}

class _Nvim implements NeovimGateway {
  @override
  Future<String?> executable({bool refresh = false}) async => '/usr/bin/nvim';
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// `~/.claude/settings.json` em memória.
class _ClaudeSettings implements ClaudeCodeSettings {
  final values = <String, Object>{'promptSuggestionEnabled': true};
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

/// CLI `claude` de mentira, com dados no formato real.
class _Claude implements ClaudeInfoSource {
  static final _d = DateTime(2026, 10, 20);

  @override
  Future<Result<ClaudeAccount, ClaudeInfoError>> account() async =>
      const Success(
        ClaudeAccount(
          loggedIn: true,
          authMethod: 'claude.ai',
          email: 'dev@gorila.work',
          orgId: '00000000-1111-2222-3333-444444444444',
          orgName: 'Gorila',
          subscriptionType: 'team',
        ),
      );
  @override
  Future<Result<void, ClaudeInfoError>> logout() async => const Success(null);
  @override
  Future<Result<ClaudeUsage, ClaudeInfoError>> usage() async => Success(
    ClaudeUsage(
      available: true,
      subscriptionType: 'team',
      windows: [
        UsageWindow(
          kind: UsageWindowKind.session,
          percent: 5,
          resetsAt: DateTime.now().add(const Duration(hours: 4, minutes: 49)),
        ),
        UsageWindow(
          kind: UsageWindowKind.weekly,
          percent: 63,
          resetsAt: DateTime(2026, 10, 25, 17),
        ),
        UsageWindow(
          kind: UsageWindowKind.weeklyModel,
          label: 'Fable',
          percent: 37,
          resetsAt: DateTime(2026, 10, 25, 17),
        ),
      ],
    ),
  );
  @override
  Future<Result<List<McpServerInfo>, ClaudeInfoError>> mcpServers() async =>
      const Success([
        McpServerInfo(
          name: 'claude.ai ClickUp',
          target: 'https://mcp.clickup.com/mcp',
          status: McpStatus.connected,
          statusText: 'Connected',
        ),
        McpServerInfo(
          name: 'claude.ai Notion',
          target: 'https://mcp.notion.com/mcp',
          status: McpStatus.needsAuth,
          statusText: 'Needs authentication',
        ),
        McpServerInfo(
          name: 'plugin:rankedin:rankedin',
          target: 'https://rankedin.app/api/mcp (HTTP)',
          status: McpStatus.needsAuth,
          statusText: 'Needs authentication',
        ),
        McpServerInfo(
          name: 'gsh',
          target: '/home/dev/.gsh/bin/gsh mcp --agent claude-desktop',
          status: McpStatus.connected,
          statusText: 'Connected',
        ),
        McpServerInfo(
          name: 'notebooklm',
          target: '/home/dev/.local/bin/notebooklm-mcp --transport stdio',
          status: McpStatus.failed,
          statusText: 'Failed to connect — CONNECTION_CLOSED',
        ),
        McpServerInfo(
          name: '21st',
          target: 'https://21st.dev/api/mcp (HTTP)',
          status: McpStatus.pending,
          statusText: 'Pending approval (run `claude` to approve)',
        ),
      ]);
  @override
  Future<Result<List<ClaudePluginInfo>, ClaudeInfoError>> plugins() async =>
      Success([
        ClaudePluginInfo(
          id: 'scaffold-dev@scaffold-dev',
          enabled: true,
          version: '0.2.0',
          scope: 'user',
          updatedAt: _d,
          displayName: 'scaffold-dev',
          author: 'Hélio Vinícius',
          description: 'Mentor para devs juniores: aprenda com o código.',
        ),
        ClaudePluginInfo(
          id: 'caveman@caveman',
          enabled: true,
          version: '17f9f2ec2377',
          scope: 'user',
          updatedAt: DateTime(2026, 8, 28),
          author: 'Julius Brussee',
          description: 'Ultra-compressed communication mode.',
        ),
        ClaudePluginInfo(
          id: 'watch@claude-video',
          enabled: false,
          version: '0.2.0',
          scope: 'project',
          updatedAt: DateTime(2026, 7, 27),
          author: 'Bradley Bonanno',
          description: 'Let Claude watch a video.',
        ),
      ]);
  @override
  Future<Result<List<MarketplacePlugin>, ClaudeInfoError>> directory() async =>
      const Success([
        MarketplacePlugin(
          name: 'agent-sdk-dev',
          marketplace: 'claude-plugins-official',
          author: 'Anthropic',
          description: 'Development kit for working with the Claude Agent SDK',
        ),
        MarketplacePlugin(
          name: 'adobe-for-creativity',
          marketplace: 'claude-plugins-official',
          author: 'Adobe',
          description:
              'Harness creative AI tools to edit images and automate '
              'design workflows.',
        ),
        MarketplacePlugin(
          name: 'caveman',
          marketplace: 'caveman',
          author: 'Julius Brussee',
          description: 'Ultra-compressed communication mode.',
          installed: true,
        ),
        MarketplacePlugin(
          name: 'ponytail',
          marketplace: 'ponytail',
          author: 'Dietrich Gebert',
          description: 'Forces the laziest solution that works.',
        ),
      ]);
  @override
  Future<Result<List<ClaudeSkillInfo>, ClaudeInfoError>> skills(
    String? workspace,
  ) async => Success([
    ClaudeSkillInfo(
      name: 'sukuna',
      description: 'Especialista em prescrever treinos',
      path: '/home/dev/.claude/skills/sukuna/SKILL.md',
      updatedAt: DateTime(2026, 8, 18),
    ),
    ClaudeSkillInfo(
      name: 'toji',
      description: 'Vai prescrever dietas como um profissional',
      path: '/home/dev/.claude/skills/toji/SKILL.md',
      updatedAt: DateTime(2026, 8, 18),
    ),
    ClaudeSkillInfo(
      name: 'caveman',
      description: 'Ultra-compressed communication mode.',
      path: '/x/caveman/skills/caveman/SKILL.md',
      source: SkillSource.plugin,
      plugin: 'caveman@caveman',
      updatedAt: _d,
    ),
    ClaudeSkillInfo(
      name: 'release-notes',
      description: 'Escreve as notas de versão do GSH.',
      path: '/home/dev/gsh/.claude/skills/release-notes/SKILL.md',
      source: SkillSource.project,
      updatedAt: _d,
    ),
  ]);
  @override
  Future<List<MemoryFileInfo>> memoryFiles(String? workspace) async => const [
    MemoryFileInfo(
      path: '/home/dev/.claude/CLAUDE.md',
      scope: MemoryScope.user,
    ),
    MemoryFileInfo(path: '/home/dev/gsh/CLAUDE.md', scope: MemoryScope.project),
  ];
  @override
  Future<List<AutoMemoryEntry>> autoMemory(String? workspace) async => [
    AutoMemoryEntry(
      title: 'Profile',
      hook: 'Who Helio is — name and work focus',
      path: '/m/profile.md',
      type: 'user',
      updatedAt: DateTime(2026, 9, 11),
    ),
    AutoMemoryEntry(
      title: 'Release flow',
      hook: 'Never commit on main; branch helio',
      path: '/m/release.md',
      type: 'feedback',
      updatedAt: DateTime(2026, 8, 27),
    ),
  ];
  @override
  Future<List<String>> outputStyles() async => ['Explanatory', 'Learning'];
  @override
  Future<List<String>> projectPlugins(String workspace) async => [
    'caveman@caveman',
  ];
  @override
  Future<String> readUserInstructions() async =>
      '# Gorila Squad\n\nResponder em português.';
  @override
  Future<Result<void, ClaudeInfoError>> writeUserInstructions(String t) async =>
      const Success(null);
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

Future<void> _mount(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1280, 900);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final settings = SettingsController(_Store());
  final module = createModule(
    register: (c) => c
      ..addInstance<NeovimGateway>(_Nvim())
      ..addInstance<ClaudeInfoSource>(_Claude())
      ..addInstance<ClaudeCodeSettings>(_ClaudeSettings())
      ..route(
        '/',
        provide: (s) => s
          ..addChangeNotifier<NeovimSettingsViewModel>(
            NeovimSettingsViewModel.new,
          )
          ..addChangeNotifier<ClaudeInfoViewModel>(ClaudeInfoViewModel.new),
        child: (context, state) => shotTheme(
          const RepaintBoundary(key: shotKey, child: SettingsPage()),
        ),
      ),
  );
  await tester.pumpWidget(
    ModularApp(
      module: module,
      provide: (s) => s
        ..addChangeNotifier<SettingsController>(() => settings)
        ..addChangeNotifier<KeepAwakeController>(KeepAwakeController.new),
      child: const _Root(),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _open(WidgetTester tester, String label) async {
  await tester.tap(find.text(label).first);
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() async {
    LocaleSettings.setLocale(AppLocale.ptBr);
    PackageInfo.setMockInitialValues(
      appName: 'GSH Desktop',
      packageName: 'gsh',
      version: '2.4.0',
      buildNumber: '1',
      buildSignature: '',
    );
    // Pontes do shell: com elas, os botões "Abrir"/"Vincular" ficam ativos.
    intents.requestOpenFileTab = (_) {};
    intents.activeWorkspaceRoot = () => '/home/dev/gsh';
    // Armazenamento (aba Sistema) pergunta a pasta de documentos.
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/path_provider'),
          (_) async => '/home/dev/Documentos',
        );
    await loadShotFonts();
  });

  testWidgets('menu tem os grupos e a busca filtra pelo rótulo', (
    tester,
  ) async {
    await _mount(tester);
    for (final label in [
      'Configurações',
      'Este computador',
      'Personalização',
      'Cowork',
    ]) {
      expect(find.text(label), findsWidgets, reason: label);
    }
    // O fim do menu fica fora da janela de teste: rola até lá.
    await tester.scrollUntilVisible(
      find.text('Chaves de API'),
      120,
      // O campo de busca também é um Scrollable; o da lista vem depois.
      scrollable: find
          .descendant(
            of: find.byType(SettingsNav),
            matching: find.byType(Scrollable),
          )
          .last,
    );
    expect(find.text('Plataforma'), findsOneWidget);
    await tester.enterText(find.byType(TextField).first, 'PLUG');
    await tester.pumpAndSettle();
    expect(find.text('Plugins'), findsOneWidget);
    expect(find.text('Conectores'), findsNothing);
    expect(find.text('Este computador'), findsNothing);
    // As abas próprias do GSH ficam no outro lado do menu.
    await tester.enterText(find.byType(TextField).first, '');
    await tester.pumpAndSettle();
    await tester.tap(find.text('GSH Desktop').first);
    await tester.pumpAndSettle();
    expect(find.text('Hosts remotos'), findsOneWidget);
    expect(find.text('Este computador'), findsNothing);
    await tester.enterText(find.byType(TextField).first, 'hosts');
    await tester.pumpAndSettle();
    expect(find.text('Hosts remotos'), findsOneWidget);
    expect(find.text('Automações'), findsNothing);

    await tester.enterText(find.byType(TextField).first, '');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Claude').first);
    await tester.pumpAndSettle();
    await _open(tester, 'Conectores');
    expect(find.text('Vincular'), findsNWidgets(2));
    expect(find.text('Falhou'), findsOneWidget);
    expect(find.text('Fornecido pelo plugin rankedin'), findsOneWidget);
  });

  testWidgets('preview: PNG por aba', tags: ['preview'], (tester) async {
    await _mount(tester);
    await takeShot(tester, 'settings_tab_geral');
    for (final (label, name) in [
      ('Conta', 'conta'),
      ('Privacidade', 'privacidade'),
      ('Uso', 'uso'),
      ('Recursos', 'recursos'),
      ('Memória', 'memoria'),
      ('Design systems', 'design_systems'),
      ('Claude Code', 'claude_code'),
      ('Cowork', 'cowork'),
      ('Sistema', 'sistema'),
      ('Extensões', 'extensoes'),
      ('Desenvolvedor', 'desenvolvedor'),
      ('Skills', 'skills'),
      ('Conectores', 'conectores'),
      ('Plugins', 'plugins'),
    ]) {
      await _open(tester, label);
      await takeShot(tester, 'settings_tab_$name');
    }
    // Descobrir de Plugins (diretório dos marketplaces) e de Conectores.
    await _open(tester, 'Descobrir');
    await takeShot(tester, 'settings_tab_plugins_descobrir');
    await _open(tester, 'Conectores');
    await _open(tester, 'Descobrir');
    await takeShot(tester, 'settings_tab_conectores_descobrir');
    await tester.enterText(find.byType(TextField).first, 'con');
    await tester.pumpAndSettle();
    await takeShot(tester, 'settings_nav_search');
  });
}
