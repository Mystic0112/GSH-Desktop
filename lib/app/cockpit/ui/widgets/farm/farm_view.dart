// Ported from clodfarm (github.com/matank001/clodfarm), MIT License, see third_party/clodfarm/LICENSE.

import 'dart:async';
import 'dart:math' as math;

import 'package:cockpit/app/cockpit/domain/entities/farm_loop.dart';
import 'package:cockpit/app/cockpit/ui/viewmodels/cockpit_viewmodel.dart';
import 'package:cockpit/app/cockpit/ui/viewmodels/farm_viewmodel.dart';
import 'package:cockpit/app/cockpit/ui/widgets/farm/farm_scene.dart';
import 'package:cockpit/app/cockpit/ui/widgets/farm/farm_scene_painter.dart';
import 'package:cockpit/app/cockpit/ui/widgets/farm/farm_sprites.dart';
import 'package:cockpit/app/cockpit/ui/widgets/farm/farm_world.dart';
import 'package:cockpit/app/core/ui/themes/themes.dart';
import 'package:cockpit/i18n/strings.g.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:path/path.dart' as p;
import 'package:shadcn_flutter/shadcn_flutter.dart';

/// A fazenda de agentes, no visual do clodfarm: celeiro, curral, lago e um
/// cercado com um canteiro por loop principal. Quem trabalha digita no laptop
/// do seu canteiro, quem espera acena com o balão de alerta, quem está ocioso
/// passeia pelo celeiro e quem dorme cochila no curral; subagentes são minis
/// em volta do canteiro do pai. Arraste para mover, roda para zoom, duplo
/// clique para enquadrar.
class FarmView extends StatefulWidget {
  const FarmView({super.key});

  @override
  State<FarmView> createState() => _FarmViewState();
}

/// Cores do HUD: fazem parte da arte do cenário (não do tema do app).
const _hudBg = Color(0xE6182414);
const _hudInk = Color(0xFF0b1208);
const _hudText = Color(0xFFfff8e8);
const _hudMuted = Color(0xFFc9d6a8);

class _FarmViewState extends State<FarmView> {
  late final FarmViewModel _vm = context.read<FarmViewModel>();
  final _scene = FarmScene();
  final _cam = FarmCamera();
  final _labels = FarmLabels();
  final _frame = _Frame();
  final _hover = ValueNotifier<Critter?>(null);
  final _mouse = ValueNotifier<Offset?>(null);
  final _clock = Stopwatch()..start();
  Timer? _anim;
  FarmWorld? _world;
  Size _size = Size.zero;
  Timer? _resize;
  int _gen = 0;
  int _lastUs = 0;
  double _pinch = 1;

  @override
  void initState() {
    super.initState();
    _vm
      ..attach()
      ..addListener(_sync);
    _sync();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // aba escondida (TickerMode desligado pelo pane) = fazenda parada
    if (TickerMode.valuesOf(context).enabled) {
      _anim ??= Timer.periodic(_frameEvery, (_) => _tick());
      _lastUs = _clock.elapsedMicroseconds;
    } else {
      _anim?.cancel();
      _anim = null;
    }
  }

  @override
  void dispose() {
    _vm
      ..removeListener(_sync)
      ..detach();
    _anim?.cancel();
    _resize?.cancel();
    _world?.dispose();
    _labels.dispose();
    _frame.dispose();
    _hover.dispose();
    _mouse.dispose();
    super.dispose();
  }

  void _sync() {
    _scene.sync(_vm.plots);
    if (_world != null && _scene.outgrown) unawaited(_rebuild());
  }

  /// 20 quadros por segundo, num Timer e não num Ticker: o Ticker faz o
  /// Flutter compor um quadro a cada vsync (60 Hz), e cada quadro composto
  /// custa CPU (medido no Linux: ~0,5% por fps). A animação é em passos de
  /// pixel e a aba pode ficar aberta por horas.
  static const _frameEvery = Duration(milliseconds: 50);

  void _tick() {
    final now = _clock.elapsedMicroseconds;
    _scene.update(math.min(0.1, (now - _lastUs) / 1e6));
    _lastUs = now;
    _frame.tick();
  }

  /// A janela e o pedaço que o HUD cobre: largo, ele fica ao lado da
  /// fazenda; alto, em cima.
  FarmViewport _viewport(Size s) {
    final wide = s.width > s.height * 1.15 && 240 < s.width * 0.4;
    return FarmViewport(
      w: s.width,
      h: s.height,
      left: wide ? 240 : 0,
      top: wide ? 8 : 150,
      right: 12,
      bottom: 12,
    );
  }

  Future<void> _rebuild() async {
    if (_size.isEmpty) return;
    final gen = ++_gen;
    final view = _viewport(_size);
    final need = _scene.need;
    final layout = layoutFarm(
      plots: (need.plots * 1.15).ceil() + 1,
      yard: (need.yard * 1.1).ceil() + 2,
      view: view,
      snap: (z) => _cam.snap(z, down: true),
    );
    final world = await buildWorld(layout);
    if (!mounted || gen != _gen) {
      world.dispose();
      return;
    }
    final old = _world;
    _scene.relayout(layout);
    if (_cam.auto || old == null) {
      _cam.fit(layout, view);
    } else {
      _cam
        ..z = math.max(_cam.z, layout.z)
        ..clampTo(layout, _size);
    }
    setState(() => _world = world);
    SchedulerBinding.instance.addPostFrameCallback((_) => old?.dispose());
  }

  void _onSize(Size s) {
    if (s == _size) return;
    _size = s;
    _resize?.cancel();
    _resize = Timer(
      Duration(milliseconds: _world == null ? 0 : 150),
      () => unawaited(_rebuild()),
    );
  }

