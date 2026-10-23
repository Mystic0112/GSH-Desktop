// Ported from clodfarm (github.com/matank001/clodfarm), MIT License, see third_party/clodfarm/LICENSE.

import 'dart:isolate';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:gsh_desktop/app/gsh/ui/widgets/farm/farm_sprites.dart'
    show hd, spark;
import 'package:gsh_desktop/app/gsh/ui/widgets/farm/pix.dart';

part 'farm_world_paint.dart';
part 'farm_world_props.dart';

/// O mundo da fazenda: o layout (onde fica celeiro, curral, lago, cercado e
/// canteiros) e o fundo estático pintado uma vez (grama com ruído, árvores,
/// caminhos, decoração). Coordenadas em pixels de mundo; o fundo é HD (2x).

// Paleta do campo.
const _g0 = 0xFF4a6524, _g1 = 0xFF577530, _g2 = 0xFF648436, _g3 = 0xFF71923c;
const _g4 = 0xFF80a246, _worn = 0xFF8ea456;
const t0 = 0xFF1c3519;
const _t1 = 0xFF28501f, _t2 = 0xFF346a27, _t3 = 0xFF468a31, _t4 = 0xFF63a93f;
const _t5 = 0xFF8cc65a, _trunk = 0xFF4b3421;
const _r0 = 0xFF34343c, _r1 = 0xFF55555e, _r2 = 0xFF6f6f78, _r3 = 0xFF8d8d96;
const _r4 = 0xFFaeaeb5;
const _soil = 0xFF6b4a2e, _soil2 = 0xFF57391f, _soil3 = 0xFF7d5a3a;
const _soilo = 0xFF3f2915;
const _w0 = 0xFF2a5a8a, _w1 = 0xFF3f7fb8, _w2 = 0xFF5b9ed0, _w3 = 0xFF9fd0ee;
final _shadow32 = rgba(20, 32, 10, .32);
final _shadow36 = rgba(20, 32, 10, .36);
final _shadow30 = rgba(20, 32, 10, .3);
final _shadow35 = rgba(20, 32, 10, .35);
final _shadow38 = rgba(20, 32, 10, .38);

const _bayer = [
  [0, 8, 2, 10],
  [12, 4, 14, 6],
  [3, 11, 1, 9],
  [15, 7, 13, 5],
];
const _flowerC = [
  0xFFf4f1e8,
  0xFFf5c542,
  0xFFf59cc0,
  0xFFb9d9ff,
  0xFFff8f6b,
  0xFFc99bf0,
];

/// Canteiro (w x h) e o passo entre eles (cx x cy). O cy é maior que o do
/// clodfarm (40) para caber a etiqueta com o título embaixo de cada canteiro.
const plotW = 30.0, plotH = 16.0, plotCx = 60.0, plotCy = 46.0;
const _yardCx = 19.0, _yardCy = 17.0, _crowLane = 22.0;

/// Onde ficam os subagentes de um canteiro (os pés, a partir do canto):
/// em cima, embaixo, depois à direita.
const subSpots = <(double, double)>[
  (5, -2),
  (25, -2),
  (5, plotH + 9),
  (25, plotH + 9),
  (15, -2),
  (15, plotH + 9),
  (plotW + 7, 5),
  (plotW + 7, plotH + 1),
];

class FarmDecor {
  const FarmDecor(this.kind, this.x, this.y, this.r, this.c);
  final String kind;
  final double x, y, r;
  final int c;
}

/// A janela onde a fazenda é desenhada (px lógicos) e o quanto o HUD cobre.
class FarmViewport {
  const FarmViewport({
    required this.w,
    required this.h,
    this.left = 0,
    this.top = 0,
    this.right = 0,
    this.bottom = 0,
  });
  final double w, h, left, top, right, bottom;

  /// O zoom "clássico" do clodfarm: px por pixel de mundo.
  int get s => (math.min(w / 330, h / 205)).round().clamp(2, 6);
}

class FarmLayout {
  FarmLayout({
    required this.w,
    required this.h,
    required this.t,
    required this.play,
    required this.barn,
    required this.yard,
    required this.yardCols,
    required this.pond,
    required this.field,
    required this.plots,
    required this.columns,
    required this.gateAt,
    required this.sign,
    required this.crow,
    required this.door,
    required this.content,
    required this.paths,
    required this.z,
    required this.capPlots,
    required this.capYard,
  });

