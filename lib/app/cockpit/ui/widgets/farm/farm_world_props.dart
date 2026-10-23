// Ported from clodfarm (github.com/matank001/clodfarm), MIT License, see third_party/clodfarm/LICENSE.

part of 'farm_world.dart';

void _hay(Raster g, num x, num y) {
  g
    ..fill(x, y, 18, 14, 0xFF7a5a1a)
    ..fill(x + 1, y + 1, 16, 12, 0xFFe0b64e)
    ..fill(x + 1, y + 1, 16, 3, 0xFFf0cf7a)
    ..fill(x + 1, y + 10, 16, 3, 0xFFc7973a)
    ..fill(x + 5, y + 1, 2, 12, 0xFFa8782a)
    ..fill(x + 12, y + 1, 2, 12, 0xFFa8782a);
  for (var i = 0; i < 6; i++) {
    g.fill(x + 2 + i * 3, y - 1 + (i % 2), 1, 2, 0xFFf0cf7a);
  }
}

void _barn(Raster g, ui.Rect b) {
  final x = b.left * hd, y = b.top * hd, w = b.width * hd, hh = b.height * hd;
  const roofH = 32;
  g.ellipse(x + w / 2 + 6, y + hh + 1, w / 2 + 12, 8, _shadow36);
  // paredes: tábuas vermelhas, cantoneira branca, base de pedra
  final wy = y + roofH - 2, wh = hh - roofH + 2;
  g.fill(x, wy, w, wh, 0xFF3a1410);
  var i = 0;
  for (var px = x + 2; px < x + w - 2; px += 6, i++) {
    g
      ..fill(px, wy, 6, wh - 2, i.isOdd ? 0xFFa8432f : 0xFFb34a33)
      ..fill(px, wy, 1, wh - 2, 0xFF8e3624);
  }
  g.fill(x + 2, wy, w - 4, 2, 0xFFc95c42);
  for (var k = 0; k < 18; k++) {
    g.fill(
      x + 4 + ((k * 37) % (w - 10)),
      wy + 6 + ((k * 23) % (wh - 12)),
      2,
      1,
      0xFF933826,
    );
  }
  g
    ..fill(x + 2, wy, 4, wh - 2, 0xFFefe4cf)
    ..fill(x + w - 6, wy, 4, wh - 2, 0xFFd6c8ad)
    ..fill(x, y + hh - 5, w, 5, 0xFF6f6a66);
  for (var px = x + 2; px < x + w - 2; px += 7) {
    g.fill(px, y + hh - 5, 5, 3, 0xFF8d8783);
  }
  // telhado: empena escalonada de telhas com acabamento branco
  for (var k = 0; k < roofH; k++) {
    final inset = math.max(0, ((roofH - k) * 0.95).round() - 6);
    final rx = x - 4 + inset, rw = w + 8 - inset * 2;
    g
      ..fill(rx, y + k, rw, 1, 0xFF2d1511)
      ..fill(
        rx + 2,
        y + k,
        math.max(0, rw - 4),
        1,
        k % 4 == 3 ? 0xFF4a2019 : 0xFF6a3024,
      );
    if (k % 4 != 3) {
      for (var sx = rx + 4 + ((k >> 2) % 2) * 4; sx < rx + rw - 4; sx += 8) {
        g.fill(sx, y + k, 1, 1, 0xFF4f231b);
      }
    }
    g
      ..fill(rx + 2, y + k, 2, 1, 0xFFf3ead8)
      ..fill(rx + rw - 4, y + k, 2, 1, 0xFFd6c8ad);
  }
  g.fill(x - 4, y + roofH - 2, w + 8, 2, 0xFFf3ead8);
  // janela do sótão com feno
  final lx = x + w / 2 - 10, ly = y + 10;
  g
    ..fill(lx, ly, 20, 16, 0xFFf3ead8)
    ..fill(lx + 2, ly + 2, 16, 12, 0xFF2d1a10)
    ..fill(lx + 2, ly + 9, 16, 5, 0xFFe0b64e);
  for (var k = 0; k < 5; k++) {
    g.fill(lx + 3 + k * 3, ly + 7 + (k % 2), 1, 3, 0xFFf0cf7a);
  }
  g.fill(lx + 9, ly + 2, 2, 12, 0xFFf3ead8);
  // o portão grande com o X branco
  const dw = 34.0;
  final dh = wh - 9, dx = x + w / 2 - dw / 2, dy = wy + 6;
  g
    ..fill(dx - 2, dy - 2, dw + 4, dh + 2, 0xFFf3ead8)
    ..fill(dx, dy, dw, dh, 0xFF7a2c1f);
  for (var px = dx + 3; px < dx + dw; px += 4) {
    g.fill(px, dy, 1, dh, 0xFF6a2519);
  }
  for (var k = 0; k < dh; k++) {
    final t = ((k / dh) * (dw / 2 - 2)).round();
    g
      ..fill(dx + t, dy + k, 2, 1, 0xFFf3ead8)
      ..fill(dx + dw / 2 - 2 - t, dy + k, 2, 1, 0xFFf3ead8)
      ..fill(dx + dw / 2 + t, dy + k, 2, 1, 0xFFf3ead8)
      ..fill(dx + dw - 2 - t, dy + k, 2, 1, 0xFFf3ead8);
  }
  g
    ..fill(dx + dw / 2 - 1, dy, 2, dh, 0xFFf3ead8)
    ..fill(dx - 1, dy + 4, 3, 2, 0xFF2d1a10)
    ..fill(dx - 1, dy + dh - 7, 3, 2, 0xFF2d1a10)
    ..fill(dx + dw - 2, dy + 4, 3, 2, 0xFF2d1a10)
    ..fill(dx + dw - 2, dy + dh - 7, 3, 2, 0xFF2d1a10)
    // lampião e o catavento: a faísca do Claude na cumeeira
    ..fill(x + w / 2 + 22, wy + 8, 4, 6, 0xFF2d1a10)
    ..fill(x + w / 2 + 23, wy + 9, 2, 4, 0xFFffd27a);
  final vx = x + w / 2, vy = y - 12;
  g.fill(vx - 1, vy + 6, 2, 8, 0xFF2d1511);
  for (var j = 0; j < spark.length; j++) {
    for (var k = 0; k < spark[j].length; k++) {
      final ch = spark[j][k];
      if (ch != '.') {
        g.fill(
          vx - 5 + k,
          vy - 4 + j,
          1,
          1,
          ch == 'w' ? 0xFFffd59e : 0xFFd97757,
        );
      }
    }
  }
  _hay(g, x + w + 2, y + hh - 14);
  _hay(g, x - 20, y + hh - 14);
  _hay(g, x + w + 6, y + hh - 26);
}

