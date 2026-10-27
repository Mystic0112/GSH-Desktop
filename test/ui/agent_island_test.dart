import 'package:gsh_desktop/app/core/domain/entities/harness.dart';
import 'package:gsh_desktop/app/core/ui/themes/themes.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/agent_permission.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/agent_island.dart';
import 'package:gsh_desktop/i18n/strings.g.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'shot_harness.dart';

IslandAgent _agent(
  String id,
  String title,
  IslandAgentState state, {
  HarnessKind? harness = HarnessKind.claudeCode,
}) => (
  tabId: id,
  title: title,
  workspace: 'GSH-Desktop',
  state: state,
  harness: harness,
);

final _agents = [
  _agent('t1', 'refactor do chat', IslandAgentState.working),
  _agent('t2', 'testes de LSP', IslandAgentState.working),
  _agent('t3', 'plano da ilha', IslandAgentState.waiting),
  _agent('t4', 'migração do banco', IslandAgentState.finished),
  _agent('t5', 'deploy', IslandAgentState.waiting),
];

const _ask = AgentPermissionAsk(
  id: 'p1',
  tabId: 't5',
  toolName: 'Bash',
  input: {'command': 'npm test -- --watch=false'},
  alwaysRule: 'Bash(npm test:*)',
);

/// A ilha como fica na barra: centro de uma faixa de 46px, com espaço
/// embaixo para a lista (um [Overlay] próprio, dentro da captura).
Future<
  ({List<(String, AgentPermissionDecision)> decisions, List<String> reveals})
>
_pump(
  WidgetTester tester, {
  required List<IslandAgent> agents,
  List<AgentPermissionAsk> asks = const [],
}) async {
  final decisions = <(String, AgentPermissionDecision)>[];
  final reveals = <String>[];
  await tester.pumpWidget(
    shotHost(
      RepaintBoundary(
        key: shotKey,
        child: Overlay(
          initialEntries: [
            OverlayEntry(
              builder: (context) => ColoredBox(
                color: context.colors.bg,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    height: 46,
                    child: Center(
                      child: AgentIslandView(
                        agents: agents,
                        asks: asks,
                        onDecide: (id, d) => decisions.add((id, d)),
                        onReveal: reveals.add,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
  await tester.pump();
  return (decisions: decisions, reveals: reveals);
}

void main() {
  setUpAll(loadShotFonts);
  setUp(() => LocaleSettings.setLocale(AppLocale.ptBr));

  void size(WidgetTester tester, double h) {
    tester.view
      ..physicalSize = Size(1040, h * 2)
      ..devicePixelRatio = 2;
    addTearDown(tester.view.reset);
  }

  testWidgets('recolhida: só os contadores, sem a lista', (tester) async {
    size(tester, 80);
    await _pump(tester, agents: _agents);
    expect(find.text('2'), findsNWidgets(2)); // trabalhando · esperando
    expect(find.text('1'), findsOneWidget); // terminou
    expect(find.text('Trabalhando'.toUpperCase()), findsNothing);
    await takeShot(tester, 'agent_island_collapsed');
  });

  testWidgets('sem agentes: o gorila dorme sozinho', (tester) async {
    size(tester, 80);
    await _pump(tester, agents: const []);
    expect(find.byType(Text), findsNothing);
    await takeShot(tester, 'agent_island_empty');
  });

  testWidgets('pedido abre a ilha e Permitir decide allow', (tester) async {
    size(tester, 520);
    final r = await _pump(tester, agents: _agents, asks: const [_ask]);
    expect(find.text('Bash · npm test -- --watch=false'), findsOneWidget);
    expect(find.text('Sempre'), findsOneWidget);
    expect(find.text('Negar'), findsOneWidget);
    expect(find.text('No terminal'), findsOneWidget);
    // o pedido conta como "esperando"; a aba dele não repete na lista
    expect(find.text('deploy'), findsOneWidget);
    await takeShot(tester, 'agent_island_expanded');
    await tester.tap(find.text('Permitir'));
    expect(r.decisions, [('p1', AgentPermissionDecision.allow)]);
  });

  testWidgets('No terminal devolve o pedido e vai até a aba', (tester) async {
    size(tester, 520);
    final r = await _pump(tester, agents: _agents, asks: const [_ask]);
    await tester.tap(find.text('No terminal'));
    expect(r.decisions, [('p1', AgentPermissionDecision.pass)]);
    expect(r.reveals, ['t5']);
  });

  testWidgets('sem "Sempre" quando o harness não sugere regra', (tester) async {
    size(tester, 520);
    await _pump(
      tester,
      agents: _agents,
      asks: const [
        AgentPermissionAsk(
          id: 'p2',
          tabId: 't5',
          toolName: 'Edit',
          input: {'file_path': '/repo/lib/main.dart'},
        ),
      ],
    );
    expect(find.text('Sempre'), findsNothing);
    expect(find.text('Edit · /repo/lib/main.dart'), findsOneWidget);
  });
}
