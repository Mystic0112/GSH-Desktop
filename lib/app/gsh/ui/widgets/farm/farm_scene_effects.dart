part of 'farm_scene_painter.dart';

/// Cor da barrinha do contexto: verde até 60% da janela, amarelo até 85%,
/// vermelho daí em diante (perto de compactar).
int contextBarColor(double fill) => fill < 0.6
    ? 0xFF6cc24a
    : fill < 0.85
    ? 0xFFf2c84b
    : 0xFFe0513c;

/// O que o painter desenha no mundo além do cenário e dos bichos: barra
/// de contexto, poeirinha de nascer/sumir, contorno do canteiro arrastado e
/// os bichinhos de estimação.
extension _Effects on FarmScenePainter {
  /// Um bichinho e, se levou carinho, o coração subindo e sumindo.
  void _pet(Canvas c, FarmPet p, double t, double calm) {
    final (w, h) = petSize(p.kind);
    final x = FarmScenePainter._hx(p.x), y = FarmScenePainter._hx(p.y);
    final sh = shadowSprite(4, 1);
    _draw(
      c,
      sh,
      x - sh.width / 4,
      y - sh.height / 4,
      sh.width / 2,
      sh.height / 2,
      0.3,
    );
    final img = petSprite(p.kind, p.frame(calm), p.dir);
    _draw(c, img, x - w / 2, y - h + 0.5, w, h);
    final k = p.heart(t);
    if (k != null) {
      final hy = FarmScenePainter._hx(y - h - 2 - k * 8);
      _draw(
        c,
        iconSprite(FarmIcon.heart),
        x - 2.5,
        hy - 5,
        5,
        5,
        math.min(1, (1 - k) * 2.5),
      );
    }
  }

  /// Contorno de 1 px (com sombra) em volta de [r].
  void _outline(Canvas c, Rect r, int color) {
    for (final (d, k) in [(0.5, 0x8014100c), (0.0, color)]) {
      _rect(c, r.left + d, r.top + d, r.width, 1, k);
      _rect(c, r.left + d, r.bottom - 1 + d, r.width, 1, k);
      _rect(c, r.left + d, r.top + d, 1, r.height, k);
      _rect(c, r.right - 1 + d, r.top + d, 1, r.height, k);
    }
  }

  /// A poeirinha de nascer/sumir (ver [FarmPuff]), em pixels de mundo.
  void _puff(Canvas c, FarmPuff p, double t) {
    final k = ((t - p.t0) / FarmPuff.life).clamp(0.0, 1.0);
    final s = p.mini ? 0.6 : 1.0, a = 1 - k;
    // a coluna de luz: ao nascer sobe do chão; ao sumir, encolhe e apaga
    final ch = FarmScenePainter._hx(
      20 * s * (p.born ? math.min(1, k * 4) : 1 - k * 0.5),
    );
    final cw = math.max(0.5, FarmScenePainter._hx(3 * s * (1 - k)));
    if (ch > 0) {
      _rect(
        c,
        FarmScenePainter._hx(p.x - cw / 2),
        FarmScenePainter._hx(p.y - ch),
        cw,
        ch,
        p.born ? 0xFFfff3c4 : 0xFFdfe8f4,
        a * 0.7,
      );
    }
    // o anel de poeira no chão: abre, sobe um tico e os grãos encolhem
    final r = (3 + k * 12) * s,
        g = math.max(0.5, FarmScenePainter._hx((2.5 - 2 * k) * s));
    for (var i = 0; i < 8; i++) {
      final ang = i * math.pi / 4 + 0.4;
      final px = p.x + math.cos(ang) * r;
      final py = p.y - 1 - k * 3 * s + math.sin(ang) * r * 0.45;
      _rect(
        c,
        FarmScenePainter._hx(px - g / 2),
        FarmScenePainter._hx(py - g / 2),
        g,
        g,
        0xFFeee4cc,
        a,
      );
    }
  }

  /// A barrinha do contexto em cima da cabeça: borda escura, trilho e o
  /// quanto da janela já foi, na cor de [contextBarColor].
  void _gauge(Canvas c, double x, double y, double fill, double a) {
    const w = 12.0;
    final l = FarmScenePainter._hx(x - w / 2 - 0.5);
    _rect(c, l, y, w + 1, 2, 0xFF14100c, a);
    _rect(c, l + 0.5, y + 0.5, w, 1, 0xFF3a3f4a, a);
    final f = (fill * w * 2).ceil() / 2;
    if (f > 0) {
      _rect(c, l + 0.5, y + 0.5, f, 1, contextBarColor(fill), a);
      _rect(c, l + 0.5, y + 0.5, f, 0.5, 0x40ffffff, a);
    }
  }
}