  void _hoverAt(Offset local) {
    _mouse.value = local;
    _hover.value = _world == null ? null : _scene.hit(_cam.toWorld(local));
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<FarmViewModel>();
    _cam.dpr = MediaQuery.devicePixelRatioOf(context);
    final label = context.typo.mono.copyWith(
      fontSize: 10,
      height: 1.2,
      fontWeight: FontWeight.w700,
      color: _hudText,
      shadows: const [
        Shadow(color: Color(0xFF14100c), offset: Offset(1, 1)),
        Shadow(color: Color(0xFF14100c), offset: Offset(-1, 0)),
        Shadow(color: Color(0xFF14100c), offset: Offset(0, -1)),
      ],
    );
    return LayoutBuilder(
      builder: (context, box) {
        final size = box.biggest;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _onSize(size);
        });
        final world = _world;
        return ClipRect(
          child: Stack(
            children: [
              Positioned.fill(
                child: Listener(
                  onPointerSignal: (e) {
                    if (e is! PointerScrollEvent || world == null) return;
                    _cam.zoomAt(
                      e.localPosition,
                      math.exp(-e.scrollDelta.dy * 0.0018),
                      world.layout,
                      size,
                    );
                  },
                  child: MouseRegion(
                    onHover: (e) => _hoverAt(e.localPosition),
                    onExit: (_) {
                      _hover.value = null;
                      _mouse.value = null;
                    },
                    child: GestureDetector(
                      onTapUp: world == null
                          ? null
                          : (d) => _open(
                              _scene.hit(_cam.toWorld(d.localPosition)),
                            ),
                      onDoubleTap: world == null
                          ? null
                          : () => _cam.fit(world.layout, _viewport(size)),
                      onScaleStart: (_) => _pinch = 1,
                      onScaleUpdate: (d) {
                        if (world == null) return;
                        if (d.scale != 1 && d.pointerCount != 1) {
                          _cam.zoomAt(
                            d.localFocalPoint,
                            d.scale / _pinch,
                            world.layout,
                            size,
                          );
                          _pinch = d.scale;
                        }
                        _cam.pan(d.focalPointDelta, world.layout, size);
                      },
                      // camada própria: o quadro da fazenda não repinta o
                      // resto da janela
                      child: RepaintBoundary(
                        child: CustomPaint(
                          isComplex: true,
                          willChange: true,
                          size: size,
                          painter: FarmScenePainter(
                            scene: _scene,
                            world: world,
                            cam: _cam,
                            labels: _labels,
                            label: label,
                            hover: _hover,
                            repaint: _frame,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(left: 10, top: 10, child: _Hud(vm: vm)),
              if (vm.plots.isEmpty) const Positioned.fill(child: _FarmEmpty()),
              Positioned.fill(
                child: IgnorePointer(
                  child: ListenableBuilder(
                    listenable: Listenable.merge([_hover, _mouse]),
                    builder: (context, _) =>
                        _tip(context, size, _hover.value, _mouse.value),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Clique no bicho: foca a aba do terminal dele (subagente → a do pai).
  /// Sem aba no GSH, sessão parada é retomada numa aba nova; rodando fora,
  /// só avisa (retomar ali duplicaria a conversa).
  void _open(Critter? c) {
    if (c == null) return;
    final sid = c.loop.parentId ?? c.loop.id;
    final main = _vm.loops.where((l) => l.id == sid).firstOrNull ?? c.loop;
    final parked = main.activity.status == FarmStatus.idle;
    final ok = context.read<CockpitViewModel>().revealAgentSession(
      sid,
      resumeCwd: parked ? main.project : null,
    );
    if (ok) return;
    showToast(
      context: context,
      location: ToastLocation.bottomRight,
      builder: (context, overlay) => SurfaceCard(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            context.t.cockpit.farm.outsideGsh,
            style: context.typo.label,
          ),
        ),
      ),
    );
  }

  Widget _tip(BuildContext context, Size size, Critter? c, Offset? at) {
    if (c == null || at == null) return const SizedBox.shrink();
    final tr = context.t.cockpit.farm;
    final l = c.loop;
    final activity = _activityLabel(tr, l.activity);
    final text = [
      l.title,
      if (!l.isSubagent) p.basename(l.project),
      if (l.agentType != null) l.agentType!,
      if (l.tool != null) '$activity · ${l.tool}' else activity,
      tr.tokensDetail(
        out: _compact(l.outputTokens),
        ctx: _compact(l.contextTokens),
      ),
      tr.clickToOpen,
    ].join('\n');
    final right = at.dx > size.width - 280, below = at.dy < size.height - 140;
    return Stack(
      children: [
        Positioned(
          left: right ? null : at.dx + 14,
          right: right ? size.width - at.dx + 14 : null,
          top: below ? at.dy + 16 : null,
          bottom: below ? null : size.height - at.dy + 12,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 320),
            child: TooltipContainer(child: Text(text)),
          ),
        ),
      ],
    );
  }
}

/// Avisa o painter que há um quadro novo.
class _Frame extends ChangeNotifier {
  void tick() => notifyListeners();
}

String _compact(int n) {
  if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
  if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
  return '$n';
}

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
    final tr = context.t.cockpit.farm;
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
            color: switch (s) {
              FarmStatus.working => colors.online,
              FarmStatus.waiting => colors.warn,
              FarmStatus.idle => colors.gitUntracked,
            },
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
                tr.waiting(n: vm.countBy(FarmStatus.waiting)),
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
    final tr = context.t.cockpit.farm;
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
