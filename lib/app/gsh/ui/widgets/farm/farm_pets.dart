import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:gsh_desktop/app/gsh/ui/widgets/farm/farm_world.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/farm/pix.dart';

/// Os bichinhos de estimação: um cachorro e uma galinha passeando devagar
/// pela fazenda, um gato cochilando no sofá do escritório. Não abrem nada:
/// o clique só solta um coraçãozinho. Andam no mesmo tick da cena (aba
/// escondida = parados) e em passos de meio pixel, então quase todo quadro
/// deles sai igual e nem repinta.
enum PetKind { dog, chicken, cat }

class FarmPet {
  FarmPet(this.kind, this.x, this.y, this.rnd)
    : tx = x,
      ty = y,
      wait = 1 + rnd.nextDouble() * 4,
      seed = rnd.nextDouble() * 10;

  final PetKind kind;
  final math.Random rnd;
  double x, y, tx, ty, wait;
  final double seed;

  /// Para que lado olha (1 = direita).
  int dir = 1;
  int step = 0;
  double _stepT = 0;
  bool moving = false;

  /// O caminho até o lugar do passeio (contorna cerca, lago e celeiro).
  final route = FarmRoute();

  /// Quando levou o último carinho (o coração sobe por [heartLife] s).
  double? petAt;
  static const heartLife = 1.2;

  double get _speed => switch (kind) {
    PetKind.dog => 7,
    PetKind.chicken => 4,
    PetKind.cat => 0,
  };

  void update(double dt, FarmLayout l) {
    if (kind == PetKind.cat) return; // o gato não sai do sofá
    if (wait > 0) {
      wait -= dt;
      moving = false;
      if (wait <= 0) _pick(l);
      return;
    }
    final w = route.next(l.nav, ui.Offset(x, y), ui.Offset(tx, ty));
    final dx = w.dx - x, dy = w.dy - y, d = math.sqrt(dx * dx + dy * dy);
    if (d < 0.5) {
      moving = false;
      wait = 3 + rnd.nextDouble() * 9;
      return;
    }
    moving = true;
    final sp = math.min(_speed * dt, d);
    x += dx / d * sp;
    y += dy / d * sp;
    if (dx.abs() > 0.3) dir = dx.sign.toInt();
    _stepT += dt;
    if (_stepT > 0.18) {
      _stepT = 0;
      step = (step + 1) % 2;
    }
  }

  /// Um passeio curto: um lugar livre perto. Com a grade do mundo, a rota
  /// contorna o que houver no meio; sem ela, o meio do caminho também tem
  /// de estar livre (anda reto).
  void _pick(FarmLayout l) {
    for (var i = 0; i < 20; i++) {
      final nx = x + rnd.nextDouble() * 60 - 30;
      final ny = y + rnd.nextDouble() * 30 - 15;
      if (!l.play.deflate(8).contains(ui.Offset(nx, ny)) ||
          l.blocked(nx, ny) ||
          (l.nav == null && l.blocked((x + nx) / 2, (y + ny) / 2))) {
        continue;
      }
      tx = nx;
      ty = ny;
      return;
    }
    wait = 2;
  }

  /// O quadro do sprite agora ([calm] = relógio lento da cena).
  int frame(double calm) => switch (kind) {
    PetKind.dog =>
      moving ? 1 + step : ((calm * 2 + seed).floor().isOdd ? 3 : 0),
    PetKind.chicken =>
      moving ? 1 + step : ((calm * 2 + seed).floor() % 5 == 0 ? 3 : 0),
    // o rabo do gato mexe de vez em quando
    PetKind.cat => (calm * 0.5 + seed).floor() % 4 == 0 ? 1 : 0,
  };

  /// Fase (0..1) do coração do carinho, ou `null` sem coração à vista.
  double? heart(double t) {
    final at = petAt;
    if (at == null || t - at > heartLife) return null;
    return (t - at) / heartLife;
  }

  /// Sob o ponto (pixels de mundo)?
  bool hit(ui.Offset p) {
    final (w, h) = _size[kind]!;
    return (p.dx - x).abs() < w / 2 + 2 && p.dy > y - h - 2 && p.dy < y + 2;
  }

  int frameKey(double t, double calm) => Object.hash(
    (x * 2).round(),
    (y * 2).round(),
    frame(calm),
    dir,
    heart(t) == null ? -1 : (t * 12).floor(),
  );
}

/// Tamanho de cada bicho em pixels de mundo (o sprite é o dobro, HD).
const _size = {
  PetKind.dog: (11.0, 8.0),
  PetKind.chicken: (8.0, 8.0),
  PetKind.cat: (10.0, 7.0),
};

(double, double) petSize(PetKind k) => _size[k]!;

final _petCache = <(PetKind, int, int), ui.Image>{};

