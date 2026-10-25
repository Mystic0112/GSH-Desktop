// Ported from clodfarm (github.com/matank001/clodfarm), MIT License, see third_party/clodfarm/LICENSE.

part of 'farm_world.dart';

// ------------------------------------------------------------- o fundo

/// Fundo pronto: a imagem HD do mundo e a faixa de árvores da frente (que
/// passa por cima dos bichos), mais pedras e decoração (eles desviam delas).
class FarmWorld {
  FarmWorld(this.layout, this.bg, this.fg, this.fgY, this.scenery);
  final FarmLayout layout;

  /// O cenário pintado: o painter troca plantação/espantalho por monitores
  /// e impressora no escritório.
  final FarmScenery scenery;
  final ui.Image bg;
  final ui.Image fg;
  final int fgY;

  void dispose() {
    bg.dispose();
    fg.dispose();
  }
}

typedef _Built = ({
  Uint8List bg,
  Uint8List fg,
  int fgY,
  List<ui.Rect> rocks,
  List<FarmDecor> decor,
});

/// Pinta o fundo num isolate (é o passo caro) e sobe as imagens.
Future<FarmWorld> buildWorld(
  FarmLayout l, {
  int seed = 7,
  FarmScenery scenery = FarmScenery.farm,
}) async {
  final built = await Isolate.run(() => _paintWorld(l, seed, scenery));
  l
    ..rocks = built.rocks
    ..decor = built.decor;
  final bg = await imageFromRgba(built.bg, l.w * hd, l.h * hd);
  final fg = await imageFromRgba(built.fg, l.w * hd, (l.h - built.fgY) * hd);
  return FarmWorld(l, bg, fg, built.fgY, scenery);
}

double Function(double, double) _valueNoise(int seed) {
  final rnd = mulberry32(seed);
  const n = 64;
  final grid = List.generate(n * n, (_) => rnd());
  double at(int x, int y) => grid[(y % n) * n + (x % n)];
  double lerp(double a, double b, double t) => a + (b - a) * t;
  return (x, y) {
    final xi = x.floor(), yi = y.floor(), xf = x - xi, yf = y - yi;
    final u = xf * xf * (3 - 2 * xf), v = yf * yf * (3 - 2 * yf);
    return lerp(
      lerp(at(xi, yi), at(xi + 1, yi), u),
      lerp(at(xi, yi + 1), at(xi + 1, yi + 1), u),
      v,
    );
  };
}

_Built _paintWorld(FarmLayout l, int seed, FarmScenery scenery) {
  final w = l.w, h = l.h, rnd = mulberry32(seed);
  final g = Raster(w * hd, h * hd);
  if (scenery == FarmScenery.office) {
    // escritório: rua e calçada em volta, nada de mato (e nada passa por
    // cima dos bichos: a faixa da frente fica vazia)
    _street(g, l, rnd);
    final (rocks, decor) = _officeProps(g, l, rnd);
    return (
      bg: g.toRgba(),
      fg: Raster(w * hd, hd).toRgba(),
      fgY: h - 1,
      rocks: rocks,
      decor: decor,
    );
  }
  // grama: duas oitavas de ruído, dithering ordenado entre cinco tons e uma
  // clareira gasta em volta da fazenda
  final n1 = _valueNoise(seed + 1), n2 = _valueNoise(seed + 2);
  const tones = [_g0, _g1, _g2, _g3, _g4, _worn];
  final c = l.content;
  final cx = c.center.dx, cy = c.center.dy + 6;
  final rx = math.max(60.0, c.width * 0.62),
      ry = math.max(50.0, c.height * 0.64);
  for (var y = 0; y < h; y++) {
    for (var x = 0; x < w; x++) {
      final ex = (x - cx) / rx, ey = (y - cy) / ry;
      final e = ex * ex + ey * ey;
      var t =
          n1(x / 22, y / 22) * 0.62 +
          n2(x / 7, y / 7) * 0.38 +
          (1 - math.min(1.4, e)) * 0.3;
      t += (_bayer[y & 3][x & 3] / 16 - 0.5) * 0.14;
      final k = ((t - 0.18) * 5.2).floor().clamp(0, 5);
      g.fill(x * hd, y * hd, hd, hd, tones[k]);
    }
  }
  for (var i = 0; i < (w * h) / 40; i++) {
    final x = (rnd() * w * hd).floor(), y = (rnd() * h * hd).floor();
    final r = rnd();
    if (r < 0.55) {
      final cc = rnd() < 0.5 ? _g0 : _g1;
      g
        ..fill(x, y, 1, 3, cc)
        ..fill(x + 2, y + 1, 1, 2, cc)
        ..fill(x + 1, y + 2, 1, 1, cc);
    } else if (r < 0.85) {
      g.fill(x, y, 1, 2, rnd() < 0.5 ? _g4 : 0xFF93b552);
    } else if (!l.blocked(x / hd, y / hd)) {
      final cc = _flowerC[(rnd() * _flowerC.length).floor()];
      g
        ..fill(x - 1, y, 3, 1, cc)
        ..fill(x, y - 1, 1, 3, cc)
        ..fill(x, y, 1, 1, 0xFFf5e27a);
    }
  }
  final (rocks, decor) = _farmProps(g, l, rnd);
  // árvores na borda: as de trás no fundo, a fileira de baixo na frente de
  // tudo (faixa própria)
  final trees = <(double, double, double)>[];
  final t = l.t;
  for (var x = -6.0; x < w + 12; x += 12 + rnd() * 9) {
    trees.add((x, 2 + rnd() * (t - 16), 10 + rnd() * 5));
    if (rnd() < 0.6) trees.add((x + 6, -6 + rnd() * 8, 11 + rnd() * 4));
  }
  for (var y = t - 4.0; y < h - t + 6; y += 12 + rnd() * 8) {
    trees
      ..add((2 + rnd() * (t - 14), y, 9 + rnd() * 5))
      ..add((w - 2 - rnd() * (t - 14), y, 9 + rnd() * 5));
    if (rnd() < 0.5) trees.add((-4, y + 6, 11));
    if (rnd() < 0.5) trees.add((w + 4.0, y + 6, 11));
  }
  final front = <(double, double, double)>[];
  for (var x = -6.0; x < w + 12; x += 12 + rnd() * 9) {
    front.add((x, h - t + 12 + rnd() * 10, 11 + rnd() * 5));
  }
  trees.sort((a, b) => a.$2.compareTo(b.$2));
  for (final (x, y, r) in trees) {
    _tree(g, (x * hd).round(), (y * hd).round(), (r * hd).round(), rnd);
  }
  final fgY = math.max(0, h - t - 8);
  final f = Raster(w * hd, (h - fgY) * hd);
  front.sort((a, b) => a.$2.compareTo(b.$2));
  for (final (x, y, r) in front) {
    _tree(f, (x * hd).round(), ((y - fgY) * hd).round(), (r * hd).round(), rnd);
  }
  return (bg: g.toRgba(), fg: f.toRgba(), fgY: fgY, rocks: rocks, decor: decor);
}

