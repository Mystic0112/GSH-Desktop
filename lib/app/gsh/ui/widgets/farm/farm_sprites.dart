// Ported from clodfarm (github.com/matank001/clodfarm), MIT License, see third_party/clodfarm/LICENSE.

import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:gsh_desktop/app/gsh/ui/widgets/farm/pix.dart';

part 'farm_sprites_hats.dart';
part 'farm_sprites_crops.dart';
part 'farm_sprites_icons.dart';
part 'office_sprites.dart';

/// Sprites HD da fazenda (grade 2x: um pixel de mundo = 2x2 pixels de arte).
/// Cada pose é rasterizada uma vez e guardada: o loop de frame nunca monta
/// sprite. ponytail: caches globais, sem descarte (são poucos KB por pose);
/// limpar só se a paleta de cores crescer sem limite.

const hd = 2;
const clay = 0xFFd97757;
const _eye = 0xFF231815;
const _shine = 0xFFFFFFFF;

/// Paleta HD de um corpo: tinta, brilho, luz, base, sombra, escuro, bochecha.
class BodyPal {
  const BodyPal(this.o, this.l, this.h, this.b, this.s, this.d, this.k);
  final int o, l, h, b, s, d, k;

  factory BodyPal.of(int body) => body == clay
      ? const BodyPal(
          0xFF4a1f12,
          0xFFf7c3a3,
          0xFFec9670,
          0xFFd97757,
          0xFFb95d3f,
          0xFF8a3a21,
          0xFFf3ab98,
        )
      : BodyPal(
          mix(shade(body, -0.5), 0xFF1a1216, 0.25),
          shade(body, 0.2),
          shade(body, 0.09),
          body,
          shade(body, -0.11),
          shade(body, -0.28),
          mix(body, 0xFFff9f9f, 0.45),
        );
}

/// Clawd em HD, 32 x 36 (o corpo começa na linha 12, embaixo do chapéu).
/// Poses: look (-1, 0, 1), legs (0 parado, 1/2 os passos), blink, sleep
/// (sentado, olhos fechados), arms (0 baixo, 1 pra cima, 2/3 digitando), happy.
Pix clawdHD(
  BodyPal pal, {
  int look = 0,
  int legs = 0,
  bool blink = false,
  bool sleep = false,
  int arms = 0,
  bool happy = false,
}) {
  final p = Pix(32, 36);
  final x0 = sleep ? 4 : 5, x1 = sleep ? 27 : 26;
  final y0 = sleep ? 18 : 13, y1 = sleep ? 33 : 30;
  for (var y = y0; y <= y1; y++) {
    for (var x = x0; x <= x1; x++) {
      if ((x == x0 || x == x1) && (y == y0 || y == y1)) continue;
      var c = pal.b;
      if (y <= y0 + 1 || x <= x0 + 1) c = pal.h;
      if (y == y0 && x >= x0 + 2 && x <= x0 + 9) c = pal.l;
      if (x == x0 + 1 && y == y0 + 1) c = pal.l;
      if (x >= x1 - 1 || y >= y1 - 1) c = pal.s;
      if (y == y1 && x > x0 + 1 && x < x1 - 1) c = pal.d;
      p.set(x, y, c);
    }
  }
  final ay = sleep
      ? [y1 - 5, y1 - 5]
      : arms == 1
      ? [15, 15]
      : arms == 2
      ? [19, 22]
      : arms == 3
      ? [22, 19]
      : [21, 21];
  final tall = sleep ? 3 : 4;
  for (var k = 0; k < tall; k++) {
    p
      ..set(x0 - 3, ay[0] + k, k == 0 ? pal.l : pal.h)
      ..set(x0 - 2, ay[0] + k, pal.h)
      ..set(x0 - 1, ay[0] + k, pal.b)
      ..set(x1 + 1, ay[1] + k, pal.b)
      ..set(x1 + 2, ay[1] + k, pal.s)
      ..set(x1 + 3, ay[1] + k, k == tall - 1 ? pal.d : pal.s);
  }
  if (!sleep) {
    const lxs = [6, 11, 19, 24];
    for (var i = 0; i < 4; i++) {
      final up = legs != 0 && ((i.isEven) == (legs == 1));
      for (var y = 31; y <= (up ? 32 : 33); y++) {
        p
          ..set(lxs[i], y, y == 31 ? pal.s : pal.d)
          ..set(lxs[i] + 1, y, pal.d);
      }
    }
  }
  p.outline(pal.o);
  final ey = y0 + 4, sh = look * 2;
  for (final ex in [10 + sh, 19 + sh]) {
    if (sleep) {
      p
        ..set(ex, ey + 3, _eye)
        ..set(ex + 1, ey + 4, _eye)
        ..set(ex + 2, ey + 3, _eye);
    } else if (blink) {
      p
        ..rect(ex, ey + 4, 3, 1, _eye)
        ..set(ex - 1, ey + 3, pal.s)
        ..set(ex + 3, ey + 3, pal.s);
    } else {
      p
        ..rect(ex, ey, 3, 6, _eye)
        ..set(ex, ey, _shine)
        ..set(ex, ey + 1, _shine)
        ..set(ex + 2, ey + 4, 0xFF4a3a36);
    }
  }
  p
    ..rect(7 + sh, ey + 7, 3, 1, pal.k)
    ..rect(22 + sh, ey + 7, 3, 1, pal.k);
  if (happy && !sleep) {
    p
      ..rect(15 + sh, ey + 7, 2, 1, _eye)
      ..rect(15 + sh, ey + 8, 2, 1, 0xFFc8505a);
  }
  return p;
}

