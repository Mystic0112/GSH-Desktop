import 'dart:math' as math;

import 'package:cockpit/app/cockpit/domain/entities/farm_loop.dart';
import 'package:cockpit/app/cockpit/ui/viewmodels/farm_viewmodel.dart';
import 'package:cockpit/app/cockpit/ui/widgets/farm/farm_scene.dart';
import 'package:cockpit/app/cockpit/ui/widgets/farm/farm_world.dart';
import 'package:flutter_test/flutter_test.dart';

FarmLoop _loop(
  String id,
  String project, {
  String? parent,
  FarmActivity activity = FarmActivity.running,
}) => FarmLoop(
  id: id,
  harness: 'claude',
  project: project,
  title: id,
  activity: activity,
  lastSeen: DateTime(2026, 10, 23),
  parentId: parent,
);

FarmLayout _layout(int plots) => layoutFarm(
  plots: plots,
  yard: 0,
  view: const FarmViewport(w: 1200, h: 780, left: 240, top: 8),
  snap: (z) => z >= 2 ? z.floorToDouble() : z,
);

void main() {
  test(
    'o cercado cabe os canteiros pedidos, sem sobrepor, dentro da cerca',
    () {
      for (final n in [1, 7, 25]) {
        final l = _layout(n);
        expect(l.plots.length, greaterThanOrEqualTo(math.max(6, n)));
        for (final p in l.plots) {
          expect(
            l.field.contains(p.topLeft) && l.field.contains(p.bottomRight),
            isTrue,
          );
          for (final o in l.plots) {
            if (!identical(o, p)) expect(o.overlaps(p), isFalse);
          }
        }
        expect(l.barn.right, lessThan(l.field.left));
        expect(l.z, greaterThan(0));
      }
    },
  );

  test(
    'canteiros do mesmo projeto ficam juntos e não mudam quando chega outro',
    () {
      final scene = FarmScene(rnd: math.Random(1))..layout = _layout(8);
      final loops = [
        _loop('a1', '/p/a'),
        _loop('b1', '/p/b'),
        _loop('a2', '/p/a'),
      ];
      scene.sync(groupFarm(loops));
      int plotOf(String id) =>
          scene.plotInfo.indexWhere((i) => i?.main?.id == id);
      expect((plotOf('a1') - plotOf('a2')).abs(), 1);
      final before = {
        for (final id in ['a1', 'a2', 'b1']) id: plotOf(id),
      };

      scene.sync(groupFarm([...loops, _loop('c1', '/p/c')]));
      for (final e in before.entries) {
        expect(plotOf(e.key), e.value);
      }
      expect(plotOf('c1'), isNonNegative);
      // nome da pasta só no primeiro canteiro de cada projeto
      expect(scene.plotInfo.where((i) => i?.project == 'a').length, 1);
    },
  );

  test('subagentes ocupam os lugares do canteiro do pai; o resto vira +N', () {
    final scene = FarmScene(rnd: math.Random(1))..layout = _layout(6);
    scene.sync(
      groupFarm([
        _loop('m', '/p/a'),
        for (var i = 0; i < 11; i++) _loop('s$i', '/p/a', parent: 'm'),
      ]),
    );
    final i = scene.plotInfo.indexWhere((p) => p?.main?.id == 'm');
    expect(scene.plotInfo[i]!.more, 11 - subSpots.length);
    final plot = scene.layout!.plots[i];
    final minis = scene.critters.values.where((c) => c.mini).toList();
    expect(minis, hasLength(subSpots.length));
    for (final c in minis) {
      expect(
        subSpots.any((s) => c.spot == plot.topLeft.translate(s.$1, s.$2)),
        isTrue,
      );
    }
  });

  test('pose segue a atividade', () {
    final scene = FarmScene(rnd: math.Random(1))..layout = _layout(6);
    scene.sync(
      groupFarm([
        _loop('w', '/p/a'),
        _loop('q', '/p/a', activity: FarmActivity.waiting),
        _loop('i', '/p/a', activity: FarmActivity.idle),
        _loop('z', '/p/a', activity: FarmActivity.sleeping),
        _loop('d', '/p/a', parent: 'w', activity: FarmActivity.done),
      ]),
    );
    CritterMode mode(String id) => scene.critters[id]!.mode;
    expect(mode('w'), CritterMode.work);
    expect(mode('q'), CritterMode.wait);
    expect(mode('i'), CritterMode.wander);
    expect(mode('z'), CritterMode.sleep);
    expect(scene.critters['z']!.home, isNotNull);
    expect(mode('d'), CritterMode.done);
  });
}
