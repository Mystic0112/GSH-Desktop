@Tags(['preview'])
library;

import 'dart:math' as math;

import 'package:gsh_desktop/app/core/domain/entities/app_settings.dart';
import 'package:gsh_desktop/app/core/ui/themes/themes.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/farm_loop.dart';
import 'package:gsh_desktop/app/gsh/ui/viewmodels/farm_viewmodel.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/farm/farm_scene.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/farm/farm_scene_painter.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/team_farm.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/farm/farm_courier.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/farm/farm_team.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/farm/farm_world.dart';
import 'package:gsh_desktop/i18n/strings.g.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'shot_harness.dart';

FarmLoop _loop(
  String id,
  FarmActivity activity, {
  String harness = 'claude',
  String project = '/home/dev/gsh-desktop',
  String? title,
  String? parent,
  String? agentType,
  String? teammate,
  int tokens = 0,
  int ctx = 0,
  int window = 0,
}) => FarmLoop(
  id: id,
  harness: harness,
  project: project,
  title: title ?? id,
  activity: activity,
  lastSeen: DateTime(2026, 10, 23),
  parentId: parent,
  agentType: agentType,
  teammate: teammate,
  outputTokens: tokens,
  contextTokens: ctx,
  contextWindow: window,
);

/// Um canteiro com 6 minis do squad, um órfão, os principais do Codex e do
/// Antigravity, um principal "kurama" e gente parada.
List<FarmLoop> _loops() => [
  _loop(
    'm',
    FarmActivity.editing,
    title: 'Refatorar a fazenda',
    tokens: 60000,
    ctx: 63000,
    window: 200000,
  ),
  for (final (i, a) in const [
    'escanor',
    'bulma',
    'ippo',
    'levi',
    'nezuko',
    'gon',
  ].indexed)
    _loop(
      's$i',
      i == 3 ? FarmActivity.waiting : FarmActivity.running,
      parent: 'm',
      agentType: a,
    ),
  _loop(
    'cx',
    FarmActivity.running,
    harness: 'codex',
    project: '/home/dev/loja-api',
    title: 'Corrigir o build do Windows',
    ctx: 150000,
    window: 258400,
  ),
  _loop(
    'ag',
    FarmActivity.waiting,
    harness: 'antigravity',
    project: '/home/dev/site',
    title: 'Landing nova',
    ctx: 40000,
  ),
  _loop(
    'o1',
    FarmActivity.running,
    project: '/home/dev/infra',
    parent: 'sumiu',
    agentType: 'saitama',
    title: 'Pipeline de deploy',
  ),
  _loop(
    'k',
    FarmActivity.thinking,
    title: 'kurama',
    tokens: 200000,
    ctx: 182000,
    window: 200000,
  ),
  // o "kurama" lidera um time: dois teammates com canteiro próprio
  for (final (i, (name, type)) in const [
    ('revisor', 'levi'),
    ('testes', 'Explore'),
  ].indexed)
    _loop(
      't$i',
      i == 0 ? FarmActivity.editing : FarmActivity.reading,
      parent: 'k',
      teammate: name,
      title: name,
      agentType: type,
      tokens: 20000,
      ctx: 50000 + i * 70000,
      window: 200000,
    ),
  _loop('z', FarmActivity.sleeping, title: 'Spike de cache', ctx: 90000),
  _loop('i', FarmActivity.idle, title: 'Docs do hook', ctx: 30000),
];

void main() {
  setUpAll(loadShotFonts);

  // zoom 0 = enquadra o mundo inteiro (o duplo clique)
  for (final scenery in FarmScenery.values) {
    for (final zoom in [0.0, 1.0, 3.0, 5.0]) {
      _preview(scenery, zoom);
    }
    _preview(scenery, 5, puffs: true);
    _preview(scenery, 0, drag: true);
    _preview(scenery, 5, pets: true);
    _teamPreview(scenery);
    _teamPreview(scenery, couriers: true);
  }
}

/// Colegas falsos, como chegam pela rede: `project` só com o nome da pasta
/// e, para quem não libera títulos, o título igual à pasta.
List<(String, String, List<FarmLoop>)> _peers() => [
  (
    'm1',
    'Bianca',
    [
      _loop(
        'b1',
        FarmActivity.editing,
        project: 'app-mobile',
        title: 'Tela de perfil',
        tokens: 40000,
      ),
      _loop(
        'b2',
        FarmActivity.running,
        project: 'app-mobile',
        parent: 'b1',
        agentType: 'levi',
      ),
      _loop(
        'b3',
        FarmActivity.waiting,
        project: 'chatbot',
        title: 'Prompt novo',
      ),
      _loop('b4', FarmActivity.sleeping, project: 'chatbot', title: 'Docs'),
    ],
  ),
  (
    'm2',
    'Rafael',
    [
      for (final (i, a) in const [
        FarmActivity.thinking,
        FarmActivity.reading,
        FarmActivity.idle,
      ].indexed)
        _loop(
          'r$i',
          a,
          project: 'loja-api',
          title: 'loja-api',
          tokens: i * 90000,
        ),
    ],
  ),
];

