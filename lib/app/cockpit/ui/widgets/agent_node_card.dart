import 'package:cockpit/app/cockpit/ui/session/external_agent.dart';
import 'package:cockpit/app/cockpit/ui/session/pane_item.dart';
import 'package:cockpit/app/cockpit/ui/session/terminal_session.dart';
import 'package:cockpit/app/cockpit/ui/widgets/agent_graph_painter.dart';
import 'package:cockpit/app/core/domain/entities/harness.dart';
import 'package:cockpit/app/core/ui/themes/themes.dart';
import 'package:cockpit/app/core/ui/widgets/app_tooltip.dart';
import 'package:cockpit/app/core/utils/path_utils.dart';
import 'package:cockpit/i18n/strings.g.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

/// Logo do harness (SVG do catálogo); monocromático segue [color].
class HarnessIcon extends StatelessWidget {
  const HarnessIcon(
    this.spec, {
    super.key,
    this.size = 16,
    required this.color,
  });
  final HarnessSpec spec;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) => SvgPicture.asset(
    spec.assetPath,
    width: size,
    height: size,
    colorFilter: spec.isMonochrome
        ? ColorFilter.mode(color, BlendMode.srcIn)
        : null,
  );
}

/// Nó do grafo: card do agente (aba de terminal ou nó externo — app desktop)
/// + a porta (à direita) de onde se arrasta um link. A caixa inclui a metade
/// de fora da porta — fora dela não há hit test.
class AgentNodeCard extends StatelessWidget {
  const AgentNodeCard({
    super.key,
    required this.session,
    required this.color,
    this.maestro = false,
    required this.onTap,
    required this.onSecondaryTap,
    required this.onDrag,
    required this.onPortDragStart,
    required this.onPortDrag,
    required this.onPortDragEnd,
  });

  final PaneItem session;

  /// Cor do agente (`AgentGraphStore.colorOf`: escolhida ou a do hash).
  final Color color;

  /// Maestro do workspace: ganha o selo ao lado do nome.
  final bool maestro;
  final VoidCallback onTap;

  /// Clique direito no card (posição global): menu do nó.
  final ValueChanged<Offset> onSecondaryTap;
  final ValueChanged<Offset> onDrag;
  final VoidCallback onPortDragStart;
  final ValueChanged<Offset> onPortDrag;
  final VoidCallback onPortDragEnd;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final accent = color;
    final s = session;
    final harness = switch (s) {
      ExternalAgent(:final app) => app.icon,
      TerminalSession(:final activeHarness) => activeHarness,
      _ => null,
    };
    final spec = harness == null ? null : HarnessCatalog.getSpec(harness);
    return SizedBox(
      width: kAgentNodeWidth + kAgentPortRadius,
      height: kAgentNodeHeight,
      child: Stack(
        children: [
          GestureDetector(
            onTap: onTap,
            onSecondaryTapUp: (d) => onSecondaryTap(d.globalPosition),
            onPanUpdate: (d) => onDrag(d.delta),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Container(
                width: kAgentNodeWidth,
                height: kAgentNodeHeight,
                padding: const EdgeInsets.fromLTRB(14, 10, 12, 10),
                decoration: BoxDecoration(
                  color: colors.panel2,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: accent.withValues(alpha: 0.7)),
                  boxShadow: [BoxShadow(color: colors.shadow, blurRadius: 8)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (spec != null) ...[
                          HarnessIcon(spec, color: colors.text),
                          const SizedBox(width: 8),
                        ],
                        Expanded(
                          child: Text(
                            session.displayTitle,
                            overflow: TextOverflow.ellipsis,
                            style: context.typo.label.copyWith(
                              color: colors.text,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (maestro)
                          AppTooltip(
                            message: context.t.cockpit.agentGraph.maestro,
                            child: Icon(
                              Icons.workspace_premium,
                              size: 16,
                              color: accent,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    if (s is ExternalAgent)
                      _DesktopLine(app: s.app.label)
                    else
                      Text(
                        basenameOf(
                          s is TerminalSession
                              ? s.currentDirectory ?? s.workingDirectory
                              : s.workingDirectory,
                        ),
                        overflow: TextOverflow.ellipsis,
                        style: context.typo.mono.copyWith(
                          fontSize: 11,
                          color: colors.text3,
                        ),
                      ),
                    const Spacer(),
                    _StatusChip(session: s),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: kAgentNodeWidth - kAgentPortRadius,
            top: kAgentNodeHeight / 2 - kAgentPortRadius,
            child: AppTooltip(
              message: context.t.cockpit.agentGraph.connectHint,
              child: GestureDetector(
                onPanStart: (_) => onPortDragStart(),
                onPanUpdate: (d) => onPortDrag(d.delta),
                onPanEnd: (_) => onPortDragEnd(),
                child: MouseRegion(
                  cursor: SystemMouseCursors.precise,
                  child: Container(
                    width: kAgentPortRadius * 2,
                    height: kAgentPortRadius * 2,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colors.panel,
                      border: Border.all(color: accent, width: 2),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Selo "desktop" + nome do app, no lugar da pasta do terminal.
class _DesktopLine extends StatelessWidget {
  const _DesktopLine({required this.app});
  final String app;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final small = context.typo.label.copyWith(fontSize: 11);
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
          decoration: BoxDecoration(
            color: colors.panel3,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: colors.border2),
          ),
          child: Text(
            context.t.cockpit.agentGraph.desktopBadge,
            style: small.copyWith(fontSize: 10, color: colors.text2),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            app,
            overflow: TextOverflow.ellipsis,
            style: small.copyWith(color: colors.text3),
          ),
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.session});
  final PaneItem session;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tr = context.t.cockpit.agentGraph;
    final s = session;
    final (label, color, pulsing) = switch (s) {
      ExternalAgent() when s.isWorking => (
        tr.statusWorking,
        colors.accent,
        true,
      ),
      ExternalAgent(:final online) => (
        online ? tr.statusOnline : tr.statusOffline,
        online ? colors.online : colors.text4,
        false,
      ),
      TerminalSession(:final status) => switch (status) {
        TerminalStatus.working => (tr.statusWorking, colors.accent, true),
        TerminalStatus.waiting => (tr.statusWaiting, colors.warn, false),
        TerminalStatus.idle => (tr.statusIdle, colors.text3, false),
      },
      _ => (tr.statusIdle, colors.text3, false),
    };
    final queued = s is ExternalAgent && s.pending > 0
        ? ' · ${tr.queued(n: s.pending)}'
        : '';
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _StatusDot(color: color, pulsing: pulsing),
        const SizedBox(width: 6),
        Text(
          '$label$queued',
          style: context.typo.label.copyWith(fontSize: 11, color: color),
        ),
      ],
    );
  }
}

/// Ponto do status; pulsa (opacidade) enquanto o agente trabalha.
class _StatusDot extends StatefulWidget {
  const _StatusDot({required this.color, required this.pulsing});
  final Color color;
  final bool pulsing;

  @override
  State<_StatusDot> createState() => _StatusDotState();
}

class _StatusDotState extends State<_StatusDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
    lowerBound: 0.35,
  );

  @override
  void initState() {
    super.initState();
    _sync();
  }

  @override
  void didUpdateWidget(_StatusDot oldWidget) {
    super.didUpdateWidget(oldWidget);
    _sync();
  }

  void _sync() {
    if (widget.pulsing && !_pulse.isAnimating) {
      _pulse.repeat(reverse: true);
    } else if (!widget.pulsing) {
      _pulse.value = 1;
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
    opacity: _pulse,
    child: Container(
      width: 7,
      height: 7,
      decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle),
    ),
  );
}
