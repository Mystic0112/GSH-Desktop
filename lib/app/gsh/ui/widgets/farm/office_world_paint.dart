part of 'farm_world.dart';

// ------------------------------------------------- o escritório (cenário 2)

/// O mesmo [FarmLayout] da fazenda, pintado como um escritório visto de cima
/// (inspirado no habblaud, MIT; arte refeita aqui pixel a pixel): o campo
/// vira o prédio, o cercado vira a ala das salas de projeto (um canteiro =
/// uma ilha de mesas), o curral vira o lounge de pufes, o celeiro a copa, o
/// lago uma mesa de reunião e os caminhos um corredor acarpetado.

// Paleta do escritório.
const _fl0 = 0xFFebe4d6, _fl1 = 0xFFe5ddcd, _flLine = 0xFFd8cfbd;
const _cp0 = 0xFFd5dae0, _cp1 = 0xFFcbd1d9, _cp2 = 0xFFdfe3e8;
const _rug0 = 0xFFbfc9d4, _rugE = 0xFFa9b5c3;
const _wl0 = 0xFF3a404c, _wl1 = 0xFF5d6575;
const _face = 0xFFd3cbba, _face2 = 0xFFc6bda9, _base = 0xFFa99f89;
const _wd0 = 0xFFc99c66, _wd1 = 0xFFb88a55, _wd2 = 0xFFa47646;
const _wdE = 0xFF6e4a2a;
final _oShadow = rgba(40, 36, 30, .18);

/// Pinta o miolo do escritório e devolve os obstáculos (pedras: nenhuma;
/// decoração: plantas, estantes, pufes...), dos quais os bichos desviam.
(List<ui.Rect>, List<FarmDecor>) _officeProps(
  Raster g,
  FarmLayout l,
  double Function() rnd,
) {
  final p = l.play, c = l.content;
  _building(g, p, rnd);
  for (final pts in l.paths) {
    _runner(g, pts);
  }
  _meeting(g, l);
  // móveis soltos no salão, longe do miolo, do corredor e da porta da copa
  bool clear(double x, double y, double pad) =>
      !l.blocked(x, y) &&
      !l.onPath(x, y, pad) &&
      (ui.Offset(x, y) - l.door).distance > 30 &&
      !(x > c.left - 4 && x < c.right + 4 && y > c.top - 4 && y < c.bottom + 6);
  const kinds = [
    ('plant', 0.36, 6.0),
    ('shelf', 0.18, 7.0),
    ('pouf', 0.14, 5.0),
    ('lamp', 0.12, 3.0),
    ('bin', 0.08, 3.0),
    ('cooler', 0.06, 4.0),
    ('sofa', 0.06, 10.0),
  ];
  final decor = <FarmDecor>[];
  l.decor = decor;
  final want = ((l.w * l.h) / 4200).round().clamp(6, 40);
  for (var tries = 0; decor.length < want && tries < 900; tries++) {
    final x = p.left + 10 + rnd() * (p.width - 20);
    var y = p.top + 12 + rnd() * (p.height - 16);
    var pr = rnd();
    var kind = kinds.first;
    for (final k in kinds) {
      if (pr < k.$2) {
        kind = k;
        break;
      }
      pr -= k.$2;
    }
    // estante e sofá encostam na parede de cima
    if (kind.$1 == 'shelf' || kind.$1 == 'sofa') y = p.top + 13;
    if (!clear(x, y, 9) ||
        decor.any(
          (o) => (ui.Offset(o.x, o.y) - ui.Offset(x, y)).distance < 26,
        )) {
      continue;
    }
    decor.add(FarmDecor(kind.$1, x, y, kind.$3, (rnd() * 6).floor()));
  }
  for (final d in [...decor]..sort((a, b) => a.y.compareTo(b.y))) {
    _officeDecor(g, d);
  }
  _lounge(g, l);
  _wing(g, l);
  _copa(g, l.barn);
  // na placa da fazenda, um vaso grande ao lado da porta da ala
  _officeDecor(g, FarmDecor('plant', l.sign.dx, l.sign.dy + 13, 6, 1));
  return (const <ui.Rect>[], decor);
}

