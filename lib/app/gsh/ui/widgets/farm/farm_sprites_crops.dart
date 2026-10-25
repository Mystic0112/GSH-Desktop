// Ported from clodfarm (github.com/matank001/clodfarm), MIT License, see third_party/clodfarm/LICENSE.

part of 'farm_sprites.dart';

/// A faísca do Claude (catavento, pedras, colheita madura).
const spark = [
  '....o....',
  '.o..o..o.',
  '..o.o.o..',
  '...ooo...',
  'oooowoooo',
  '...ooo...',
  '..o.o.o..',
  '.o..o..o.',
  '....o....',
];

enum CropStage { seed, sprout, grow, ripe, wilt }

/// Plantas do canteiro, 10 x 18 HD, três quadros de balanço por estágio.
final Map<CropStage, List<ui.Image>> crops = {
  for (final stage in CropStage.values)
    stage: [
      for (final sw in [-1, 0, 1]) _crop(stage, sw),
    ],
};

ui.Image _crop(CropStage stage, int sw) {
  final p = Pix(10, 18);
  const g1 = 0xFF3f8f35, g2 = 0xFF6fcf5b, g3 = 0xFFa6e27a;
  switch (stage) {
    case CropStage.seed:
      p
        ..rect(3, 15, 4, 1, 0xFF4a3220)
        ..set(4, 14, g2)
        ..set(5, 13, g2)
        ..set(3, 13, g1)
        ..set(6, 14, g3);
    case CropStage.wilt:
      p
        ..line(4, 16, 4, 10, 0xFF7a6a3a)
        ..line(4, 10, 7, 11, 0xFF7a6a3a)
        ..set(7, 12, 0xFF5c4b27)
        ..line(3, 13, 1, 14, 0xFF8a7a45)
        ..set(8, 12, 0xFF5c4b27);
    default:
      final top = stage == CropStage.sprout ? 10 : 6;
      for (var y = top; y <= 16; y++) {
        p.set(4 + (y < top + 3 ? sw : 0), y, g1);
      }
      p
        ..rect(1 + sw, top + 3, 3, 1, g2)
        ..set(1 + sw, top + 2, g3)
        ..rect(5 + sw, top + 5, 3, 1, g2)
        ..set(7 + sw, top + 4, g3);
      if (stage != CropStage.sprout) {
        p
          ..rect(1, top + 8, 3, 1, g2)
          ..rect(5, top + 9, 3, 1, g1);
      }
      if (stage == CropStage.grow) {
        p
          ..rect(3 + sw, top - 2, 3, 2, 0xFFd97757)
          ..set(4 + sw, top - 2, 0xFFf2a07a);
      }
      if (stage == CropStage.ripe) {
        for (var y = 0; y < spark.length; y++) {
          for (var x = 0; x < spark[y].length; x++) {
            final ch = spark[y][x];
            if (ch == '.') continue;
            p.set(
              x + sw - 0.5,
              y - 1,
              ch == 'w'
                  ? 0xFFfff1cf
                  : (x == 4 || y == 4)
                  ? 0xFFe8845f
                  : 0xFFd97757,
            );
          }
        }
      }
  }
  return p.toImage();
}
