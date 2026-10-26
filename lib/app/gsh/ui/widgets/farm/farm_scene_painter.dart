// Ported from clodfarm (github.com/matank001/clodfarm), MIT License, see third_party/clodfarm/LICENSE.

import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:gsh_desktop/app/core/domain/entities/app_settings.dart'
    show FarmScenery;
import 'package:gsh_desktop/app/gsh/domain/entities/farm_loop.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/team_farm.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/farm/farm_courier.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/farm/farm_scene.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/farm/farm_sprites.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/farm/farm_squad_looks.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/farm/farm_team.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/farm/farm_world.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/farm/farm_camera.dart';
import 'package:flutter/widgets.dart';

export 'farm_camera.dart';

part 'farm_scene_effects.dart';
part 'farm_scene_overlay.dart';

/// O pedaço do mundo à vista, nas coordenadas de um lote.
typedef _View = ({double x0, double y0, double x1, double y1});

bool _seen(_View v, double x, double y, [double m = 24]) =>
    x > v.x0 - m && x < v.x1 + m && y > v.y0 - m && y < v.y1 + m + 20;

/// Textos medidos uma vez (etiquetas dos canteiros).
class FarmLabels {
  final _cache = <String, TextPainter>{};

  TextPainter of(String text, TextStyle style) => _cache.putIfAbsent(
    '${style.color?.toARGB32()}|${style.fontSize}|$text',
    () => TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout(),
  );

  void dispose() {
    for (final t in _cache.values) {
      t.dispose();
    }
    _cache.clear();
  }
}

/// Desenha um quadro da fazenda: fundo, plantação, espantalho, bichos em
/// ordem de profundidade, árvores da frente, faíscas, e por cima (em pixels
/// de tela, para ficarem nítidos) etiquetas e balões. As fazendas dos
/// colegas ([peers]) vão do mesmo jeito, cada uma no seu canto do mundo e
/// com a faixa do nome; lote fora da tela nem é visitado.
class FarmScenePainter extends CustomPainter {
  FarmScenePainter({
    required this.scene,
    required this.world,
    required this.cam,
    required this.labels,
    required this.label,
    required this.hover,
    required Listenable repaint,
    this.peers = const [],
    this.banner,
    this.me,
    this.couriers = const [],
  }) : super(repaint: repaint);

  final FarmScene scene;
  final FarmWorld? world;
  final List<FarmLot> peers;

  /// Mensageiros do time andando entre os lotes neste quadro.
  final List<CourierRun> couriers;

  /// O texto da faixa do colega (vem traduzido da view).
  final String Function(String name)? banner;

  /// A placa da minha fazenda/sala ("Você" ou o meu nome no time), só
  /// desenhada com colegas na tela.
  final String? me;
  final FarmCamera cam;
  final FarmLabels labels;
  final TextStyle label;
  final ValueNotifier<Critter?> hover;

  /// Zoom (px por pixel de mundo) a partir do qual a etiqueta fica grande
  /// (e a plaquinha da pasta aparece), os balões e os nomes dos minis.
  static const tagsAt = 2.0, bubblesAt = 1.9, miniBubblesAt = 3.6;
  static const miniNamesAt = 4.0;

  static final _img = Paint()..filterQuality = FilterQuality.none;
  static final _fill = Paint()..isAntiAlias = false;

  static double _hx(double v) => (v * hd).roundToDouble() / hd;

  void _draw(
    Canvas c,
    ui.Image img,
    double x,
    double y,
    double w,
    double h, [
    double a = 1,
  ]) {
    _img.color = Color.fromRGBO(0, 0, 0, a.clamp(0, 1));
    c.drawImageRect(
      img,
      Rect.fromLTWH(0, 0, img.width.toDouble(), img.height.toDouble()),
      Rect.fromLTWH(x, y, w, h),
      _img,
    );
  }

  void _rect(
    Canvas c,
    double x,
    double y,
    double w,
    double h,
    int color, [
    double a = 1,
  ]) => c.drawRect(
    Rect.fromLTWH(x, y, w, h),
    _fill..color = Color(color).withValues(alpha: Color(color).a * a),
  );

