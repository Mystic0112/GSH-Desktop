import 'package:cockpit/app/cockpit/domain/entities/farm_loop.dart';
import 'package:cockpit/app/cockpit/ui/viewmodels/farm_viewmodel.dart';
import 'package:cockpit/app/cockpit/ui/widgets/farm_scene.dart';
import 'package:cockpit/app/core/ui/themes/themes.dart';
import 'package:cockpit/app/core/ui/widgets/app_tooltip.dart';
import 'package:cockpit/i18n/strings.g.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:path/path.dart' as p;
import 'package:shadcn_flutter/shadcn_flutter.dart';

/// A fazenda: um canteiro por pasta, um gorila por loop de agente, subagentes
/// menores embaixo do pai. Inspirada no clodfarm (matank001/clodfarm).
class FarmView extends StatefulWidget {
  const FarmView({super.key});

  @override
  State<FarmView> createState() => _FarmViewState();
}

class _FarmViewState extends State<FarmView>
    with SingleTickerProviderStateMixin {
  late final FarmViewModel _vm = context.read<FarmViewModel>();
  late final AnimationController _phase = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat();

  @override
  void initState() {
    super.initState();
    _vm.attach();
  }

  @override
  void dispose() {
    _vm.detach();
    _phase.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<FarmViewModel>();
    final colors = context.colors;
    return ColoredBox(
      color: colors.panel,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _FarmHeader(vm: vm),
          Expanded(
            child: vm.plots.isEmpty
                ? const _FarmEmpty()
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        for (final plot in vm.plots)
                          _Plot(plot: plot, phase: _phase),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

/// Verde trabalhando, amarelo precisa de alguém, azul parado.
Color farmStatusColor(AppColors colors, FarmStatus status) => switch (status) {
  FarmStatus.working => colors.online,
  FarmStatus.waiting => colors.warn,
  FarmStatus.idle => colors.gitUntracked,
};

String _compact(int n) {
  if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
  if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
  return '$n';
}

class _FarmHeader extends StatelessWidget {
  const _FarmHeader({required this.vm});
  final FarmViewModel vm;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tr = context.t.cockpit.farm;
    Widget chip(FarmStatus s, String label) => Padding(
      padding: const EdgeInsets.only(left: 14),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Dot(color: farmStatusColor(colors, s)),
          const SizedBox(width: 6),
          Text(label, style: context.typo.label.copyWith(color: colors.text2)),
        ],
      ),
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.border)),
      ),
      child: Row(
        children: [
          Text(
            tr.title,
            style: context.typo.title.copyWith(
              fontSize: 14,
              color: colors.text,
            ),
          ),
          const Spacer(),
          chip(
            FarmStatus.working,
            tr.working(n: vm.countBy(FarmStatus.working)),
          ),
          chip(
            FarmStatus.waiting,
            tr.waiting(n: vm.countBy(FarmStatus.waiting)),
          ),
          chip(FarmStatus.idle, tr.idle(n: vm.countBy(FarmStatus.idle))),
          const SizedBox(width: 16),
          Text(
            tr.tokens(n: _compact(vm.outputTokens)),
            style: context.typo.mono.copyWith(
              fontSize: 11,
              color: colors.text3,
            ),
          ),
        ],
      ),
    );
  }
}

class _FarmEmpty extends StatelessWidget {
  const _FarmEmpty();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tr = context.t.cockpit.farm;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              tr.emptyTitle,
              style: context.typo.title.copyWith(color: colors.text),
            ),
            const SizedBox(height: 8),
            Text(
              tr.emptyHint,
              textAlign: TextAlign.center,
              style: context.typo.label.copyWith(color: colors.text3),
            ),
          ],
        ),
      ),
    );
  }
}

