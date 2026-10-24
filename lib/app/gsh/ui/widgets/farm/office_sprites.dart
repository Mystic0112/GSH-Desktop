part of 'farm_sprites.dart';

/// Monitores das ilhas do escritório, 14 x 10 HD: o equivalente da
/// plantação. O estágio (tokens gerados) é o quanto a tela tem de código; os
/// três quadros rolam as linhas (só animam com o dono trabalhando).
final Map<CropStage, List<ui.Image>> monitors = {
  for (final stage in CropStage.values)
    stage: [for (var f = 0; f < 3; f++) _monitor(stage, f)],
};

ui.Image _monitor(CropStage stage, int f) {
  final p = Pix(14, 10)
    ..rect(0, 0, 14, 8, 0xFF2a2f3a)
    ..rect(6, 8, 2, 1, 0xFF5a606c)
    ..rect(4, 9, 6, 1, 0xFF7c828e);
  final off = stage == CropStage.seed || stage == CropStage.wilt;
  p.rect(1, 1, 12, 6, off ? 0xFF1b1f28 : 0xFF1e2b3d);
  if (off) {
    p
      ..set(9, 2, 0xFF323846)
      ..set(10, 2, 0xFF323846)
      ..set(11, 3, 0xFF323846);
    return p.toImage();
  }
  const ink = [0xFF7fb4ff, 0xFF6fcf8b, 0xFFf2b43a, 0xFFc99bf0, 0xFF9fd0ee];
  final lines = switch (stage) {
    CropStage.sprout => 2,
    CropStage.grow => 4,
    _ => 5,
  };
  for (var i = 0; i < lines && i < 5; i++) {
    final k = i + f;
    final indent = (k * 3) % 4 == 0 ? 0 : 1 + (k % 2);
    final len = 3 + (k * 5) % 6;
    p.rect(
      2 + indent,
      1 + i,
      math.min(len, 10 - indent),
      1,
      ink[k % ink.length],
    );
  }
  if (stage == CropStage.ripe) {
    // pronto: o selo laranja do Claude no canto
    p
      ..rect(10, 4, 3, 1, clay)
      ..rect(11, 3, 1, 3, clay)
      ..set(11, 4, 0xFFfff1cf);
  }
  return p.toImage();
}

/// A impressora no lugar do espantalho, 28 x 24 HD: quadros 0 e 1 imprimindo
/// (papel saindo, luz verde), 2 parada.
final List<ui.Image> printerHD = List.generate(3, (f) {
  final p = Pix(28, 24);
  const ink = 0xFF3a404c;
  p
    // sombra no chão e o corpo
    ..rect(3, 21, 24, 3, 0x2E28241E)
    ..rect(1, 8, 26, 14, ink)
    ..rect(2, 9, 24, 12, 0xFFdfe2e6)
    ..rect(2, 9, 24, 2, 0xFFf4f5f7)
    ..rect(2, 17, 24, 4, 0xFFc3c8cf)
    // tampa e bandeja de entrada
    ..rect(4, 3, 20, 6, ink)
    ..rect(5, 4, 18, 4, 0xFFf2f4f6)
    ..rect(7, 1, 14, 3, ink)
    ..rect(8, 2, 12, 2, 0xFFffffff)
    // painel
    ..rect(18, 11, 6, 3, 0xFF2a2f3a)
    ..set(19, 12, f == 2 ? 0xFF4a6a52 : 0xFF7cfc9a)
    ..set(21, 12, f == 1 ? 0xFFf2b43a : 0xFF5a606c)
    // saída do papel
    ..rect(4, 15, 12, 2, 0xFF2a2f3a);
  if (f < 2) {
    final out = f == 0 ? 3 : 6;
    p
      ..rect(5, 15 + 2, 10, out, 0xFF9aa3b2)
      ..rect(6, 15 + 2, 8, out - 1, 0xFFffffff)
      ..rect(7, 18, 5, 1, 0xFF9aa3b2);
  }
  return p.toImage();
});