/// A minha fazenda com dois colegas ao lado, no zoom que mostra todas.
/// Com [couriers]: três mensageiros falsos, um no meio do caminho (carta
/// minha para a Bianca), um entregando (caixa do Rafael para mim) e um
/// saindo da porta da Bianca.
void _teamPreview(FarmScenery scenery, {bool couriers = false}) => testWidgets(
  'preview: time no ${scenery.name}${couriers ? ' com mensageiros' : ''}',
  (tester) async {
    const size = Size(1200, 600);
    tester.view
      ..physicalSize = size
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final scene = FarmScene(rnd: math.Random(4))..sync(groupFarm(_loops()));
    const view = FarmViewport(w: 1200, h: 600);
    final layout = layoutFarm(
      plots: scene.need.plots + 1,
      yard: scene.need.yard + 2,
      view: view,
      snap: (z) => z,
    );
    final world = (await tester.runAsync(
      () => buildWorld(layout, scenery: scenery),
    ))!;
    scene
      ..relayout(layout)
      ..placePets(office: scenery == FarmScenery.office);
    final lots = <FarmLot>[];
    for (final (id, name, loops) in _peers()) {
      final lot = FarmLot(id, name)..scene.sync(groupFarm(loops));
      final ll = layoutLot(layout, lot.scene.need);
      lot.world = await tester.runAsync(
        () => buildWorld(ll, seed: lot.seed, scenery: scenery),
      );
      lot.scene.relayout(ll);
      lots.add(lot);
    }
    final b = arrangeLots(layout, lots, joined: scenery == FarmScenery.office);
    for (var i = 0; i < 40; i++) {
      scene.update(0.05);
      for (final l in lots) {
        l.scene.update(0.05);
      }
    }
    final cam = FarmCamera()
      ..team = b
      ..teamZ = math.min(size.width / b.width, size.height / b.height)
      ..fit(layout, view);
    cam
      ..z = cam.minZ(layout)
      ..clampTo(layout, size);
    await tester.pumpWidget(
      shotHost(
        RepaintBoundary(
          key: shotKey,
          child: Builder(
            builder: (context) => CustomPaint(
              size: size,
              painter: FarmScenePainter(
                scene: scene,
                world: world,
                cam: cam,
                labels: FarmLabels(),
                label: context.typo.mono.copyWith(
                  fontSize: 10,
                  height: 1.2,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFfff8e8),
                ),
                hover: ValueNotifier(null),
                repaint: ChangeNotifier(),
                peers: lots,
                me: context.t.gsh.farm.you,
                couriers: couriers
                    ? _fakeCouriers(scene, world, lots)
                    : const [],
                banner: scenery == FarmScenery.office
                    ? null
                    : (n) => context.t.gsh.farm.peerBanner(name: n),
              ),
            ),
          ),
        ),
      ),
    );
    await takeShot(
      tester,
      '${couriers ? 'team_courier' : 'team_preview'}_${scenery.name}',
    );
  },
);

