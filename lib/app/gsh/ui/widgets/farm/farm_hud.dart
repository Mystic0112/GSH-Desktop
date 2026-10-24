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
  const _Hud({required this.vm});
  final FarmViewModel vm;

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
                tr.tokens(n: _grouped(vm.outputTokens)).toUpperCase(),
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
