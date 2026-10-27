import 'package:gsh_desktop/app/gsh/ui/session/chat_session.dart';
import 'dart:async' show unawaited;

import 'package:gsh_desktop/app/gsh/domain/entities/agent_message.dart';
import 'package:gsh_desktop/app/gsh/ui/actions/agent_graph_actions.dart';
import 'package:gsh_desktop/app/gsh/ui/session/agent_graph_session.dart';
import 'package:gsh_desktop/app/gsh/ui/session/external_agent.dart';
import 'package:gsh_desktop/app/gsh/ui/session/pane_item.dart';
import 'package:gsh_desktop/app/gsh/ui/session/terminal_session.dart';
import 'package:gsh_desktop/app/gsh/ui/viewmodels/agent_graph_store.dart';
import 'package:gsh_desktop/app/gsh/ui/viewmodels/gsh_viewmodel.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/agent_graph_painter.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/agent_graph_parts.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/agent_node_card.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/new_agent_dialog.dart';
import 'package:gsh_desktop/app/core/domain/entities/harness.dart';
import 'package:gsh_desktop/app/core/domain/result.dart';
import 'package:gsh_desktop/app/core/ui/automation_controller.dart';
import 'package:gsh_desktop/app/core/ui/themes/themes.dart';
import 'package:gsh_desktop/app/core/ui/widgets/app_menu.dart';
import 'package:gsh_desktop/i18n/strings.g.dart';
import 'package:flutter/scheduler.dart' show Ticker;
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

const Size _kScene = Size(4000, 3000);
const Offset _kPortOffset = Offset(kAgentNodeWidth, kAgentNodeHeight / 2);

/// Canvas do grafo de agentes (estilo Maestri): nós = abas de terminal com
/// agente, cabos = links definidos e mensagens observadas. Pan/zoom pelo
/// [InteractiveViewer]; cabos pelo [AgentGraphPainter].
class AgentGraphView extends StatefulWidget {
  const AgentGraphView({super.key, required this.session});
  final AgentGraphSession session;

  @override
  State<AgentGraphView> createState() => _AgentGraphViewState();
}