  final int w, h, t;
  final ui.Rect play, barn, yard, field, content;
  final int yardCols, columns;

  /// Lago: centro e raios.
  final ui.Rect pond;
  final List<ui.Rect> plots;

  /// Portão do cercado: lado esquerdo, na altura [gateAt].
  final double gateAt;
  final ui.Offset sign, crow, door;
  final List<List<ui.Offset>> paths;

  /// Zoom que mostra a fazenda inteira na janela (px lógicos por px de mundo).
  final double z;
  final int capPlots, capYard;

  List<ui.Rect> rocks = const [];
  List<FarmDecor> decor = const [];

  /// Centro do lago e raios: [pond] guarda (cx, cy) no topo-esquerdo e
  /// (rx, ry) no tamanho.
  double get pondCx => pond.left;
  double get pondCy => pond.top;
  double get pondRx => pond.width;
  double get pondRy => pond.height;

  /// Onde o n-ésimo que dorme senta no curral.
  ui.Offset yardSpot(int i) => ui.Offset(
    yard.left + 13 + (i % yardCols) * _yardCx,
    yard.top + 19 + (i ~/ yardCols) * _yardCy,
  );

  /// Lugar livre (fora de celeiro, cercado, lago, pedras): ninguém anda ali.
  bool blocked(double x, double y) {
    bool inR(ui.Rect r, [double pad = 0]) =>
        x > r.left - pad &&
        x < r.right + pad &&
        y > r.top - pad &&
        y < r.bottom + pad + 4;
    if (inR(barn, 8) || inR(field, 2) || inR(yard, 6)) return true;
    if ((x - crow.dx).abs() < 12 && y > crow.dy - 24 && y < crow.dy + 6) {
      return true;
    }
    if ((x - sign.dx).abs() < 8 && y > sign.dy - 4 && y < sign.dy + 14) {
      return true;
    }
    final px = (x - pondCx) / (pondRx + 8), py = (y - pondCy) / (pondRy + 6);
    if (px * px + py * py < 1) return true;
    if (decor.any(
      (d) =>
          d.r > 0 &&
          (x - d.x).abs() < d.r + 5 &&
          y > d.y - d.r - 2 &&
          y < d.y + 5,
    )) {
      return true;
    }
    return rocks.any(
      (r) =>
          (x - r.left).abs() < r.width / 2 + 6 &&
          y > r.top - 4 &&
          y < r.bottom + 4,
    );
  }

  bool onPath(double x, double y, [double pad = 5]) => paths.any((pts) {
    for (var i = 1; i < pts.length; i++) {
      final a = pts[i - 1], b = pts[i];
      if (x > math.min(a.dx, b.dx) - pad &&
          x < math.max(a.dx, b.dx) + pad &&
          y > math.min(a.dy, b.dy) - pad &&
          y < math.max(a.dy, b.dy) + pad) {
        return true;
      }
    }
    return false;
  });
}

