// Ported from clodfarm (github.com/matank001/clodfarm), MIT License, see third_party/clodfarm/LICENSE.

import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:gsh_desktop/app/gsh/domain/entities/farm_loop.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/farm/farm_scene.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/farm/farm_sprites.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/farm/farm_squad_looks.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/farm/farm_world.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/farm/pix.dart';

/// O que o bicho está fazendo na cena (não é a [FarmActivity]: é a pose).
enum CritterMode {
  /// No canteiro, digitando no laptop.
  work,

  /// No canteiro, parado, com o balão de alerta: precisa de alguém.
  wait,

  /// Passeando em volta do celeiro.
  wander,

  /// Sentado no curral, olhos fechados.
  sleep,

  /// Subagente que terminou: comemora e apaga.
  done,
}

/// Rumos tentados quando o caminho reto bate num obstáculo: de 30° em 30°
/// até 150°, todos para o lado preferido antes do outro (segue a parede
/// pela mesma mão, sem ziguezague).
const _turns = [0.0, 0.52, 1.05, 1.57, 2.09, 2.62];

/// Um bicho da fazenda (o `Critter` do clodfarm): um Clawd por loop
/// principal ou um mini por subagente.
class Critter {
  Critter(this.loop, this.x, this.y, this.born, math.Random rnd)
    : tx = x,
      ty = y,
      wait = rnd.nextDouble() * 2,
      blinkT = 2 + rnd.nextDouble() * 3,
      lookT = 1 + rnd.nextDouble() * 4,
      speed = 20 + rnd.nextDouble() * 6,
      side = rnd.nextBool() ? 1 : -1,
      seed = (hashStr(loop.id) % 97) / 7;

  FarmLoop loop;
  double x, y, tx, ty, wait, blinkT, lookT, speed;
  final double seed;
  double born;
  double blink = 0, phaseT = 0, hop = 0, roam = 0;
  double? gone, strollT, cheerUntil;
  int dir = 0, phase = 0, step = 0, look = 0;

  /// Para que lado ele contorna obstáculos (fica o mesmo até chegar).
  int side;
  bool moving = false;
  ui.Offset? spot, home, stroll;
  CritterMode mode = CritterMode.wander;
  late FarmSkin skin;
  int color = 0;

  /// Visual fixo do agente do squad, ou `null` (visual sorteado).
  SquadLook? squad;

  /// Largura livre embaixo do mini para o nome (pixels de mundo).
  double room = 20;

  /// O caminho até o destino atual (desvia de cerca, parede e mesa).
  final route = FarmRoute();

  bool get mini => loop.isSubagent;