/// Parede horizontal em pixels de mundo: o topo escuro e, embaixo, a face
/// clara de [face] px com rodapé.
void _wallH(Raster g, num x0, num x1, num y, [num face = 2]) {
  final ax = x0 * hd, w = (x1 - x0) * hd, ay = y * hd;
  if (face > 0) {
    g
      ..fill(ax, ay, w, face * hd, _face)
      ..fill(ax, ay + face * hd - 2, w, 1, _face2)
      ..fill(ax, ay + face * hd - 1, w, 1, _base)
      ..fill(ax, ay + face * hd, w, 2, _oShadow);
  }
  g
    ..fill(ax, ay - 3, w, 3, _wl0)
    ..fill(ax, ay - 3, w, 1, _wl1);
}

/// Parede vertical (só o topo escuro aparece de cima).
void _wallV(Raster g, num x, num y0, num y1) => g
  ..fill(x * hd - 1, y0 * hd - 3, 3, (y1 - y0) * hd + 3, _wl0)
  ..fill(x * hd - 1, y0 * hd - 3, 1, (y1 - y0) * hd + 3, _wl1)
  ..fill(x * hd + 2, y0 * hd, 2, (y1 - y0) * hd, _oShadow);

/// O prédio: piso de lajotas claras, a parede de cima com janelas e as
/// paredes da volta.
void _building(Raster g, ui.Rect p, double Function() rnd) {
  const tile = 12;
  for (var ty = p.top; ty < p.bottom; ty += tile) {
    for (var tx = p.left; tx < p.right; tx += tile) {
      final k = ((tx - p.left) ~/ tile + (ty - p.top) ~/ tile).isEven;
      final tw = math.min(tile.toDouble(), p.right - tx);
      final th = math.min(tile.toDouble(), p.bottom - ty);
      g
        ..fill(tx * hd, ty * hd, tw * hd, th * hd, k ? _fl0 : _fl1)
        ..fill(tx * hd, ty * hd, tw * hd, 1, _flLine)
        ..fill(tx * hd, ty * hd, 1, th * hd, _flLine);
    }
  }
  for (var i = 0; i < p.width * p.height / 30; i++) {
    g.fill(
      ((p.left + rnd() * p.width) * hd).round(),
      ((p.top + rnd() * p.height) * hd).round(),
      1,
      1,
      _flLine,
    );
  }
  // parede de cima com face alta, janelas e um relógio
  const faceH = 9.0;
  _wallH(g, p.left - 2, p.right + 2, p.top - faceH, faceH);
  for (var wx = p.left + 18; wx < p.right - 30; wx += 52) {
    _window(g, wx, p.top - faceH + 1.5);
  }
  _clock(g, p.right - 14, p.top - faceH / 2);
  _wallV(g, p.left - 1, p.top - faceH, p.bottom + 1);
  _wallV(g, p.right + 1, p.top - faceH, p.bottom + 1);
  g
    ..fill((p.left - 2) * hd, p.bottom * hd, (p.width + 4) * hd, 4, _wl0)
    ..fill((p.left - 2) * hd, p.bottom * hd, (p.width + 4) * hd, 1, _wl1);
}

/// Corredor: uma passadeira cinza-azulada sobre o piso.
void _runner(Raster g, List<ui.Offset> pts) {
  void seg(ui.Offset a, ui.Offset b, double pad, int c) => g.fill(
    math.min(a.dx, b.dx) * hd - pad,
    math.min(a.dy, b.dy) * hd - pad,
    (a.dx - b.dx).abs() * hd + pad * 2,
    (a.dy - b.dy).abs() * hd + pad * 2,
    c,
  );
  for (final (pad, c) in const [
    (7.0, 0xFF9aa8b8),
    (6.0, 0xFFb4c0cd),
    (4.0, 0xFFbecad6),
  ]) {
    for (var i = 1; i < pts.length; i++) {
      seg(pts[i - 1], pts[i], pad, c);
    }
  }
}

