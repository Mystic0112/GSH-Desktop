import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gsh_desktop/app/core/ui/themes/themes.dart';
import 'package:gsh_desktop/app/gsh/domain/contracts/harness_source.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/project_harness.dart';
import 'package:gsh_desktop/app/gsh/ui/session/harness_session.dart';
import 'package:gsh_desktop/app/gsh/ui/viewmodels/harness_viewmodel.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/harness_view.dart';
import 'package:gsh_desktop/i18n/strings.g.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'shot_harness.dart';

class _Source implements HarnessSource {
  @override
  Future<ProjectHarness> read(String workspace) async => const ProjectHarness(
    [
      HarnessEntry(
        kind: HarnessKind.memory,
        name: '~/.claude/CLAUDE.md',
        detail: '/home/helio/.claude/CLAUDE.md',
        scope: HarnessScope.user,
        path: '/a',
      ),
      HarnessEntry(
        kind: HarnessKind.memory,
        name: 'CLAUDE.md',
        detail: '/repo/CLAUDE.md',
        scope: HarnessScope.project,
        path: '/b',
        alwaysOnChars: 12000,
      ),
      HarnessEntry(
        kind: HarnessKind.memory,
        name: 'CLAUDE.local.md',
        detail: '/repo/CLAUDE.local.md',
        scope: HarnessScope.local,
        path: '/c',
      ),
      HarnessEntry(
        kind: HarnessKind.skills,
        name: 'deploy',
        detail: 'Sobe a versão para homologação e confere o health check',
        scope: HarnessScope.project,
        path: '/d',
      ),
      HarnessEntry(
        kind: HarnessKind.skills,
        name: 'graphify',
        detail: 'Transforma qualquer entrada num grafo de conhecimento',
        scope: HarnessScope.user,
        path: '/e',
        alwaysOnChars: 9000,
      ),
      HarnessEntry(
        kind: HarnessKind.agents,
        name: 'levi',
        detail: 'QA e testes, perfeccionista',
        scope: HarnessScope.user,
        path: '/f',
        alwaysOnChars: 400,
      ),
      HarnessEntry(
        kind: HarnessKind.agents,
        name: 'escanor',
        detail: 'Backend PHP / Laravel',
        scope: HarnessScope.user,
        path: '/g',
      ),
      HarnessEntry(
        kind: HarnessKind.commands,
        name: '/git:pr',
        detail: 'Abre um PR com o resumo do diff',
        scope: HarnessScope.project,
        path: '/h',
      ),
      HarnessEntry(
        kind: HarnessKind.hooks,
        name: 'PreToolUse · Bash',
        detail: 'gsh hook',
        scope: HarnessScope.user,
        path: '/i',
      ),
      HarnessEntry(
        kind: HarnessKind.hooks,
        name: 'Stop',
        detail: './scripts/notify.sh',
        scope: HarnessScope.project,
        path: '/j',
        issues: [HarnessIssue.missingScript],
      ),
      HarnessEntry(
        kind: HarnessKind.permissions,
        name: 'Bash(npm test *)',
        detail: 'allow',
        scope: HarnessScope.project,
        path: '/k',
      ),
      HarnessEntry(
        kind: HarnessKind.permissions,
        name: 'Bash(git push *)',
        detail: 'ask',
        scope: HarnessScope.local,
        path: '/l',
      ),
      HarnessEntry(
        kind: HarnessKind.permissions,
        name: 'Read(.env)',
        detail: 'deny',
        scope: HarnessScope.project,
        path: '/m',
      ),
      HarnessEntry(
        kind: HarnessKind.mcp,
        name: 'postgres',
        detail: 'npx @mcp/postgres',
        scope: HarnessScope.project,
        path: '/n',
      ),
      HarnessEntry(
        kind: HarnessKind.mcp,
        name: 'clickup',
        detail: 'http · https://mcp.clickup.com',
        scope: HarnessScope.user,
      ),
    ],
    invalidFiles: ['/repo/.claude/settings.local.json'],
  );

  @override
  Future<String> create(
    String workspace,
    HarnessKind kind, {
    String? name,
  }) async => '/x';
}

class _Root extends StatelessWidget {
  const _Root();
  @override
  Widget build(BuildContext context) => TranslationProvider(
    child: RepaintBoundary(
      key: shotKey,
      child: shotTheme(
        ShadcnApp.router(
          debugShowCheckedModeBanner: false,
          theme: buildTheme(
            brightness: Brightness.dark,
            settings: shotSettings,
          ).copyWith(platform: () => TargetPlatform.linux),
          routerConfig: ModularApp.routerConfigOf(context),
        ),
      ),
    ),
  );
}

void main() {
  setUpAll(() async {
    LocaleSettings.setLocale(AppLocale.ptBr);
    await loadShotFonts();
  });

  testWidgets('seções, escopos e regras de permissão', (tester) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final module = createModule(
      register: (c) => c
        ..addInstance<HarnessSource>(_Source())
        ..route(
          '/',
          provide: (s) =>
              s..addChangeNotifier<HarnessViewModel>(HarnessViewModel.new),
          child: (context, state) => shotTheme(
            HarnessView(
              session: HarnessSession(
                id: 'h',
                projectId: 'p',
                workingDirectory: '/home/helio/projetos/loja',
              ),
              active: true,
            ),
          ),
        ),
    );
    await tester.pumpWidget(ModularApp(module: module, child: const _Root()));
    await tester.pumpAndSettle();
    for (final s in [
      'Instruções',
      'Skills',
      'Subagentes',
      'Comandos',
      'Hooks',
      'Permissões',
      'MCP',
    ]) {
      expect(find.text(s), findsOneWidget);
    }
    expect(find.text('bloquear'), findsOneWidget);
    expect(find.text('Custo fixo por turno'), findsOneWidget);
    expect(find.text('Avisos: 2'), findsOneWidget);
    expect(find.text('Usuário'), findsWidgets);
    await takeShot(tester, 'harness_view');
  });
}