// ------------------------------------------------------------------- skins

/// O visual de um Clawd: chapéu (sorteado pelo id, ou o fixo do agente do
/// squad) na cor do agente e corpo de argila (tingido, no squad). Guarda as
/// poses já rasterizadas.
class FarmSkin {
  FarmSkin._(this.hat, this.hatColor, this.body);

  static final _cache = <String, FarmSkin>{};

  /// Chapéu estável por [id]; os chapéus "tingíveis" usam [color]. Com
  /// [hat]/[body] (o visual do squad), o chapéu é esse (`null` = careca) e o
  /// corpo vem tingido.
  factory FarmSkin.of(
    String id,
    int color, {
    bool fixed = false,
    FarmHat? hat,
    int body = clay,
  }) {
    final h = fixed ? hat : FarmHat.values[hashStr(id) % FarmHat.values.length];
    final hc = h == null ? 0 : _hatColor(h, color);
    return _cache.putIfAbsent(
      '${h?.index}|$hc|$body',
      () => FarmSkin._(h, hc, body),
    );
  }

  final FarmHat? hat;
  final int hatColor;
  final int body;
  final _frames = List<ui.Image?>.filled(288, null);
  Pix? _hat;

  ui.Image frame({
    int look = 0,
    int legs = 0,
    bool blink = false,
    bool sleep = false,
    int arms = 0,
    bool happy = false,
  }) {
    final code =
        look +
        1 +
        3 * legs +
        9 * (blink ? 1 : 0) +
        18 * (sleep ? 1 : 0) +
        36 * arms +
        144 * (happy ? 1 : 0);
    return _frames[code] ??= () {
      final p = clawdHD(
        BodyPal.of(body),
        look: look,
        legs: legs,
        blink: blink,
        sleep: sleep,
        arms: arms,
        happy: happy,
      );
      final hat = this.hat;
      if (hat != null) {
        _hat ??= _hatPix(hat, hatColor)..outline(_hatInk(hatColor));
        p.stamp(_hat!, 0, sleep ? 5 : 0);
      }
      return p.toImage();
    }();
  }
}