/// O miolo da fazenda: caminhos, lago, pedras, decoração, curral, cercado,
/// canteiros, celeiro e placa.
(List<ui.Rect>, List<FarmDecor>) _farmProps(
  Raster g,
  FarmLayout l,
  double Function() rnd,
) {
  final w = l.w, h = l.h, c = l.content;
  for (final pts in l.paths) {
    _path(g, pts, rnd);
  }
  _pond(g, l, rnd);
  // pedras e natureza no campo, onde não há mais nada
  bool clear(double x, double y, double pad) =>
      !l.blocked(x, y) &&
      !l.onPath(x, y, pad) &&
      (ui.Offset(x, y) - l.door).distance > 30 &&
      !(x > c.left - 4 && x < c.right + 4 && y > c.top - 4 && y < c.bottom + 6);
  final p = l.play;
  final rocks = <ui.Rect>[];
  l.rocks = rocks;
  final wantRocks = ((w * h) / 45000).round().clamp(2, 10);
  for (var tries = 0; rocks.length < wantRocks && tries < 400; tries++) {
    final rw = 12 + (rnd() * 8).floor();
    final r = ui.Rect.fromLTWH(
      p.left + 10 + rnd() * (p.width - 20),
      p.top + rnd() * (p.height - 12),
      rw.toDouble(),
      (rw * 0.75).roundToDouble(),
    );
    if (clear(r.left, r.top, 10) &&
        clear(r.left, r.bottom, 10) &&
        rocks.every((o) => (o.topLeft - r.topLeft).distance > 44)) {
      rocks.add(r);
    }
  }
  const kinds = [
    ('flowers', 0.5, 0.0),
    ('bush', 0.27, 7.0),
    ('mushrooms', 0.09, 0.0),
    ('pumpkin', 0.09, 6.0),
    ('log', 0.05, 8.0),
  ];
  final decor = <FarmDecor>[];
  l.decor = decor;
  final wantDecor = ((w * h) / 2600).round().clamp(8, 70);
  for (var tries = 0; decor.length < wantDecor && tries < 900; tries++) {
    final x = p.left + 8 + rnd() * (p.width - 16);
    final y = p.top + 10 + rnd() * (p.height - 14);
    var pr = rnd();
    var kind = kinds.first;
    for (final k in kinds) {
      if (pr < k.$2) {
        kind = k;
        break;
      }
      pr -= k.$2;
    }
    if (!clear(x, y, 9) ||
        decor.any(
          (o) => (ui.Offset(o.x, o.y) - ui.Offset(x, y)).distance < 22,
        ) ||
        rocks.any((o) => (o.topLeft - ui.Offset(x, y)).distance < 20)) {
      continue;
    }
    decor.add(FarmDecor(kind.$1, x, y, kind.$3, (rnd() * 6).floor()));
  }
  // flores na frente do celeiro e em volta do lago
  final b = l.barn;
  for (final fx in [b.left + 4, b.right - 6]) {
    decor.add(FarmDecor('flowers', fx, b.bottom + 4, 0, (rnd() * 6).floor()));
  }
  decor
    ..add(FarmDecor('flowers', l.pondCx - l.pondRx - 8, l.pondCy + 6, 0, 2))
    ..add(FarmDecor('flowers', l.pondCx + l.pondRx + 8, l.pondCy + 4, 0, 4));
  for (final r in rocks) {
    _rock(g, r);
  }
  for (final d in [...decor]..sort((a, b) => a.y.compareTo(b.y))) {
    _decor(g, d, rnd);
  }
  _yard(g, l.yard, rnd);
  _fence(g, l.field, l.gateAt);
  for (final pl in l.plots) {
    _plot(g, pl);
  }
  _barn(g, l.barn);
  _sign(g, l.sign);
  return (rocks, decor);
}