void _plot(Raster g, ui.Rect p) {
  final x = p.left * hd, y = p.top * hd, w = p.width * hd, hh = p.height * hd;
  g
    ..fill(x - 2, y, w + 4, hh + 2, _soilo)
    ..fill(x, y - 2, w, hh + 6, _soilo)
    ..fill(x, y, w, hh + 2, 0xFF4f3420)
    ..fill(x, y, w, hh, _soil);
  for (var yy = y + 3; yy < y + hh - 1; yy += 6) {
    g
      ..fill(x + 2, yy, w - 4, 2, _soil3)
      ..fill(x + 2, yy + 2, w - 4, 2, _soil2)
      ..fill(x + 3, yy, w - 8, 1, 0xFF8e6a46);
  }
  for (var i = 0; i < 10; i++) {
    g.fill(
      x + 3 + ((i * 17) % (w - 6)),
      y + 2 + ((i * 11) % (hh - 4)),
      1,
      1,
      i.isOdd ? 0xFF3f2915 : 0xFF9a7650,
    );
  }
}

void _path(Raster g, List<ui.Offset> pts, double Function() rnd) {
  void seg(ui.Offset a, ui.Offset b, double pad, int c) => g.fill(
    math.min(a.dx, b.dx) * hd - pad,
    math.min(a.dy, b.dy) * hd - pad,
    (a.dx - b.dx).abs() * hd + pad * 2,
    (a.dy - b.dy).abs() * hd + pad * 2,
    c,
  );
  for (final (pad, c) in const [
    (8.0, 0xFF7f6a3d),
    (7.0, 0xFFa88a58),
    (5.0, 0xFFb69866),
  ]) {
    for (var i = 1; i < pts.length; i++) {
      seg(pts[i - 1], pts[i], pad, c);
    }
  }
  for (var i = 1; i < pts.length; i++) {
    final a = pts[i - 1], b = pts[i];
    final n = (((a.dx - b.dx).abs() + (a.dy - b.dy).abs()) * 0.8).round();
    for (var k = 0; k < n; k++) {
      final t = rnd();
      final px = ((a.dx + (b.dx - a.dx) * t) * hd + (rnd() - 0.5) * 11).round();
      final py = ((a.dy + (b.dy - a.dy) * t) * hd + (rnd() - 0.5) * 11).round();
      g.fill(px, py, 2, 1, rnd() < 0.5 ? 0xFFcdb07c : 0xFF8b7045);
    }
  }
}

