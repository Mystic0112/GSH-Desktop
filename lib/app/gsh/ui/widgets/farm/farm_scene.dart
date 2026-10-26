// Ported from clodfarm (github.com/matank001/clodfarm), MIT License, see third_party/clodfarm/LICENSE.

import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:gsh_desktop/app/gsh/domain/entities/farm_loop.dart';
import 'package:gsh_desktop/app/gsh/ui/viewmodels/farm_viewmodel.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/farm/farm_critter.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/farm/farm_pets.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/farm/farm_sprites.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/farm/farm_squad_looks.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/farm/farm_world.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/farm/pix.dart';
import 'package:gsh_desktop/app/core/ui/themes/agent_colors.dart';
import 'package:path/path.dart' as p;

export 'farm_critter.dart';
export 'farm_pets.dart';

part 'farm_scene_plots.dart';

/// Dono de um canteiro: um loop principal com os subagentes dele, ou só os
/// subagentes de um pai que saiu da janela ([main] `null`, [id] = o pai).
typedef _Owner = ({
  String id,
  String project,
  FarmLoop? main,
  List<FarmLoop> subs,
});

/// A cena viva (o `Scene` + `reconcile` do clodfarm, sem DOM): os bichos, os
/// canteiros de cada loop e as faíscas. Não desenha: o painter lê daqui.
class FarmScene {
  FarmScene({math.Random? rnd}) : rnd = rnd ?? math.Random();

  final math.Random rnd;
  FarmLayout? layout;
  final critters = <String, Critter>{};
  final sparks = <FarmSpark>[];

  /// Poeirinhas de quem acabou de chegar ou de sair (ver [FarmPuff]).
  final puffs = <FarmPuff>[];

  /// Os bichinhos de estimação (ver [placePets]).
  final pets = <FarmPet>[];
  final _plotOf = <String, int>{};
  List<FarmPlotInfo?> plotInfo = const [];

  /// Relógio da cena em segundos.
  double t = 0;
  bool _first = true;

  /// Algum principal trabalhando (o espantalho acorda).
  bool working = false;

  /// Algum bicho desenhado trabalhando: a fazenda anima no ritmo cheio.
  bool busy = false;

  bool _dirty = true;
  int _key = 0;

  /// Relógio lento (degraus de 1/4 s) das animações de fundo: plantação
  /// balançando, "z" de quem dorme, respiração. Em degraus, os quadros entre
  /// um degrau e outro saem iguais e não precisam ser repintados.
  double get calm => (t * 4).floor() / 4;

  /// Quanto a fazenda precisa caber: canteiros e vagas no curral.
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

  /// Vaga escolhida para o primeiro canteiro de cada projeto (pela pasta),
  /// vinda das preferências; quem não tem fica com a posição automática.
  Map<String, int> pins = const {};

  /// Projeto (pasta) dono de cada canteiro, `null` = vago.
  List<String?> plotProject = const [];

  /// Canteiro sendo arrastado e a vaga sob o mouse (o painter destaca).
  int? dragFrom, dragTo;

