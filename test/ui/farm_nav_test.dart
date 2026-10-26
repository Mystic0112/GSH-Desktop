import 'dart:math' as math;

import 'package:gsh_desktop/app/gsh/domain/entities/farm_loop.dart';
import 'package:gsh_desktop/app/gsh/ui/viewmodels/farm_viewmodel.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/farm/farm_courier.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/farm/farm_scene.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/farm/farm_world.dart';
import 'package:flutter_test/flutter_test.dart';

FarmLayout _layout(int plots, {int yard = 2}) => layoutFarm(
  plots: plots,
  yard: yard,
  view: const FarmViewport(w: 1200, h: 780, left: 240, top: 8),
  snap: (z) => z >= 2 ? z.floorToDouble() : z,
);

/// Todo o caminho anda em chão livre (fora as pontas, que podem estar no
/// canto de uma ilha ou numa cadeira).
void _expectClear(FarmNav nav, List<Offset> pts) {
  for (var i = 1; i < pts.length; i++) {
    final a = pts[i - 1], b = pts[i];
    final n = ((b - a).distance / 1).ceil();
    for (var k = 0; k <= n; k++) {
      final p = a + (b - a) * (k / math.max(1, n));
      if ((p - pts.first).distance < 6 || (p - pts.last).distance < 6) {
        continue;
      }
      expect(nav.walkable(p.dx, p.dy), isTrue, reason: 'pisou em $p');
    }
  }
}

FarmLoop _loop(String id, {String? parent, FarmActivity? activity}) => FarmLoop(
  id: id,
  harness: 'claude',
  project: '/p/${id.hashCode % 5}',
  title: id,
  activity: activity ?? FarmActivity.editing,
  lastSeen: DateTime(2026, 10, 26),
  parentId: parent,
);

void main() {
  test('fazenda: do celeiro ao canteiro passa pelo portão do cercado', () {
    final l = _layout(8);
    final nav = l.nav = FarmNav(l, office: false);
    final spot = Offset(l.plots[3].left - 7, l.plots[3].bottom);
    final r = nav.route(l.door, spot)!;
    expect(r.last, spot);
    _expectClear(nav, [l.door, ...r]);
    // entra no cercado pela abertura do portão, não pela cerca
    final crossing = [l.door, ...r].indexed.where((e) {
      final (i, p) = e;
      return i > 0 &&
          [l.door, ...r][i - 1].dx < l.field.left &&
          p.dx >= l.field.left;
    });
    expect(crossing, isNotEmpty);
    final pts = [l.door, ...r];
    final (i, b) = crossing.first;
    final a = pts[i - 1];
    final y = a.dy + (b.dy - a.dy) * (l.field.left - a.dx) / (b.dx - a.dx);
    expect((y - l.gateAt).abs(), lessThan(8));
    // e o curral é pela porteira de cima
    final sleep = l.yardSpot(0);
    final r2 = nav.route(spot, sleep)!;
    _expectClear(nav, [spot, ...r2]);
  });

  test('escritório: da ilha ao lounge pelas portas, sem pisar nas mesas', () {
    final l = _layout(8);
    final nav = l.nav = FarmNav(l, office: true);
    final spot = Offset(l.plots[4].left - 7, l.plots[4].bottom);
    final r = nav.route(spot, l.yardSpot(0))!;
    _expectClear(nav, [spot, ...r]);
    for (final p in l.plots) {
      expect(nav.walkable(p.center.dx, p.center.dy), isFalse);
    }
    // rota repetida sai do cache, sem nova busca
    final before = nav.searches;
    nav.route(spot, l.yardSpot(0));
    expect(nav.searches, before);
  });

  test('sem caminho: devolve null (quem anda vai reto)', () {
    final l = _layout(6);
    final nav = l.nav = FarmNav(l, office: false);
    expect(nav.route(l.door, const Offset(-50, -50)), isNull);
  });

  test(
    '35 agentes andando: rota só quando o destino muda, nunca por quadro',
    () {
      final l = _layout(40, yard: 8);
      l.nav = FarmNav(l, office: true);
      final scene = FarmScene(rnd: math.Random(5))..relayout(l);
      final loops = [
        for (var i = 0; i < 35; i++)
          _loop(
            'a$i',
            activity: i % 7 == 0 ? FarmActivity.sleeping : FarmActivity.editing,
          ),
        for (var i = 0; i < 10; i++) _loop('s$i', parent: 'a${i * 2}'),
      ];
      scene.sync(groupFarm(loops));
      final watch = Stopwatch()..start();
      var onDesks = 0;
      for (var i = 0; i < 600; i++) {
        scene.update(0.05);
        // o passeio do gorila trabalhando é pelo corredor, nunca pela mesa
        for (final c in scene.critters.values) {
          if (c.mini) continue;
          if (l.plots.any((p) => p.deflate(2).contains(Offset(c.x, c.y)))) {
            onDesks++;
          }
        }
      }
      watch.stop();
      expect(onDesks, 0);
      // 30 s de cena: as buscas são poucas por bicho, não uma por quadro
      expect(l.nav!.searches, lessThan(45 * 12));
      expect(watch.elapsedMilliseconds, lessThan(3000));
      // ninguém ficou parado em cima de uma mesa
      for (final c in scene.critters.values) {
        if (c.mini || c.moving) continue;
        final onDesk = l.plots.any((p) => p.contains(Offset(c.x, c.y - 1)));
        expect(onDesk, isFalse, reason: c.loop.id);
      }
    },
  );

  testWidgets('mensageiro sai pela porta de um lote e entra pela do outro', (
    tester,
  ) async {
    final la = _layout(6), lb = _layout(6);
    final wa = (await tester.runAsync(() => buildWorld(la)))!;
    final wb = (await tester.runAsync(() => buildWorld(lb, seed: 9)))!;
    addTearDown(() {
      wa.dispose();
      wb.dispose();
    });
    final atB = Offset(la.w + 0.0, 0);
    final from = Offset(la.plots[0].left - 7, la.plots[0].bottom);
    final to = Offset(lb.plots[1].left - 7, lb.plots[1].bottom) + atB;
    final path = courierRoute(wa, Offset.zero, from, wb, atB, to);
    expect((path.first, path.last), (from, to));
    // sai pela borda de baixo, embaixo da porta do celeiro, e entra igual
    final da = Offset(la.door.dx, la.play.bottom - 4);
    final db = Offset(lb.door.dx, lb.play.bottom - 4) + atB;
    final ia = path.indexWhere((p) => (p - da).distance < 0.01);
    final ib = path.indexWhere((p) => (p - db).distance < 0.01);
    expect(ia, greaterThan(0));
    expect(ib, greaterThan(ia));
    // dentro de cada lote, pelo chão livre (o portão do cercado)
    _expectClear(la.nav!, path.sublist(0, ia + 1));
    _expectClear(lb.nav!, [for (final p in path.sublist(ib)) p - atB]);
    // a mesma rota no quadro seguinte vem do cache
    expect(
      identical(courierRoute(wa, Offset.zero, from, wb, atB, to), path),
      isTrue,
    );
  });
}
