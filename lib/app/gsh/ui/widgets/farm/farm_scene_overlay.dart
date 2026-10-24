part of 'farm_scene_painter.dart';

/// O que o painter desenha em pixels de tela, por cima do mundo: nomes dos
/// minis, títulos e plaquinhas dos canteiros, a faixa do colega e balões.
extension _Overlay on FarmScenePainter {
  /// Etiquetas e balões em pixels de tela.
  void _overlay(
    Canvas canvas,
    FarmScene scene,
    FarmWorld w,
    FarmLot? lot,
    List<Critter> list,
    double z,
    _View v,
  ) {
    final l = w.layout, t = scene.t, calm = scene.calm;
    final o = lot?.at ?? Offset.zero;
    Offset scr(double x, double y) => cam.toScreen(x + o.dx, y + o.dy);
    bool seen(double x, double y, [double m = 24]) => _seen(v, x, y, m);
    final names = z >= FarmScenePainter.miniNamesAt;
    // o nome de cada mini embaixo dos pés (o do squad, se ele é um)
    if (names) {
      for (final c in list) {
        if (!c.mini || c.gone != null || !seen(c.x, c.y)) continue;
        final tp = labels.of(
          FarmScenePainter._clip(
            FarmScenePainter.miniName(c.loop),
            ((c.room * z - 6) / 4.9).floor(),
          ),
          _name,
        );
        final at = scr(c.x, c.y + 0.5);
        _plate(
          canvas,
          tp,
          Offset((at.dx - tp.width / 2).roundToDouble(), at.dy),
        );
      }
    }
    // o título embaixo de cada canteiro, em todo zoom: numa plaquinha escura
    // para ler em cima da grama. Vai até o título do canteiro vizinho.
    final small = z < FarmScenePainter.tagsAt;
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
        FarmScenePainter._clip(
          info.title,
          (maxW / (style.fontSize! * 0.62)).floor(),
        ),
        style,
      );
      final at = scr(p.left, p.bottom + (small ? 9 : 9.5));
      final drop = names && info.minis >= 3 ? FarmScenePainter._nameH + 2 : 0.0;
      _plate(canvas, tp, at.translate(0, drop));
      // o nome da pasta numa plaquinha de madeira no canto do primeiro
      // canteiro de cada projeto
      if (info.project != null && !small) {
        // com os nomes dos minis de cima à mostra, desce para não cobrir
        final corner = scr(p.left, p.top).translate(
          0,
          names && info.minis > 0 ? FarmScenePainter._nameH + 3 : 0,
        );
        final pw = p.width * z - 6;
        final sp = labels.of(
          FarmScenePainter._clip(info.project!, (pw / 5.6).floor()),
          _plank,
        );
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
    if (lot != null) _banner(canvas, lot, w, scr);
    final hov = hover.value;
    for (final c in list) {
      if (c.gone != null || !seen(c.x, c.y)) continue;
      final alert = c.mode == CritterMode.wait;
      final focus = identical(c, hov);
      final far =
          z <
          (c.mini
              ? FarmScenePainter.miniBubblesAt
              : FarmScenePainter.bubblesAt);
      if (!alert && !focus && far) continue;
      if (c.mode == CritterMode.done && !focus) continue;
      final bob = c.bob(t, t, calm);
      final top = c.mini ? (c.squad?.hat == null ? 13 : 15) : 25;
      final at = scr(c.x, c.y - top + bob);
      // balões crescem com o zoom (1 ou 2 px por pixel do ícone)
      final big = c.mini && !focus ? z >= 5 : z >= 3;
      _bubble(canvas, at, c.icon, alert, big ? 2 : 1, t);
    }
  }

  /// A faixa com o nome do colega, no alto da fazenda dele: tábua de
  /// madeira na fazenda, placa na parede da sala no escritório. Tamanho fixo em
  /// pixels de tela, para ler com o zoom afastado.
  void _banner(
    Canvas canvas,
    FarmLot lot,
    FarmWorld w,
    Offset Function(double, double) scr,
  ) {
    final l = w.layout, office = w.scenery == FarmScenery.office;
    final text = banner?.call(lot.name) ?? lot.name;
    final tp = labels.of(
      text,
      label.copyWith(
        fontSize: 12,
        color: Color(office ? 0xFF2a2f3a : 0xFF3a2616),
        shadows: const [],
      ),
    );
    // no escritório, na face da parede de cima, como placa da sala
    final at = scr(l.content.center.dx, office ? l.play.top - 4.5 : l.t + 2.0);
    final box = Rect.fromLTWH(
      (at.dx - tp.width / 2 - 8).roundToDouble(),
      (at.dy - tp.height / 2 - 4).roundToDouble(),
      tp.width + 16,
      tp.height + 8,
    );
    final (ink, fill, hi) = office
        ? (0xFF3a404c, 0xFFf2f4f6, 0xFFffffff)
        : (0xFF3a2616, 0xFFc9964a, 0xFFdcae62);
    _rect(canvas, box.left + 2, box.bottom, box.width, 2, 0x5514100c);
    _rect(canvas, box.left, box.top, box.width, box.height, ink);
    _rect(
      canvas,
      box.left + 2,
      box.top + 2,
      box.width - 4,
      box.height - 4,
      fill,
    );
    _rect(canvas, box.left + 2, box.top + 2, box.width - 4, 1, hi);
    tp.paint(canvas, Offset(box.left + 8, box.top + 4));
  }

  /// Texto numa plaquinha escura, canto superior esquerdo em [at].
  void _plate(Canvas canvas, TextPainter tp, Offset at) {
    _rect(canvas, at.dx - 2, at.dy, tp.width + 4, tp.height, 0xC014100c);
    tp.paint(canvas, at);
  }

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
}