  /// Põe a cena de acordo com os loops do ViewModel.
  void sync(List<FarmPlot> plots) {
    _last = plots;
    _dirty = true;
    final mains = [for (final pl in plots) ...pl.mains];
    final mainIds = {for (final m in mains) m.id};
    final subsOf = <String, List<FarmLoop>>{};
    for (final pl in plots) {
      for (final l in pl.loops) {
        if (l.isSubagent) (subsOf[l.parentId!] ??= []).add(l);
      }
    }
    final owners = <_Owner>[
      for (final pl in plots) ...[
        for (final m in pl.mains)
          (id: m.id, project: m.project, main: m, subs: subsOf[m.id] ?? []),
        // órfãos: o pai saiu da janela, mas eles seguem trabalhando
        for (final MapEntry(key: pid, value: subs) in subsOf.entries)
          if (!mainIds.contains(pid) && subs.first.project == pl.project)
            (id: pid, project: pl.project, main: null, subs: subs),
      ],
    ];
    final sleepers =
        mains
            .where((m) => m.activity == FarmActivity.sleeping)
            .map((m) => m.id)
            .toList()
          ..sort();
    // a fazenda cresce até a vaga mais longe escolhida para quem está à vista
    final pinned = [
      for (final o in owners)
        if (pins[o.project] case final i?) i + 1,
    ];
    need = (
      plots: math.max(owners.length, pinned.fold(0, math.max)),
      yard: sleepers.length,
    );
    final l = layout;
    if (l == null) return;
    // canteiros ficam: um loop guarda o seu enquanto existe (e os órfãos
    // herdam o do pai); um novo pega o primeiro livre depois dos do mesmo
    // projeto, ou a partir da vaga escolhida para o projeto. Os projetos com
    // vaga escolhida escolhem primeiro.
    final ids = owners.map((o) => o.id).toSet();
    _plotOf.removeWhere((id, i) => !ids.contains(id) || i >= l.plots.length);
    final taken = _plotOf.values.toSet();
    int rank(_Owner o) => pins[o.project] ?? l.plots.length;
    final order = [for (final (i, o) in owners.indexed) (i, o)]
      ..sort((a, b) {
        final c = rank(a.$2).compareTo(rank(b.$2));
        return c != 0 ? c : a.$1.compareTo(b.$1);
      });
    for (final (_, o) in order) {
      if (_plotOf.containsKey(o.id)) continue;
      final sib = owners
          .where((x) => x.project == o.project && _plotOf.containsKey(x.id))
          .map((x) => _plotOf[x.id]!);
      var free = sib.isEmpty ? pins[o.project] ?? 0 : sib.reduce(math.max) + 1;
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
      _plotOf[o.id] = free;
      taken.add(free);
    }
    final info = List<FarmPlotInfo?>.filled(l.plots.length, null);
    plotProject = List<String?>.filled(l.plots.length, null);
    final want = <String, (CritterMode, ui.Offset?, ui.Offset?)>{};
    final loops = <String, FarmLoop>{};
    final room = <String, double>{};
    for (final o in owners) {
      final pi = _plotOf[o.id];
      if (pi == null) continue;
      final plot = l.plots[pi];
      plotProject[pi] = o.project;
      final m = o.main;
      final subs = [...o.subs]..sort((a, b) => _rank(a).compareTo(_rank(b)));
      // time: o lead é quem tem teammate à vista; todos levam a cor dele
      final lead = m == null
          ? null
          : m.isTeammate
          ? mains.where((x) => x.id == m.parentId).firstOrNull
          : mains.any((x) => x.isTeammate && x.parentId == m.id)
          ? m
          : null;
      info[pi] = FarmPlotInfo(
        team: lead == null ? null : _colorOf(lead),
        main: m,
        title: m?.title ?? subs.first.title,
        project: p.basename(o.project),
        stage: _stage(
          m?.outputTokens ?? subs.fold(0, (n, s) => n + s.outputTokens),
        ),
        more: math.max(0, subs.length - subSpots.length),
        minis: math.min(subs.length, subSpots.length),
      );
      if (m != null) {
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
      }
      for (var n = 0; n < subs.length && n < subSpots.length; n++) {
        final s = subs[n];
        loops[s.id] = s;
        // até 4, um mini a cada 20 px de mundo; mais que isso, a cada 10
        room[s.id] = subs.length > 4 ? 10 : 20;
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
    // o nome da pasta só no primeiro canteiro de cada projeto
    plotInfo = [
      for (var i = 0; i < info.length; i++)
        info[i] == null || i == 0 || info[i - 1]?.project != info[i]!.project
            ? info[i]
            : info[i]!.unlabeled,
    ];
    working = mains.any((m) => m.activity.status == FarmStatus.working);
    busy = loops.values.any((m) => m.activity.status == FarmStatus.working);
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
        if (!_first) {
          _puff(pos.dx, pos.dy, born: true, mini: loop.isSubagent);
          sparkle(pos.dx, pos.dy - 8, loop.isSubagent ? 3 : 6);
        }
        critters[id] = c;
      } else if (c.mode != CritterMode.done && mode == CritterMode.done) {
        c.cheerUntil = t + 2.5;
        sparkle(c.x, c.y - 6, 10);
      }
      final squad = squadLookOf(loop);
      c
        ..loop = loop
        ..gone = null
        ..mode = mode
        ..spot = spot
        ..home = home
        ..squad = squad
        ..room = room[id] ?? 20
        ..color = _colorOf(loop);
      if (!loop.isSubagent) {
        c.skin = squad == null
            ? FarmSkin.of(id, c.color)
            : FarmSkin.of(
                id,
                squad.color,
                fixed: true,
                hat: squad.hat,
                body: squad.body,
              );
      }
      if (mode != CritterMode.work) c.stroll = null;
    });
    for (final c in critters.values) {
      if (!want.containsKey(c.loop.id) && c.gone == null) {
        c.gone = t;
        _puff(c.x, c.y, born: false, mini: c.mini);
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

  /// A cor do bicho: a do agente do squad, senão a do tipo (ou do id).
  static int _colorOf(FarmLoop l) =>
      squadLookOf(l)?.color ?? argbOf(agentColorFor(l.agentType ?? l.id));

  static int _rank(FarmLoop l) => switch (l.activity.status) {
    FarmStatus.working => 0,
    FarmStatus.waiting => 1,
    FarmStatus.idle => l.activity == FarmActivity.done ? 3 : 2,
  };

  /// A plantação mostra o trabalho: cresce com os tokens gerados.
  static CropStage _stage(int tokens) => tokens < 5000
      ? CropStage.seed
      : tokens < 30000
      ? CropStage.sprout
      : tokens < 150000
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

  void _puff(double x, double y, {required bool born, required bool mini}) {
    // aba escondida não anda o relógio: não deixa a fila crescer à toa
    if (puffs.length < 40) puffs.add(FarmPuff(x, y, t, born: born, mini: mini));
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

  /// Avança a cena [dt] segundos. Devolve se o quadro mudou (senão, nem
  /// precisa repintar).
  bool update(double dt) {
    t += dt;
    for (final c in critters.values) {
      c.update(dt, this);
    }
    final lay = layout;
    if (lay != null) {
      for (final p in pets) {
        p.update(dt, lay);
      }
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
    puffs.removeWhere((p) => t - p.t0 > FarmPuff.life);
    for (final s in sparks) {
      s
        ..x += s.vx * dt
        ..y += s.vy * dt
        ..vy += 40 * dt;
    }
    final key = _frameKey();
    final dirty =
        _dirty || sparks.isNotEmpty || puffs.isNotEmpty || key != _key;
    _key = key;
    _dirty = false;
    return dirty;
  }

  /// Tudo o que muda de um quadro para outro, num número: plantação e
  /// espantalho (pelos relógios deles) e cada bicho ([Critter.frameKey]).
  int _frameKey() {
    final c = calm;
    var h = Object.hash(c, working ? (t * 2.8).floor() : -1);
    for (final b in critters.values) {
      h = Object.hash(h, b.frameKey(t, c));
    }
    for (final p in pets) {
      h = Object.hash(h, p.frameKey(t, c));
    }
    return h;
  }

  /// Solta os bichinhos no mundo novo: cachorro e galinha passeando na
  /// fazenda, o gato no sofá do escritório (sem sofá, no último pufe do
  /// lounge: o layout sempre deixa vagas sobrando, ninguém senta nele).
  void placePets({required bool office}) {
    final l = layout;
    pets.clear();
    if (l == null) return;
    if (office) {
      final sofa = l.decor.where((d) => d.kind == 'sofa').firstOrNull;
      final at = sofa == null
          ? l.yardSpot(l.capYard - 1) + const ui.Offset(0, -1)
          : ui.Offset(sofa.x - 3, sofa.y - 2);
      pets.add(FarmPet(PetKind.cat, at.dx, at.dy, rnd));
      return;
    }
    for (final k in const [PetKind.dog, PetKind.chicken]) {
      final s = randomSpot();
      pets.add(FarmPet(k, s.dx, s.dy, rnd));
    }
  }

  /// O bichinho sob o ponto (pixels de mundo): leva um carinho.
  FarmPet? petAt(ui.Offset p) {
    final pet = pets.where((x) => x.hit(p)).firstOrNull;
    pet?.petAt = t;
    return pet;
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

/// O efeito de nascer ou sumir de um bicho, no chão onde ele está: uma
/// coluna de luz (sobe ao nascer, apaga ao sumir) e um anel de poeirinha que
/// se abre e some em [life] segundos.
class FarmPuff {
  FarmPuff(this.x, this.y, this.t0, {required this.born, required this.mini});
  final double x, y, t0;
  final bool born, mini;
  static const life = 0.6;
}

/// Estrelinha que cai piscando.
class FarmSpark {
  FarmSpark(this.x, this.y, this.vx, this.vy, this.life, this.k, this.color);
  double x, y, vx, vy, life;
  final int k;
  final int? color;
}