void _tree(Raster g, int x, int y, int r, double Function() rnd) {
  g
    ..ellipse(x + 4, y + r - 2, r + 3, math.max(5, (r / 3).round()), _shadow32)
    ..fill(x - 4, y + r - 15, 8, 15, _trunk)
    ..fill(x - 4, y + r - 15, 2, 15, 0xFF5e4330)
    ..fill(x + 2, y + r - 15, 2, 15, 0xFF35241a)
    ..fill(x - 6, y + r - 2, 3, 2, _trunk)
    ..fill(x + 3, y + r - 2, 3, 2, 0xFF35241a);
  final blobs = [
    for (final (dx, dy, k) in const [
      (0.0, 0.0, 1.0),
      (-0.5, -0.15, 0.62),
      (0.5, -0.1, 0.6),
      (0.0, -0.52, 0.62),
      (-0.3, 0.3, 0.55),
      (0.35, 0.32, 0.5),
    ])
      (x + dx * r, y + dy * r, math.max(3.0, r * k)),
  ];
  for (final (bx, by, br) in blobs) {
    g.circle(bx, by, br + 2, t0);
  }
  for (final (bx, by, br) in blobs) {
    g.circle(bx, by, br, _t1);
  }
  for (final (bx, by, br) in blobs) {
    g.circle(bx - br * 0.18, by - br * 0.22, br * 0.78, _t2);
  }
  for (final (bx, by, br) in blobs) {
    if (by < y + r * 0.2) {
      g.circle(bx - br * 0.32, by - br * 0.38, br * 0.46, _t3);
    }
  }
  for (final (bx, by, br) in blobs.sublist(1, 4)) {
    g.circle(bx - br * 0.4, by - br * 0.46, br * 0.2, _t4);
  }
  for (var i = 0; i < r * 2.2; i++) {
    final a = rnd() * math.pi * 2, d = rnd() * r * 0.95;
    final lx = (x + math.cos(a) * d).round();
    final ly = (y + math.sin(a) * d * 0.9).round();
    g.fill(lx, ly, 2, 1, ly < y ? _t4 : _t1);
    if (ly < y - r * 0.3) g.fill(lx, ly - 1, 1, 1, _t5);
  }
}

void _rock(Raster g, ui.Rect r) {
  final cx = (r.left * hd).round(), rx = r.width;
  final ry = (r.height * 0.9).round(), cy = (r.bottom * hd - ry).round();
  g
    ..ellipse(cx + 3, cy + ry, rx + 2, 4, _shadow38)
    ..ellipse(cx, cy, rx + 1, ry + 1, _r0)
    ..ellipse(cx, cy, rx, ry, _r1)
    ..ellipse(
      cx - (rx * 0.15).round(),
      cy - (ry * 0.2).round(),
      (rx * 0.72).round(),
      (ry * 0.62).round(),
      _r2,
    )
    ..ellipse(
      cx - (rx * 0.35).round(),
      cy - (ry * 0.45).round(),
      (rx * 0.32).round(),
      (ry * 0.22).round(),
      _r3,
    )
    ..fill(cx - (rx * 0.5).round(), cy - (ry * 0.55).round(), 2, 1, _r4)
    ..ellipse(
      cx + (rx * 0.3).round(),
      cy - ry + 1,
      (rx * 0.32).round(),
      1,
      0xFF5f8a34,
    )
    ..fill(cx + (rx * 0.2).round(), cy - ry, 3, 1, 0xFF86b04a);
  if ((r.left + r.top).round().isOdd) {
    for (var j = 0; j < spark.length; j++) {
      for (var i = 0; i < spark[j].length; i++) {
        if (spark[j][i] != '.' && (i + j).isEven) {
          g.fill(cx - 4 + i, cy - 3 + j, 1, 1, 0xFF45454e);
        }
      }
    }
  }
}