/// No lugar do lago: tapete azul com a mesa de reunião e cadeiras.
void _meeting(Raster g, FarmLayout l) {
  final cx = l.pondCx, cy = l.pondCy, rx = l.pondRx, ry = l.pondRy;
  final rug = ui.Rect.fromLTRB(
    cx - rx - 6,
    cy - ry - 4,
    cx + rx + 6,
    cy + ry + 6,
  );
  _rug(g, rug, 0xFF5d7fae, 0xFF4a6894, 0xFF7f9dc6);
  final tl = cx - rx + 5, tr = cx + rx - 5;
  // cadeiras em cima e embaixo da mesa
  for (var x = tl + 4; x <= tr - 3; x += 9) {
    _chair(g, x, cy - ry + 1, up: true);
    _chair(g, x, cy + ry + 2, up: false);
  }
  final t = ui.Rect.fromLTRB(tl, cy - ry + 3, tr, cy + ry - 1);
  g
    ..fill(t.left * hd + 2, t.bottom * hd, t.width * hd, 3, _oShadow)
    ..fill(t.left * hd + 2, t.top * hd, t.width * hd - 4, t.height * hd, _wdE)
    ..fill(t.left * hd, t.top * hd + 2, t.width * hd, t.height * hd - 4, _wdE)
    ..fill(
      t.left * hd + 2,
      t.top * hd + 1,
      t.width * hd - 4,
      t.height * hd - 4,
      _wd0,
    )
    ..fill(
      t.left * hd + 1,
      t.top * hd + 3,
      t.width * hd - 2,
      t.height * hd - 7,
      _wd0,
    )
    ..fill(t.left * hd + 2, t.bottom * hd - 4, t.width * hd - 4, 3, _wd2)
    ..fill(t.left * hd + 4, t.top * hd + 2, t.width * hd - 8, 1, 0xFFdcb27c);
  // papéis e um notebook em cima
  final mx = cx * hd;
  g
    ..fill(mx - 14, cy * hd - 6, 7, 5, 0xFFf7f5ee)
    ..fill(mx - 13, cy * hd - 5, 4, 1, 0xFFb9bec6)
    ..fill(mx + 6, cy * hd - 7, 9, 6, 0xFF2f3542)
    ..fill(mx + 7, cy * hd - 6, 7, 3, 0xFF6fa8dc);
}

/// Tapete retangular com borda e um filete interno.
void _rug(Raster g, ui.Rect r, int fill, int edge, int line) {
  final x = r.left * hd, y = r.top * hd, w = r.width * hd, h = r.height * hd;
  g
    ..fill(x + 2, y + h, w, 2, _oShadow)
    ..fill(x, y, w, h, edge)
    ..fill(x + 1, y + 1, w - 2, h - 2, fill)
    ..fill(x + 4, y + 4, w - 8, 1, line)
    ..fill(x + 4, y + h - 5, w - 8, 1, line)
    ..fill(x + 4, y + 4, 1, h - 8, line)
    ..fill(x + w - 5, y + 4, 1, h - 8, line);
}

/// No lugar do curral: o lounge de piso de madeira, tapete verde e um pufe
/// em cada vaga de quem dorme.
void _lounge(Raster g, FarmLayout l) {
  final y = l.yard;
  for (var py = y.top, i = 0; py < y.bottom; py += 3, i++) {
    final h = math.min(3.0, y.bottom - py);
    g
      ..fill(y.left * hd, py * hd, y.width * hd, h * hd, i.isOdd ? _wd0 : _wd1)
      ..fill(y.left * hd, py * hd, y.width * hd, 1, _wd2);
    for (var px = y.left + (i * 13) % 23; px < y.right; px += 23) {
      g.fill(px * hd, py * hd, 1, h * hd, _wd2);
    }
  }
  _rug(
    g,
    ui.Rect.fromLTRB(y.left + 3, y.top + 6, y.right - 3, y.bottom - 2),
    0xFF6aa06d,
    0xFF4d7f53,
    0xFF8cc08a,
  );
  const colors = [0xFFe0533f, 0xFFf2b43a, 0xFF4f86d9, 0xFF6fbf5a, 0xFFe57fb0];
  final cap = l.yardCols * ((y.height - 10) / 17).round();
  for (var i = 0; i < cap; i++) {
    final s = l.yardSpot(i);
    _pouf(g, s.dx * hd, (s.dy - 2) * hd, colors[i % colors.length]);
  }
  // paredes com a porta no meio de cima e um vaso no canto de fora
  final gx0 = y.center.dx - 8, gx1 = y.center.dx + 8;
  _wallH(g, y.left - 2, gx0, y.top);
  _wallH(g, gx1, y.right + 2, y.top);
  _wallV(g, y.left - 2, y.top, y.bottom);
  _wallV(g, y.right + 2, y.top, y.bottom);
  _wallH(g, y.left - 2, y.right + 2, y.bottom, 0);
  _plant(g, (y.right + 7) * hd, (y.bottom - 1) * hd, 0, white: true);
}

