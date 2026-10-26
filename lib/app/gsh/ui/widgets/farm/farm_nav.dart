part of 'farm_world.dart';

// ------------------------------------------------------ caminhos de verdade

/// A grade de caminhar de um mundo: células de [cell] px marcadas como
/// bloqueadas (cercas, paredes, celeiro/copa, lago/mesa de reunião, pedras,
/// móveis, ilhas de mesas no escritório) uma vez, quando o mundo é montado.
/// [route] acha o caminho por BFS na grade grossa e corta os cantos por
/// linha de visada; a rota fica em cache por (célula de saída, célula de
/// chegada), então quem pede de novo o mesmo destino não recalcula.
///
/// ponytail: BFS em grade de 4 px (uns poucos milhares de células por
/// mundo); trocar por A* com heap só se o mundo crescer muito.
class FarmNav {
  FarmNav(FarmLayout l, {required this.office})
    : cols = (l.w / cell).ceil(),
      rows = (l.h / cell).ceil(),
      _blocked = Uint8List((l.w / cell).ceil() * (l.h / cell).ceil()) {
    _mark(l);
  }

  static const cell = 4.0;

  /// Rotas guardadas; a mais antiga sai quando passa disso.
  static const cacheMax = 256;

  final bool office;
  final int cols, rows;
  final Uint8List _blocked;
  final _cache = <(int, int), List<ui.Offset>?>{};

  /// Quantas buscas de verdade (sem cache) já rodaram: os testes medem.
  int searches = 0;

  int _at(double x, double y) {
    final cx = (x / cell).floor(), cy = (y / cell).floor();
    if (cx < 0 || cy < 0 || cx >= cols || cy >= rows) return -1;
    return cy * cols + cx;
  }

  bool walkable(double x, double y) {
    final i = _at(x, y);
    return i >= 0 && _blocked[i] == 0;
  }

  bool _free(int i) => i >= 0 && i < _blocked.length && _blocked[i] == 0;

  ui.Offset _center(int i) =>
      ui.Offset((i % cols + 0.5) * cell, (i ~/ cols + 0.5) * cell);

  // ---------------------------------------------------------- a grade

  void _box(ui.Rect r) {
    if (r.isEmpty) return;
    final x0 = math.max(0, (r.left / cell).floor());
    final x1 = math.min(cols - 1, ((r.right - 0.01) / cell).floor());
    final y0 = math.max(0, (r.top / cell).floor());
    final y1 = math.min(rows - 1, ((r.bottom - 0.01) / cell).floor());
    for (var y = y0; y <= y1; y++) {
      for (var x = x0; x <= x1; x++) {
        _blocked[y * cols + x] = 1;
      }
    }
  }

  /// Linha horizontal de cerca/parede de [x0] a [x1] na altura [y], com
  /// uma abertura opcional [gap] (de, até).
  void _hLine(double x0, double x1, double y, [(double, double)? gap]) {
    if (gap == null) {
      _box(ui.Rect.fromLTRB(x0, y - 1, x1, y + 1));
      return;
    }
    _box(ui.Rect.fromLTRB(x0, y - 1, gap.$1, y + 1));
    _box(ui.Rect.fromLTRB(gap.$2, y - 1, x1, y + 1));
  }

  void _vLine(double x, double y0, double y1, [(double, double)? gap]) {
    if (gap == null) {
      _box(ui.Rect.fromLTRB(x - 1, y0, x + 1, y1));
      return;
    }
    _box(ui.Rect.fromLTRB(x - 1, y0, x + 1, gap.$1));
    _box(ui.Rect.fromLTRB(x - 1, gap.$2, x + 1, y1));
  }

  /// Uma caixa com paredes nos quatro lados e uma porta: [door] diz o lado
  /// (`top`, `bottom`, `left`) e o vão.
  void _walls(ui.Rect r, String side, (double, double) door) {
    _hLine(r.left, r.right, r.top, side == 'top' ? door : null);
    _hLine(r.left, r.right, r.bottom, side == 'bottom' ? door : null);
    _vLine(r.left, r.top, r.bottom, side == 'left' ? door : null);
    _vLine(r.right, r.top, r.bottom);
  }

