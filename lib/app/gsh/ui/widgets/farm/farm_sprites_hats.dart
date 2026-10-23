// Ported from clodfarm (github.com/matank001/clodfarm), MIT License, see third_party/clodfarm/LICENSE.

part of 'farm_sprites.dart';

// ------------------------------------------------------------------ chapéus

class HatPal {
  HatPal(int hc, int band)
    : h = hc,
      l = shade(hc, 0.17),
      d = shade(hc, -0.17),
      dd = shade(hc, -0.3),
      b = band,
      bl = shade(band, 0.18),
      bd = shade(band, -0.2);
  final int h, l, d, dd, b, bl, bd;
}

class _Hat {
  const _Hat(this.draw, {this.base = 0, required this.band, this.tint = false});
  final void Function(Pix p, HatPal c) draw;
  final int base;
  final int band;

  /// Chapéu que veste a cor do agente (gorro, boné, fone).
  final bool tint;
}

final _hats = <_Hat>[
  _Hat(_straw, base: 0xFFf0cf7a, band: 0xFFc0392b),
  const _Hat(_beanie, band: 0xFFf7f3ea, tint: true),
  const _Hat(_cap, band: 0xFFf7f3ea, tint: true),
  _Hat(_flower, base: 0xFFffd0dc, band: 0xFFf5c542),
  const _Hat(_headphones, band: 0xFF5b6272, tint: true),
  _Hat(_bow, base: 0xFFe0508a, band: 0xFFf59cc0),
  _Hat(_crown, base: 0xFFf5c542, band: 0xFFd63a3a),
  _Hat(_sprout, base: 0xFF6fcf5b, band: 0xFF3f8f35),
  _Hat(_leaf, base: 0xFF63a93f, band: 0xFF8a5a2b),
  _Hat(_wizard, base: 0xFF5b4bb7, band: 0xFFf5c542),
  _Hat(_chef, base: 0xFFf7f3ea, band: 0xFFd8d2c4),
];

void _straw(Pix p, HatPal c) {
  void brim(int from) => p.ovalFn(
    16,
    12,
    15.2,
    2.9,
    (x, y, u, v) => y < from
        ? 0
        : v < -0.25
        ? c.l
        : v > 0.45
        ? c.d
        : c.h,
  );
  brim(0);
  p.ovalFn(
    16,
    8.5,
    7.2,
    5.5,
    (x, y, u, v) => y > 11
        ? 0
        : y == 9
        ? c.bl
        : y == 10
        ? c.b
        : y == 11
        ? c.bd
        : u < -0.5
        ? c.l
        : u > 0.62
        ? c.d
        : c.h,
  );
  brim(12);
  p.map((x, y, col) => col == c.h && (x * 3 + y * 5) % 7 == 0 ? c.d : null);
}

void _beanie(Pix p, HatPal c) {
  p
    ..ovalFn(
      16,
      14.5,
      12.6,
      11,
      (x, y, u, v) => y > 15
          ? 0
          : y >= 13
          ? (x.isOdd ? c.d : c.dd)
          : u < -0.45 && v < -0.1
          ? c.l
          : x % 3 == 0
          ? c.d
          : c.h,
    )
    ..ovalFn(
      16,
      3.2,
      3.3,
      3.1,
      (x, y, u, v) => u < -0.1 && v < -0.1
          ? c.bl
          : v > 0.5
          ? c.bd
          : c.b,
    );
}

void _cap(Pix p, HatPal c) {
  p
    ..ovalFn(
      15,
      13.5,
      10.6,
      8.6,
      (x, y, u, v) => y > 13
          ? 0
          : u < -0.45 && v < -0.2
          ? c.l
          : u > 0.55
          ? c.d
          : c.h,
    )
    ..line(15, 6, 15, 12, c.d)
    ..rect(14, 4, 3, 1, c.b)
    ..rect(8, 9, 4, 3, c.b)
    ..set(8, 9, c.bl)
    ..rect(21, 12, 10, 1, c.h)
    ..rect(21, 13, 10, 1, c.dd)
    ..set(30, 12, c.d)
    ..rect(22, 11, 6, 1, c.d);
}

void _flower(Pix p, HatPal c) {
  p
    ..line(23, 9, 21, 13, 0xFF3f8f35)
    ..oval(19.5, 11, 2.2, 1.2, 0xFF63b04a, -0.5);
  for (final (px, py) in [(20.5, 5.0), (26.5, 5.0), (23.5, 2.2), (23.5, 7.8)]) {
    p.ovalFn(
      px,
      py,
      2.6,
      2.4,
      (x, y, u, v) => u < -0.2 && v < -0.2
          ? c.l
          : v > 0.5
          ? c.d
          : c.h,
    );
  }
  p.ovalFn(23.5, 5, 1.9, 1.9, (x, y, u, v) => u < 0 && v < 0 ? c.bl : c.b);
}

