@Tags(['preview'])
library;

import 'dart:math' as math;

import 'package:gsh_desktop/app/core/domain/entities/app_settings.dart';
import 'package:gsh_desktop/app/core/ui/themes/themes.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/farm_loop.dart';
import 'package:gsh_desktop/app/gsh/ui/viewmodels/farm_viewmodel.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/farm/farm_scene.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/farm/farm_scene_painter.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/farm/farm_world.dart';
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
  int tokens = 0,
}) => FarmLoop(
  id: id,
  harness: harness,
  project: project,
  title: title ?? id,
  activity: activity,
  lastSeen: DateTime(2026, 10, 23),
  parentId: parent,
  agentType: agentType,
  outputTokens: tokens,
);

/// Um canteiro com 6 minis do squad, um órfão, os principais do Codex e do
/// Antigravity, um principal "kurama" e gente parada.
List<FarmLoop> _loops() => [
  _loop('m', FarmActivity.editing, title: 'Refatorar a fazenda', tokens: 60000),
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
  ),
  _loop(
    'ag',
    FarmActivity.waiting,
    harness: 'antigravity',
    project: '/home/dev/site',
    title: 'Landing nova',
  ),
  _loop(
    'o1',
    FarmActivity.running,
    project: '/home/dev/infra',
    parent: 'sumiu',
    agentType: 'saitama',
    title: 'Pipeline de deploy',
  ),
  _loop('k', FarmActivity.thinking, title: 'kurama', tokens: 200000),
  _loop('z', FarmActivity.sleeping, title: 'Spike de cache'),
  _loop('i', FarmActivity.idle, title: 'Docs do hook'),
];

void main() {
  setUpAll(loadShotFonts);

  // zoom 0 = enquadra o mundo inteiro (o duplo clique)
  for (final scenery in FarmScenery.values) {
    for (final zoom in [0.0, 1.0, 3.0, 5.0]) {
      _preview(scenery, zoom);
    }
  }
}

void _preview(FarmScenery scenery, double zoom) =>
    testWidgets('preview: ${scenery.name} no zoom $zoom', (tester) async {
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
      scene.relayout(layout);
      for (var i = 0; i < 40; i++) {
        scene.update(0.05);
      }
      final cam = FarmCamera()..fit(layout, FarmViewport(w: 960, h: 600));
      // zoom 3: enquadra o canteiro dos minis
      final main =
          layout.plots[scene.plotInfo.indexWhere((p) => p?.main?.id == 'm')];
      if (zoom > 0) {
        cam
          ..z = zoom
          ..x = main.center.dx - size.width / 2 / zoom
          ..y = main.center.dy - size.height / 2 / zoom
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
      await takeShot(tester, '${name}_${zoom.toInt()}');
    });
