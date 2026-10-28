import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter/rendering.dart' as rendering;
import 'package:flutter/scheduler.dart' show SchedulerBinding, SchedulerPhase;
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:gsh_desktop/app/core/domain/entities/harness.dart';
import 'package:gsh_desktop/app/core/ui/themes/themes.dart';
import 'package:gsh_desktop/app/core/ui/widgets/hover_tap.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/agent_permission.dart';
import 'package:gsh_desktop/app/gsh/ui/session/chat_session.dart';
import 'package:gsh_desktop/app/gsh/ui/session/pane_item.dart';
import 'package:gsh_desktop/app/gsh/ui/session/terminal_session.dart';
import 'package:gsh_desktop/app/gsh/ui/viewmodels/chat_viewmodel.dart';
import 'package:gsh_desktop/app/gsh/ui/viewmodels/gsh_viewmodel.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/agent_island_panel.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/island_gorilla.dart';
import 'package:gsh_desktop/i18n/strings.g.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

enum IslandAgentState { working, waiting, finished }

/// Um agente que a ilha mostra (aba de terminal ou de chat).
typedef IslandAgent = ({
  String tabId,
  String title,
  String workspace,
  IslandAgentState state,
  HarnessKind? harness,
});

const islandWindowChannel = MethodChannel('gsh/agent_island');

/// O segundo engine recebe só a vista da ilha. As decisões continuam no
/// broker do engine principal, onde o hook do terminal está esperando.
String encodeIslandSnapshot(
  List<IslandAgent> agents,
  List<AgentPermissionAsk> asks,
) => jsonEncode({
  'agents': [
    for (final a in agents)
      {
        'tabId': a.tabId,
        'title': a.title,
        'workspace': a.workspace,
        'state': a.state.name,
        'harness': a.harness?.name,
      },
  ],
  'asks': [
    for (final a in asks)
      {
        'id': a.id,
        'tabId': a.tabId,
        'toolName': a.toolName,
        'input': a.input,
        'alwaysRule': a.alwaysRule,
      },
  ],
});

/// Ilha de agentes ligada ao shell: observa as abas (status do hook, "não
/// visto", chat esperando) e os pedidos de permissão, e só reconstrói quando
/// a lista que ela mostra muda (o chat notifica a cada token).
class AgentIsland extends StatefulWidget {
  const AgentIsland({super.key});

  @override
  State<AgentIsland> createState() => _AgentIslandState();
}

class _AgentIslandState extends State<AgentIsland> {
  late final GshViewModel _vm = context.read<GshViewModel>();
  late final ChatViewModel _chats = context.read<ChatViewModel>();
  List<Listenable> _watched = const [];
  List<IslandAgent> _agents = const [];
  List<AgentPermissionAsk> _asks = const [];
  bool _deferred = false;
  bool _floatingAvailable = true;

