part of 'farm_world.dart';

// ------------------------------------------------- móveis do escritório
// Coordenadas: as funções com `x, y` em pixels de mundo dizem isso; as
// demais recebem o pé do móvel já na grade HD (`X, Y`).

const _books = [
  0xFFd94b3c,
  0xFF4f86d9,
  0xFFf2b43a,
  0xFF6fbf5a,
  0xFF8a63c9,
  0xFFe57fb0,
  0xFF3fa7a0,
];
const _poufC = [
  0xFFe0533f,
  0xFFf2b43a,
  0xFF6fbf5a,
  0xFF4f86d9,
  0xFFe57fb0,
  0xFF3fa7a0,
];

void _officeDecor(Raster g, FarmDecor d) {
  final x = (d.x * hd).round(), y = (d.y * hd).round();
  switch (d.kind) {
    case 'plant':
      _plant(g, x, y, d.c, white: d.c.isEven);
    case 'shelf':
      _shelf(g, x, y, d.c);
    case 'pouf':
      _pouf(g, x, y - 4, _poufC[d.c % _poufC.length]);
    case 'lamp':
      _lamp(g, x, y);
    case 'bin':
      g
        ..ellipse(x + 1, y, 5, 2, _oShadow)
        ..fill(x - 4, y - 9, 8, 9, 0xFF5f6773)
        ..fill(x - 3, y - 9, 6, 8, 0xFF8a929e)
        ..fill(x - 3, y - 9, 2, 8, 0xFFa3abb6)
        ..fill(x - 4, y - 10, 8, 2, 0xFF5f6773)
        ..fill(x - 3, y - 10, 6, 1, 0xFF3a404c);
    case 'cooler':
      g
        ..ellipse(x + 1, y, 7, 2, _oShadow)
        ..fill(x - 5, y - 12, 10, 12, 0xFF7d8592)
        ..fill(x - 4, y - 12, 8, 11, 0xFFf2f4f6)
        ..fill(x - 2, y - 8, 1, 2, 0xFF4f86d9)
        ..fill(x + 1, y - 8, 1, 2, 0xFFd94b3c)
        ..ellipse(x, y - 17, 5, 6, 0xFF4f86b8)
        ..ellipse(x, y - 17, 4, 5, 0xFF8fcbef)
        ..fill(x - 2, y - 21, 1, 5, 0xFFd8f0fb);
    case 'sofa':
      _sofa(g, x, y, _poufC[(d.c + 3) % _poufC.length]);
  }
}

/// Vaso: folhas redondas ([c] par) ou folhas compridas para cima.
void _plant(Raster g, num x, num y, int c, {bool white = false}) {
  final pot = white ? 0xFFf2f1ec : 0xFFc8693e;
  final potS = white ? 0xFFcfd0cb : 0xFF9c4c2a;
  g
    ..ellipse(x + 1, y, 8, 2, _oShadow)
    ..fill(x - 6, y - 10, 12, 10, 0xFF5c4636)
    ..fill(x - 5, y - 9, 10, 9, pot)
    ..fill(x + 2, y - 9, 3, 9, potS)
    ..fill(x - 6, y - 11, 12, 3, 0xFF5c4636)
    ..fill(x - 5, y - 11, 10, 2, white ? 0xFFffffff : 0xFFdd8458);
  if (c.isEven) {
    const blobs = [(-6, -16, 6), (6, -16, 6), (0, -21, 7), (0, -14, 6)];
    for (final (dx, dy, r) in blobs) {
      g.circle(x + dx, y + dy, r + 1, t0);
    }
    for (final (dx, dy, r) in blobs) {
      g
        ..circle(x + dx, y + dy, r, _t2)
        ..circle(x + dx - 1, y + dy - 2, r * 0.55, _t3);
    }
    g
      ..fill(x - 3, y - 25, 2, 1, _t4)
      ..fill(x + 4, y - 19, 2, 1, _t4);
  } else {
    // espada-de-são-jorge: folhas em pé, contornadas
    for (final (dx, top) in const [(-5, 22), (-2, 28), (1, 25), (4, 20)]) {
      g
        ..fill(x + dx - 1, y - 9 - top, 4, top, t0)
        ..fill(x + dx, y - 8 - top, 2, top - 1, _t3)
        ..fill(x + dx, y - 8 - top, 1, top - 1, _t4)
        ..fill(x + dx + 1, y - 18, 1, 6, 0xFFb9d46a);
    }
  }
}

