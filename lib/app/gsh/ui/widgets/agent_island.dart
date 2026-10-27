import 'dart:async';

import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter/gestures.dart' show PointerEnterEvent, PointerExitEvent;
import 'package:flutter/scheduler.dart' show SchedulerBinding, SchedulerPhase;
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

  @override
  void initState() {
    super.initState();
    _vm.addListener(_sync);
    _rewatch();
    _agents = _collect();
    _asks = _vm.permissions.pending;
  }

  @override
  void dispose() {
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
  Widget build(BuildContext context) => AgentIslandView(
    agents: _agents,
    asks: _asks,
    onDecide: _vm.permissions.decide,
    onReveal: _vm.revealTab,
  );
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
  });

  final List<IslandAgent> agents;
  final List<AgentPermissionAsk> asks;
  final void Function(String id, AgentPermissionDecision decision) onDecide;
  final ValueChanged<String> onReveal;

  @override
  State<AgentIslandView> createState() => _AgentIslandViewState();
}

class _AgentIslandViewState extends State<AgentIslandView> {
  final _link = LayerLink();
  // Sempre mostrado: recolhida, o filho do overlay é vazio.
  final _portal = OverlayPortalController()..show();
  final _group = Object();
  int _hovers = 0;
  bool _pinned = false;
  Timer? _leave;
  Timer? _cheer;

  bool get _expanded => _hovers > 0 || _pinned || widget.asks.isNotEmpty;

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
  void dispose() {
    _leave?.cancel();
    _cheer?.cancel();
    super.dispose();
  }

  void _enter(PointerEnterEvent _) {
    _leave?.cancel();
    setState(() => _hovers++);
  }

  // Folga para o mouse cruzar da pílula para a lista sem fechar.
  void _exit(PointerExitEvent _) {
    _hovers--;
    _leave?.cancel();
    _leave = Timer(const Duration(milliseconds: 180), () {
      if (mounted) setState(() {});
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
            onEnter: _enter,
            onExit: _exit,
            child: Semantics(
              button: true,
              label: tr.summary(
                working: working,
                waiting: waiting,
                finished: finished,
              ),
              child: HoverTap(
                onTap: () => setState(() => _pinned = !_pinned),
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
    return Align(
      alignment: Alignment.topLeft,
      child: CompositedTransformFollower(
        link: _link,
        targetAnchor: Alignment.bottomCenter,
        followerAnchor: Alignment.topCenter,
        offset: const Offset(0, 6),
        child: TapRegion(
          groupId: _group,
          child: MouseRegion(
            onEnter: _enter,
            onExit: _exit,
            child: AgentIslandPanel(
              agents: widget.agents,
              asks: widget.asks,
              onDecide: widget.onDecide,
              onReveal: widget.onReveal,
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