/// Sprite HD do bicho, pés embaixo no meio; [dir] -1 = espelhado.
ui.Image petSprite(PetKind kind, int frame, int dir) =>
    _petCache[(kind, frame, dir)] ??= () {
      final p = switch (kind) {
        PetKind.dog => _dog(frame),
        PetKind.chicken => _chicken(frame),
        PetKind.cat => _cat(frame),
      };
      if (dir >= 0) return p.toImage();
      final m = Pix(p.w, p.h);
      for (var y = 0; y < p.h; y++) {
        for (var x = 0; x < p.w; x++) {
          m.set(p.w - 1 - x, y, p.get(x, y));
        }
      }
      return m.toImage();
    }();

/// Cachorro caramelo de coleira vermelha, olhando para a direita. Quadros:
/// 0 parado, 1-2 andando, 3 parado abanando o rabo.
Pix _dog(int f) {
  const fur = 0xFFc98a4b, lit = 0xFFe3ad6e, sh = 0xFFa36a35;
  const ear = 0xFF6b4423;
  final p = Pix(22, 16);
  // rabo: em pé, ou abanando
  if (f == 3) {
    p
      ..set(3, 6, fur)
      ..set(2, 5, fur)
      ..set(1, 5, lit);
  } else {
    p
      ..set(3, 6, fur)
      ..set(3, 5, fur)
      ..set(2, 4, lit);
  }
  p
    ..rect(4, 7, 11, 5, fur)
    ..rect(5, 7, 9, 1, lit)
    ..rect(5, 11, 9, 1, sh)
    ..rect(13, 3, 6, 6, fur)
    ..rect(14, 3, 4, 1, lit)
    ..rect(18, 6, 3, 3, lit)
    ..rect(13, 3, 2, 5, ear)
    ..rect(13, 9, 3, 1, 0xFFe0533f);
  const legs = [4, 7, 11, 14];
  for (var i = 0; i < 4; i++) {
    final up = f == 1 && i.isEven || f == 2 && i.isOdd;
    p.rect(legs[i], 12, 2, up ? 1 : 2, sh);
  }
  p.outline(0xFF3a2414);
  p
    ..set(20, 6, 0xFF231815)
    ..set(16, 5, 0xFF231815);
  return p;
}

/// Galinha branca de crista vermelha. Quadros: 0 parada, 1-2 andando, 3
/// bicando o chão.
Pix _chicken(int f) {
  const white = 0xFFf4f1e8, sh = 0xFFd6cfbf, red = 0xFFe0533f;
  const beak = 0xFFf2b43a;
  final p = Pix(16, 16)
    ..oval(7, 9, 4.5, 3.2, white)
    ..rect(2, 5, 2, 4, white)
    ..rect(4, 11, 6, 1, sh)
    ..rect(5, 8, 3, 2, sh);
  final peck = f == 3;
  final hx = peck ? 10 : 9, hy = peck ? 8 : 3;
  p.rect(hx, hy, 3, 4, white);
  for (final (x, up) in [(6, f == 1), (8, f == 2)]) {
    p.rect(x, 12, 1, up ? 1 : 2, beak);
  }
  p.outline(0xFF4a3a2a);
  p
    ..set(hx, hy - 1, red)
    ..set(hx + 1, hy - 1, red)
    ..set(hx + 3, hy + 1, beak)
    ..set(hx + 2, hy + 3, red)
    ..set(hx + 2, hy + 1, 0xFF231815);
  return p;
}

/// Gato cinza rajado enrolado, de olhos fechados. Quadros: 0 rabo deitado,
/// 1 a ponta do rabo levantada.
Pix _cat(int f) {
  const fur = 0xFF8f949e, lit = 0xFFb9bdc6, dark = 0xFF5d626c;
  final p = Pix(20, 14)
    ..oval(11, 8, 7, 3.6, fur)
    ..rect(7, 5, 8, 1, lit)
    ..oval(5, 7.5, 3.4, 3, fur)
    ..rect(3, 3, 2, 2, fur)
    ..rect(6, 3, 2, 2, fur)
    ..rect(6, 11, 10, 1, dark);
  if (f == 1) {
    p
      ..set(17, 10, dark)
      ..set(18, 9, dark)
      ..set(18, 8, lit);
  } else {
    p
      ..set(17, 11, dark)
      ..set(18, 11, lit);
  }
  for (final x in [9, 12, 15]) {
    p.rect(x, 6, 1, 2, dark);
  }
  p.outline(0xFF3a3d45);
  p
    ..set(4, 4, 0xFFe7a3a8)
    ..set(7, 4, 0xFFe7a3a8)
    ..rect(3, 8, 2, 1, 0xFF231815)
    ..rect(6, 8, 2, 1, 0xFF231815);
  return p;
}