/// No lugar do cercado: a ala das salas de projeto, de carpete, com a porta
/// à esquerda e uma ilha de mesas por canteiro.
void _wing(Raster g, FarmLayout l) {
  final f = l.field;
  g.fill(f.left * hd, f.top * hd, f.width * hd, f.height * hd, _cp0);
  for (var i = 0; i < f.width * f.height / 6; i++) {
    final x = f.left + ((i * 7919) % 1000) / 1000 * f.width;
    final y = f.top + ((i * 104729) % 997) / 997 * f.height;
    g.fill((x * hd).round(), (y * hd).round(), 1, 1, i.isOdd ? _cp1 : _cp2);
  }
  for (var i = 0; i < l.plots.length; i++) {
    _island(g, l.plots[i], i);
  }
  // estante no canto de cima do corredor da impressora, vasos nos cantos
  if (l.gateAt - f.top > 32) _shelf(g, (f.left + 9) * hd, (f.top + 14) * hd, 2);
  _plant(g, (f.right - 7) * hd, (f.top + 11) * hd, 3);
  _plant(g, (f.right - 7) * hd, (f.bottom - 2) * hd, 4, white: true);
  final g0 = l.gateAt - 8, g1 = l.gateAt + 8;
  _wallH(g, f.left - 1, f.right + 1, f.top, 3);
  _wallV(g, f.left, f.top, g0);
  _wallV(g, f.left, g1, f.bottom);
  _wallV(g, f.right, f.top, f.bottom);
  _wallH(g, f.left - 1, f.right + 1, f.bottom, 0);
  // batentes da porta
  for (final y in [g0, g1]) {
    g.fill(f.left * hd - 2, y * hd - 1, 5, 2, 0xFFe9edf2);
  }
}

/// Uma ilha: tapete da sala, cadeiras azuis onde sentam os minis (em cima e
/// embaixo) e duas fileiras de mesas brancas. Os
/// monitores (que acendem com o trabalho) são do painter.
void _island(Raster g, ui.Rect p, int i) {
  _rug(
    g,
    ui.Rect.fromLTRB(p.left - 13, p.top - 12, p.right + 11, p.bottom + 10),
    _rug0,
    _rugE,
    0xFFcdd5de,
  );
  for (var k = 0; k < 3; k++) {
    _chair(g, p.left + 5 + k * 10, p.top - 5, up: true);
    _chair(g, p.left + 5 + k * 10, p.bottom + 5, up: false);
  }
  final x = p.left * hd, w = p.width * hd;
  g.fill(x + 2, (p.bottom) * hd, w, 3, _oShadow);
  for (var row = 0; row < 2; row++) {
    final y = (p.top + row * 8) * hd;
    g
      ..fill(x - 1, y - 1, w + 2, 18, 0xFF8f97a3)
      ..fill(x, y, w, 12, 0xFFf7f7f4)
      ..fill(x, y, w, 1, 0xFFffffff)
      ..fill(x, y + 12, w, 4, 0xFFdde1e6)
      ..fill(x, y + 15, w, 1, 0xFFb5bcc6);
    for (var k = 0; k < 3; k++) {
      final dx = x + k * 20;
      if (k > 0) g.fill(dx, y, 1, 16, 0xFFc9ced6);
      // teclado e mouse
      g
        ..fill(dx + 5, y + 9, 9, 2, 0xFFc3c9d2)
        ..fill(dx + 6, y + 9, 7, 1, 0xFFdfe3e8)
        ..fill(dx + 16, y + 9, 2, 2, 0xFF9aa3b2);
    }
    // uma caneca ou papéis em mesas sorteadas pela posição
    final pick = (i * 3 + row * 5) % 4;
    final px = x + pick.clamp(0, 2) * 20 + 15;
    if (pick == 0) {
      g
        ..fill(px, y + 2, 3, 3, 0xFFd94b3c)
        ..fill(px, y + 2, 3, 1, 0xFF6b2018);
    } else if (pick == 3) {
      g
        ..fill(px - 1, y + 2, 5, 4, 0xFFf7f5ee)
        ..fill(px - 1, y + 2, 5, 4, 0xFFdfe3e8)
        ..fill(px, y + 3, 3, 1, 0xFF9aa3b2);
    }
  }
}

