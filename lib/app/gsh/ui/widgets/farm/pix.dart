// Ported from clodfarm (github.com/matank001/clodfarm), MIT License, see third_party/clodfarm/LICENSE.

import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

/// Primitivas de pixel art da fazenda: RNG semeado, cores em `int` ARGB, a
/// grade [Pix] (sprites, contorno automático) e o [Raster] (o mundo, com
/// alpha). Tudo Dart puro até a conversão em `ui.Image`, para o mundo poder
/// ser montado num isolate.

const _m32 = 0xFFFFFFFF;

int _imul(int a, int b) => (a * b) & _m32;

/// RNG semeado do clodfarm (mulberry32), em uint32: mesma semente, mesmo mundo.
double Function() mulberry32(int seed) {
  var s = seed & _m32;
  return () {
    s = (s + 0x6d2b79f5) & _m32;
    var t = _imul(s ^ (s >> 15), 1 | s);
    t = ((t + _imul(t ^ (t >> 7), 61 | t)) & _m32) ^ t;
    return ((t ^ (t >> 14)) & _m32) / 4294967296;
  };
}

/// FNV-1a estável (o `hashStr` do clodfarm).
int hashStr(String s) {
  var x = 2166136261;
  for (final c in s.codeUnits) {
    x = _imul(x ^ c, 16777619);
  }
  return x;
}

double clampD(num v, num a, num b) => math.max(a, math.min(b, v)).toDouble();

// ------------------------------------------------------------------ cores
// ARGB em int; 0 = transparente (opacas sempre têm alpha 0xFF).

int rgba(int r, int g, int b, double a) =>
    ((a * 255).round() << 24) | (r << 16) | (g << 8) | b;

int _ch(int c, int shift) => (c >> shift) & 0xFF;

/// Clareia (amt > 0) ou escurece uma cor, como o `shade` do clodfarm.
int shade(int c, double amt) {
  int f(int v) => (v + amt * 255).round().clamp(0, 255);
  return 0xFF000000 | f(_ch(c, 16)) << 16 | f(_ch(c, 8)) << 8 | f(_ch(c, 0));
}

int mix(int a, int b, double t) {
  int m(int s) => (_ch(a, s) + (_ch(b, s) - _ch(a, s)) * t).round();
  return 0xFF000000 | m(16) << 16 | m(8) << 8 | m(0);
}

int argbOf(ui.Color c) => c.toARGB32() | 0xFF000000;

/// Função de cor por pixel de [Pix.ovalFn]: `u, v` vão de -1 a 1 na elipse.
/// Devolver 0 pula o pixel.
typedef PixShader = int Function(int x, int y, double u, double v);

/// Grade de pixels de um sprite (a classe `Pix` do clodfarm): formas
/// preenchidas e depois contornadas em tinta por [outline].
class Pix {
  Pix(this.w, this.h) : p = Uint32List(w * h);

  final int w;
  final int h;
  final Uint32List p;

  void set(num x, num y, int c) {
    final xi = x.floor(), yi = y.floor();
    if (c != 0 && xi >= 0 && yi >= 0 && xi < w && yi < h) p[yi * w + xi] = c;
  }

  int get(int x, int y) =>
      x >= 0 && y >= 0 && x < w && y < h ? p[y * w + x] : 0;

  void rect(num x, num y, num rw, num rh, int c) {
    for (var j = 0; j < rh; j++) {
      for (var i = 0; i < rw; i++) {
        set(x + i, y + j, c);
      }
    }
  }

  void oval(num cx, num cy, num rx, num ry, int c, [double rot = 0]) =>
      ovalFn(cx, cy, rx, ry, (_, _, _, _) => c, rot);

  void ovalFn(num cx, num cy, num rx, num ry, PixShader c, [double rot = 0]) {
    final cs = math.cos(rot), sn = math.sin(rot), r = math.max(rx, ry) + 1;
    for (var y = (cy - r).floor(); y <= cy + r; y++) {
      for (var x = (cx - r).floor(); x <= cx + r; x++) {
        final dx = x + 0.5 - cx, dy = y + 0.5 - cy;
        final u = (dx * cs + dy * sn) / rx, v = (-dx * sn + dy * cs) / ry;
        if (u * u + v * v <= 1) set(x, y, c(x, y, u, v));
      }
    }
  }

  void line(num x0, num y0, num x1, num y1, int c) {
    final n = math.max(math.max((x1 - x0).abs(), (y1 - y0).abs()), 1);
    for (var i = 0; i <= n; i++) {
      set(
        (x0 + (x1 - x0) * i / n).round(),
        (y0 + (y1 - y0) * i / n).round(),
        c,
      );
    }
  }

