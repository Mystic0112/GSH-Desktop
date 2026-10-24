// Ported from clodfarm (github.com/matank001/clodfarm), MIT License, see third_party/clodfarm/LICENSE.

import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:gsh_desktop/app/core/domain/entities/app_settings.dart'
    show FarmScenery;
import 'package:gsh_desktop/app/gsh/domain/entities/farm_loop.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/farm/farm_scene.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/farm/farm_sprites.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/farm/farm_squad_looks.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/farm/farm_world.dart';
import 'package:flutter/widgets.dart';

import 'package:gsh_desktop/app/gsh/ui/widgets/farm/farm_camera.dart';

export 'farm_camera.dart';

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
/// de tela, para ficarem nítidos) etiquetas e balões.
class FarmScenePainter extends CustomPainter {
  FarmScenePainter({
    required this.scene,
    required this.world,
    required this.cam,
    required this.labels,
    required this.label,
    required this.hover,
    required Listenable repaint,
  }) : super(repaint: repaint);

  final FarmScene scene;
  final FarmWorld? world;
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

  void _rect(Canvas c, double x, double y, double w, double h, int color) =>
      c.drawRect(Rect.fromLTWH(x, y, w, h), _fill..color = Color(color));

  @override
  void paint(Canvas canvas, Size size) {
    final w = world;
    _rect(canvas, 0, 0, size.width, size.height, t0);
    if (w == null) return;
    final l = w.layout, t = scene.t, calm = scene.calm, r = cam.rt;
    canvas
      ..save()
      ..clipRect(Offset.zero & size)
      ..translate(r.ox / cam.dpr, r.oy / cam.dpr)
      ..scale(r.z);
    final vx0 = -r.ox / r.zr, vy0 = -r.oy / r.zr;
    final vx1 = vx0 + size.width * cam.dpr / r.zr;
    final vy1 = vy0 + size.height * cam.dpr / r.zr;
    final sx = math.max(0, vx0.floor()), sy = math.max(0, vy0.floor());
    final sw = math.min(l.w, vx1.ceil() + 1) - sx;
    final sh = math.min(l.h, vy1.ceil() + 1) - sy;
    _img.color = const Color(0xFF000000);
    if (sw > 0 && sh > 0) {
      canvas.drawImageRect(
        w.bg,
        Rect.fromLTWH(
          sx * hd.toDouble(),
          sy * hd.toDouble(),
          sw * hd.toDouble(),
          sh * hd.toDouble(),
        ),
        Rect.fromLTWH(
          sx.toDouble(),
          sy.toDouble(),
          sw.toDouble(),
          sh.toDouble(),
        ),
        _img,
      );
    }
    bool seen(double x, double y, [double m = 24]) =>
        x > vx0 - m && x < vx1 + m && y > vy0 - m && y < vy1 + m + 20;

    // plantação (no escritório, os monitores das mesas), e a plaquinha "+N"
    // de quem tem mais minis do que desenha
    final office = w.scenery == FarmScenery.office;
    for (var i = 0; i < l.plots.length; i++) {
      final p = l.plots[i];
      if (!seen(p.left, p.top, 40)) continue;
      final info = i < scene.plotInfo.length ? scene.plotInfo[i] : null;
      final stage = info?.stage ?? CropStage.seed;
      if (office) {
        // a tela rola o código só com o dono trabalhando
        final on = info?.main?.activity.status == FarmStatus.working;
        final frames = monitors[stage]!;
        for (var row = 0; row < 2; row++) {
          for (var k = 0; k < 3; k++) {
            final f = on ? (calm * 4 + k + row * 2).floor() % 3 : 1;
            final x = p.left + 1.5 + k * 10, y = p.top - 1.5 + row * 8;
            _draw(canvas, frames[f], x, y, 7, 5);
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
        if (c.mode == CritterMode.work && still) {
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
      if (still && c.stroll == null && c.mode == CritterMode.work) {
        _draw(canvas, laptopHD[c.typingFrame(t)], x + 4, y - 6, 9, 7, fade);
      } else if (still && c.mode == CritterMode.wait) {
        _draw(canvas, laptopHD[2], x + 4, y - 6, 9, 7, fade);
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
    canvas.restore();
    _overlay(canvas, size, list, r.z, seen);
  }

  /// Etiquetas e balões em pixels de tela.
  void _overlay(
    Canvas canvas,
    Size size,
    List<Critter> list,
    double z,
    bool Function(double, double, [double]) seen,
  ) {
    final l = world!.layout, t = scene.t, calm = scene.calm;
    final names = z >= miniNamesAt;
    // o nome de cada mini embaixo dos pés (o do squad, se ele é um)
    if (names) {
      for (final c in list) {
        if (!c.mini || c.gone != null || !seen(c.x, c.y)) continue;
        final tp = labels.of(
          _clip(miniName(c.loop), ((c.room * z - 6) / 4.9).floor()),
          _name,
        );
        final at = cam.toScreen(c.x, c.y + 0.5);
        _plate(
          canvas,
          tp,
          Offset((at.dx - tp.width / 2).roundToDouble(), at.dy),
        );
      }
    }
    // o título embaixo de cada canteiro, em todo zoom: numa plaquinha escura
    // para ler em cima da grama. Vai até o título do canteiro vizinho.
    final small = z < tagsAt;
    final style = small ? _small : label;
    final maxW = (plotCx - 6) * z - 6;
    for (var i = 0; i < l.plots.length && i < scene.plotInfo.length; i++) {
      final info = scene.plotInfo[i];
      if (info == null) continue;
      final p = l.plots[i];
      if (!seen(p.left, p.top, 40)) continue;
      // alinhada à esquerda do canteiro: o balão do bicho da fileira de
      // baixo fica à esquerda dele, e não cobre o título; com os nomes dos
      // minis de baixo à mostra, desce uma linha
      final tp = labels.of(
        _clip(info.title, (maxW / (style.fontSize! * 0.62)).floor()),
        style,
      );
      final at = cam.toScreen(p.left, p.bottom + (small ? 9 : 9.5));
      final drop = names && info.minis >= 3 ? _nameH + 2 : 0.0;
      _plate(canvas, tp, at.translate(0, drop));
      // o nome da pasta numa plaquinha de madeira no canto do primeiro
      // canteiro de cada projeto
      if (info.project != null && !small) {
        // com os nomes dos minis de cima à mostra, desce para não cobrir
        final corner = cam
            .toScreen(p.left, p.top)
            .translate(0, names && info.minis > 0 ? _nameH + 3 : 0);
        final pw = p.width * z - 6;
        final sp = labels.of(_clip(info.project!, (pw / 5.6).floor()), _plank);
        final box = Rect.fromLTWH(
          corner.dx - 2,
          corner.dy - 2,
          sp.width + 6,
          sp.height + 2,
        );
        _rect(canvas, box.left, box.top, box.width, box.height, 0xFF3a2616);
        _rect(
          canvas,
          box.left + 1,
          box.top + 1,
          box.width - 2,
          box.height - 2,
          0xFFc9964a,
        );
        _rect(canvas, box.left + 1, box.top + 1, box.width - 2, 1, 0xFFdcae62);
        sp.paint(canvas, Offset(box.left + 3, box.top + 1));
      }
    }
    final hov = hover.value;
    for (final c in list) {
      if (c.gone != null || !seen(c.x, c.y)) continue;
      final alert = c.mode == CritterMode.wait;
      final focus = identical(c, hov);
      final far = z < (c.mini ? miniBubblesAt : bubblesAt);
      if (!alert && !focus && far) continue;
      if (c.mode == CritterMode.done && !focus) continue;
      final bob = c.bob(t, t, calm);
      final top = c.mini ? (c.squad?.hat == null ? 13 : 15) : 25;
      final at = cam.toScreen(c.x, c.y - top + bob);
      // balões crescem com o zoom (1 ou 2 px por pixel do ícone)
      final big = c.mini && !focus ? z >= 5 : z >= 3;
      _bubble(canvas, at, c.icon, alert, big ? 2 : 1, t);
    }
  }

  /// Texto numa plaquinha escura, canto superior esquerdo em [at].
  void _plate(Canvas canvas, TextPainter tp, Offset at) {
    _rect(canvas, at.dx - 2, at.dy, tp.width + 4, tp.height, 0xC014100c);
    tp.paint(canvas, at);
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

  /// Balão de pixel: caixa de cantos cortados, rabinho e o ícone. [u] é o
  /// tamanho do pixel em px lógicos.
  void _bubble(
    Canvas c,
    Offset at,
    FarmIcon icon,
    bool alert,
    double u,
    double t,
  ) {
    final ink = alert
        ? ((t * 4).floor().isOdd ? 0xFFe0513c : 0xFF6b1a10)
        : 0xFF1f2a44;
    final fill = alert ? 0xFFffe08a : 0xFFfff8e8;
    final w = 16 * u, h = 16 * u;
    final left = (at.dx - w / 2).roundToDouble(), top = at.dy - h - 3 * u;
    final cx = at.dx.roundToDouble();
    _rect(c, left + u, top, w - 2 * u, h, ink);
    _rect(c, left, top + u, w, h - 2 * u, ink);
    _rect(c, cx - 2 * u, top + h - u, 4 * u, 2 * u, ink);
    _rect(c, cx - u, top + h + u, 2 * u, u, ink);
    _rect(c, left + u, top + u, w - 2 * u, h - 2 * u, fill);
    _rect(c, cx - u, top + h - u, 2 * u, u, fill);
    _draw(c, iconSprite(icon), left + 3 * u, top + 3 * u, 10 * u, 10 * u);
  }

  @override
  bool shouldRepaint(FarmScenePainter old) =>
      old.world != world || old.label != label;
}
