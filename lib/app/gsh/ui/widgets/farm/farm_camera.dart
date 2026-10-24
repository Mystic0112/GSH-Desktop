// Ported from clodfarm (github.com/matank001/clodfarm), MIT License, see third_party/clodfarm/LICENSE.

import 'dart:math' as math;

import 'package:gsh_desktop/app/gsh/ui/widgets/farm/farm_world.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/farm/pix.dart';
import 'package:flutter/widgets.dart';

/// Câmera da fazenda: (x, y) em pixels de mundo no canto da janela, z = px
/// lógicos por pixel de mundo. Desenha num zoom "encaixado" em pixels de tela
/// inteiros (par quando há espaço, para os sprites HD caírem inteiros
/// também): nítido e sem tremer ao arrastar.
class FarmCamera {
  double x = 0, y = 0, z = 3, dpr = 1;
  bool auto = true;

  /// O mundo todo com as fazendas dos colegas e o zoom que o mostra inteiro;
  /// `null` = só a minha fazenda (os limites de sempre).
  Rect? team;
  double? teamZ;

  Rect _bounds(FarmLayout l) =>
      team ?? Rect.fromLTWH(0, 0, l.w.toDouble(), l.h.toDouble());

  /// Zoom mínimo: o que enquadra a minha fazenda ou, com colegas, o conjunto.
  double minZ(FarmLayout l) => math.min(l.z, teamZ ?? l.z);

  double snap(double z, {bool down = false}) {
    final zr = z * dpr;
    if (zr < 2) return z;
    final step = zr >= 4 && dpr >= 1.5 ? 2 : 1;
    final n = down ? (zr / step + 1e-6).floor() : (zr / step).round();
    return math.max(step, n * step) / dpr;
  }

  /// Zoom desenhado e o deslocamento arredondado em pixels de tela.
  ({double z, double zr, double ox, double oy}) get rt {
    final dz = snap(z), zr = dz * dpr;
    return (
      z: dz,
      zr: zr,
      ox: (-x * zr).roundToDouble(),
      oy: (-y * zr).roundToDouble(),
    );
  }

  Offset toWorld(Offset s) {
    final r = rt;
    return Offset((s.dx * dpr - r.ox) / r.zr, (s.dy * dpr - r.oy) / r.zr);
  }

  Offset toScreen(double wx, double wy) {
    final r = rt;
    return Offset(
      ((r.ox + wx * r.zr) / dpr).roundToDouble(),
      ((r.oy + wy * r.zr) / dpr).roundToDouble(),
    );
  }

  void fit(FarmLayout l, FarmViewport v) {
    z = l.z;
    auto = true;
    final b = l.content;
    x = b.center.dx - (v.left + (v.w - v.left - v.right) / 2) / z;
    y = b.center.dy - (v.top + (v.h - v.top - v.bottom) / 2) / z;
    clampTo(l, Size(v.w, v.h));
  }

  void clampTo(FarmLayout l, Size view) {
    final dz = snap(z), vw = view.width / dz, vh = view.height / dz;
    final b = _bounds(l);
    x = b.width <= vw
        ? b.left + (b.width - vw) / 2
        : clampD(x, b.left, b.right - vw);
    y = b.height <= vh
        ? b.top + (b.height - vh) / 2
        : clampD(y, b.top, b.bottom - vh);
  }

  void zoomAt(Offset s, double factor, FarmLayout l, Size view) {
    final z0 = snap(z), wx = x + s.dx / z0, wy = y + s.dy / z0;
    z = clampD(z * factor, minZ(l), math.max(8, l.z * 3));
    final z1 = snap(z);
    x = wx - s.dx / z1;
    y = wy - s.dy / z1;
    auto = false;
    clampTo(l, view);
  }

  void pan(Offset delta, FarmLayout l, Size view) {
    x -= delta.dx / z;
    y -= delta.dy / z;
    auto = false;
    clampTo(l, view);
  }
}