  /// Contorna toda forma preenchida em [c] (os vazios vizinhos de um cheio).
  void outline(int c, {bool diag = false}) {
    bool f(int x, int y) => get(x, y) != 0;
    final add = <int>[];
    for (var y = 0; y < h; y++) {
      for (var x = 0; x < w; x++) {
        if (p[y * w + x] != 0) continue;
        if (f(x - 1, y) ||
            f(x + 1, y) ||
            f(x, y - 1) ||
            f(x, y + 1) ||
            (diag &&
                (f(x - 1, y - 1) ||
                    f(x + 1, y - 1) ||
                    f(x - 1, y + 1) ||
                    f(x + 1, y + 1)))) {
          add.add(y * w + x);
        }
      }
    }
    for (final i in add) {
      p[i] = c;
    }
  }

  /// Recolore: `fn` devolve a cor nova, ou null para manter.
  void map(int? Function(int x, int y, int c) fn) {
    for (var i = 0; i < p.length; i++) {
      if (p[i] == 0) continue;
      final n = fn(i % w, i ~/ w, p[i]);
      if (n != null) p[i] = n;
    }
  }

  /// Cola outra grade por cima (pixels transparentes não cobrem).
  void stamp(Pix o, int dx, int dy) {
    for (var y = 0; y < o.h; y++) {
      for (var x = 0; x < o.w; x++) {
        set(x + dx, y + dy, o.p[y * o.w + x]);
      }
    }
  }

  /// Rasteriza como `ui.Image` na hora (sprite pequeno: um retângulo por
  /// trecho de mesma cor de cada linha).
  ui.Image toImage() {
    final rec = ui.PictureRecorder();
    final canvas = ui.Canvas(rec);
    final paint = ui.Paint()..isAntiAlias = false;
    for (var y = 0; y < h; y++) {
      var x = 0;
      while (x < w) {
        final c = p[y * w + x];
        var e = x + 1;
        while (e < w && p[y * w + e] == c) {
          e++;
        }
        if (c != 0) {
          paint.color = ui.Color(c);
          canvas.drawRect(
            ui.Rect.fromLTRB(x.toDouble(), y.toDouble(), e.toDouble(), y + 1),
            paint,
          );
        }
        x = e;
      }
    }
    final pic = rec.endRecording();
    final img = pic.toImageSync(w, h);
    pic.dispose();
    return img;
  }
}

/// A tela do mundo (o `<canvas>` do fundo no clodfarm): `fillRect` com alpha.
class Raster {
  Raster(this.w, this.h) : p = Uint32List(w * h);

  final int w;
  final int h;
  final Uint32List p;

  void fill(num x, num y, num rw, num rh, int c) {
    final x0 = math.max(0, x.round()), y0 = math.max(0, y.round());
    final x1 = math.min(w, (x + rw).round()),
        y1 = math.min(h, (y + rh).round());
    final a = c >>> 24;
    if (a == 0) return;
    for (var yy = y0; yy < y1; yy++) {
      final row = yy * w;
      for (var xx = x0; xx < x1; xx++) {
        p[row + xx] = a == 0xFF ? c : _blend(p[row + xx], c, a);
      }
    }
  }

  static int _blend(int dst, int src, int a) {
    int m(int s) => (_ch(dst, s) * (255 - a) + _ch(src, s) * a) ~/ 255;
    final da = dst >>> 24;
    final oa = a + da * (255 - a) ~/ 255;
    return oa << 24 | m(16) << 16 | m(8) << 8 | m(0);
  }

  /// O `pxCircle` do clodfarm: um disco em fileiras de 1px.
  void circle(num cx, num cy, num r, int c) {
    for (var y = -r.toDouble(); y <= r; y++) {
      final ww = math.sqrt(math.max(0, r * r - y * y + r * 0.8)).floor();
      fill((cx - ww).round(), (cy + y).round(), ww * 2 + 1, 1, c);
    }
  }

  void ellipse(num cx, num cy, num rx, num ry, int c) {
    for (var y = -ry.toDouble(); y <= ry; y++) {
      final ww = (rx * math.sqrt(math.max(0, 1 - (y * y) / (ry * ry + 0.6))))
          .floor();
      fill((cx - ww).round(), (cy + y).round(), ww * 2 + 1, 1, c);
    }
  }

  /// Bytes RGBA para `ui.decodeImageFromPixels`.
  Uint8List toRgba() {
    final out = Uint8List(w * h * 4);
    for (var i = 0; i < p.length; i++) {
      final c = p[i];
      out[i * 4] = _ch(c, 16);
      out[i * 4 + 1] = _ch(c, 8);
      out[i * 4 + 2] = _ch(c, 0);
      out[i * 4 + 3] = c >>> 24;
    }
    return out;
  }
}

Future<ui.Image> imageFromRgba(Uint8List rgba, int w, int h) {
  final done = Completer<ui.Image>();
  ui.decodeImageFromPixels(rgba, w, h, ui.PixelFormat.rgba8888, done.complete);
  return done.future;
}