  void update(double dt, FarmScene scene) {
    final rnd = scene.rnd;
    blinkT -= dt;
    if (blinkT < 0) {
      blink = 0.14;
      blinkT = 2 + rnd.nextDouble() * 4;
    }
    blink = math.max(0, blink - dt);
    ui.Offset? goal;
    final s = spot;
    if (mini && s != null) {
      goal = s;
    } else if (mode == CritterMode.work && s != null) {
      // trabalhando ele não fica parado: de vez em quando dá uma volta no
      // canteiro para olhar a plantação e volta
      strollT = (strollT ?? 4 + rnd.nextDouble() * 10) - dt;
      if (strollT! < 0) {
        if (stroll != null) {
          stroll = null;
          strollT = 6 + rnd.nextDouble() * 12;
        } else {
          stroll = _strollSpot(s, scene);
          strollT = 2 + rnd.nextDouble() * 2.5;
        }
      }
      goal = stroll ?? s;
    } else if (mode == CritterMode.wait && s != null) {
      goal = s;
    } else if (mode == CritterMode.sleep) {
      goal = home;
    }
    lookT -= dt;
    if (lookT < 0) {
      look = look != 0 ? 0 : (rnd.nextBool() ? -1 : 1);
      lookT = look != 0
          ? 0.8 + rnd.nextDouble()
          : (mode == CritterMode.wait ? 0.6 : 2) + rnd.nextDouble() * 4;
    }
    if (goal != null) {
      tx = goal.dx;
      ty = goal.dy;
    } else if ((tx - x).abs() + (ty - y).abs() < 1.5 || roam > 12) {
      // chegou (ou rodou demais contornando): escolhe outro lugar
      wait -= dt;
      if (wait <= 0 || roam > 12) {
        final p = scene.randomSpot();
        tx = p.dx;
        ty = p.dy;
        wait = 1 + rnd.nextDouble() * 4;
        roam = 0;
        side = rnd.nextBool() ? 1 : -1;
      }
    }
    final l = scene.layout;
    final w = route.next(l?.nav, ui.Offset(x, y), ui.Offset(tx, ty));
    final dx = w.dx - x, dy = w.dy - y;
    if (dx.abs() + dy.abs() < 1.2) {
      moving = false;
      phase = 0;
      step = 0;
      if (mode == CritterMode.work) dir = 1;
    } else {
      final dist = math.sqrt(dx * dx + dy * dy);
      moving = true;
      final sp = math.min((mode == CritterMode.work ? 34 : speed) * dt, dist);
      var (ux, uy) = (dx / dist, dy / dist);
      if (goal == null && l != null && !route.active && !l.blocked(x, y)) {
        // passeando, não atravessa lago nem celeiro: contorna
        roam += dt;
        final free = _steer(l, ux, uy, sp, dist);
        if (free == null) {
          tx = x;
          ty = y;
          wait = 0;
          ux = uy = 0;
        } else {
          (ux, uy) = free;
        }
      }
      x += ux * sp;
      y += uy * sp;
      if (ux.abs() > 0.3) dir = ux.sign.toInt();
      phaseT += dt; // o passo: pisa, passa, pisa o outro, passa
      if (phaseT > 0.11) {
        phaseT = 0;
        step = (step + 1) % 4;
        phase = const [1, 0, 2, 0][step];
      }
    }
    if (mode == CritterMode.wait) hop = (hop + dt * 4) % (math.pi * 2);
  }

  /// Onde dar a volta trabalhando: perto do canteiro, num lugar onde dá
  /// para pisar (no escritório, o corredor em volta da ilha, nunca em cima
  /// das mesas). Sem grade, o miolo do canteiro, como antes.
  ui.Offset? _strollSpot(ui.Offset s, FarmScene scene) {
    final rnd = scene.rnd, nav = scene.layout?.nav;
    if (nav == null) {
      return ui.Offset(
        s.dx + 4 + rnd.nextDouble() * 30,
        s.dy - 2 - rnd.nextDouble() * 24,
      );
    }
    for (var i = 0; i < 8; i++) {
      final p = ui.Offset(
        s.dx - 4 + rnd.nextDouble() * 50,
        s.dy - 30 + rnd.nextDouble() * 38,
      );
      if (nav.walkable(p.dx, p.dy)) return p;
    }
    return null;
  }

  /// O primeiro rumo livre perto de (ux, uy), olhando um pouco à frente
  /// (sem encostar na borda), para o lado preferido primeiro. `null` = cercado.
  (double, double)? _steer(
    FarmLayout l,
    double ux,
    double uy,
    double sp,
    double dist,
  ) {
    final ahead = math.min(sp + 4, dist);
    for (final sgn in [side, -side]) {
      for (final a in _turns) {
        if (a == 0 && sgn != side) continue;
        final c = math.cos(a * sgn), s = math.sin(a * sgn);
        final vx = ux * c - uy * s, vy = ux * s + uy * c;
        if (l.blocked(x + vx * ahead, y + vy * ahead) ||
            l.blocked(x + vx * sp, y + vy * sp)) {
          continue;
        }
        side = sgn;
        return (vx, vy);
      }
    }
    return null;
  }

  bool cheering(double now) =>
      (cheerUntil != null && now < cheerUntil!) || now - born < 1.8;

