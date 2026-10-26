// Ported from clodfarm (github.com/matank001/clodfarm), MIT License, see third_party/clodfarm/LICENSE.

part of 'farm_view.dart';

/// 1234567 → "1,234,567" (o contador grande do HUD).
String _grouped(int n) =>
    n.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',');

/// Caixa de pixel do HUD: fundo escuro, borda de tinta, cantos retos.
class _HudBox extends StatelessWidget {
  const _HudBox({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
    decoration: BoxDecoration(
      color: _hudBg,
      border: Border.all(color: _hudInk, width: 2),
    ),
    child: child,
  );
}

class _Hud extends StatelessWidget {
  const _Hud({required this.vm, this.onResetPlots});
  final FarmViewModel vm;

  /// "Redefinir posições" dos canteiros; `null` = nada escolhido, some.
  final VoidCallback? onResetPlots;

  @override
  Widget build(BuildContext context) {
    final tr = context.t.gsh.farm;
    final colors = context.colors;
    final mono = context.typo.mono.copyWith(
      fontWeight: FontWeight.w700,
      height: 1.2,
    );
    final small = mono.copyWith(fontSize: 11, color: _hudText);
    final loops = vm.loops.toList();
    final subs = loops.where((l) => l.isSubagent).length;
    Widget chip(Widget child) => Padding(
      padding: const EdgeInsets.only(top: 4),
      child: _HudBox(child: child),
    );
    Widget status(FarmStatus s, String text) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: farmStatusColor(colors, s),
            border: Border.all(color: _hudInk),
          ),
        ),
        const SizedBox(width: 6),
        Text(text.toUpperCase(), style: small),
      ],
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _HudBox(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              RawImage(
                image: iconSprite(FarmIcon.flame),
                width: 20,
                height: 20,
                filterQuality: FilterQuality.none,
              ),
              const SizedBox(width: 8),
              Text(
                tr.spentHud(n: _grouped(vm.spentTokens)).toUpperCase(),
                style: mono.copyWith(fontSize: 16, color: _hudText),
              ),
            ],
          ),
        ),
        chip(
          Text(
            '${tr.agents(n: loops.length - subs)} · ${tr.subagents(n: subs)}'
                .toUpperCase(),
            style: small,
          ),
        ),
        chip(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              status(
                FarmStatus.working,
                tr.working(n: vm.countBy(FarmStatus.working)),
              ),
              status(
                FarmStatus.waiting,
                needYou(tr, vm.countBy(FarmStatus.waiting)),
              ),
              status(FarmStatus.idle, tr.idle(n: vm.countBy(FarmStatus.idle))),
            ],
          ),
        ),
        if (onResetPlots case final reset?)
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: reset,
              child: chip(
                Text(
                  tr.resetPlots.toUpperCase(),
                  style: small.copyWith(color: _hudMuted, fontSize: 10),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _FarmEmpty extends StatelessWidget {
  const _FarmEmpty();

  @override
  Widget build(BuildContext context) {
    final tr = context.t.gsh.farm;
    final mono = context.typo.mono.copyWith(color: _hudText, height: 1.4);
    return IgnorePointer(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 380),
          child: _HudBox(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    tr.emptyTitle.toUpperCase(),
                    style: mono.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    tr.emptyHint,
                    textAlign: TextAlign.center,
                    style: mono.copyWith(fontSize: 11, color: _hudMuted),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Nome do harness do loop (`claude` → "Claude Code"): nome próprio, não se
/// traduz.
String _harnessLabel(FarmLoop l) =>
    HarnessCatalog.specs.values
        .where((s) => s.allEntryPoints.contains(l.harness))
        .firstOrNull
        ?.label ??
    l.harness;

String _compact(int n) {
  // 200.0k → 200k
  String f(double v) => v.toStringAsFixed(1).replaceFirst(RegExp(r'\.0$'), '');
  if (n >= 1000000) return '${f(n / 1000000)}M';
  if (n >= 1000) return '${f(n / 1000)}k';
  return '$n';
}

String _activityLabel(Translations$gsh$farm$en tr, FarmActivity a) {
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