class _Plot extends StatelessWidget {
  const _Plot({required this.plot, required this.phase});
  final FarmPlot plot;
  final Animation<double> phase;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tokens = plot.loops.fold(0, (s, l) => s + l.outputTokens);
    return Container(
      width: 380,
      decoration: BoxDecoration(
        color: colors.panel2,
        border: Border.all(color: colors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
            child: Row(
              children: [
                Expanded(
                  child: AppTooltip(
                    message: plot.project,
                    child: Text(
                      p.basename(plot.project),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.typo.title.copyWith(color: colors.text),
                    ),
                  ),
                ),
                Text(
                  _compact(tokens),
                  style: context.typo.mono.copyWith(
                    fontSize: 11,
                    color: colors.text3,
                  ),
                ),
              ],
            ),
          ),
          CustomPaint(
            painter: const FarmGroundPainter(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 16),
              child: Wrap(
                spacing: 10,
                runSpacing: 12,
                children: [
                  for (final main in plot.mains)
                    _Family(
                      main: main,
                      subs: plot.subagentsOf(main.id).toList(),
                      phase: phase,
                    ),
                  // Órfãos (pai fora da janela) entram como família própria.
                  for (final orphan in plot.loops.where(
                    (l) =>
                        l.isSubagent &&
                        !plot.mains.any((m) => m.id == l.parentId),
                  ))
                    _Critter(loop: orphan, phase: phase, small: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Um loop principal com os subagentes enfileirados embaixo.
class _Family extends StatelessWidget {
  const _Family({required this.main, required this.subs, required this.phase});
  final FarmLoop main;
  final List<FarmLoop> subs;
  final Animation<double> phase;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _Critter(loop: main, phase: phase),
        if (subs.isNotEmpty)
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 260),
            child: Wrap(
              spacing: 4,
              runSpacing: 4,
              alignment: WrapAlignment.center,
              children: [
                for (final s in subs)
                  _Critter(loop: s, phase: phase, small: true),
              ],
            ),
          ),
      ],
    );
  }
}

class _Critter extends StatelessWidget {
  const _Critter({required this.loop, required this.phase, this.small = false});
  final FarmLoop loop;
  final Animation<double> phase;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tr = context.t.cockpit.farm;
    final status = loop.activity.status;
    final statusColor = farmStatusColor(colors, status);
    final Color body;
    final Color face;
    if (loop.isSubagent) {
      body = agentColorFor(loop.agentType ?? loop.id);
      face = Color.lerp(body, FarmScene.highlight, 0.45)!;
    } else {
      body = FarmScene.mainBody;
      face = FarmScene.mainFace;
    }
    final size = small ? 28.0 : 44.0;
    final activity = _activityLabel(tr, loop.activity);
    final tooltip = [
      loop.title,
      if (loop.agentType != null) loop.agentType!,
      if (loop.tool != null) '$activity · ${loop.tool}' else activity,
      tr.tokensDetail(
        out: _compact(loop.outputTokens),
        ctx: _compact(loop.contextTokens),
      ),
    ].join('\n');

    return AppTooltip(
      message: tooltip,
      child: SizedBox(
        width: small ? 60 : 92,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Bubble(activity: loop.activity, color: statusColor, small: small),
            const SizedBox(height: 2),
            SizedBox.square(
              dimension: size,
              child: CustomPaint(
                painter: FarmCritterPainter(
                  body: body,
                  face: face,
                  phase: phase,
                  bobbing: status == FarmStatus.working,
                  dim:
                      loop.activity == FarmActivity.sleeping ||
                      loop.activity == FarmActivity.done,
                ),
              ),
            ),
            const SizedBox(height: 3),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _Dot(color: statusColor, size: small ? 5 : 6),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    small ? (loop.agentType ?? loop.title) : loop.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.typo.label.copyWith(
                      fontSize: small ? 9.5 : 11,
                      color: colors.text,
                    ),
                  ),
                ),
              ],
            ),
            if (!small)
              Text(
                activity,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.typo.label.copyWith(
                  fontSize: 10,
                  color: colors.text3,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Balão sobre a cabeça com o ícone da atividade.
class _Bubble extends StatelessWidget {
  const _Bubble({
    required this.activity,
    required this.color,
    required this.small,
  });
  final FarmActivity activity;
  final Color color;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final icon = switch (activity) {
      FarmActivity.thinking => Icons.more_horiz,
      FarmActivity.reading => Icons.menu_book_outlined,
      FarmActivity.editing => Icons.edit_outlined,
      FarmActivity.running => Icons.terminal,
      FarmActivity.searching => Icons.travel_explore,
      FarmActivity.delegating => Icons.call_split,
      FarmActivity.tooling => Icons.build_outlined,
      FarmActivity.waiting => Icons.priority_high,
      FarmActivity.idle => Icons.pause,
      FarmActivity.sleeping => Icons.bedtime_outlined,
      FarmActivity.done => Icons.check,
    };
    final d = small ? 14.0 : 18.0;
    return Container(
      width: d,
      height: d,
      decoration: BoxDecoration(
        color: colors.panel,
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 1.2),
      ),
      child: Icon(icon, size: d * 0.62, color: color),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.color, this.size = 7});
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );
}

String _activityLabel(Translations$cockpit$farm$en tr, FarmActivity a) {
  final t = tr.activity;
  return switch (a) {
    FarmActivity.thinking => t.thinking,
    FarmActivity.reading => t.reading,
    FarmActivity.editing => t.editing,
    FarmActivity.running => t.running,
    FarmActivity.searching => t.searching,
    FarmActivity.delegating => t.delegating,
    FarmActivity.tooling => t.tooling,
    FarmActivity.waiting => t.waiting,
    FarmActivity.idle => t.idle,
    FarmActivity.sleeping => t.sleeping,
    FarmActivity.done => t.done,
  };
}
