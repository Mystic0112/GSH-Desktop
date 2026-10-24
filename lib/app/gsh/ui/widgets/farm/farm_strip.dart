import 'package:gsh_desktop/app/core/ui/themes/themes.dart';
import 'package:gsh_desktop/app/core/ui/widgets/app_menu.dart';
import 'package:gsh_desktop/app/core/ui/widgets/app_tooltip.dart';
import 'package:gsh_desktop/app/core/ui/widgets/hover_tap.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/farm_loop.dart';
import 'package:gsh_desktop/app/gsh/ui/viewmodels/farm_viewmodel.dart';
import 'package:gsh_desktop/app/gsh/ui/viewmodels/gsh_viewmodel.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/agent_status_dot.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/farm/farm_view.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/telemetry_case_view.dart';
import 'package:gsh_desktop/i18n/strings.g.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:path/path.dart' as p;
import 'package:shadcn_flutter/shadcn_flutter.dart';

/// Mini-fazenda fixa da topbar: quantos agentes trabalham / esperam / estão
/// parados (clique abre a fazenda) e, se alguém espera, a pílula "N precisam
/// de você" que abre a fila. Some quando não há loop nenhum. Liga o polling
/// da fazenda enquanto está montada (= o app aberto).
class FarmStrip extends StatefulWidget {
  const FarmStrip({super.key, required this.onOpenFarm});

  final VoidCallback onOpenFarm;

  @override
  State<FarmStrip> createState() => _FarmStripState();
}

class _FarmStripState extends State<FarmStrip> {
  late final FarmViewModel _vm = context.read<FarmViewModel>();

  @override
  void initState() {
    super.initState();
    _vm.attach();
  }

  @override
  void dispose() {
    _vm.detach();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<FarmViewModel>();
    if (vm.loops.isEmpty) return const SizedBox.shrink();
    final tr = context.t.gsh.farm;
    final working = vm.countBy(FarmStatus.working);
    final waiting = vm.countBy(FarmStatus.waiting);
    final idle = vm.countBy(FarmStatus.idle);
    final queue = vm.waiting;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppTooltip(
          message: [
            tr.working(n: working),
            needYou(tr, waiting),
            tr.idle(n: idle),
          ].join(' · '),
          child: HoverTap(
            onTap: widget.onOpenFarm,
            hoverColor: context.colors.panel3,
            borderRadius: BorderRadius.circular(5),
            padding: const EdgeInsets.symmetric(horizontal: 7),
            child: SizedBox(
              height: 28,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _Count(status: FarmStatus.working, n: working),
                  const SizedBox(width: 10),
                  _Count(status: FarmStatus.waiting, n: waiting),
                  const SizedBox(width: 10),
                  _Count(status: FarmStatus.idle, n: idle),
                ],
              ),
            ),
          ),
        ),
        if (queue.isNotEmpty) ...[
          const SizedBox(width: 4),
          Builder(
            builder: (anchor) => _NeedYouPill(
              label: needYou(tr, queue.length),
              onTap: () => _openQueue(anchor, queue),
            ),
          ),
        ],
        const SizedBox(width: 8),
      ],
    );
  }

  /// Fila "precisa de mim": clique foca a aba da sessão. Quem espera está
  /// vivo, então nunca retoma (retomar duplicaria a conversa).
  Future<void> _openQueue(BuildContext anchor, List<FarmWaiting> queue) async {
    final sid = await showAppMenu<String>(
      anchor,
      minWidth: 260,
      items: [
        for (final w in queue)
          AppMenuItem(
            value: w.sessionId,
            label: w.title,
            leading: const AgentStatusDot(status: FarmStatus.waiting),
            labelWidget: _QueueRow(w),
          ),
      ],
    );
    if (sid == null || !mounted) return;
    if (context.read<GshViewModel>().revealAgentSession(sid)) return;
    showOutsideGshToast(context);
  }
}

/// "N precisam de você" com o singular certo (slang não tem plural de `pt`).
String needYou(Translations$gsh$farm$en tr, int n) =>
    n == 1 ? tr.waitingOne : tr.waiting(n: n);

class _Count extends StatelessWidget {
  const _Count({required this.status, required this.n});
  final FarmStatus status;
  final int n;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      // O amarelo pisca na pílula; aqui fica parado (um ponto piscando basta).
      Container(
        width: 7,
        height: 7,
        decoration: BoxDecoration(
          color: farmStatusColor(context.colors, status),
          shape: BoxShape.circle,
        ),
      ),
      const SizedBox(width: 5),
      Text(
        '$n',
        style: context.typo.mono.copyWith(
          fontSize: 12,
          color: n == 0 ? context.colors.text4 : context.colors.text2,
        ),
      ),
    ],
  );
}

class _NeedYouPill extends StatelessWidget {
  const _NeedYouPill({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final warn = context.colors.warn;
    return HoverTap(
      onTap: onTap,
      color: warn.withValues(alpha: 0.14),
      hoverColor: warn.withValues(alpha: 0.24),
      borderRadius: BorderRadius.circular(11),
      padding: const EdgeInsets.symmetric(horizontal: 9),
      child: SizedBox(
        height: 22,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AgentStatusDot(status: FarmStatus.waiting),
            const SizedBox(width: 6),
            Text(
              label,
              style: context.typo.label.copyWith(
                fontSize: 12,
                color: warn,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Linha da fila: título da sessão e, embaixo, pasta · há quanto espera ·
/// subagentes esperando.
class _QueueRow extends StatelessWidget {
  const _QueueRow(this.w);
  final FarmWaiting w;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final detail = [
      p.basename(w.project),
      telemetryRelative(context, w.since),
      ...w.subagents,
    ].join(' · ');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          w.title,
          overflow: TextOverflow.ellipsis,
          style: context.typo.body.copyWith(fontSize: 13, color: colors.text),
        ),
        Text(
          detail,
          overflow: TextOverflow.ellipsis,
          style: context.typo.mono.copyWith(fontSize: 11, color: colors.text3),
        ),
      ],
    );
  }
}