  @override
  void paint(Canvas canvas, Size size) {
    final w = world;
    // fora do mundo: mata na fazenda, asfalto no escritório
    final office = w?.scenery == FarmScenery.office;
    _rect(canvas, 0, 0, size.width, size.height, office ? 0xFF4a4d55 : t0);
    if (w == null) return;
    final r = cam.rt;
    canvas
      ..save()
      ..clipRect(Offset.zero & size)
      ..translate(r.ox / cam.dpr, r.oy / cam.dpr)
      ..scale(r.z);
    final gx0 = -r.ox / r.zr, gy0 = -r.oy / r.zr;
    final gx1 = gx0 + size.width * cam.dpr / r.zr;
    final gy1 = gy0 + size.height * cam.dpr / r.zr;
    final shown = <(FarmLot?, FarmScene, FarmWorld, _View, List<Critter>)>[];
    for (final (lot, sc, wd) in [
      (null, scene, w),
      for (final p in peers)
        if (p.world != null) (p, p.scene, p.world!),
    ]) {
      final at = lot?.at ?? Offset.zero, l = wd.layout;
      final v = (
        x0: gx0 - at.dx,
        y0: gy0 - at.dy,
        x1: gx1 - at.dx,
        y1: gy1 - at.dy,
      );
      if (v.x1 < 0 || v.y1 < 0 || v.x0 > l.w || v.y0 > l.h) continue;
      canvas
        ..save()
        ..translate(at.dx, at.dy);
      final list = _lot(canvas, sc, wd, v, lot?.clip ?? 0);
      canvas.restore();
      shown.add((lot, sc, wd, v, list));
    }
    // mensageiros por cima dos lotes (passam de um para o outro)
    final gv = (x0: gx0, y0: gy0, x1: gx1, y1: gy1);
    for (final c in couriers) {
      _courier(canvas, c, gv);
    }
    canvas.restore();
    for (final (lot, sc, wd, v, list) in shown) {
      _overlay(canvas, sc, wd, lot, list, r.z, v);
    }
    for (final c in couriers) {
      _delivered(canvas, c, r.z, gv);
    }
  }