  void _mark(FarmLayout l) {
    // fora da área de andar (mato da borda, rua, paredes do prédio)
    final p = l.play;
    for (var i = 0; i < _blocked.length; i++) {
      if (!p.contains(_center(i))) _blocked[i] = 1;
    }
    final y = l.yard, f = l.field, b = l.barn;
    final yardDoor = (y.center.dx - 8, y.center.dx + 8);
    final gate = (l.gateAt - 8, l.gateAt + 8);
    if (office) {
      // copa (porta embaixo), lounge (porta em cima), ala (porta à
      // esquerda), mesa de reunião, ilhas de mesas e a impressora
      _walls(b.inflate(1), 'bottom', (b.center.dx - 9, b.center.dx + 9));
      _walls(
        ui.Rect.fromLTRB(y.left - 2, y.top, y.right + 2, y.bottom),
        'top',
        yardDoor,
      );
      _walls(f, 'left', gate);
      final tl = l.pondCx - l.pondRx + 5, tr = l.pondCx + l.pondRx - 5;
      _box(
        ui.Rect.fromLTRB(
          tl - 1,
          l.pondCy - l.pondRy,
          tr + 1,
          l.pondCy + l.pondRy + 2,
        ),
      );
      for (final pl in l.plots) {
        _box(pl.inflate(1));
      }
      _box(ui.Rect.fromLTWH(l.crow.dx - 7, l.crow.dy - 6, 14, 7));
    } else {
      // celeiro, curral (porteira em cima), cercado (portão à esquerda),
      // lago, espantalho e placa
      _box(b);
      _walls(
        ui.Rect.fromLTRB(y.left - 2, y.top, y.right + 2, y.bottom),
        'top',
        yardDoor,
      );
      _walls(f, 'left', gate);
      for (var i = 0; i < _blocked.length; i++) {
        final c = _center(i);
        final px = (c.dx - l.pondCx) / (l.pondRx + 3);
        final py = (c.dy - l.pondCy) / (l.pondRy + 2);
        if (px * px + py * py < 1) _blocked[i] = 1;
      }
      _box(ui.Rect.fromLTWH(l.crow.dx - 4, l.crow.dy - 5, 8, 7));
      _box(ui.Rect.fromLTWH(l.sign.dx - 2, l.sign.dy + 2, 4, 6));
    }
    for (final r in l.rocks) {
      _box(
        ui.Rect.fromLTWH(
          r.left - r.width / 2 - 1,
          r.top - 1,
          r.width + 2,
          r.height + 2,
        ),
      );
    }
    for (final d in l.decor) {
      if (d.r <= 0) continue;
      _box(
        ui.Rect.fromLTRB(
          d.x - d.r * 0.7,
          d.y - d.r * 0.8,
          d.x + d.r * 0.7,
          d.y + 2,
        ),
      );
    }
  }

  // ---------------------------------------------------------- as rotas

  /// A célula livre mais perto de [i] (até 3 de distância), ou -1.
  int _nearFree(int i) {
    if (i < 0) return -1;
    if (_free(i)) return i;
    final cx = i % cols, cy = i ~/ cols;
    for (var r = 1; r <= 3; r++) {
      for (var dy = -r; dy <= r; dy++) {
        for (var dx = -r; dx <= r; dx++) {
          if (dx.abs() != r && dy.abs() != r) continue;
          final x = cx + dx, y = cy + dy;
          if (x < 0 || y < 0 || x >= cols || y >= rows) continue;
          if (_free(y * cols + x)) return y * cols + x;
        }
      }
    }
    return -1;
  }