/// O layout real, crescido para caber: um cercado com um canteiro por loop
/// principal (o espantalho fica no canto), o celeiro com o curral de quem
/// dorme, o lago e os caminhos. Testa larguras de cercado e curral e fica com
/// a que mostra a fazenda maior na janela. [snap] arredonda o zoom para
/// pixels inteiros.
FarmLayout layoutFarm({
  required int plots,
  required int yard,
  required FarmViewport view,
  required double Function(double z) snap,
}) {
  final nP = math.max(6, plots), nY = math.max(5, yard);
  final avW = math.max(120.0, view.w - view.left - view.right);
  final avH = math.max(120.0, view.h - view.top - view.bottom);
  const gap = 16.0;
  ({double z, int fc, int fr, int yc, double cw, double ch, double fw})? best;
  double fh = 0, lw = 0, yw = 0, yh = 0;
  for (var fc = 1; fc <= math.min(nP, 30); fc++) {
    final fr = (nP / fc).ceil();
    if (fc > 1 && (nP / (fc - 1)).ceil() == fr) continue;
    for (final yc in const [5, 7, 9, 12, 16, 22, 30]) {
      if (yc > 5 && yc > nY + 4) break;
      final fw = fc * plotCx - (plotCx - plotW) + 35 + _crowLane;
      final fhh = fr * plotCy - (plotCy - plotH) + 30;
      final yww = yc * _yardCx + 8, yhh = (nY / yc).ceil() * _yardCy + 10;
      final lww = math.max(yww, 96.0), lh = 8 + 44 + 16 + yhh + 40;
      final cw = lww + gap + fw, ch = math.max(lh, fhh);
      final z = math.min(avW / cw, avH / ch);
      if (best == null || z > best.z + 1e-6) {
        best = (z: z, fc: fc, fr: fr, yc: yc, cw: cw, ch: ch, fw: fw);
        fh = fhh;
        lw = lww;
        yw = yww;
        yh = yhh;
      }
    }
  }
  final b = best!;
  final z = snap(math.min(view.s.toDouble(), b.z));
  final t = (math.min(view.w, view.h) / view.s * 0.14).round().clamp(20, 40);
  final x0 = math
      .max(t + 4, (view.left / z + (avW / z - b.cw) / 2).round())
      .toDouble();
  final y0 = math
      .max(t + 6, (view.top / z + (avH / z - b.ch) / 2).round())
      .toDouble();
  final w = math.max((view.w / z).ceil(), (x0 + b.cw + t + 4).ceil());
  final h = math.max((view.h / z).ceil(), (y0 + b.ch + t + 4).ceil());
  final play = ui.Rect.fromLTRB(t + 2.0, t + 8.0, w - t - 2.0, h - t - 4.0);
  final barn = ui.Rect.fromLTWH(x0 + ((lw - 46) / 2).round(), y0 + 8, 46, 44);
  final yardR = ui.Rect.fromLTWH(
    x0 + ((lw - yw) / 2).round(),
    barn.bottom + 16,
    yw,
    yh,
  );
  final pond = ui.Rect.fromLTWH(
    x0 + (lw / 2).round(),
    yardR.bottom + 21,
    math.min(30, (lw / 2).round() - 6).toDouble(),
    11,
  );
  final field = ui.Rect.fromLTWH(
    x0 + lw + gap,
    y0 + ((b.ch - fh) / 2).round(),
    b.fw,
    fh,
  );
  final fx = field.left + 19 + _crowLane, fy = field.top + 15;
  final plotRects = [
    for (var i = 0; i < b.fc * b.fr; i++)
      ui.Rect.fromLTWH(
        fx + (i % b.fc) * plotCx,
        fy + (i ~/ b.fc) * plotCy,
        plotW,
        plotH,
      ),
  ];
  final crow = ui.Offset(field.left + 13, field.bottom - 9);
  final door = ui.Offset(barn.center.dx, barn.bottom + 2);
  // caminhos de terra: da porta do celeiro ao curral, e dali ao portão
  final py = door.dy + 7;
  final gy = clampD(
    py,
    field.top + 12,
    math.max(field.top + 12, field.bottom - 38),
  );
  final mx = field.left - 8;
  final paths = [
    [ui.Offset(door.dx, door.dy - 1), ui.Offset(door.dx, yardR.top + 2)],
    if (gy == py)
      [ui.Offset(door.dx, py), ui.Offset(field.left + 4, py)]
    else
      [
        ui.Offset(door.dx, py),
        ui.Offset(mx, py),
        ui.Offset(mx, gy),
        ui.Offset(field.left + 4, gy),
      ],
  ];
  return FarmLayout(
    w: w,
    h: h,
    t: t,
    play: play,
    barn: barn,
    yard: yardR,
    yardCols: b.yc,
    pond: pond,
    field: field,
    plots: plotRects,
    columns: b.fc,
    gateAt: gy,
    sign: ui.Offset(field.left - 7, gy - 9),
    crow: crow,
    door: door,
    content: ui.Rect.fromLTWH(x0, y0, b.cw, b.ch),
    paths: paths,
    z: z,
    capPlots: plotRects.length,
    capYard: b.yc * (nY / b.yc).ceil(),
  );
}
