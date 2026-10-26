// Ported from clodfarm (github.com/matank001/clodfarm), MIT License, see third_party/clodfarm/LICENSE.

import 'dart:async';
import 'dart:math' as math;

import 'package:gsh_desktop/app/core/domain/entities/app_settings.dart';
import 'package:gsh_desktop/app/core/domain/entities/harness.dart';
import 'package:gsh_desktop/app/core/ui/settings_controller.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/farm_loop.dart';
import 'package:gsh_desktop/app/gsh/ui/viewmodels/gsh_viewmodel.dart';
import 'package:gsh_desktop/app/gsh/ui/viewmodels/farm_viewmodel.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/agent_status_dot.dart';
import 'package:gsh_desktop/app/gsh/ui/viewmodels/team_post.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/farm/farm_courier.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/farm/farm_scene.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/farm/farm_strip.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/farm/farm_scene_painter.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/farm/farm_sprites.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/farm/farm_team.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/farm/farm_world.dart';
import 'package:gsh_desktop/app/core/ui/themes/themes.dart';
import 'package:gsh_desktop/i18n/strings.g.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:path/path.dart' as p;
import 'package:shadcn_flutter/shadcn_flutter.dart';

part 'farm_hud.dart';
part 'farm_view_team.dart';

/// A fazenda de agentes, no visual do clodfarm: celeiro, curral, lago e um
/// cercado com um canteiro por loop principal. Quem trabalha digita no laptop
/// do seu canteiro, quem espera acena com o balão de alerta, quem está ocioso
/// passeia pelo celeiro e quem dorme cochila no curral; subagentes são minis
/// em volta do canteiro do pai. Com a fazenda do time ligada, as fazendas
/// dos colegas ficam ao lado da minha (afaste o zoom para ver todas). Arraste
/// para mover, roda para zoom, duplo clique para enquadrar a minha.
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
  Duration? _every;
  bool _live = false;
  int _viewKey = 0;
  FarmWorld? _world;
  Size _size = Size.zero;
  Timer? _resize;
  int _gen = 0;
  int _lastUs = 0;
  FarmScenery? _scenery;
  double _pinch = 1;

  /// As fazendas dos colegas (ver `farm_view_team.dart`) e de quem é o bicho
  /// sob o mouse (`null` = meu).
  final _team = <FarmLot>[];
  FarmLot? _hoverLot;

  /// Mensageiros do time à vista neste quadro (o painter lê esta lista).
  final _runs = <CourierRun>[];
  bool _hadRuns = false;
  TeamPost? _post;

  @override
  void initState() {
    super.initState();
    _vm
      ..attach()
      ..addListener(_sync);
    _hover.addListener(_frame.tick);
    _sync();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // aba escondida (TickerMode desligado pelo pane) = fazenda parada
    final live = TickerMode.valuesOf(context).enabled;
    if (live && !_live) _lastUs = _clock.elapsedMicroseconds;
    _live = live;
    _schedule();
  }

  @override
  void dispose() {
    _vm
      ..removeListener(_sync)
      ..detach();
    _anim?.cancel();
    _hover.removeListener(_frame.tick);
    _resize?.cancel();
    _world?.dispose();
    _disposeTeam();
    _labels.dispose();
    _frame.dispose();
    _hover.dispose();
    _mouse.dispose();
    super.dispose();
  }

  void _sync() {
    _scene.sync(_vm.plots);
    if (_world != null && _scene.outgrown) unawaited(_rebuild());
    _syncPeers();
  }

  /// 20 quadros por segundo com alguém trabalhando (ou o mouse em cima),
  /// 12 com a fazenda parada; num Timer e não num Ticker: o Ticker faz o
  /// Flutter compor um quadro a cada vsync (60 Hz), e cada quadro composto
  /// custa CPU (medido no Linux: ~0,5% por fps). A animação é em passos de
  /// pixel e a aba pode ficar aberta por horas.
  static const _busyEvery = Duration(milliseconds: 50);
  static const _calmEvery = Duration(milliseconds: 83);

  /// Liga, desliga ou troca o ritmo do Timer da animação.
  void _schedule() {
    final want = !_live
        ? null
        : _scene.busy || _hover.value != null || _peersBusy || _runs.isNotEmpty
        ? _busyEvery
        : _calmEvery;
    if (want == _every) return;
    _anim?.cancel();
    _every = want;
    _anim = want == null ? null : Timer.periodic(want, (_) => _tick());
  }

  void _tick() {
    final now = _clock.elapsedMicroseconds;
    final dt = math.min(0.1, (now - _lastUs) / 1e6);
    // mensageiro à vista anda a cada quadro; o último que some limpa a tela
    final runs = _syncCouriers();
    final dirty = _scene.update(dt) | _updatePeers(dt) | runs | _hadRuns;
    _hadRuns = runs;
    _lastUs = now;
    // quadro igual ao anterior (ninguém andou, nada piscou): nem repinta
    final view = Object.hash(_cam.x, _cam.y, _cam.z, _world);
    if (dirty || view != _viewKey) {
      _viewKey = view;
      _frame.tick();
    }
    _schedule();
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
    final world = await buildWorld(
      layout,
      scenery: _scenery ?? FarmScenery.farm,
    );
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
        ..z = math.max(_cam.z, _cam.minZ(layout))
        ..clampTo(layout, _size);
    }
    setState(() => _world = world);
    SchedulerBinding.instance.addPostFrameCallback((_) => old?.dispose());
    // os colegas acompanham o tamanho do meu mundo e o cenário
    _arrange();
    _syncPeers();
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
    final (c, lot) = _hitAt(local);
    _hoverLot = lot;
    _hover.value = c;
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<FarmViewModel>();
    // trocar o cenário nas configurações refaz o mundo
    final scenery = context.select<SettingsController, FarmScenery>(
      (c) => c.settings.farmScenery,
    );
    if (scenery != _scenery) {
      final first = _scenery == null;
      _scenery = scenery;
      if (!first) unawaited(_rebuild());
    }
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
                    _frame.tick();
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
                          : (d) {
                              // bicho de colega: o terminal está na máquina
                              // dele, clique não faz nada
                              final (c, lot) = _hitAt(d.localPosition);
                              if (lot == null) _open(c);
                            },
                      onDoubleTap: world == null
                          ? null
                          : () {
                              _cam.fit(world.layout, _viewport(size));
                              _frame.tick();
                            },
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
                        // arrastar é imediato, não espera o Timer
                        _frame.tick();
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
                            peers: _team,
                            couriers: _runs,
                            banner: scenery == FarmScenery.office
                                ? null
                                : (n) => context.t.gsh.farm.peerBanner(name: n),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(left: 10, top: 10, child: _Hud(vm: vm)),
              if (vm.plots.isEmpty && _team.isEmpty)
                const Positioned.fill(child: _FarmEmpty()),
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
    final ok = context.read<GshViewModel>().revealAgentSession(
      sid,
      resumeCwd: parked ? main.project : null,
      harness: main.harness,
    );
    if (!ok) showOutsideGshToast(context);
  }

  Widget _tip(BuildContext context, Size size, Critter? c, Offset? at) {
    if (c == null || at == null) return const SizedBox.shrink();
    final tr = context.t.gsh.farm;
    final l = c.loop;
    final activity = _activityLabel(tr, l.activity);
    final peer = _hoverLot?.name;
    final of = peer == null ? '' : ' · ${tr.peerOf(name: peer)}';
    final text = [
      l.title,
      if (!l.isSubagent) '${p.basename(l.project)} · ${_harnessLabel(l)}$of',
      if (l.isSubagent && peer != null) tr.peerOf(name: peer),
      if (l.agentType != null) l.agentType!,
      if (l.tool != null) '$activity · ${l.tool}' else activity,
      tr.spent(total: _compact(l.spentTokens)),
      tr.spentDetail(
        input: _compact(l.inputTokens),
        cache: _compact(l.cacheReadTokens),
        out: _compact(l.outputTokens),
      ),
      tr.context(
        ctx: _compact(l.contextTokens),
        window: _compact(l.window),
        pct: (l.contextFill * 100).round(),
      ),
      if (peer == null) tr.clickToOpen,
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

/// Aviso de que o agente roda fora do GSH (o terminal dele é outra janela).
void showOutsideGshToast(BuildContext context) => showToast(
  context: context,
  location: ToastLocation.bottomRight,
  builder: (context, overlay) => SurfaceCard(
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Text(context.t.gsh.farm.outsideGsh, style: context.typo.label),
    ),
  ),
);

/// Avisa o painter que há um quadro novo.
class _Frame extends ChangeNotifier {
  void tick() => notifyListeners();
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