/// Subagente em HD: um Claude pequeno com faixa na cor dele, 20 x 16. Com
/// [hat]/[body] (o visual do squad) o corpo vem tingido e ganha o chapéu
/// em miniatura: 20 x 21, os pés na mesma linha.
final _miniCache = <String, ui.Image>{};
ui.Image miniHD(
  int color, {
  int legs = 0,
  int arms = 0,
  bool blink = false,
  FarmHat? hat,
  int body = clay,
}) {
  final code =
      '$color|$legs|$arms|$blink|${hat?.index}|$body'
      '|${hat == null ? 0 : _hatColor(hat, color)}';
  return _miniCache[code] ??= () {
    final p = Pix(20, 16), pal = BodyPal.of(body);
    for (var y = 2; y <= 11; y++) {
      for (var x = 3; x <= 16; x++) {
        if ((x == 3 || x == 16) && (y == 2 || y == 11)) continue;
        p.set(
          x,
          y,
          y == 4
              ? shade(color, 0.16)
              : y == 5
              ? color
              : y == 2 || x == 3
              ? pal.h
              : x == 16 || y == 11
              ? pal.s
              : pal.b,
        );
      }
    }
    p
      ..set(17, 5, color)
      ..set(18, 6, shade(color, -0.15));
    final ay = 7 - arms * 3;
    p
      ..rect(1, ay, 2, 3, pal.h)
      ..rect(17, ay, 2, 3, pal.s);
    const lxs = [4, 7, 11, 14];
    for (var i = 0; i < 4; i++) {
      final up = legs != 0 && (i.isEven == (legs == 1));
      p.rect(lxs[i], 12, 2, up ? 1 : 2, pal.d);
    }
    p.outline(pal.o);
    for (final ex in [6, 12]) {
      if (blink) {
        p.rect(ex, 9, 2, 1, _eye);
      } else {
        p
          ..rect(ex, 7, 2, 3, _eye)
          ..set(ex, 7, _shine);
      }
    }
    if (hat == null) return p.toImage();
    // o meio da aba (linha 7 do chapéu) cobre o topo da cabeça (linha 2)
    return (Pix(20, 21)
          ..stamp(p, 0, 5)
          ..stamp(_hatMini(hat, _hatColor(hat, color)), 1, 0))
        .toImage();
  }();
}

// ------------------------------------------------------- objetos da fazenda

/// Laptop: dois quadros ligado (texto rolando) e um desligado. 18 x 14.
final List<ui.Image> laptopHD = List.generate(3, (f) {
  final p = Pix(18, 14)
    ..rect(1, 0, 16, 9, 0xFF1b1f2a)
    ..rect(2, 1, 14, 7, f == 2 ? 0xFF1d2833 : 0xFF22303c);
  if (f < 2) {
    final rows = f == 1
        ? [(3, 5, 0xFF7cfc9a), (4, 3, 0xFFd97757), (3, 7, 0xFF7cfc9a)]
        : [(3, 7, 0xFF7cfc9a), (5, 4, 0xFF7cfc9a), (3, 4, 0xFFd97757)];
    for (var i = 0; i < 3; i++) {
      p.rect(rows[i].$1, 2 + i * 2, rows[i].$2, 1, rows[i].$3);
    }
    p.rect(12, 6, 2, 1, f == 1 ? 0xFF7cfc9a : 0xFF22303c);
  } else {
    p.set(3, 2, 0xFF3a4a58);
  }
  p
    ..rect(0, 9, 18, 1, 0xFFc3cad6)
    ..rect(0, 10, 18, 2, 0xFF9aa3b2)
    ..rect(0, 12, 18, 1, 0xFF1b1f2a);
  for (var x = 2; x < 16; x += 2) {
    p.set(x, 10, 0xFF6b7383);
  }
  p
    ..set(0, 9, 0xFF1b1f2a)
    ..set(17, 9, 0xFF1b1f2a)
    ..rect(0, 10, 1, 2, 0xFF1b1f2a)
    ..rect(17, 10, 1, 2, 0xFF1b1f2a);
  return p.toImage();
});

