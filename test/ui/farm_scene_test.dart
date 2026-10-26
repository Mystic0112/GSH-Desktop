import 'dart:math' as math;

import 'package:gsh_desktop/app/gsh/domain/entities/farm_loop.dart';
import 'package:gsh_desktop/app/gsh/ui/viewmodels/farm_viewmodel.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/farm/farm_scene.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/farm/farm_scene_painter.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/farm/farm_sprites.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/farm/farm_squad_looks.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/farm/farm_world.dart';
import 'package:flutter_test/flutter_test.dart';

FarmLoop _loop(
  String id,
  String project, {
  String? parent,
  String? agentType,
  String? title,
  String? teammate,
  FarmActivity activity = FarmActivity.running,
}) => FarmLoop(
  id: id,
  teammate: teammate,
  harness: 'claude',
  project: project,
  title: title ?? id,
  activity: activity,
  lastSeen: DateTime(2026, 10, 23),
  parentId: parent,
  agentType: agentType,
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

  test('bicho que já existe troca de pose quando a atividade muda', () {
    final scene = FarmScene(rnd: math.Random(1))..layout = _layout(6);
    scene.sync(groupFarm([_loop('w', '/p/a')]));
    expect(scene.critters['w']!.mode, CritterMode.work);
    scene.sync(groupFarm([_loop('w', '/p/a', activity: FarmActivity.waiting)]));
    expect(scene.critters['w']!.mode, CritterMode.wait);
  });

  test('órfãos (pai fora da janela) ganham canteiro e aparecem', () {
    final scene = FarmScene(rnd: math.Random(1))..layout = _layout(6);
    scene.sync(
      groupFarm([
        _loop('m', '/p/a'),
        _loop('o1', '/p/a', parent: 'sumiu'),
        _loop('o2', '/p/a', parent: 'sumiu'),
      ]),
    );
    expect(scene.critters.keys, containsAll(['m', 'o1', 'o2']));
    final orphan = scene.plotInfo.where((i) => i != null && i.main == null);
    expect(orphan, hasLength(1));
    expect(orphan.single!.minis, 2);
    expect(scene.need.plots, 2);
    // o pai volta: o canteiro dos órfãos vira o dele
    final at = scene.plotInfo.indexOf(orphan.single);
    scene.sync(
      groupFarm([
        _loop('m', '/p/a'),
        _loop('sumiu', '/p/a'),
        _loop('o1', '/p/a', parent: 'sumiu'),
      ]),
    );
    expect(scene.plotInfo[at]?.main?.id, 'sumiu');
  });

  test('agente do squad tem visual fixo; desconhecido segue sorteado', () {
    expect(squadNameOf(_loop('a', '/p', agentType: 'escanor')), 'escanor');
    expect(
      squadNameOf(_loop('a', '/p', agentType: 'gorila-squad:Bulma')),
      'bulma',
    );
    expect(squadNameOf(_loop('a', '/p', title: 'Kurama')), 'kurama');
    expect(squadNameOf(_loop('a', '/p', agentType: 'Explore')), isNull);
    final scene = FarmScene(rnd: math.Random(1))..layout = _layout(6);
    scene.sync(
      groupFarm([
        _loop('m', '/p/a', title: 'kurama'),
        _loop('s1', '/p/a', parent: 'm', agentType: 'escanor'),
        _loop('s2', '/p/a', parent: 'm', agentType: 'Explore'),
      ]),
    );
    expect(scene.critters['m']!.skin.hat, FarmHat.wizard);
    expect(scene.critters['m']!.skin.body, squadLooks['kurama']!.body);
    expect(scene.critters['s1']!.squad?.hat, FarmHat.crown);
    expect(scene.critters['s2']!.squad, isNull);
  });

  test('quem passeia contorna o celeiro em vez de travar nele', () {
    final scene = FarmScene(rnd: math.Random(3))..layout = _layout(6);
    final l = scene.layout!;
    scene.sync(groupFarm([_loop('w', '/p/a', activity: FarmActivity.idle)]));
    final c = scene.critters['w']!;
    // de um lado do celeiro ao outro, com ele no meio do caminho
    final y = l.barn.center.dy;
    c
      ..x = l.barn.left - 14
      ..y = y
      ..tx = l.barn.right + 14
      ..ty = y
      ..roam = 0;
    final goal = (c.tx, c.ty);
    var reached = false;
    for (var i = 0; i < 20 * 12 && !reached; i++) {
      c.update(0.05, scene);
      expect(l.blocked(c.x, c.y), isFalse);
      reached = (c.x - goal.$1).abs() + (c.y - goal.$2).abs() < 1.5;
    }
    expect(reached, isTrue);
  });

  test('fazenda parada pula a maior parte dos quadros', () {
    final scene = FarmScene(rnd: math.Random(1))..layout = _layout(6);
    scene.sync(
      groupFarm([
        for (var i = 0; i < 4; i++)
          _loop('z$i', '/p/$i', activity: FarmActivity.sleeping),
      ]),
    );
    expect(scene.busy, isFalse);
    // todo mundo chega no lugar, as faíscas de chegada caem
    for (var i = 0; i < 12 * 30; i++) {
      scene.update(1 / 12);
    }
    var dirty = 0;
    const frames = 12 * 20;
    for (var i = 0; i < frames; i++) {
      if (scene.update(1 / 12)) dirty++;
    }
    // ignore: avoid_print
    print('farm: $dirty de $frames quadros repintados (parada, 12 fps)');
    // só o relógio lento (4 Hz) e uma piscada aqui e ali
    expect(dirty, lessThan(frames * 0.5));
    // algo andando (faísca) suja o quadro
    scene.sparkle(10, 10, 1);
    expect(scene.update(1 / 12), isTrue);
  });

  test('barrinha do contexto: verde, amarelo e vermelho', () {
    expect(contextBarColor(0.31), contextBarColor(0));
    expect(contextBarColor(0.6), isNot(contextBarColor(0.59)));
    expect(contextBarColor(0.84), contextBarColor(0.6));
    expect(contextBarColor(0.85), isNot(contextBarColor(0.84)));
    expect(contextBarColor(1), contextBarColor(0.85));
  });

  test('quem chega ou sai deixa uma poeirinha que some em 0,6 s', () {
    final scene = FarmScene(rnd: math.Random(1))..layout = _layout(8);
    scene.sync(groupFarm([_loop('a', '/p/a')]));
    // o primeiro sync é a fazenda abrindo: ninguém "chega"
    expect(scene.puffs, isEmpty);
    scene.sync(groupFarm([_loop('a', '/p/a'), _loop('b', '/p/a')]));
    expect(scene.puffs.single.born, isTrue);
    scene
      ..update(0.3)
      ..sync(groupFarm([_loop('b', '/p/a')]));
    final gone = scene.puffs.where((p) => !p.born).single;
    expect((gone.x, gone.y), (scene.critters['a']!.x, scene.critters['a']!.y));
    expect(scene.update(0.35), isTrue);
    expect(scene.puffs.single, same(gone));
    scene.update(0.3);
    expect(scene.puffs, isEmpty);
    expect(scene.critters.keys, ['b']);
  });

  test('teammate tem canteiro próprio, tamanho cheio e a cor do lead', () {
    final scene = FarmScene(rnd: math.Random(1))..layout = _layout(8);
    scene.sync(
      groupFarm([
        _loop('lead', '/p/a'),
        _loop('sub', '/p/a', parent: 'lead'),
        _loop('t1', '/p/a', parent: 'lead', teammate: 'revisor'),
        _loop('t2', '/p/a', parent: 'lead', teammate: 'testes'),
        _loop('solo', '/p/a'),
      ]),
    );
    FarmPlotInfo? plotOf(String id) =>
        scene.plotInfo.where((i) => i?.main?.id == id).firstOrNull;
    // o subagente segue mini no canteiro do lead; teammates não
    expect(plotOf('lead')!.minis, 1);
    expect(scene.critters['sub']!.mini, isTrue);
    for (final id in ['t1', 't2']) {
      expect(plotOf(id), isNotNull);
      expect(scene.critters[id]!.mini, isFalse);
      expect(plotOf(id)!.team, plotOf('lead')!.team);
    }
    expect(plotOf('lead')!.team, isNotNull);
    expect(plotOf('solo')!.team, isNull);
    expect(scene.need.plots, 4);
  });
}
