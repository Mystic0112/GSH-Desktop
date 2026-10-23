// Ported from clodfarm (github.com/matank001/clodfarm), MIT License, see third_party/clodfarm/LICENSE.

import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:gsh_desktop/app/gsh/domain/entities/farm_loop.dart';
import 'package:gsh_desktop/app/gsh/ui/viewmodels/farm_viewmodel.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/farm/farm_sprites.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/farm/farm_world.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/farm/pix.dart';
import 'package:gsh_desktop/app/core/ui/themes/agent_colors.dart';
import 'package:path/path.dart' as p;

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
      seed = (hashStr(loop.id) % 97) / 7;

  FarmLoop loop;
  double x, y, tx, ty, wait, blinkT, lookT, speed;
  final double seed;
  double born;
  double blink = 0, phaseT = 0, hop = 0;
  double? gone, strollT, cheerUntil;
  int dir = 0, phase = 0, step = 0, look = 0;
  bool moving = false;
  ui.Offset? spot, home, stroll;
  CritterMode mode = CritterMode.wander;
  late FarmSkin skin;
  int color = 0;

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
          stroll = ui.Offset(
            s.dx + 4 + rnd.nextDouble() * 30,
            s.dy - 2 - rnd.nextDouble() * 24,
          );
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
    } else if ((tx - x).abs() + (ty - y).abs() < 1.5) {
      wait -= dt;
      if (wait <= 0) {
        final p = scene.randomSpot();
        tx = p.dx;
        ty = p.dy;
        wait = 1 + rnd.nextDouble() * 4;
      }
    }
    final dx = tx - x, dy = ty - y;
    if (dx.abs() + dy.abs() < 1.2) {
      moving = false;
      phase = 0;
      step = 0;
      if (mode == CritterMode.work) dir = 1;
    } else {
      final dist = math.sqrt(dx * dx + dy * dy);
      moving = true;
      final sp = (mode == CritterMode.work ? 34 : speed) * dt;
      final nx = x + dx / dist * math.min(sp, dist);
      final ny = y + dy / dist * math.min(sp, dist);
      final l = scene.layout;
      if (goal == null && l != null && l.blocked(nx, ny) && !l.blocked(x, y)) {
        // passeando, não atravessa lago nem celeiro: escolhe outro lugar
        tx = x;
        ty = y;
        wait = 0;
      } else {
        x = nx;
        y = ny;
      }
      if (dx.abs() > 0.5) dir = dx.sign.toInt();
      phaseT += dt; // o passo: pisa, passa, pisa o outro, passa
      if (phaseT > 0.11) {
        phaseT = 0;
        step = (step + 1) % 4;
        phase = const [1, 0, 2, 0][step];
      }
    }
    if (mode == CritterMode.wait) hop = (hop + dt * 4) % (math.pi * 2);
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
      );
    }
    final sleep = mode == CritterMode.sleep && !moving;
    final typing = mode == CritterMode.work && !moving && stroll == null;
    final cheer = cheering(now);
    return skin.frame(
      look: moving || typing ? dir : look,
      legs: phase,
      blink: blinking,
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
  double bob(double t, double now) {
    if (mode == CritterMode.wait && !moving) {
      return -(math.sin(hop).abs() * 2.5 * 2).round() / 2;
    }
    if (!moving && cheering(now)) {
      return -((math.sin(t * 8).abs() * 5).round()) / 2;
    }
    if (moving) return step.isOdd ? -0.5 : 0;
    if (mini) return 0;
    if (mode == CritterMode.sleep) {
      return math.sin(t * 1.6 + seed) > 0.2 ? 0.5 : 0;
    }
    return math.sin(t * 2 + seed) > 0.7 ? -0.5 : 0;
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

/// O que está plantado num canteiro.
class FarmPlotInfo {
  const FarmPlotInfo({
    required this.main,
    required this.project,
    required this.stage,
    required this.more,
  });
  final FarmLoop? main;

  /// Nome da pasta, só no primeiro canteiro de cada projeto.
  final String? project;
  final CropStage stage;

  /// Subagentes além dos [subSpots] (a plaquinha "+N").
  final int more;
}

/// A cena viva (o `Scene` + `reconcile` do clodfarm, sem DOM): os bichos, os
/// canteiros de cada loop e as faíscas. Não desenha: o painter lê daqui.
class FarmScene {
  FarmScene({math.Random? rnd}) : rnd = rnd ?? math.Random();

  final math.Random rnd;
  FarmLayout? layout;
  final critters = <String, Critter>{};
  final sparks = <FarmSpark>[];
  final _plotOf = <String, int>{};
  List<FarmPlotInfo?> plotInfo = const [];

  /// Relógio da cena em segundos.
  double t = 0;
  bool _first = true;
  bool working = false;

  /// Quanto a fazenda precisa caber: canteiros (principais) e vagas no curral.
  ({int plots, int yard}) need = (plots: 0, yard: 0);

  /// O layout atual não comporta [need]: reconstruir o mundo.
  bool get outgrown {
    final l = layout;
    if (l == null) return true;
    return need.plots > l.capPlots ||
        need.yard > l.capYard ||
        (l.capPlots > 8 && need.plots < l.capPlots * 0.45);
  }

  List<FarmPlot> _last = const [];

  /// Põe a cena de acordo com os loops do ViewModel.
  void sync(List<FarmPlot> plots) {
    _last = plots;
    final mains = [for (final pl in plots) ...pl.mains];
    final sleepers =
        mains
            .where((m) => m.activity == FarmActivity.sleeping)
            .map((m) => m.id)
            .toList()
          ..sort();
    need = (plots: mains.length, yard: sleepers.length);
    final l = layout;
    if (l == null) return;
    // canteiros ficam: um loop guarda o seu enquanto existe; um novo pega o
    // primeiro livre depois dos do mesmo projeto
    final ids = mains.map((m) => m.id).toSet();
    _plotOf.removeWhere((id, i) => !ids.contains(id) || i >= l.plots.length);
    final taken = _plotOf.values.toSet();
    for (final m in mains) {
      if (_plotOf.containsKey(m.id)) continue;
      final sib = mains
          .where((o) => o.project == m.project && _plotOf.containsKey(o.id))
          .map((o) => _plotOf[o.id]!);
      var free = sib.isEmpty ? 0 : sib.reduce(math.max) + 1;
      while (taken.contains(free)) {
        free++;
      }
      if (free >= l.plots.length) {
        free = 0;
        while (taken.contains(free)) {
          free++;
        }
      }
      if (free >= l.plots.length) break;
      _plotOf[m.id] = free;
      taken.add(free);
    }
    final info = List<FarmPlotInfo?>.filled(l.plots.length, null);
    final want = <String, (CritterMode, ui.Offset?, ui.Offset?)>{};
    final loops = <String, FarmLoop>{};
    for (final pl in plots) {
      for (final m in pl.mains) {
        final pi = _plotOf[m.id];
        if (pi == null) continue;
        final plot = l.plots[pi];
        final subs = pl.subagentsOf(m.id).toList()
          ..sort((a, b) => _rank(a).compareTo(_rank(b)));
        info[pi] = FarmPlotInfo(
          main: m,
          project: p.basename(m.project),
          stage: _stage(m),
          more: math.max(0, subs.length - subSpots.length),
        );
        final yi = sleepers.indexOf(m.id);
        loops[m.id] = m;
        want[m.id] = (
          switch (m.activity) {
            FarmActivity.waiting => CritterMode.wait,
            FarmActivity.sleeping => CritterMode.sleep,
            FarmActivity.idle || FarmActivity.done => CritterMode.wander,
            _ => CritterMode.work,
          },
          ui.Offset(plot.left - 7, plot.bottom),
          yi < 0 ? null : l.yardSpot(yi),
        );
        for (var n = 0; n < subs.length && n < subSpots.length; n++) {
          final s = subs[n];
          loops[s.id] = s;
          want[s.id] = (
            switch (s.activity) {
              FarmActivity.done => CritterMode.done,
              FarmActivity.waiting => CritterMode.wait,
              FarmActivity.idle || FarmActivity.sleeping => CritterMode.sleep,
              _ => CritterMode.work,
            },
            ui.Offset(plot.left + subSpots[n].$1, plot.top + subSpots[n].$2),
            null,
          );
        }
      }
    }
    // o nome da pasta só no primeiro canteiro de cada projeto
    plotInfo = [
      for (var i = 0; i < info.length; i++)
        info[i] == null || i == 0 || info[i - 1]?.project != info[i]!.project
            ? info[i]
            : FarmPlotInfo(
                main: info[i]!.main,
                project: null,
                stage: info[i]!.stage,
                more: info[i]!.more,
              ),
    ];
    working = mains.any((m) => m.activity.status == FarmStatus.working);
    want.forEach((id, w) {
      final (mode, spot, home) = w;
      final loop = loops[id]!;
      var c = critters[id];
      final at =
          loop.isSubagent ||
              mode == CritterMode.work ||
              mode == CritterMode.wait
          ? spot
          : home;
      if (c == null) {
        var pos = _first
            ? randomSpot()
            : l.door + ui.Offset(rnd.nextDouble() * 6 - 3, 4);
        final owner = loop.parentId == null ? null : critters[loop.parentId];
        if (owner != null) pos = ui.Offset(owner.x, owner.y);
        if (_first && at != null) pos = at;
        c = Critter(loop, pos.dx, pos.dy, _first ? t - 5 : t, rnd);
        if (!_first) sparkle(pos.dx, pos.dy - 8, loop.isSubagent ? 8 : 16);
        critters[id] = c;
      } else if (c.mode != CritterMode.done && mode == CritterMode.done) {
        c.cheerUntil = t + 2.5;
        sparkle(c.x, c.y - 6, 10);
      }
      c
        ..loop = loop
        ..gone = null
        ..mode = mode
        ..spot = spot
        ..home = home
        ..color = argbOf(agentColorFor(loop.agentType ?? loop.id));
      if (!loop.isSubagent) c.skin = FarmSkin.of(loop.id, c.color);
      if (mode != CritterMode.work) c.stroll = null;
    });
    for (final c in critters.values) {
      if (!want.containsKey(c.loop.id) && c.gone == null) {
        c.gone = t;
        sparkle(c.x, c.y - 8, 8, 0xFFd8e6c4);
      }
    }
    if (want.isNotEmpty) _first = false;
  }

  /// O mundo foi refeito: todo mundo vai direto para o lugar novo.
  void relayout(FarmLayout l) {
    layout = l;
    for (final c in critters.values) {
      if (c.x > l.w || c.y > l.h || l.blocked(c.x, c.y)) {
        final p = randomSpot();
        c
          ..x = p.dx
          ..y = p.dy;
      }
      c
        ..tx = c.x
        ..ty = c.y;
    }
    sync(_last);
    for (final c in critters.values) {
      final at =
          c.mini || c.mode == CritterMode.work || c.mode == CritterMode.wait
          ? c.spot
          : c.home;
      if (at != null) {
        c
          ..x = at.dx
          ..y = at.dy;
      }
    }
  }

  static int _rank(FarmLoop l) => switch (l.activity.status) {
    FarmStatus.working => 0,
    FarmStatus.waiting => 1,
    FarmStatus.idle => l.activity == FarmActivity.done ? 3 : 2,
  };

  /// A plantação mostra o trabalho: cresce com os tokens gerados.
  static CropStage _stage(FarmLoop m) => m.outputTokens < 5000
      ? CropStage.seed
      : m.outputTokens < 30000
      ? CropStage.sprout
      : m.outputTokens < 150000
      ? CropStage.grow
      : CropStage.ripe;

  /// Um lugar livre para passear: em volta do celeiro, entre a borda da
  /// fazenda e o cercado (fora dali o HUD pode cobrir).
  ui.Offset randomSpot() {
    final l = layout;
    if (l == null) return ui.Offset.zero;
    final x0 = math.max(l.play.left + 8, l.content.left - 12);
    final x1 = l.field.left - 8;
    final y0 = math.max(l.play.top + 16, l.content.top);
    final y1 = math.min(l.play.bottom, l.content.bottom + 12);
    for (var i = 0; i < 60; i++) {
      final x = x0 + rnd.nextDouble() * (x1 - x0);
      final y = y0 + rnd.nextDouble() * (y1 - y0);
      if (!l.blocked(x, y)) return ui.Offset(x, y);
    }
    return l.door + const ui.Offset(0, 12);
  }

  void sparkle(double x, double y, int n, [int? color]) {
    if (sparks.length > 400) return;
    for (var i = 0; i < n; i++) {
      final a = rnd.nextDouble() * math.pi * 2, s = 10 + rnd.nextDouble() * 26;
      sparks.add(
        FarmSpark(
          x,
          y,
          math.cos(a) * s,
          math.sin(a) * s - 12,
          0.7 + rnd.nextDouble() * 0.5,
          i % 4,
          color,
        ),
      );
    }
  }

  /// Avança a cena [dt] segundos.
  void update(double dt) {
    t += dt;
    for (final c in critters.values) {
      c.update(dt, this);
    }
    critters.removeWhere((_, c) => c.gone != null && t - c.gone! > 0.52);
    // canteiro de quem trabalha brilha: uma faísca de vez em quando
    final l = layout;
    if (l != null) {
      for (var i = 0; i < plotInfo.length; i++) {
        final m = plotInfo[i]?.main;
        if (m == null || m.activity.status != FarmStatus.working) continue;
        if (rnd.nextDouble() < dt * 0.35) {
          final pl = l.plots[i];
          sparkle(pl.left + rnd.nextDouble() * pl.width, pl.top + 4, 3);
        }
      }
    }
    sparks.removeWhere((s) => (s.life -= dt) <= 0);
    for (final s in sparks) {
      s
        ..x += s.vx * dt
        ..y += s.vy * dt
        ..vy += 40 * dt;
    }
  }

  /// O bicho sob o ponto (em pixels de mundo), o da frente primeiro.
  Critter? hit(ui.Offset p) {
    Critter? best;
    for (final c in critters.values) {
      if (c.gone != null) continue;
      final w = c.mini ? 6 : 9, top = c.mini ? 10 : 19;
      if (p.dx > c.x - w &&
          p.dx < c.x + w &&
          p.dy > c.y - top &&
          p.dy < c.y + 2 &&
          (best == null || c.y > best.y)) {
        best = c;
      }
    }
    return best;
  }
}

/// Estrelinha que cai piscando.
class FarmSpark {
  FarmSpark(this.x, this.y, this.vx, this.vy, this.life, this.k, this.color);
  double x, y, vx, vy, life;
  final int k;
  final int? color;
}