  /// O caminho de [from] até [to] (pixels de mundo): pontos a seguir, o
  /// último é o próprio [to]. `null` = não há caminho (quem pede cai no
  /// andar reto de antes). Saída e chegada podem estar numa célula
  /// bloqueada (o gorila no canto da ilha, o mini na cadeira): valem a
  /// célula livre mais perto.
  List<ui.Offset>? route(ui.Offset from, ui.Offset to) {
    final s = _nearFree(_at(from.dx, from.dy));
    final g = _nearFree(_at(to.dx, to.dy));
    if (s < 0 || g < 0) return null;
    final key = (s, g);
    final List<ui.Offset>? cells;
    if (_cache.containsKey(key)) {
      cells = _cache.remove(key);
      _cache[key] = cells; // a mais usada vai para o fim
    } else {
      cells = _search(s, g);
      if (_cache.length >= cacheMax) _cache.remove(_cache.keys.first);
      _cache[key] = cells;
    }
    if (cells == null) return null;
    // corta os cantos: de cada ponto, o mais longe que se vê em linha reta
    final pts = [from, ...cells, to];
    final out = <ui.Offset>[];
    var i = 0;
    while (i < pts.length - 1) {
      var j = pts.length - 1;
      while (j > i + 1 && !_sees(pts[i], pts[j])) {
        j--;
      }
      out.add(pts[j]);
      i = j;
    }
    return out;
  }

  /// BFS de 8 vizinhos (sem cortar quina de bloqueio): os centros das
  /// células do caminho, sem a de saída.
  List<ui.Offset>? _search(int s, int g) {
    searches++;
    final prev = Int32List(_blocked.length)..fillRange(0, _blocked.length, -1);
    final queue = Int32List(_blocked.length);
    var head = 0, tail = 0;
    queue[tail++] = s;
    prev[s] = s;
    while (head < tail) {
      final c = queue[head++];
      if (c == g) break;
      final cx = c % cols, cy = c ~/ cols;
      for (var dy = -1; dy <= 1; dy++) {
        for (var dx = -1; dx <= 1; dx++) {
          if (dx == 0 && dy == 0) continue;
          final x = cx + dx, y = cy + dy;
          if (x < 0 || y < 0 || x >= cols || y >= rows) continue;
          final n = y * cols + x;
          if (prev[n] >= 0 || !_free(n)) continue;
          if (dx != 0 &&
              dy != 0 &&
              (!_free(cy * cols + x) || !_free(y * cols + cx))) {
            continue;
          }
          prev[n] = c;
          queue[tail++] = n;
        }
      }
    }
    if (prev[g] < 0) return null;
    final path = <ui.Offset>[];
    for (var c = g; c != s; c = prev[c]) {
      path.add(_center(c));
    }
    return path.reversed.toList();
  }

  /// Dá para ir reto de [a] a [b] sem pisar em célula bloqueada?
  bool _sees(ui.Offset a, ui.Offset b) {
    final d = b - a, n = (d.distance / (cell / 2)).ceil();
    final ia = _at(a.dx, a.dy), ib = _at(b.dx, b.dy);
    for (var k = 1; k < n; k++) {
      final p = a + d * (k / n);
      final i = _at(p.dx, p.dy);
      // a célula de saída/chegada pode ser bloqueada (canto da ilha)
      if (i == ia || i == ib) continue;
      if (!_free(i)) return false;
    }
    return true;
  }
}

/// A rota de quem anda (gorila, bichinho): pede a [FarmNav] só quando o
/// destino (ou o mundo) muda, nunca por quadro, e diz o próximo ponto.
class FarmRoute {
  ui.Offset? _to;
  FarmNav? _nav;
  List<ui.Offset>? _pts;
  int _i = 0;

  /// Há rota de verdade (senão quem anda vai reto, como antes).
  bool get active => _pts != null;

  /// O próximo ponto rumo a [to], estando em [at].
  ui.Offset next(FarmNav? nav, ui.Offset at, ui.Offset to) {
    if (nav == null) return to;
    final from = _to;
    if (from == null || !identical(nav, _nav) || (from - to).distance > 1) {
      _to = to;
      _nav = nav;
      _i = 0;
      _pts = (to - at).distance < 3 ? null : nav.route(at, to);
    }
    final p = _pts;
    if (p == null) return to;
    while (_i < p.length - 1 && (p[_i] - at).distance < 1.5) {
      _i++;
    }
    return p[_i];
  }

  /// Esquece a rota (teleportou: mundo refeito).
  void reset() => _to = null;
}