  ui.Image sprite(double t, double now) {
    final blinking = blink > 0;
    if (mini) {
      final done = mode == CritterMode.done;
      return miniHD(
        done && !cheering(now) ? 0xFF9aa3b2 : color,
        legs: phase,
        blink: blinking || mode == CritterMode.sleep,
        arms:
            (mode == CritterMode.work &&
                    !moving &&
                    (t * 6 + seed).floor().isOdd) ||
                (done && cheering(now) && (t * 5).floor().isOdd)
            ? 1
            : 0,
        hat: squad?.hat,
        body: squad?.body ?? clay,
      );
    }
    final sleep = mode == CritterMode.sleep && !moving;
    final typing = mode == CritterMode.work && !moving && stroll == null;
    final cheer = cheering(now);
    return skin.frame(
      look: moving || typing ? dir : look,
      legs: phase,
      // dormindo os olhos já estão fechados: piscar não muda o quadro
      blink: blinking && !sleep,
      sleep: sleep,
      arms: typing
          ? ((t * 7 + seed).floor().isOdd ? 2 : 3)
          : cheer && !moving
          ? ((t * 5).floor().isOdd ? 1 : 0)
          : 0,
      happy: cheer && !sleep,
    );
  }

  /// Quanto ele sobe neste quadro, em pixels de mundo (meios: a grade HD).
  /// [calm] é o relógio lento da cena (o respirar de quem está parado).
  double bob(double t, double now, double calm) {
    if (mode == CritterMode.wait && !moving) {
      return -(math.sin(hop).abs() * 2.5 * 2).round() / 2;
    }
    if (!moving && cheering(now)) {
      return -((math.sin(t * 8).abs() * 5).round()) / 2;
    }
    if (moving) return step.isOdd ? -0.5 : 0;
    if (mini) return 0;
    if (mode == CritterMode.sleep) {
      return math.sin(calm * 1.6 + seed) > 0.2 ? 0.5 : 0;
    }
    return math.sin(calm * 2 + seed) > 0.7 ? -0.5 : 0;
  }

  /// Quadro do laptop (e do led do mini) digitando.
  int typingFrame(double t) => (t * 3 + seed).floor() % 2;

  /// Fase (0..1) do k-ésimo "z" de quem dorme, no relógio lento.
  double zPhase(double calm, int k) => (calm * 0.4 + k * 0.5 + seed) % 1;

  /// Opacidade de nascer/sumir/terminado.
  double fade(double t) {
    var f = gone != null
        ? clampD(1 - (t - gone!) / 0.5, 0, 1)
        : clampD((t - born) / 0.35, 0, 1);
    if (mode == CritterMode.done && !cheering(t)) f *= 0.45;
    return f;
  }

  /// Tudo o que o painter desenha deste bicho neste quadro, num número: se
  /// não mudou, o quadro não precisa ser repintado.
  int frameKey(double t, double calm) {
    var h = Object.hash(
      (x * hd).round(),
      (y * hd).round(),
      identityHashCode(sprite(t, t)),
      (bob(t, t, calm) * 2).round(),
      (fade(t) * 64).round(),
      mode,
      moving,
      stroll == null,
    );
    if (mode == CritterMode.work) h = Object.hash(h, typingFrame(t));
    if (mode == CritterMode.wait) {
      h = Object.hash(h, (t * 3).floor(), (t * 4).floor());
    }
    if (mode == CritterMode.sleep) h = Object.hash(h, calm);
    return h;
  }

  /// Ícone do balão sobre a cabeça.
  FarmIcon get icon => switch (loop.activity) {
    FarmActivity.thinking => FarmIcon.dots,
    FarmActivity.reading => FarmIcon.scroll,
    FarmActivity.editing => FarmIcon.quill,
    FarmActivity.running => FarmIcon.terminal,
    FarmActivity.searching => FarmIcon.globe,
    FarmActivity.delegating => FarmIcon.tasks,
    FarmActivity.tooling => FarmIcon.gear,
    FarmActivity.waiting => FarmIcon.alert,
    FarmActivity.idle => FarmIcon.pause,
    FarmActivity.sleeping => FarmIcon.zzz,
    FarmActivity.done => FarmIcon.heart,
  };
}