/// No lugar do celeiro: a copa, com piso xadrez, bancada, geladeira e uma
/// mesinha. A porta fica embaixo no meio (onde os bichos chegam).
void _copa(Raster g, ui.Rect b) {
  const faceH = 8.0;
  g.ellipse(
    (b.center.dx + 3) * hd,
    (b.bottom + 1) * hd,
    b.width * hd / 2 + 8,
    6,
    _oShadow,
  );
  for (var ty = b.top; ty < b.bottom; ty += 4) {
    for (var tx = b.left; tx < b.right; tx += 4) {
      final k = ((tx - b.left) ~/ 4 + (ty - b.top) ~/ 4).isEven;
      g.fill(tx * hd, ty * hd, 8, 8, k ? 0xFFeef3f8 : 0xFFc9d7e6);
    }
  }
  _wallH(g, b.left - 1, b.right + 1, b.top, faceH);
  _clock(g, b.left + 9, b.top + 4);
  // bancada com pia e cafeteira
  final cy = (b.top + faceH) * hd, cx0 = (b.left + 1) * hd;
  final cw = (b.width - 14) * hd;
  g
    ..fill(cx0, cy, cw, 14, _wdE)
    ..fill(cx0, cy, cw, 6, 0xFFe9e4da)
    ..fill(cx0, cy + 6, cw, 7, _wd1)
    ..fill(cx0, cy + 6, cw, 1, _wd2);
  for (var x = cx0 + 10; x < cx0 + cw; x += 12) {
    g
      ..fill(x, cy + 7, 1, 6, _wd2)
      ..fill(x - 3, cy + 9, 2, 1, 0xFF6e4a2a);
  }
  g
    ..fill(cx0 + 14, cy + 1, 12, 4, 0xFFa5adb8)
    ..fill(cx0 + 15, cy + 2, 10, 2, 0xFF7f8894)
    ..fill(cx0 + 19, cy - 2, 2, 3, 0xFF8f97a3)
    ..fill(cx0 + 36, cy - 6, 9, 10, 0xFF2b2f3a)
    ..fill(cx0 + 37, cy - 5, 7, 3, 0xFF4a505d)
    ..fill(cx0 + 42, cy - 1, 2, 1, 0xFFe0533f)
    ..fill(cx0 + 39, cy + 1, 3, 3, 0xFFf7f5ee)
    ..fill(cx0 + 52, cy - 3, 8, 6, 0xFFe9e4da)
    ..fill(cx0 + 53, cy - 2, 6, 3, 0xFF3a404c);
  // geladeira no canto direito
  final fx = (b.right - 12) * hd, fy = (b.top + 2) * hd;
  g
    ..fill(fx + 2, fy + 38, 22, 3, _oShadow)
    ..fill(fx, fy, 22, 38, 0xFF7d8592)
    ..fill(fx + 1, fy + 1, 20, 36, 0xFFf2f4f6)
    ..fill(fx + 1, fy + 1, 20, 3, 0xFFffffff)
    ..fill(fx + 1, fy + 14, 20, 1, 0xFFb9bec6)
    ..fill(fx + 3, fy + 7, 1, 5, 0xFF9aa3b2)
    ..fill(fx + 3, fy + 18, 1, 8, 0xFF9aa3b2)
    ..fill(fx + 18, fy + 1, 3, 36, 0xFFd8dde3);
  // mesinha redonda com dois banquinhos
  final tx = (b.left + 14) * hd, ty = (b.top + 31) * hd;
  g
    ..ellipse(tx - 12, ty, 4, 3, _wdE)
    ..ellipse(tx - 12, ty - 1, 3, 2, _wd0)
    ..ellipse(tx + 12, ty, 4, 3, _wdE)
    ..ellipse(tx + 12, ty - 1, 3, 2, _wd0)
    ..ellipse(tx + 1, ty + 3, 9, 4, _oShadow)
    ..ellipse(tx, ty, 9, 6, 0xFF8f97a3)
    ..ellipse(tx, ty - 1, 8, 5, 0xFFf7f7f4)
    ..fill(tx - 3, ty - 3, 3, 3, 0xFFd94b3c);
  _plant(g, (b.right - 5) * hd, (b.bottom - 2) * hd, 2);
  final d0 = b.center.dx - 9, d1 = b.center.dx + 9;
  _wallV(g, b.left - 1, b.top, b.bottom);
  _wallV(g, b.right + 1, b.top, b.bottom);
  _wallH(g, b.left - 1, d0, b.bottom, 0);
  _wallH(g, d1, b.right + 1, b.bottom, 0);
  // capacho na porta
  g.fill(d0 * hd + 4, b.bottom * hd - 5, (d1 - d0) * hd - 8, 4, 0xFF8a6a4a);
}