void _post(Raster g, num x, num y) => g
  ..fill(x - 2, y - 11, 5, 13, 0xFF3a2616)
  ..fill(x - 1, y - 10, 3, 11, 0xFF8a6038)
  ..fill(x - 1, y - 10, 3, 2, 0xFFb08250)
  ..fill(x - 2, y + 2, 6, 2, _shadow30);

void _hrail(Raster g, num xa, num xb, num y) => g
  ..fill(xa, y - 8, xb - xa, 2, 0xFF3a2616)
  ..fill(xa, y - 7, xb - xa, 1, 0xFFa37446)
  ..fill(xa, y - 4, xb - xa, 2, 0xFF3a2616)
  ..fill(xa, y - 3, xb - xa, 1, 0xFF8a6038);

void _vrail(Raster g, num x, num ya, num yb) => g
  ..fill(x - 1, ya, 3, yb - ya, 0xFF3a2616)
  ..fill(x, ya, 1, yb - ya, 0xFF8a6038);

/// A cerca do cercado, com portão no lado esquerdo na altura [gateAt].
void _fence(Raster g, ui.Rect f, double gateAt) {
  final x0 = f.left * hd,
      y0 = f.top * hd,
      x1 = f.right * hd,
      y1 = f.bottom * hd;
  const gw = 16.0 * hd;
  final gl = [gateAt * hd - gw / 2, gateAt * hd + gw / 2];
  _hrail(g, x0, x1, y0);
  _vrail(g, x0, y0, gl[0]);
  _vrail(g, x0, gl[1], y1);
  _vrail(g, x1, y0, y1);
  for (var x = x0; x <= x1; x += 20) {
    _post(g, math.min(x, x1), y0);
  }
  for (var y = y0 + 20; y < y1; y += 20) {
    if (y < gl[0] - 2 || y > gl[1] + 2) _post(g, x0, y);
    _post(g, x1, y);
  }
  _post(g, x0, gl[0]);
  _post(g, x0, gl[1]);
  _hrail(g, x0, x1, y1);
  for (var x = x0; x <= x1; x += 20) {
    _post(g, math.min(x, x1), y1);
  }
}

void _yard(Raster g, ui.Rect yr, double Function() rnd) {
  final x = yr.left * hd,
      y = yr.top * hd,
      w = yr.width * hd,
      hh = yr.height * hd;
  g
    ..fill(x - 2, y - 2, w + 4, hh + 4, rgba(90, 70, 30, .3))
    ..fill(x, y, w, hh, 0xFFb99a55);
  const straw = [0xFFd8bb6c, 0xFFa4843f, 0xFFc9a95c, 0xFFe6cc84];
  for (var i = 0; i < (w * hh) / 18; i++) {
    g.fill(
      (x + rnd() * (w - 3)).round(),
      (y + rnd() * (hh - 1)).round(),
      3,
      1,
      straw[i % 4],
    );
  }
  final gate = [
    (yr.center.dx * hd - 16).round(),
    (yr.center.dx * hd + 16).round(),
  ];
  void post(num px, num py) => g
    ..fill(px - 2, py - 9, 5, 12, 0xFF3a2616)
    ..fill(px - 1, py - 8, 3, 10, 0xFF8a6038)
    ..fill(px - 1, py - 8, 3, 2, 0xFFb08250);
  void rail(num xa, num xb, num py) => g
    ..fill(xa, py - 6, xb - xa, 2, 0xFF3a2616)
    ..fill(xa, py - 5, xb - xa, 1, 0xFFa37446)
    ..fill(xa, py - 2, xb - xa, 2, 0xFF3a2616);
  rail(x - 4, gate[0], y);
  rail(gate[1], x + w + 4, y);
  for (final px in [x - 4, x + w + 3]) {
    g
      ..fill(px - 1, y, 3, hh, 0xFF3a2616)
      ..fill(px, y, 1, hh, 0xFF8a6038);
  }
  rail(x - 4, x + w + 4, y + hh);
  for (var px = x - 4; px <= x + w + 4; px += 18) {
    if (px < gate[0] - 3 || px > gate[1] + 3) post(px, y);
    post(px, y + hh);
  }
  post(gate[0], y);
  post(gate[1], y);
  for (var py = y + 18; py < y + hh; py += 18) {
    post(x - 4, py);
    post(x + w + 3, py);
  }
}