/// Estante branca com livros coloridos (3 prateleiras).
void _shelf(Raster g, num x, num y, int c) {
  const w = 22, h = 26;
  final x0 = x - w ~/ 2, y0 = y - h;
  g
    ..fill(x0 + 2, y, w, 2, _oShadow)
    ..fill(x0, y0, w, h, 0xFF7d8592)
    ..fill(x0 + 1, y0 + 1, w - 2, h - 2, 0xFFf2f0ea)
    ..fill(x0 + 1, y0 + 1, w - 2, 2, 0xFFffffff);
  for (var row = 0; row < 3; row++) {
    final ry = y0 + 4 + row * 7;
    g.fill(x0 + 2, ry, w - 4, 6, 0xFF9a8d7a);
    var bx = x0 + 2;
    var k = c + row * 3;
    while (bx < x0 + w - 3) {
      final bw = 2 + (k % 2);
      final bh = 4 + (k * 7) % 3;
      if ((k * 5) % 7 != 0) {
        g
          ..fill(bx, ry + 6 - bh, bw, bh, _books[k % _books.length])
          ..fill(bx, ry + 6 - bh, 1, bh, 0x33FFFFFF);
      }
      bx += bw;
      k++;
    }
    g.fill(x0 + 1, ry + 6, w - 2, 1, 0xFFd8d4cb);
  }
}

/// Pufe redondo, visto de cima, centrado em (x, y) na grade HD.
void _pouf(Raster g, num x, num y, int c) => g
  ..ellipse(x + 2, y + 6, 10, 3, _oShadow)
  ..ellipse(x, y, 11, 8, shade(c, -0.32))
  ..ellipse(x, y, 10, 7, c)
  ..ellipse(x - 2, y - 2, 6, 3, shade(c, 0.1))
  ..fill(x - 4, y - 4, 3, 1, shade(c, 0.22));

/// Luminária de chão: base, haste e cúpula com luz quente.
void _lamp(Raster g, num x, num y) => g
  ..ellipse(x + 1, y, 6, 2, _oShadow)
  ..ellipse(x, y - 1, 4, 1, 0xFF3a404c)
  ..fill(x - 1, y - 26, 2, 25, 0xFF4b5261)
  ..ellipse(x, y - 30, 12, 7, rgba(255, 220, 140, .18))
  ..fill(x - 6, y - 34, 12, 8, 0xFF8d7f66)
  ..fill(x - 5, y - 34, 10, 7, 0xFFf3ead8)
  ..fill(x - 5, y - 34, 10, 2, 0xFFfffaf0)
  ..fill(x - 4, y - 27, 8, 1, 0xFFffe29a);

/// Sofá de dois lugares encostado na parede.
void _sofa(Raster g, int x, int y, int c) {
  final d = shade(c, -0.3), l = shade(c, 0.12);
  g
    ..fill(x - 15, y, 32, 3, _oShadow)
    ..fill(x - 16, y - 18, 32, 18, d)
    ..fill(x - 15, y - 17, 30, 7, c)
    ..fill(x - 15, y - 17, 30, 2, l)
    ..fill(x - 15, y - 9, 4, 8, c)
    ..fill(x + 11, y - 9, 4, 8, c)
    ..fill(x - 11, y - 10, 11, 8, l)
    ..fill(x, y - 10, 11, 8, l)
    ..fill(x - 1, y - 10, 1, 8, d);
}

/// Cadeira de escritório azul vista de cima, centrada em (x, y) no mundo;
/// [up] = encosto em cima (a pessoa olha para baixo).
void _chair(Raster g, num x, num y, {required bool up}) {
  final cx = (x * hd).round(), cy = (y * hd).round();
  g
    ..fill(cx - 4, cy + 4, 10, 2, _oShadow)
    ..fill(cx - 5, cy - 4, 10, 9, 0xFF263f73)
    ..fill(cx - 4, cy - 3, 8, 7, 0xFF5079c4)
    ..fill(cx - 3, cy - 2, 4, 2, 0xFF6d93d8);
  final by = up ? cy - 6 : cy + 3;
  g
    ..fill(cx - 5, by, 10, 4, 0xFF263f73)
    ..fill(cx - 4, by + 1, 8, 2, 0xFF3b5fa8);
}

/// Janela na face da parede de cima (x, y = canto, no mundo).
void _window(Raster g, num x, num y) {
  final wx = x * hd, wy = y * hd;
  g
    ..fill(wx, wy, 36, 12, 0xFF7d8592)
    ..fill(wx + 1, wy + 1, 34, 10, 0xFFf2f4f6)
    ..fill(wx + 2, wy + 2, 15, 8, 0xFF9fd0ee)
    ..fill(wx + 19, wy + 2, 15, 8, 0xFF9fd0ee)
    ..fill(wx + 4, wy + 3, 2, 1, 0xFFe6f5fd)
    ..fill(wx + 3, wy + 4, 2, 1, 0xFFe6f5fd)
    ..fill(wx + 21, wy + 3, 2, 1, 0xFFe6f5fd)
    ..fill(wx + 2, wy + 7, 15, 3, 0xFF7fbde3)
    ..fill(wx + 19, wy + 7, 15, 3, 0xFF7fbde3);
}

/// Relógio de parede (x, y = centro, no mundo).
void _clock(Raster g, num x, num y) {
  final cx = x * hd, cy = y * hd;
  g
    ..circle(cx, cy, 5, 0xFF3a404c)
    ..circle(cx, cy, 4, 0xFFffffff)
    ..fill(cx, cy - 3, 1, 3, 0xFF3a404c)
    ..fill(cx, cy, 3, 1, 0xFFd94b3c);
}