void _headphones(Pix p, HatPal c) {
  p.ovalFn(
    16,
    15.5,
    13.6,
    11.5,
    (x, y, u, v) => y > 14 || u * u + v * v < 0.7
        ? 0
        : v < -0.9
        ? c.bl
        : c.b,
  );
  for (var y = 14; y <= 21; y++) {
    final edge = y == 14 || y == 21;
    if (!edge) {
      p
        ..set(1, y, c.l)
        ..set(30, y, c.d);
    }
    p
      ..rect(2, y, 2, 1, c.h)
      ..set(4, y, c.bd)
      ..set(27, y, c.bd)
      ..rect(28, y, 2, 1, y > 18 ? c.d : c.h);
  }
}

void _bow(Pix p, HatPal c) {
  int loop(int x, int y, double u, double v) => v.abs() < 0.35 && u.abs() > 0.55
      ? c.d
      : v < -0.3
      ? c.l
      : c.h;
  p
    ..ovalFn(10.5, 8.5, 4.6, 3.5, loop, -0.3)
    ..ovalFn(21.5, 8.5, 4.6, 3.5, loop, 0.3)
    ..rect(13, 11, 2, 3, c.d)
    ..rect(17, 11, 2, 3, c.d)
    ..ovalFn(16, 9.2, 2.3, 2.5, (x, y, u, v) => u < 0 && v < 0 ? c.bl : c.b);
}

void _crown(Pix p, HatPal c) {
  for (final (px, top) in [(8, 4), (14, 2), (20, 4)]) {
    for (var y = top; y <= 9; y++) {
      final half = (y - top + 1) / (10 - top) * 2.2;
      for (var x = px; x < px + 4; x++) {
        if ((x + 0.5 - (px + 2)).abs() <= half) {
          p.set(x, y, x == px ? c.l : c.h);
        }
      }
    }
    p.rect(px + 1, top - 1, 2, 1, 0xFFfff4c2);
  }
  p
    ..rect(8, 9, 16, 4, c.h)
    ..rect(8, 9, 16, 1, c.l)
    ..rect(8, 12, 16, 1, c.d)
    ..rect(10, 10, 2, 2, c.b)
    ..rect(15, 10, 2, 2, 0xFF3b7dd8)
    ..rect(20, 10, 2, 2, c.b)
    ..set(10, 10, c.bl)
    ..set(15, 10, 0xFF9cc6f5)
    ..set(20, 10, c.bl);
}

void _sprout(Pix p, HatPal c) {
  int leaf(int x, int y, double u, double v) => v.abs() < 0.2 && u.abs() < 0.8
      ? c.d
      : v < -0.25
      ? c.l
      : c.h;
  p
    ..line(16, 13, 16, 7, c.bd)
    ..set(15, 13, c.bd)
    ..ovalFn(11.2, 6.5, 5.2, 2.6, leaf, 0.4)
    ..ovalFn(20.8, 5.5, 5.2, 2.6, leaf, -0.4);
}

void _leaf(Pix p, HatPal c) {
  p
    ..line(5, 13, 8, 11, c.b)
    ..ovalFn(
      16,
      7.5,
      10.4,
      4.1,
      (x, y, u, v) => v < -0.35
          ? c.l
          : v > 0.5
          ? c.d
          : c.h,
      -0.45,
    )
    ..line(8, 11, 24, 4, c.d);
  for (final k in [11, 15, 19]) {
    p.line(k, 10 - (k - 8) * 0.43, k + 2, 7 - (k - 8) * 0.43, c.d);
  }
}

void _wizard(Pix p, HatPal c) {
  void brim(int from) => p.ovalFn(
    16,
    12.5,
    14.6,
    2.6,
    (x, y, u, v) => y < from
        ? 0
        : v < -0.3
        ? c.l
        : v > 0.4
        ? c.dd
        : c.d,
  );
  brim(0);
  for (var y = 0; y <= 11; y++) {
    final t = (11 - y) / 11, half = 7.6 * (1 - t) + 0.7, cx = 16 + t * t * 6;
    for (var x = 0; x < 32; x++) {
      final dx = x + 0.5 - cx;
      if (dx.abs() > half) continue;
      p.set(
        x,
        y,
        y >= 9 && y <= 10
            ? (y == 9 ? c.bl : c.b)
            : dx < -half * 0.45
            ? c.l
            : dx > half * 0.5
            ? c.d
            : c.h,
      );
    }
  }
  for (final (sx, sy) in [(13, 6), (19, 3)]) {
    p
      ..set(sx, sy, c.bl)
      ..set(sx - 1, sy, c.b)
      ..set(sx + 1, sy, c.b)
      ..set(sx, sy - 1, c.b)
      ..set(sx, sy + 1, c.b);
  }
  brim(12);
}

void _chef(Pix p, HatPal c) {
  int puff(int x, int y, double u, double v) => u < -0.3 && v < -0.2
      ? c.l
      : v > 0.55
      ? c.d
      : c.h;
  p
    ..rect(9, 6, 14, 6, c.h)
    ..ovalFn(11, 5.6, 4.3, 3.7, puff)
    ..ovalFn(21, 5.6, 4.3, 3.7, puff)
    ..ovalFn(16, 3.9, 4.7, 3.9, puff);
  for (final x in [12, 16, 20]) {
    p.line(x, 7, x, 9, c.d);
  }
  p
    ..rect(9, 10, 14, 3, c.b)
    ..rect(9, 10, 14, 1, c.bl)
    ..rect(9, 12, 14, 1, c.bd)
    ..set(22, 11, c.bd);
}