/// Com [puffs]: um mini acaba de sumir e um principal novo acaba de chegar.
void _preview(
  FarmScenery scenery,
  double zoom, {
  bool puffs = false,
  bool drag = false,
  bool pets = false,
}) => testWidgets('preview: ${scenery.name} no zoom $zoom'
    '${puffs ? ' (poeira)' : ''}${drag ? ' (arrastando)' : ''}'
    '${pets ? ' (bichinhos)' : ''}', (tester) async {
  const size = Size(960, 600);
  tester.view
    ..physicalSize = size
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final plots = groupFarm(_loops());
  final scene = FarmScene(rnd: math.Random(4))..sync(plots);
  final layout = layoutFarm(
    plots: scene.need.plots + 1,
    yard: scene.need.yard + 2,
    view: FarmViewport(w: size.width, h: size.height),
    snap: (z) => z,
  );
  final world = (await tester.runAsync(
    () => buildWorld(layout, scenery: scenery),
  ))!;
  scene
    ..relayout(layout)
    ..placePets(office: scenery == FarmScenery.office);
  for (var i = 0; i < 40; i++) {
    scene.update(0.05);
  }
  if (puffs) {
    final m = scene.critters['m']!;
    scene
      ..sync(
        groupFarm([
          for (final l in _loops())
            if (l.id != 's1') l,
          _loop('n', FarmActivity.thinking, title: 'Novo'),
        ]),
      )
      ..update(0.2);
    // o novo surge ao lado do dono do canteiro, para caber no quadro
    scene.puffs.firstWhere((p) => p.born);
    scene.critters['n']!
      ..x = m.x - 26
      ..y = m.y;
    scene.puffs
      ..removeWhere((p) => p.born)
      ..add(FarmPuff(m.x - 26, m.y, scene.t - 0.15, born: true, mini: false));
  }
  if (drag) {
    scene
      ..dragFrom = scene.plotInfo.indexWhere((p) => p?.main?.id == 'm')
      ..dragTo = scene.plotInfo.lastIndexWhere((p) => p == null);
  }
  final cam = FarmCamera()..fit(layout, FarmViewport(w: 960, h: 600));
  // zoom 3: enquadra o canteiro dos minis
  final main =
      layout.plots[scene.plotInfo.indexWhere((p) => p?.main?.id == 'm')];
  // bichinhos: a câmera no primeiro, com o coração do carinho subindo; na
  // fazenda a galinha bica ao lado do cachorro
  var focus = main.center;
  if (pets) {
    final p0 = scene.pets.first;
    if (scene.pets.length > 1) {
      scene.pets[1]
        ..x = p0.x + 14
        ..y = p0.y + 3;
    }
    p0.petAt = scene.t - 0.35;
    focus = Offset(p0.x, p0.y);
  }
  if (zoom > 0) {
    cam
      ..z = zoom
      ..x = focus.dx - size.width / 2 / zoom
      ..y = focus.dy - size.height / 2 / zoom
      ..clampTo(layout, size);
  }
  await tester.pumpWidget(
    shotHost(
      RepaintBoundary(
        key: shotKey,
        child: Builder(
          builder: (context) => CustomPaint(
            size: size,
            painter: FarmScenePainter(
              scene: scene,
              world: world,
              cam: cam,
              labels: FarmLabels(),
              label: context.typo.mono.copyWith(
                fontSize: 10,
                height: 1.2,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFfff8e8),
              ),
              hover: ValueNotifier(null),
              repaint: ChangeNotifier(),
            ),
          ),
        ),
      ),
    ),
  );
  final name = scenery == FarmScenery.farm ? 'farm2' : 'office';
  await takeShot(
    tester,
    '${name}_${zoom.toInt()}${puffs ? '_puff' : ''}${drag ? '_drag' : ''}${pets ? '_pets' : ''}',
  );
});

List<CourierRun> _fakeCouriers(
  FarmScene scene,
  FarmWorld world,
  List<FarmLot> lots,
) {
  /// [at] em fração da caminhada; negativo = segundos já entregando. O
  /// caminho passa pelas portas ([courierRoute]).
  CourierRun run(
    (Offset, Critter?) a,
    (Offset, Critter?) b,
    double at,
    TeamKnockKind kind, {
    Offset targetAt = Offset.zero,
    FarmLot? fromLot,
  }) {
    final path = courierRoute(
      fromLot?.world ?? world,
      fromLot?.at ?? Offset.zero,
      a.$1,
      fromLot == null ? lots.first.world! : world,
      fromLot == null ? targetAt : Offset.zero,
      b.$1,
    );
    var len = 0.0;
    for (var i = 1; i < path.length; i++) {
      len += (path[i] - path[i - 1]).distance;
    }
    final walk = (len / courierSpeed).clamp(0.6, courierWalkMax);
    return CourierRun(
      from: a.$1,
      to: b.$1,
      path: path,
      age: at < 0 ? walk - at : walk * at,
      kind: kind,
      target: b.$2,
      targetAt: targetAt,
    );
  }

  final (bianca, rafael) = (lots[0], lots[1]);
  return [
    run(
      courierEndpoint(scene, world, Offset.zero, 'm'),
      courierEndpoint(bianca.scene, bianca.world!, bianca.at, 'b1'),
      0.45,
      TeamKnockKind.message,
      targetAt: bianca.at,
    ),
    run(
      courierEndpoint(rafael.scene, rafael.world!, rafael.at, 'r0'),
      courierEndpoint(scene, world, Offset.zero, 'k'),
      -0.8,
      TeamKnockKind.file,
      fromLot: rafael,
    ),
    run(
      courierEndpoint(bianca.scene, bianca.world!, bianca.at, null),
      courierEndpoint(scene, world, Offset.zero, 'cx'),
      0.2,
      TeamKnockKind.file,
      fromLot: bianca,
    ),
  ];
}