  @override
  void initState() {
    super.initState();
    _vm.addListener(_sync);
    _rewatch();
    _agents = _collect();
    _asks = _vm.permissions.pending;
    if (Platform.isLinux) {
      islandWindowChannel.setMethodCallHandler(_onFloatingAction);
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (mounted) unawaited(_pushFloating());
      });
    }
  }

  @override
  void dispose() {
    if (Platform.isLinux) {
      islandWindowChannel.setMethodCallHandler(null);
      unawaited(_hideFloating());
    }
    _vm.removeListener(_sync);
    for (final l in _watched) {
      l.removeListener(_sync);
    }
    super.dispose();
  }

  void _sync() {
    if (!mounted) return;
    // Notificado no meio de um build/layout (aba medindo o viewport): o
    // setState espera o quadro acabar.
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      if (_deferred) return;
      _deferred = true;
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _deferred = false;
        _sync();
      });
      return;
    }
    _rewatch();
    final agents = _collect();
    final asks = _vm.permissions.pending;
    if (listEquals(agents, _agents) && listEquals(asks, _asks)) return;
    setState(() {
      _agents = agents;
      _asks = asks;
    });
    if (Platform.isLinux) unawaited(_pushFloating());
  }

  Future<void> _pushFloating() async {
    if (!_floatingAvailable) return;
    try {
      _floatingAvailable =
          await islandWindowChannel.invokeMethod<bool>(
            'update',
            encodeIslandSnapshot(_agents, _asks),
          ) ??
          false;
    } on MissingPluginException {
      _floatingAvailable = false;
    } on PlatformException {
      _floatingAvailable = false;
    }
  }

  Future<void> _hideFloating() async {
    try {
      await islandWindowChannel.invokeMethod<void>('hide');
    } on MissingPluginException {
      // Plataforma sem janela layer-shell: a ilha da barra continua visível.
    } on PlatformException {
      // A janela pode já ter fechado junto com o engine.
    }
  }

  Future<void> _onFloatingAction(MethodCall call) async {
    if (!mounted) return;
    if (call.method == 'reveal') {
      final tabId = call.arguments;
      if (tabId is String) _vm.revealTab(tabId);
      return;
    }
    if (call.method != 'decide') return;
    if (call.arguments case {
      'id': String id,
      'decision': String decisionName,
    }) {
      final decision = AgentPermissionDecision.values
          .where((d) => d.name == decisionName)
          .firstOrNull;
      final ask = _vm.permissions.pending.where((a) => a.id == id).firstOrNull;
      if (decision == null || ask == null) return;
      if (decision == AgentPermissionDecision.allowAlways &&
          ask.alwaysRule == null) {
        return;
      }
      _vm.permissions.decide(id, decision);
    }
  }

  /// Assina o broker, cada aba de agente e a conversa de cada chat aberto.
  void _rewatch() {
    final next = <Listenable>[
      _vm.permissions,
      for (final s in _vm.allSessions)
        if (s is TerminalSession)
          s
        else if (s is ChatSession) ...[
          s,
          ?_chats.existing(s.id),
        ],
    ];
    if (listEquals(next, _watched)) return;
    for (final l in _watched) {
      l.removeListener(_sync);
    }
    for (final l in next) {
      l.addListener(_sync);
    }
    _watched = next;
  }

  List<IslandAgent> _collect() {
    final asking = {for (final a in _vm.permissions.pending) a.tabId};
    return [
      for (final s in _vm.allSessions)
        if (_stateOf(s, asking) case final state?)
          (
            tabId: s.id,
            title: s.displayTitle,
            workspace: _vm.projectById(s.projectId)?.name ?? '',
            state: state,
            harness: switch (s) {
              TerminalSession(:final activeHarness) => activeHarness,
              ChatSession() => HarnessKind.claudeCode,
              _ => null,
            },
          ),
    ];
  }

  IslandAgentState? _stateOf(PaneItem s, Set<String> asking) => switch (s) {
    TerminalSession(:final status)
        when asking.contains(s.id) || status == TerminalStatus.waiting =>
      IslandAgentState.waiting,
    TerminalSession(status: TerminalStatus.working) => IslandAgentState.working,
    ChatSession() when _chats.existing(s.id)?.waitingPermission ?? false =>
      IslandAgentState.waiting,
    ChatSession(isWorking: true) => IslandAgentState.working,
    TerminalSession() ||
    ChatSession() when s.unseenFinish => IslandAgentState.finished,
    _ => null,
  };

  @override
  Widget build(BuildContext context) {
    final view = AgentIslandView(
      agents: _agents,
      asks: _asks,
      onDecide: _vm.permissions.decide,
      onReveal: _vm.revealTab,
    );
    return Platform.isLinux ? IslandHorizontalCenter(child: view) : view;
  }
}

/// Centraliza a pílula horizontalmente no centro geométrico da janela,
/// compensando larguras diferentes nos ícones laterais da barra principal sem
/// invadir os controles vizinhos nem bloquear o arrasto da titlebar.
class IslandHorizontalCenter extends SingleChildRenderObjectWidget {
  const IslandHorizontalCenter({
    super.key,
    this.centerOffset = 0.0,
    super.child,
  });