class _AgentGraphViewState extends State<AgentGraphView>
    with SingleTickerProviderStateMixin {
  final _transform = TransformationController();
  final _clock = Stopwatch()..start();
  late final Ticker _ticker = createTicker((_) => _prunePulses());
  late final GshViewModel _vm = context.read<GshViewModel>();
  final _pulses = <({String from, String to, Duration start})>[];
  AgentMessage? _lastSeen;
  Size _viewport = Size.zero;
  Offset? _hover;
  AgentPair? _hoverPair;
  PaneItem? _linkFrom;
  Offset? _linkStart, _linkEnd;

  String get _ws => widget.session.projectId;
  AgentGraphStore get _graph => _vm.agentGraph;

  @override
  void initState() {
    super.initState();
    _lastSeen = _vm.agentMessages.forWorkspace(_ws).lastOrNull;
    _vm.agentMessages.addListener(_onMessages);
    unawaited(context.read<AutomationController>().ensureInitialized());
  }

  @override
  void dispose() {
    _vm.agentMessages.removeListener(_onMessages);
    _ticker.dispose();
    _transform.dispose();
    super.dispose();
  }

  /// Mensagens novas viram pulsos no cabo do par, na direção do envio.
  void _onMessages() {
    final all = _vm.agentMessages.forWorkspace(_ws);
    if (all.isEmpty || identical(all.last, _lastSeen)) return;
    final seen = _lastSeen == null ? -1 : all.lastIndexOf(_lastSeen!);
    // Visto saiu do teto do log: pulsa só a última (não 500 de uma vez).
    final fresh = all.sublist(seen < 0 ? all.length - 1 : seen + 1);
    _lastSeen = all.last;
    for (final m in fresh) {
      _pulses.add((from: m.fromTabId, to: m.toTabId, start: _clock.elapsed));
    }
    if (!_ticker.isActive) _ticker.start();
  }

  void _prunePulses() {
    _pulses.removeWhere((p) => _clock.elapsed - p.start > kCablePulse);
    if (_pulses.isEmpty) _ticker.stop();
    setState(() {});
  }

  /// Mantém o nó inteiro dentro da cena (o pan deixa olhar além da borda).
  static Offset _inScene(Offset p) => Offset(
    p.dx.clamp(0, _kScene.width - kAgentNodeWidth),
    p.dy.clamp(0, _kScene.height - kAgentNodeHeight),
  );

  /// "+" / clique direito no vazio: dialog "New agent"; o nó nasce em
  /// [scenePos], ou no centro da área visível. Sem canvas ainda (estado
  /// vazio), a grade posiciona.
  Future<void> _createAgent({Offset? scenePos}) async {
    final at =
        scenePos ??
        (_viewport.isEmpty
            ? null
            : _transform.toScene(_viewport.center(Offset.zero)) -
                  const Offset(kAgentNodeWidth / 2, kAgentNodeHeight / 2));
    final automation = context.read<AutomationController>();
    await automation.ensureInitialized();
    if (!mounted) return;
    final onCanvas = {for (final e in _graph.externalsOf(_ws)) e.app};
    final desktop = [
      for (final i in await _vm.desktopApps.detect())
        if (!onCanvas.contains(i.app)) i,
    ];
    if (!mounted) return;
    final maestro = agentById(_vm, _graph.maestroOf(_ws) ?? '');
    final remote = _vm.projectById(_ws)?.isRemoteTerminal ?? false;
    final draft = await showNewAgentDialog(
      context,
      harnesses: [
        for (final h in automation.harnesses) ?HarnessCatalog.getSpec(h.id),
      ],
      desktopApps: desktop,
      taken: takenLabels(addressableAgents(_vm)),
      root: _vm.projectRootOf(_ws) ?? '',
      remote: remote,
      currentMaestro: maestro?.displayTitle,
    );
    if (draft == null || !mounted) return;
    final scene = at == null ? null : _inScene(at);
    final integration = draft.desktop;
    if (integration == null) {
      createAgent(_vm, _ws, widget.session.id, draft, at: scene);
      return;
    }
    final installed = await _vm.desktopApps.install(integration);
    if (!mounted) return;
    final tr = context.t.gsh.agentGraph;
    if (installed case Failure(:final error)) {
      return showGraphToast(context, desktopAppErrorMessage(context, error));
    }
    createExternalAgent(
      _vm,
      _ws,
      integration.app,
      // A pasta é local: num workspace remoto a IDE abre sem pasta.
      remote ? draft.withCwd('') : draft,
      at: scene,
    );
    showGraphToast(context, tr.restartHint(app: integration.app.label));
  }

  void _finishLink(Map<String, Offset> positions) {
    final from = _linkFrom;
    final end = _linkEnd;
    setState(() => _linkFrom = _linkStart = _linkEnd = null);
    if (from == null || end == null) return;
    for (final e in positions.entries) {
      final to = agentById(_vm, e.key);
      if (to != null &&
          to.id != from.id &&
          (e.value & const Size(kAgentNodeWidth, kAgentNodeHeight)).contains(
            end,
          )) {
        connectAgents(_vm, _ws, from, to);
        return;
      }
    }
  }

  void _onHover(Offset p, List<GraphCable> cables, Map<String, Offset> pos) {
    AgentPair? near;
    for (final c in cables) {
      final a = pos[c.pair.$1], b = pos[c.pair.$2];
      if (a != null && b != null && distanceToCable(cableCurve(a, b), p) < 8) {
        near = c.pair;
        break;
      }
    }
    if (near == null && _hoverPair == null) return;
    setState(() {
      _hoverPair = near;
      _hover = p;
    });
  }

  /// Clique direito: num link definido = remover; no vazio = agente novo ali.
  Future<void> _onSecondaryTap(BuildContext ctx, TapUpDetails d) async {
    final pair = _hoverPair;
    if (pair == null || !_graph.isLinked(_ws, pair.$1, pair.$2)) {
      return _createAgent(scenePos: d.localPosition);
    }
    final remove = await showAppMenu<bool>(
      ctx,
      globalPosition: d.globalPosition,
      items: [
        AppMenuItem(
          value: true,
          label: context.t.gsh.agentGraph.removeLink,
          icon: Icons.link_off,
          danger: true,
        ),
      ],
    );
    if (remove == true) _graph.removeLink(_ws, pair.$1, pair.$2);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<GshViewModel>();
    final terms = vm.allSessions
        .where(
          (s) =>
              (s is TerminalSession || s is ChatSession) && s.projectId == _ws,
        )
        .toList();
    return ListenableBuilder(
      listenable: Listenable.merge([vm.agentGraph, ...terms]),
      builder: (context, _) {
        final agents = workspaceAgents(vm, _ws);
        return agents.isEmpty
            ? AgentGraphEmpty(onCreate: (_) => _createAgent())
            : LayoutBuilder(
                builder: (context, box) {
                  _viewport = box.biggest;
                  return Stack(
                    children: [
                      Positioned.fill(child: _scene(context, agents)),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: NewAgentButton(onPressed: _createAgent),
                      ),
                    ],
                  );
                },
              );
      },
    );
  }

  Widget _scene(BuildContext context, List<PaneItem> agents) {
    final colors = context.colors;
    final ids = agents.map((s) => s.id).toSet();
    final positions = _graph.positionsOf(_ws);
    if (!ids.every(positions.containsKey)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Nó recém-visto (agente iniciado à mão) liga ao maestro atual.
        if (mounted) linkToMaestro(_vm, _ws, _graph.placeMissing(_ws, ids));
      });
    }
    final shown = {
      for (final e in positions.entries)
        if (ids.contains(e.key)) e.key: e.value,
    };
    final cables = buildCables(
      defined: _graph.linksOf(_ws),
      observed: observedEdges(_vm.agentMessages.forWorkspace(_ws)),
      nodes: ids,
    );
    final now = _clock.elapsed;
    final hovered = cables.where((c) => c.pair == _hoverPair).firstOrNull;
    final painter = AgentGraphPainter(
      colorOf: _graph.colorOf,
      positions: shown,
      cables: cables,
      pulses: [
        for (final p in _pulses)
          (
            from: p.from,
            to: p.to,
            progress:
                ((now - p.start).inMilliseconds / kCablePulse.inMilliseconds)
                    .clamp(0.0, 1.0),
          ),
      ],
      lineColor: colors.text3,
      definedColor: colors.text2,
      hoverColor: colors.accent,
      hovered: _hoverPair,
      pendingFrom: _linkStart,
      pendingTo: _linkEnd,
    );
    return InteractiveViewer(
      transformationController: _transform,
      constrained: false,
      minScale: 0.3,
      maxScale: 2,
      boundaryMargin: const EdgeInsets.all(400),
      child: MouseRegion(
        onHover: (e) => _onHover(e.localPosition, cables, shown),
        onExit: (_) => setState(() => _hoverPair = null),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onSecondaryTapUp: (d) => _onSecondaryTap(context, d),
          child: SizedBox.fromSize(
            size: _kScene,
            child: Stack(
              children: [
                Positioned.fill(child: CustomPaint(painter: painter)),
                for (final s in agents)
                  if (shown[s.id] case final at?)
                    Positioned(
                      left: at.dx,
                      top: at.dy,
                      child: _node(s, at, shown),
                    ),
                if ((hovered, _hover) case (final c?, final at?))
                  Positioned(
                    left: at.dx + 14,
                    top: at.dy + 14,
                    child: CableTip(cable: c),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Nó externo muda sozinho (online/working/fila): rebuild só dele.
  Widget _node(PaneItem s, Offset at, Map<String, Offset> shown) =>
      s is ExternalAgent
      ? ListenableBuilder(listenable: s, builder: (_, _) => _card(s, at, shown))
      : _card(s, at, shown);

  Widget _card(PaneItem s, Offset at, Map<String, Offset> shown) =>
      AgentNodeCard(
        session: s,
        color: _graph.colorOf(s.id),
        maestro: _graph.maestroOf(_ws) == s.id,
        onTap: () => focusAgent(_vm, _ws, s),
        onSecondaryTap: (global) =>
            showAgentNodeMenu(context, _vm, _ws, s, global),
        onDrag: (delta) => _graph.setPosition(_ws, s.id, _inScene(at + delta)),
        onPortDragStart: () => setState(() {
          _linkFrom = s;
          _linkStart = _linkEnd = at + _kPortOffset;
        }),
        onPortDrag: (delta) => setState(() => _linkEnd = _linkEnd! + delta),
        onPortDragEnd: () => _finishLink(shown),
      );
}