/// O espantalho: dois quadros acordado (balança), um dormindo (cinza). 32 x 44.
final List<ui.Image> scarecrowHD = List.generate(3, (f) {
  final off = f == 2;
  final (o, y, yd, b, bd, r, rd, w, e) = off
      ? (
          0xFF3a3a40,
          0xFFa39d8c,
          0xFF857f70,
          0xFFb4ad9e,
          0xFF958e80,
          0xFF80808a,
          0xFF66666e,
          0xFF6b6158,
          0xFF3a3a40,
        )
      : (
          0xFF3a2616,
          0xFFe8be55,
          0xFFc28f2c,
          0xFFdcc49a,
          0xFFbfa57a,
          0xFFc0392b,
          0xFF8e2a20,
          0xFF8a6038,
          0xFF231815,
        );
  final p = Pix(32, 44), lift = f == 1 ? -1 : 0;
  p
    ..rect(15, 24, 2, 19, w)
    ..set(15, 24, shade(w, 0.15));
  for (var x = 2; x <= 29; x++) {
    for (var yy = 18; yy <= 22; yy++) {
      final armY = yy + (x < 10 ? lift : (x > 21 ? -lift : 0));
      p.set(x, armY, ((x ~/ 3) + yy) % 3 == 0 ? rd : r);
    }
  }
  for (final (x, s) in [(0, -1), (31, 1)]) {
    for (var k = 0; k < 4; k++) {
      p.set(
        x - s * (k % 2),
        18 + k + (x < 10 ? lift : -lift),
        k.isOdd ? yd : y,
      );
    }
  }
  for (var yy = 17; yy <= 30; yy++) {
    for (var x = 9; x <= 22; x++) {
      p.set(x, yy, (x % 4 == 1 || yy % 4 == 1) ? rd : r);
    }
  }
  p
    ..rect(9, 28, 14, 1, y)
    ..rect(10, 31, 3, 2, y)
    ..rect(15, 31, 2, 3, yd)
    ..rect(19, 31, 3, 2, y);
  final hy = off ? 1 : 0, hx = off ? 1 : 0;
  p
    ..ovalFn(
      16 + hx,
      12 + hy,
      6.4,
      6,
      (x, yy, u, v) => u < -0.4 && v < -0.2
          ? shade(b, 0.08)
          : u > 0.5 || v > 0.6
          ? bd
          : b,
    )
    ..rect(8 + hx, 6 + hy, 17, 2, y)
    ..rect(8 + hx, 7 + hy, 17, 1, yd)
    ..ovalFn(
      16 + hx,
      3.5 + hy,
      5.5,
      3.6,
      (x, yy, u, v) => yy > 6 + hy
          ? 0
          : u < -0.3
          ? shade(y, 0.1)
          : y,
    )
    ..rect(11 + hx, 5 + hy, 11, 1, r)
    ..outline(o);
  if (off) {
    p
      ..rect(13 + hx, 12 + hy, 2, 1, e)
      ..rect(18 + hx, 12 + hy, 2, 1, e);
  } else {
    for (final ex in [13, 18]) {
      p
        ..set(ex, 10, e)
        ..set(ex + 1, 11, e)
        ..set(ex + 1, 10, e)
        ..set(ex, 11, e);
    }
  }
  for (var x = 13; x <= 19; x++) {
    p.set(x + hx, 15 + hy + (x == 13 || x == 19 ? -1 : 0), x.isOdd ? e : bd);
  }
  return p.toImage();
});

final _shadows = <int, ui.Image>{};
ui.Image shadowSprite(int rx, int ry) => _shadows[rx * 100 + ry] ??= (Pix(
  rx * 2 + 2,
  ry * 2 + 2,
)..oval(rx + 1, ry + 1, rx, ry, 0xFF14200c)).toImage();

/// Seta de seleção (sobre quem está com o mouse em cima).
final ui.Image arrowSel = () {
  final p = Pix(9, 7);
  for (var y = 0; y < 5; y++) {
    p.rect(y, y, 9 - y * 2, 1, 0xFFffffff);
  }
  return (p..outline(0xFF1f2a44)).toImage();
}();

/// A bandeirinha de "precisa de você", dois quadros.
final List<ui.Image> flagHD = List.generate(2, (f) {
  final p = Pix(12, 20)..rect(1, 0, 1, 19, 0xFF3a1410);
  final c = f == 1 ? 0xFFff8a70 : 0xFFe0513c;
  for (var y = 1; y < 11; y++) {
    final w =
        8 - (y > 8 ? (y - 8) * 2 : 0) + (f == 1 && y > 3 && y < 7 ? 1 : 0);
    p.rect(2, y, w, 1, c);
  }
  p
    ..rect(5, 3, 2, 3, 0xFFffffff)
    ..rect(5, 7, 2, 1, 0xFFffffff)
    ..outline(0xFF3a1410);
  return p.toImage();
});

final ui.Image zed =
    (Pix(6, 6)
          ..rect(0, 0, 5, 1, 0xFFf4f1e8)
          ..line(4, 1, 0, 4, 0xFFf4f1e8)
          ..rect(0, 4, 5, 1, 0xFFf4f1e8)
          ..outline(0xFF3c4a6b))
        .toImage();

final List<ui.Image> sparkles = [
  for (final c in [0xFFfff4c2, 0xFFffd59e, 0xFFf2a07a, 0xFFffffff])
    (Pix(7, 7)
          ..rect(3, 1, 1, 5, c)
          ..rect(1, 3, 5, 1, c)
          ..set(3, 3, 0xFFffffff)
          ..set(3, 0, shade(c, -0.1))
          ..set(3, 6, shade(c, -0.1))
          ..set(0, 3, shade(c, -0.1))
          ..set(6, 3, shade(c, -0.1)))
        .toImage(),
];