  final double centerOffset;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderIslandHorizontalCenter(centerOffset);

  @override
  void updateRenderObject(
    BuildContext context,
    RenderObject renderObject,
  ) {
    (renderObject as _RenderIslandHorizontalCenter).centerOffset = centerOffset;
  }
}

class _RenderIslandHorizontalCenter extends rendering.RenderShiftedBox {
  _RenderIslandHorizontalCenter(this._centerOffset) : super(null);

  double _centerOffset;
  double get centerOffset => _centerOffset;
  set centerOffset(double value) {
    if (_centerOffset == value) return;
    _centerOffset = value;
    markNeedsLayout();
  }

  double? _lastSlotLeft;
  double? _lastWindowWidth;
  double? _lastPaintDx;
  bool _positionDirty = true;

  double _computeDx(double slotLeft, double windowWidth, double childWidth) {
    final targetCenter = windowWidth / 2 + _centerOffset;
    final targetLeft = targetCenter - childWidth / 2 - slotLeft;
    final maxLeft = math.max(0.0, size.width - childWidth);
    return targetLeft.clamp(0.0, maxLeft);
  }

  @override
  void attach(rendering.PipelineOwner owner) {
    super.attach(owner);
    _positionDirty = true;
  }

  @override
  void performLayout() {
    _positionDirty = true;
    final child = this.child;
    if (child == null) {
      size = constraints.smallest;
      return;
    }
    child.layout(constraints.loosen(), parentUsesSize: true);
    size = constraints.constrain(
      Size(
        constraints.hasBoundedWidth ? constraints.maxWidth : child.size.width,
        child.size.height,
      ),
    );
    final childParentData = child.parentData! as rendering.BoxParentData;
    final slotLeft = _lastSlotLeft;
    final windowWidth = _lastWindowWidth;
    final double dx = slotLeft != null && windowWidth != null
        ? _computeDx(slotLeft, windowWidth, child.size.width)
        : ((size.width - child.size.width) / 2 + _centerOffset).clamp(
            0.0,
            math.max(0.0, size.width - child.size.width),
          );
    childParentData.offset = Offset(dx, (size.height - child.size.height) / 2);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (_lastPaintDx != offset.dx) {
      _lastPaintDx = offset.dx;
      _positionDirty = true;
    }
    _updateChildOffset();
    super.paint(context, offset);
  }

  @override
  void applyPaintTransform(RenderObject child, Matrix4 transform) {
    _updateChildOffset();
    super.applyPaintTransform(child, transform);
  }

  @override
  bool hitTestChildren(
    rendering.BoxHitTestResult result, {
    required Offset position,
  }) {
    _updateChildOffset();
    return super.hitTestChildren(result, position: position);
  }

  void _updateChildOffset() {
    if (!_positionDirty) return;
    final child = this.child;
    if (child == null || !hasSize || !child.hasSize) return;
    if (RenderObject.debugActiveLayout != null) return;
    _positionDirty = false;
    var slotLeft = 0.0;
    var windowWidth = size.width;
    rendering.RenderBox? node = this;
    while (node != null) {
      final parent = node.parent;
      if (parent is! rendering.RenderBox) {
        if (node.hasSize) windowWidth = node.size.width;
        break;
      }
      if (node.parentData case final rendering.BoxParentData pd) {
        slotLeft += pd.offset.dx;
      }
      node = parent;
    }
    _lastSlotLeft = slotLeft;
    _lastWindowWidth = windowWidth;
    final dx = _computeDx(slotLeft, windowWidth, child.size.width);
    final dy = (size.height - child.size.height) / 2;
    final childParentData = child.parentData! as rendering.BoxParentData;
    final nextOffset = Offset(dx, dy);
    if (childParentData.offset != nextOffset) {
      childParentData.offset = nextOffset;
    }
  }
}