void _pond(Raster g, FarmLayout l, double Function() rnd) {
  final cx = l.pondCx * hd, cy = l.pondCy * hd;
  final rx = l.pondRx * hd, ry = l.pondRy * hd;
  g
    ..ellipse(cx, cy + 2, rx + 7, ry + 6, 0xFF8e7a4c)
    ..ellipse(cx, cy + 1, rx + 5, ry + 4, 0xFFc8b27a)
    ..ellipse(cx, cy + 1, rx + 2, ry + 2, 0xFF3d5a22)
    ..ellipse(cx, cy, rx, ry, _w0)
    ..ellipse(cx, cy + 2, rx - 1, ry - 1, _w1)
    ..ellipse(cx - 6, cy - 3, rx - 14, ry - 8, _w2);
  for (var i = 0; i < 10; i++) {
    g.fill(
      (cx - rx * 0.6 + rnd() * rx * 1.2).round(),
      (cy - ry * 0.5 + rnd() * ry).round(),
      4 + (rnd() * 4).round(),
      1,
      _w3,
    );
  }
  for (final (dx, dy, s) in const [
    (-0.45, 0.2, 1.0),
    (0.35, -0.15, 0.8),
    (0.15, 0.45, 0.7),
  ]) {
    final px = cx + dx * rx, py = cy + dy * ry, r = 5 * s + 2;
    g
      ..ellipse(px, py, r + 1, r * 0.6 + 1, 0xFF1f4d1d)
      ..ellipse(px, py, r, r * 0.6, 0xFF4f9a3a)
      ..fill(px, py - 1, r.ceil(), 2, _w1)
      ..fill(px - r * 0.5, py - 2, 3, 1, 0xFF7cc35a);
  }
  g
    ..fill(cx - rx * 0.45 - 1, cy + ry * 0.2 - 4, 3, 3, 0xFFf59cc0)
    ..fill(cx - rx * 0.45, cy + ry * 0.2 - 3, 1, 1, 0xFFfff4c2);
  for (final s in const [-1, 1]) {
    for (var i = 0; i < 4; i++) {
      final rxp = (cx + s * (rx - 6 + i * 4)).round();
      final top = cy - 10 - i * 3 - (i % 2) * 3;
      g
        ..fill(rxp, top, 1, cy + 4 - top, i.isOdd ? 0xFF2f5a1f : 0xFF3f7a2a)
        ..fill(rxp - 1, top - 1, 3, 5, 0xFF6b4a2b)
        ..fill(rxp, top - 3, 1, 2, 0xFF3f7a2a);
    }
  }
}

void _sign(Raster g, ui.Offset s) {
  final x = s.dx * hd, y = s.dy * hd;
  g
    ..fill(x - 1, y + 6, 3, 18, 0xFF3a2616)
    ..fill(x, y + 6, 1, 18, 0xFF8a6038)
    ..fill(x - 3, y + 23, 8, 2, _shadow35)
    ..fill(x - 11, y - 2, 22, 11, 0xFF3a2616)
    ..fill(x - 10, y - 1, 20, 9, 0xFFc9964a)
    ..fill(x - 10, y - 1, 20, 2, 0xFFdcae62)
    // uma seta: para o cercado
    ..fill(x - 7, y + 3, 9, 2, 0xFF3a2616)
    ..fill(x + 2, y + 1, 1, 6, 0xFF3a2616)
    ..fill(x + 3, y + 2, 1, 4, 0xFF3a2616)
    ..fill(x + 4, y + 3, 1, 2, 0xFF3a2616);
}