  /// Um lote (fundo, plantação, bichos, árvores da frente, faíscas) em
  /// coordenadas dele; devolve os bichos em ordem de profundidade.
  List<Critter> _lot(
    Canvas canvas,
    FarmScene scene,
    FarmWorld w,
    _View v,
    double clip,
  ) {
    final l = w.layout, t = scene.t, calm = scene.calm;
    final vx0 = v.x0, vy0 = v.y0, vx1 = v.x1, vy1 = v.y1;
    final sx = math.max(0, vx0.floor()), sy = math.max(0, vy0.floor());
    final sw = math.min(l.w, vx1.ceil() + 1) - sx;
    final sh = math.min(l.h, vy1.ceil() + 1) - sy;
    _img.color = const Color(0xFF000000);
    // [clip]: a margem da esquerda do lote colado no vizinho não é desenhada
    final bx = math.max(sx.toDouble(), clip), bw = sx + sw - bx;
    if (bw > 0 && sh > 0) {
      canvas.drawImageRect(
        w.bg,
        Rect.fromLTWH(bx * hd, sy * hd.toDouble(), bw * hd, sh * hd.toDouble()),
        Rect.fromLTWH(bx, sy.toDouble(), bw, sh.toDouble()),
        _img,
      );
    }
    bool seen(double x, double y, [double m = 24]) => _seen(v, x, y, m);

    // plantação (no escritório, os monitores das mesas), e a plaquinha "+N"
    // de quem tem mais minis do que desenha
    final office = w.scenery == FarmScenery.office;
    for (var i = 0; i < l.plots.length; i++) {
      final p = l.plots[i];
      if (!seen(p.left, p.top, 40)) continue;
      final info = i < scene.plotInfo.length ? scene.plotInfo[i] : null;
      final stage = info?.stage ?? CropStage.seed;
      if (office) {
        // a tela acende e rola o código só com o dono trabalhando, pisca
        // amarela quando ele espera você e descansa apagada no resto
        final st = info?.main?.activity.status;
        final frames = monitors[stage]!;
        for (var row = 0; row < 2; row++) {
          for (var k = 0; k < 3; k++) {
            final img = switch (st) {
              FarmStatus.working =>
                frames[(calm * 4 + k + row * 2).floor() % 3],
              FarmStatus.waiting => monitorWait[(t * 3).floor() % 2],
              _ => monitorOff,
            };
            final x = p.left + 1.5 + k * 10, y = p.top - 1.5 + row * 8;
            _draw(canvas, img, x, y, 7, 5);
          }
        }
      } else {
        final frames = crops[stage]!;
        for (var row = 0; row < 2; row++) {
          for (var k = 0; k < 3; k++) {
            final x = p.left + 6 + k * 9 + row * 4;
            final y = row == 1 ? p.bottom - 1 : p.top + 8;
            final s = (math.sin(calm * 1.6 + x * 0.7) * 0.9).round() + 1;
            _draw(canvas, frames[s], x - 2.5, y - 9, 5, 9);
          }
        }
      }
      // arrastando: o canteiro que sai e a vaga onde ele vai cair
      if (i == scene.dragFrom || i == scene.dragTo) {
        _outline(
          canvas,
          p.inflate(3),
          i == scene.dragTo ? 0xFFffe08a : 0x99ffffff,
        );
      }
      // a faixa do time embaixo do canteiro, na cor do lead
      final team = info?.team;
      if (team != null) {
        _rect(canvas, p.left - 1, p.bottom + 1, p.width + 2, 2, 0xFF14100c);
        _rect(canvas, p.left - 0.5, p.bottom + 1.5, p.width + 1, 1, team);
      }
      final more = info?.more ?? 0;
      if (more > 0) {
        final s = signSprite('+$more');
        _draw(
          canvas,
          s,
          p.right + 1,
          p.top - 13,
          s.width.toDouble(),
          s.height.toDouble(),
        );
      }
    }
    // o espantalho: balança quando alguém trabalha, cochila quando não; no
    // escritório, a impressora imprime ou fica parada
    final cr = l.crow;
    if (office && seen(cr.dx, cr.dy)) {
      final f = scene.working ? (t * 1.4).floor() % 2 : 2;
      _draw(canvas, printerHD[f], cr.dx - 7, cr.dy - 12, 14, 12);
    } else if (seen(cr.dx, cr.dy)) {
      final on = scene.working;
      final f = on ? (t * 1.4).floor() % 2 : 2;
      final sh2 = shadowSprite(8, 2);
      _draw(
        canvas,
        sh2,
        cr.dx - sh2.width / 4,
        cr.dy - sh2.height / 4,
        sh2.width / 2,
        sh2.height / 2,
        0.35,
      );
      _draw(
        canvas,
        scarecrowHD[f],
        cr.dx - 8,
        cr.dy - 21.5 + (on && (t * 2.8).floor().isOdd ? -0.5 : 0),
        16,
        22,
      );
    }
    // os bichinhos de estimação, no chão (antes dos gorilas)
    for (final p in scene.pets) {
      if (seen(p.x, p.y)) _pet(canvas, p, t, calm);
    }
    // bichos em ordem de profundidade; só os visíveis
    final list = scene.critters.values.toList()
      ..sort((a, b) => a.y.compareTo(b.y));
    final shC = shadowSprite(7, 2), shM = shadowSprite(4, 1);
    for (final c in list) {
      if (!seen(c.x, c.y)) continue;
      final s = c.sprite(t, t), bob = c.bob(t, t, calm);
      final x = _hx(c.x), y = _hx(c.y), fade = c.fade(t);
      final sh = c.mini ? shM : shC;
      _draw(
        canvas,
        sh,
        x - sh.width / 4,
        y - sh.height / 4,
        sh.width / 2,
        sh.height / 2,
        fade * 0.35,
      );
      final still = !c.moving;
      if (c.mini) {
        // o mini do squad é mais alto (chapéu): os pés ficam no lugar
        final mw = s.width / hd, mh = s.height / hd;
        _draw(canvas, s, x - mw / 2, y - mh + bob, mw, mh, fade);
        // no escritório o mini usa o monitor da mesa (sem laptop na mão)
        if (c.mode == CritterMode.work && still && !office) {
          _rect(canvas, x + 3, y - 4, 4.5, 3, 0xFF1b1f2a);
          _rect(
            canvas,
            x + 3.5,
            y - 3.5,
            3.5,
            1,
            c.typingFrame(t) == 1 ? 0xFF7cfc9a : 0xFF2c4a3c,
          );
          _rect(canvas, x + 3.5, y - 2.5, 2, 0.5, 0xFFd97757);
          _rect(canvas, x + 2.5, y - 1, 5.5, 1, 0xFF9aa3b2);
        }
        continue;
      }
      _draw(canvas, s, x - 8, y - 17 + bob, 16, 18, fade);
      // Codex e Antigravity levam um selo no peito (Claude é o padrão)
      final badge = _badge(c.loop.harness);
      if (badge != null) _draw(canvas, badge, x - 9, y - 7 + bob, 5, 7, fade);
      // quem não dorme leva a barrinha do contexto em cima da cabeça
      if (c.mode != CritterMode.sleep && c.loop.contextTokens > 0) {
        _gauge(canvas, x, y - 22 + bob, c.loop.contextFill, fade);
      }
      // no escritório o trabalho aparece no monitor da ilha: nada de
      // laptop flutuando ao lado dela
      if (still && c.stroll == null && c.mode == CritterMode.work) {
        if (!office) {
          _draw(canvas, laptopHD[c.typingFrame(t)], x + 4, y - 6, 9, 7, fade);
        }
      } else if (still && c.mode == CritterMode.wait) {
        if (!office) _draw(canvas, laptopHD[2], x + 4, y - 6, 9, 7, fade);
        _draw(
          canvas,
          flagHD[(t * 3).floor() % 2],
          x + 6,
          y - 27 + bob,
          6,
          10,
          fade,
        );
      } else if (still && c.mode == CritterMode.sleep) {
        for (var k = 0; k < 2; k++) {
          final ph = c.zPhase(calm, k);
          _draw(
            canvas,
            zed,
            _hx(x + 5 + ph * 4 + math.sin(ph * 6 + k) * 1.5),
            _hx(y - 14 - ph * 11),
            3,
            3,
            fade * math.min(1, (1 - ph) * 1.6),
          );
        }
      }
    }
    for (final p in scene.puffs) {
      if (seen(p.x, p.y)) _puff(canvas, p, t);
    }
    // a fileira de árvores da frente passa por cima de todo mundo
    final fy0 = math.max(sy, w.fgY), fh = math.min(l.h, sy + sh) - fy0;
    if (sw > 0 && fh > 0) {
      _img.color = const Color(0xFF000000);
      canvas.drawImageRect(
        w.fg,
        Rect.fromLTWH(
          sx * hd.toDouble(),
          (fy0 - w.fgY) * hd.toDouble(),
          sw * hd.toDouble(),
          fh * hd.toDouble(),
        ),
        Rect.fromLTWH(
          sx.toDouble(),
          fy0.toDouble(),
          sw.toDouble(),
          fh.toDouble(),
        ),
        _img,
      );
    }
    for (final p in scene.sparks) {
      if (p.color != null) {
        _rect(canvas, _hx(p.x), _hx(p.y), 1, 1, p.color!);
        continue;
      }
      if (p.life < 0.3 && (p.life * 20).floor().isOdd) continue;
      _draw(canvas, sparkles[p.k], _hx(p.x - 1.75), _hx(p.y - 1.75), 3.5, 3.5);
    }
    return list;
  }

  /// O que vai embaixo do mini: o nome do agente do squad, senão o tipo
  /// (`Explore`, `Plan`...), senão o título.
  static String miniName(FarmLoop l) =>
      squadNameOf(l)?.toUpperCase() ?? l.agentType ?? l.title;

  static ui.Image? _badge(String harness) => switch (harness) {
    'codex' => badgeSprite('C', 0xFF10a37f),
    'antigravity' => badgeSprite('A', 0xFF4285f4),
    _ => null,
  };

  static const _nameH = 8.0 * 1.2;

  TextStyle get _small => label.copyWith(fontSize: 9);

  TextStyle get _name => label.copyWith(fontSize: 8, height: 1.2);

  TextStyle get _plank => label.copyWith(
    fontSize: 9,
    color: const Color(0xFF3a2616),
    shadows: const [],
  );

  static String _clip(String s, int n) =>
      s.length <= n ? s : '${s.substring(0, math.max(1, n - 1))}…';

  @override
  bool shouldRepaint(FarmScenePainter old) =>
      old.world != world || old.label != label || old.peers != peers;
}