// ------------------------------------------------- a rua em volta do prédio

const _walk0 = 0xFFc9cbcf, _walk1 = 0xFFbcbfc4, _asph0 = 0xFF4a4d55;
const _asph1 = 0xFF53565e, _asph2 = 0xFF42454c;

/// O entorno urbano: calçada de placas em volta do prédio, floreiras na
/// frente da parede de cima, e embaixo meio-fio, rua com faixa tracejada e
/// postes. Pintado antes do prédio (que cobre o miolo).
void _street(Raster g, FarmLayout l, double Function() rnd) {
  final w = l.w * hd, h = l.h * hd, p = l.play;
  g.fill(0, 0, w, h, _walk0);
  for (var y = 0; y < h; y += 20) {
    g.fill(0, y, w, 1, _walk1);
  }
  for (var x = 0; x < w; x += 20) {
    g.fill(x, 0, 1, h, _walk1);
  }
  // rua: do meio-fio até o fim do mundo embaixo
  final curb = (p.bottom + 12) * hd;
  g
    ..fill(0, curb, w, h - curb, _asph0)
    ..fill(0, curb, w, 2, 0xFFe6e7ea)
    ..fill(0, curb + 2, w, 2, 0xFF8d9097);
  for (var i = 0; i < (w * (h - curb)) / 14; i++) {
    g.fill(
      (rnd() * w).round(),
      (curb + 4 + rnd() * (h - curb - 4)).round(),
      1,
      1,
      rnd() < 0.5 ? _asph1 : _asph2,
    );
  }
  final mid = ((curb + 4 + h) / 2).round();
  if (h - curb > 16) {
    for (var x = 4; x < w; x += 24) {
      g.fill(x, mid - 1, 12, 2, 0xFFe8d27a);
    }
  }
  // sombra do prédio na calçada (direita e embaixo)
  g
    ..fill(
      (p.right + 2) * hd,
      (p.top - 7) * hd,
      4,
      (p.height + 9) * hd,
      _oShadow,
    )
    ..fill(
      (p.left - 1) * hd,
      (p.bottom + 2) * hd - 2,
      (p.width + 3) * hd,
      4,
      _oShadow,
    );
  // postes na calçada de baixo, floreiras na de cima
  for (var x = p.left + 24; x < p.right - 8; x += 56) {
    _streetLamp(g, x * hd, (p.bottom + 11) * hd);
  }
  final top = (p.top - 10) * hd;
  if (top > 14) {
    for (var x = p.left + 10; x < p.right - 20; x += 44) {
      _planter(g, x * hd, top - 2);
    }
  }
}

/// Poste de rua: base, haste e luminária com um halo quente no chão.
void _streetLamp(Raster g, num x, num y) => g
  ..ellipse(x + 2, y, 5, 2, _oShadow)
  ..fill(x - 2, y - 3, 4, 3, 0xFF3a404c)
  ..fill(x - 1, y - 30, 2, 28, 0xFF4b5261)
  ..fill(x - 1, y - 31, 9, 2, 0xFF4b5261)
  ..fill(x + 5, y - 30, 6, 3, 0xFF3a404c)
  ..fill(x + 6, y - 28, 4, 1, 0xFFffe29a);

/// Floreira de calçada: caixa de concreto com arbusto.
void _planter(Raster g, num x, num y) {
  g
    ..fill(x + 2, y, 24, 2, _oShadow)
    ..fill(x, y - 7, 24, 7, 0xFF8d9097)
    ..fill(x + 1, y - 6, 22, 5, 0xFFa9acb2)
    ..fill(x + 1, y - 7, 22, 1, 0xFFd5d7db);
  for (final (dx, r) in const [(5, 5), (12, 6), (19, 5)]) {
    g.circle(x + dx, y - 9, r + 1, t0);
  }
  for (final (dx, r) in const [(5, 5), (12, 6), (19, 5)]) {
    g
      ..circle(x + dx, y - 9, r, _t2)
      ..circle(x + dx - 1, y - 11, r * 0.5, _t3);
  }
}

/// Porta de vidro na parede de baixo (a entrada pela calçada).
void _entrance(Raster g, num x, num y) {
  final dx = x * hd, dy = y * hd;
  g
    ..fill(dx - 18, dy - 1, 36, 6, 0xFF7d8592)
    ..fill(dx - 16, dy, 15, 4, 0xFF9fd0ee)
    ..fill(dx + 1, dy, 15, 4, 0xFF9fd0ee)
    ..fill(dx - 14, dy + 1, 3, 1, 0xFFe6f5fd)
    ..fill(dx + 3, dy + 1, 3, 1, 0xFFe6f5fd)
    ..fill(dx - 12, dy + 6, 24, 4, 0xFF8a6a4a);
}
