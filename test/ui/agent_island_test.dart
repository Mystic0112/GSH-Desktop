import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:gsh_desktop/app/core/domain/contracts/settings_store.dart';
import 'package:gsh_desktop/app/core/domain/entities/app_settings.dart';
import 'package:gsh_desktop/app/core/domain/entities/harness.dart';
import 'package:gsh_desktop/app/core/ui/settings_controller.dart';
import 'package:gsh_desktop/app/core/ui/themes/themes.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/agent_permission.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/agent_island.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/agent_island_panel.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/floating_agent_island.dart';
import 'package:gsh_desktop/i18n/strings.g.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'shot_harness.dart';

class _MemorySettingsStore implements SettingsStore {
  AppSettings value = shotSettings;

  @override
  Future<AppSettings> load() async => value;

  @override
  Future<void> save(AppSettings settings) async {
    value = settings;
  }
}

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
  ({
    List<(String, AgentPermissionDecision)> decisions,
    List<String> reveals,
    List<int> heights,
  })
>
_pump(
  WidgetTester tester, {
  required List<IslandAgent> agents,
  List<AgentPermissionAsk> asks = const [],
}) async {
  final decisions = <(String, AgentPermissionDecision)>[];
  final reveals = <String>[];
  final heights = <int>[];
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
                      child: IslandHorizontalCenter(
                        child: AgentIslandView(
                          agents: agents,
                          asks: asks,
                          onDecide: (id, d) => decisions.add((id, d)),
                          onReveal: reveals.add,
                          onPanelHeight: heights.add,
                        ),
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
  return (decisions: decisions, reveals: reveals, heights: heights);
}

void main() {
  setUpAll(loadShotFonts);
  setUp(() => LocaleSettings.setLocale(AppLocale.ptBr));

  test('o snapshot da janela flutuante preserva o pedido sem a regra crua', () {
    final decoded = decodeFloatingIslandSnapshot(
      encodeIslandSnapshot(_agents, const [_ask]),
    );
    expect(decoded.agents, _agents);
    expect(decoded.asks.single.id, _ask.id);
    expect(decoded.asks.single.input, _ask.input);
    expect(decoded.asks.single.alwaysRule, _ask.alwaysRule);
    expect(decoded.asks.single.alwaysRaw, isNull);
    expect(decodeFloatingIslandSnapshot('{').asks, isEmpty);
    final sanitized = decodeFloatingIslandSnapshot(
      '{"agents":[{"tabId":"","title":"x","workspace":"w","state":"working"}],'
      '"asks":[{"id":"p","tabId":"t5","toolName":"Bash","input":{},"alwaysRule":""},'
      '{"id":"","tabId":"t5","toolName":"Bash","input":{}}]}',
    );
    expect(sanitized.agents, isEmpty);
    expect(sanitized.asks.single.alwaysRule, isNull);
  });

  void size(WidgetTester tester, double h) {
    tester.view
      ..physicalSize = Size(1040, h * 2)
      ..devicePixelRatio = 2;
    addTearDown(tester.view.reset);
  }

  testWidgets('recolhida: só os contadores, sem a lista', (tester) async {
    size(tester, 80);
    final r = await _pump(tester, agents: _agents);
    expect(find.text('2'), findsNWidgets(2)); // trabalhando · esperando
    expect(find.text('1'), findsOneWidget); // terminou
    expect(find.text('Trabalhando'.toUpperCase()), findsNothing);
    expect(r.heights, [0]);
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
    expect(r.heights.single, greaterThan(0));
    await takeShot(tester, 'agent_island_expanded');
    await tester.tap(find.text('Permitir'));
    expect(r.decisions, [('p1', AgentPermissionDecision.allow)]);
  });

  testWidgets('Sempre e Negar decidem allowAlways e deny', (tester) async {
    size(tester, 520);
    final r = await _pump(tester, agents: _agents, asks: const [_ask]);
    await tester.tap(find.text('Sempre'));
    await tester.tap(find.text('Negar'));
    expect(r.decisions, [
      ('p1', AgentPermissionDecision.allowAlways),
      ('p1', AgentPermissionDecision.deny),
    ]);
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

  testWidgets('hover abre a ilha, atravessa para o painel e fecha ao sair', (
    tester,
  ) async {
    size(tester, 520);
    final r = await _pump(tester, agents: _agents);
    expect(r.heights, [0]);

    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    addTearDown(mouse.removePointer);

    // Entra na pílula: abre o painel e reporta a altura real medida.
    await mouse.moveTo(tester.getCenter(find.byType(AgentIslandView)));
    await tester.pump();
    expect(find.text('plano da ilha'), findsOneWidget);
    expect(r.heights.last, greaterThan(0));

    // Atravessa a folga até o painel e permanece aberto além dos 180ms.
    await mouse.moveTo(tester.getCenter(find.text('plano da ilha')));
    await tester.pump(const Duration(milliseconds: 250));
    expect(find.text('plano da ilha'), findsOneWidget);

    // Sai do painel: recolhe após a folga e reporta altura 0.
    await mouse.moveTo(const Offset(10, 10));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('plano da ilha'), findsNothing);
    expect(r.heights.last, 0);
  });

  testWidgets('clique prende a ilha e perda de foco da janela solta', (
    tester,
  ) async {
    size(tester, 520);
    final r = await _pump(tester, agents: _agents);
    await tester.tap(find.byType(AgentIslandView));
    await tester.pump();
    expect(find.text('plano da ilha'), findsOneWidget);
    expect(r.heights.last, greaterThan(0));

    // Na janela layer-shell do COSMIC, clicar em outro app tira o foco.
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    await tester.pump();
    expect(find.text('plano da ilha'), findsNothing);
    expect(r.heights.last, 0);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
  });

  testWidgets(
    'FloatingIslandApp mantém fundo transparente, tema/i18n e envia ações pelo canal',
    (tester) async {
      tester.view
        ..physicalSize = const Size(800, 1000)
        ..devicePixelRatio = 2;
      addTearDown(tester.view.reset);

      final calls = <MethodCall>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(islandWindowChannel, (call) async {
            calls.add(call);
            return null;
          });
      addTearDown(() {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(islandWindowChannel, null);
      });

      final settings = SettingsController(_MemorySettingsStore())
        ..setInterfaceFont('ChatUi')
        ..setCodeFont('ChatMono');
      final snapshots = ValueNotifier<FloatingIslandSnapshot>((
        agents: _agents,
        asks: const [_ask],
      ));

      await tester.pumpWidget(
        TranslationProvider(
          child: ModularApp(
            module: createModule(register: (_) {}),
            provide: (s) =>
                s..addChangeNotifier<SettingsController>(() => settings),
            child: FloatingIslandApp(snapshots: snapshots),
          ),
        ),
      );
      await tester.pump();

      final app = tester.widget<ShadcnApp>(find.byType(ShadcnApp));
      expect(app.background, Colors.transparent);
      // Na janela flutuante de 400px (que o layer-shell centra em x=960 no monitor de 1920px),
      // o centro da pílula fica em x=200px (x=960 no monitor) e o painel (380px) em x=10..390.
      expect(
        tester.getCenter(find.byType(AgentIslandView)).dx,
        closeTo(200.0, 0.5),
      );
      final floatingPanelRect = tester.getRect(find.byType(AgentIslandPanel));
      expect(floatingPanelRect.left, closeTo(10.0, 0.1));
      expect(floatingPanelRect.right, closeTo(390.0, 0.1));
      // Em viewport 1920px, o centro da pílula fica diretamente em x = 960.
      tester.view
        ..physicalSize = const Size(1920, 600)
        ..devicePixelRatio = 1;
      await tester.pump();
      expect(
        tester.getCenter(find.byType(AgentIslandView)).dx,
        closeTo(960.0, 0.5),
      );
      expect(
        calls.where((c) => c.method == 'shape').last.arguments,
        greaterThan(0),
      );

      // Troca de idioma em runtime reflete nos botões da ilha flutuante.
      LocaleSettings.setLocaleSync(AppLocale.en);
      await tester.pump(Duration.zero);
      expect(find.text('Allow'), findsOneWidget);

      await tester.tap(find.text('Allow'));
      expect(
        calls.where((c) => c.method == 'decide').single.arguments,
        {'id': 'p1', 'decision': 'allow'},
      );

      await tester.tap(find.text('plano da ilha'));
      expect(
        calls.where((c) => c.method == 'reveal').single.arguments,
        't3',
      );
    },
  );

  testWidgets(
    'barra 1919/1920px: alternar FarmStrip de 0 para 1 pedido ("1 precisa de você") mantém a pílula parada em x≈960',
    (tester) async {
      tester.view
        ..physicalSize = const Size(1919, 600)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      var backgroundTaps = 0;

      final leftWidth = ValueNotifier<double>(168);
      final farmWaitingCount = ValueNotifier<int>(0);
      final centerOffset = ValueNotifier<double>(0);
      final islandAgents = ValueNotifier<List<IslandAgent>>([
        _agent('t4', 'migração do banco', IslandAgentState.finished),
      ]);
      addTearDown(leftWidth.dispose);
      addTearDown(farmWaitingCount.dispose);
      addTearDown(centerOffset.dispose);
      addTearDown(islandAgents.dispose);

      // Reproduz a estrutura real da GshTopbar (Row + Expanded + LayoutBuilder + Center)
      // e as duas capturas de 1919px no COSMIC:
      // - Estado 0 (/tmp/codex-clipboard-jfDhuF.png): sem "1 precisa de você" no FarmStrip (~396px à direita)
      // - Estado 1 (/tmp/codex-clipboard-elgswj.png): com "1 precisa de você" no FarmStrip (~525px à direita)
      await tester.pumpWidget(
        shotHost(
          Overlay(
            initialEntries: [
              OverlayEntry(
                builder: (context) => Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    height: 46,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () => backgroundTaps++,
                            child: const SizedBox.expand(),
                          ),
                        ),
                        Positioned.fill(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Row(
                              children: [
                                ValueListenableBuilder<double>(
                                  valueListenable: leftWidth,
                                  builder: (context, w, _) =>
                                      SizedBox(width: w, height: 46),
                                ),
                                Expanded(
                                  child: LayoutBuilder(
                                    builder: (context, c) => c.maxWidth < 160
                                        ? const SizedBox.shrink()
                                        : Center(
                                            child: ValueListenableBuilder<
                                              double
                                            >(
                                              valueListenable: centerOffset,
                                              builder: (context, offset, _) =>
                                                  ValueListenableBuilder<
                                                    List<IslandAgent>
                                                  >(
                                                    valueListenable:
                                                        islandAgents,
                                                    builder:
                                                        (context, agents, _) =>
                                                            IslandHorizontalCenter(
                                                              centerOffset:
                                                                  offset,
                                                              child: AgentIslandView(
                                                                agents: agents,
                                                                asks: const [],
                                                                onDecide:
                                                                    (_, _) {},
                                                                onReveal:
                                                                    (_) {},
                                                              ),
                                                            ),
                                                  ),
                                            ),
                                          ),
                                  ),
                                ),
                                ValueListenableBuilder<int>(
                                  valueListenable: farmWaitingCount,
                                  builder: (context, waitingCount, _) => Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Contadores base do FarmStrip ("0 · 0 · 1")
                                      const SizedBox(width: 110, height: 28),
                                      // Pílula "1 precisa de você" que entra quando há pedido
                                      if (waitingCount > 0)
                                        const SizedBox(width: 129, height: 22),
                                      // 5 ícones de ação + WindowControlsTrailing
                                      const SizedBox(width: 286, height: 46),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
      await tester.pump();

      // 1) Com 0 pedidos no FarmStrip: centro da pílula em x = 959.5 (≈ 960).
      final rect0 = tester.getRect(find.byType(AgentIslandView));
      expect(rect0.center.dx, closeTo(959.5, 0.5));

      // 2) FarmStrip alterna de 0 para 1 pedido ("1 precisa de você", +129px à direita):
      // a pílula NÃO pode deslocar para a esquerda (785px); permanece cravada no mesmo x ≈ 960.
      farmWaitingCount.value = 1;
      await tester.pump();
      final rect1 = tester.getRect(find.byType(AgentIslandView));
      expect(rect1.center.dx, closeTo(rect0.center.dx, 0.01));
      expect(rect1.left, closeTo(rect0.left, 0.01));

      // 3) Quando a própria pílula também passa a exibir o contador amarelo (• 1 • 1, ~102px como em elgswj.png):
      // o centro continua ancorado em x ≈ 960.
      islandAgents.value = [
        _agent('t3', 'plano da ilha', IslandAgentState.waiting),
        _agent('t4', 'migração do banco', IslandAgentState.finished),
      ];
      await tester.pump();
      final rectWithAsk = tester.getRect(find.byType(AgentIslandView));
      expect(rectWithAsk.center.dx, closeTo(rect0.center.dx, 0.01));
      expect(rectWithAsk.width, greaterThan(rect0.width));

      // 4) Alternando FarmStrip de volta para 0 pedidos: continua imóvel em x ≈ 960.
      farmWaitingCount.value = 0;
      await tester.pump();
      final rectBackTo0 = tester.getRect(find.byType(AgentIslandView));
      expect(rectBackTo0.center.dx, closeTo(rect0.center.dx, 0.01));

      // 5) Em viewport 1920px com FarmStrip alternando 0 -> 1 pedido: cravado em x = 960.0.
      tester.view.physicalSize = const Size(1920, 600);
      await tester.pump();
      final rect1920Before = tester.getRect(find.byType(AgentIslandView));
      expect(rect1920Before.center.dx, closeTo(960.0, 0.5));
      farmWaitingCount.value = 1;
      await tester.pump();
      final rect1920After = tester.getRect(find.byType(AgentIslandView));
      expect(rect1920After.center.dx, closeTo(960.0, 0.5));
      expect(rect1920After.center.dx, closeTo(rect1920Before.center.dx, 0.01));

      // 6) Mudança compensatória: lado esquerdo cresce +129px (168 -> 297) e FarmStrip
      // encolhe -129px (1 -> 0 pedido) no mesmo frame, mantendo a largura do Expanded
      // constante (1219px) sem performLayout local no wrapper; o centro segue em x = 960.0.
      final wrapperWidthBefore = tester
          .getSize(find.byType(IslandHorizontalCenter))
          .width;
      leftWidth.value = 168 + 129;
      farmWaitingCount.value = 0;
      await tester.pump();
      final wrapperWidthAfter = tester
          .getSize(find.byType(IslandHorizontalCenter))
          .width;
      expect(wrapperWidthAfter, closeTo(wrapperWidthBefore, 0.01));
      final rectCompensated = tester.getRect(find.byType(AgentIslandView));
      expect(rectCompensated.center.dx, closeTo(960.0, 0.5));
      expect(rectCompensated.center.dx, closeTo(rect1920After.center.dx, 0.01));

      // Clique em x = 785 (onde a pílula caía no código antigo) continua sendo área vazia da barra.
      await tester.tapAt(const Offset(785, 23));
      await tester.pump();
      expect(backgroundTaps, 1);
      expect(find.text('plano da ilha'), findsNothing);

      // Clique na pílula em x = 960 abre o painel centrado em x = 960 (770..1150).
      await tester.tap(find.byType(AgentIslandView));
      await tester.pump();
      expect(find.text('plano da ilha'), findsOneWidget);
      final panelRect = tester.getRect(find.byType(AgentIslandPanel));
      expect(panelRect.left, closeTo(770.0, 0.1));
      expect(panelRect.right, closeTo(1150.0, 0.1));
    },
  );
}