void _decor(Raster g, FarmDecor d, double Function() rnd) {
  final x = (d.x * hd).round(), y = (d.y * hd).round();
  switch (d.kind) {
    case 'flowers':
      final n = 3 + (rnd() * 4).floor();
      for (var i = 0; i < n; i++) {
        final fx = x + ((rnd() - 0.5) * 16).round();
        final fy = y + ((rnd() - 0.5) * 8).round();
        final c = _flowerC[(d.c + i) % _flowerC.length];
        g
          ..fill(fx, fy, 1, 3, 0xFF3f7a2a)
          ..fill(fx - 1, fy - 2, 3, 1, c)
          ..fill(fx, fy - 3, 1, 3, c)
          ..fill(fx, fy - 2, 1, 1, 0xFFf5c542);
      }
    case 'bush':
      const blobs = [(-5, -4, 6), (5, -4, 6), (0, -8, 6), (0, -3, 7)];
      g.ellipse(x + 2, y + 1, 12, 4, _shadow30);
      for (final (dx, dy, r) in blobs) {
        g.circle(x + dx, y + dy, r + 1, t0);
      }
      for (final (dx, dy, r) in blobs) {
        g
          ..circle(x + dx, y + dy, r, _t2)
          ..circle(x + dx - 1, y + dy - 2, r * 0.55, _t3);
      }
      if (d.c.isOdd) {
        for (final (dx, dy) in const [(-6, -5), (3, -9), (6, -3), (-1, -2)]) {
          g
            ..fill(x + dx, y + dy, 2, 2, 0xFFd6334a)
            ..fill(x + dx, y + dy, 1, 1, 0xFFff8a9a);
        }
      }
    case 'pumpkin':
      for (final (dx, s) in const [(-5, 0.8), (4, 1.0)]) {
        final px = x + dx, r = 5 * s;
        g
          ..ellipse(px + 1, y + 1, r + 2, 2, _shadow30)
          ..ellipse(px, y - r * 0.8, r + 2, r * 0.8 + 1, 0xFF6b2f10)
          ..ellipse(px, y - r * 0.8, r + 1, r * 0.8, 0xFFe07b24)
          ..fill(px - 1, y - r * 1.6, 2, r * 1.6 - 1, 0xFFc4631a)
          ..fill(px - r * 0.6, y - r * 1.2, 2, 3, 0xFFf5a04a)
          ..fill(px - 1, y - r * 1.6 - 3, 2, 3, 0xFF4f6b25);
      }
    case 'log':
      g
        ..ellipse(x + 1, y + 1, 13, 3, _shadow30)
        ..fill(x - 12, y - 8, 22, 9, 0xFF3a2616)
        ..fill(x - 11, y - 7, 20, 7, 0xFF7a5433)
        ..fill(x - 11, y - 7, 20, 2, 0xFF9a6d45)
        ..ellipse(x + 10, y - 4, 3, 4, 0xFF3a2616)
        ..ellipse(x + 10, y - 4, 2, 3, 0xFFd8b27a)
        ..fill(x + 10, y - 4, 1, 1, 0xFF9a6d45);
    case 'mushrooms':
      for (final (dx, s) in const [(-3, 1.0), (3, 0.7), (0, 0.55)]) {
        final px = x + dx, r = 3 * s + 1;
        g
          ..fill(px - 1, y - 4 * s, 2, 4 * s, 0xFFf4ecd8)
          ..ellipse(px, y - 4 * s - 1, r + 1, r * 0.7 + 1, 0xFF5c130e)
          ..ellipse(px, y - 4 * s - 1, r, r * 0.7, 0xFFd6334a)
          ..fill(px - 1, y - 4 * s - 2, 1, 1, 0xFFffffff)
          ..fill(px + 1, y - 4 * s - 1, 1, 1, 0xFFffffff);
      }
  }
}