/// A pílula (gorila + contadores) e, aberta, a lista embaixo dela. Abre no
/// hover, no clique (fica presa até clicar fora) e sozinha enquanto houver
/// pedido de permissão.
class AgentIslandView extends StatefulWidget {
  const AgentIslandView({
    super.key,
    required this.agents,
    required this.asks,
    required this.onDecide,
    required this.onReveal,
    this.onPanelHeight,
  });

  final List<IslandAgent> agents;
  final List<AgentPermissionAsk> asks;
  final void Function(String id, AgentPermissionDecision decision) onDecide;
  final ValueChanged<String> onReveal;

  /// Altura interativa do painel no segundo engine; zero quando recolhido.
  final ValueChanged<int>? onPanelHeight;

  @override
  State<AgentIslandView> createState() => _AgentIslandViewState();
}

class _AgentIslandViewState extends State<AgentIslandView>
    with WidgetsBindingObserver {
  final _link = LayerLink();
  // Sempre mostrado: recolhida, o filho do overlay é vazio.
  final _portal = OverlayPortalController()..show();
  final _group = Object();
  final _panelKey = GlobalKey();
  int? _reportedPanelHeight;
  bool _heightCheckScheduled = false;
  bool _pillHovered = false;
  bool _panelHovered = false;
  bool _hoverActive = false;
  bool _pinned = false;
  Timer? _leave;
  Timer? _cheer;

  bool get _expanded => _hoverActive || _pinned || widget.asks.isNotEmpty;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  Set<String> _ids(List<IslandAgent> agents, IslandAgentState s) => {
    for (final a in agents)
      if (a.state == s) a.tabId,
  };

  @override
  void didUpdateWidget(AgentIslandView old) {
    super.didUpdateWidget(old);
    // Quem trabalhava e não passou a esperar terminou: o gorila pula.
    final done = _ids(old.agents, IslandAgentState.working)
        .difference(_ids(widget.agents, IslandAgentState.working))
        .difference(_ids(widget.agents, IslandAgentState.waiting));
    if (done.isEmpty) return;
    _cheer?.cancel();
    _cheer = Timer(const Duration(milliseconds: 1400), () {
      if (mounted) setState(() => _cheer = null);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed && _pinned) {
      setState(() => _pinned = false);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _leave?.cancel();
    _cheer?.cancel();
    super.dispose();
  }

  void _enterPill(PointerEnterEvent _) {
    _pillHovered = true;
    _leave?.cancel();
    if (!_hoverActive) setState(() => _hoverActive = true);
  }

  void _exitPill(PointerExitEvent _) {
    _pillHovered = false;
    _scheduleLeave();
  }

  void _enterPanel(PointerEnterEvent _) {
    _panelHovered = true;
    _leave?.cancel();
    if (!_hoverActive) setState(() => _hoverActive = true);
  }

  void _exitPanel(PointerExitEvent _) {
    _panelHovered = false;
    _scheduleLeave();
  }

  // Folga para o mouse cruzar da pílula para a lista sem fechar.
  void _scheduleLeave() {
    _leave?.cancel();
    if (_pillHovered || _panelHovered) return;
    _leave = Timer(const Duration(milliseconds: 180), () {
      if (mounted && !_pillHovered && !_panelHovered && _hoverActive) {
        setState(() => _hoverActive = false);
      }
    });
  }

  void _schedulePanelHeightReport() {
    if (widget.onPanelHeight == null || _heightCheckScheduled) return;
    _heightCheckScheduled = true;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _heightCheckScheduled = false;
      if (!mounted) return;
      final nextHeight = _expanded
          ? (_panelKey.currentContext?.size?.height.ceil() ?? 350)
          : 0;
      if (nextHeight == _reportedPanelHeight) return;
      _reportedPanelHeight = nextHeight;
      widget.onPanelHeight?.call(nextHeight);
    });
  }

  GorillaMood _mood(int working, int waiting) {
    if (waiting > 0) return GorillaMood.wave;
    if (_cheer != null) return GorillaMood.cheer;
    if (working > 0) return GorillaMood.typing;
    if (widget.agents.isEmpty) return GorillaMood.sleep;
    return _expanded ? GorillaMood.breathe : GorillaMood.rest;
  }

  @override
  Widget build(BuildContext context) {
    if (!_expanded) _panelHovered = false;
    _schedulePanelHeightReport();
    final colors = context.colors;
    final asked = {for (final a in widget.asks) a.tabId};
    int count(IslandAgentState s) => widget.agents
        .where((a) => a.state == s && !asked.contains(a.tabId))
        .length;
    final working = count(IslandAgentState.working);
    final waiting = count(IslandAgentState.waiting) + widget.asks.length;
    final finished = count(IslandAgentState.finished);
    final tr = context.t.gsh.agentIsland;
    return CompositedTransformTarget(
      link: _link,
      child: OverlayPortal(
        controller: _portal,
        overlayChildBuilder: _panel,
        child: TapRegion(
          groupId: _group,
          onTapOutside: (_) {
            if (_pinned) setState(() => _pinned = false);
          },
          child: MouseRegion(
            onEnter: _enterPill,
            onExit: _exitPill,
            child: Semantics(
              button: true,
              label: tr.summary(
                working: working,
                waiting: waiting,
                finished: finished,
              ),
              child: HoverTap(
                onTap: () => setState(() {
                  _pinned = !_pinned;
                  if (!_pinned) _hoverActive = false;
                }),
                color: colors.panel2,
                hoverColor: colors.panel3,
                border: Border.all(
                  color: waiting > 0 ? colors.warn : colors.border,
                ),
                borderRadius: BorderRadius.circular(15),
                padding: const EdgeInsets.symmetric(horizontal: 9),
                child: SizedBox(
                  height: 30,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IslandGorilla(mood: _mood(working, waiting)),
                      for (final (n, c) in [
                        (working, colors.accent),
                        (waiting, colors.warn),
                        (finished, colors.online),
                      ])
                        if (n > 0) _Count(n: n, color: c),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _panel(BuildContext context) {
    if (!_expanded) return const SizedBox.shrink();
    _schedulePanelHeightReport();
    final windowWidth = MediaQuery.sizeOf(context).width;
    final centerOffset =
        this.context
            .findAncestorWidgetOfExactType<IslandHorizontalCenter>()
            ?.centerOffset ??
        0.0;
    const halfPanel = AgentIslandPanel.width / 2;
    const minMargin = 10.0;
    final targetCenter = windowWidth / 2 + centerOffset;
    final clampedCenter = windowWidth >= AgentIslandPanel.width + minMargin * 2
        ? targetCenter.clamp(
            minMargin + halfPanel,
            windowWidth - minMargin - halfPanel,
          )
        : targetCenter;
    final followerDx = clampedCenter - targetCenter;
    return Align(
      alignment: Alignment.topLeft,
      child: CompositedTransformFollower(
        link: _link,
        targetAnchor: Alignment.bottomCenter,
        followerAnchor: Alignment.topCenter,
        offset: Offset(followerDx, 0),
        child: TapRegion(
          groupId: _group,
          child: MouseRegion(
            onEnter: _enterPanel,
            onExit: _exitPanel,
            child: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: AgentIslandPanel(
                key: _panelKey,
                agents: widget.agents,
                asks: widget.asks,
                onDecide: widget.onDecide,
                onReveal: (tabId) {
                  if (_pinned) setState(() => _pinned = false);
                  widget.onReveal(tabId);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Count extends StatelessWidget {
  const _Count({required this.n, required this.color});
  final int n;
  final Color color;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(left: 8),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          '$n',
          style: context.typo.mono.copyWith(
            fontSize: 12,
            color: context.colors.text2,
          ),
        ),
      ],
    ),
  );
}
