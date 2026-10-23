// Ported from clodfarm (github.com/matank001/clodfarm), MIT License, see third_party/clodfarm/LICENSE.

part of 'farm_sprites.dart';

// ---------------------------------------------------------------- placas

const _digits = {
  '0': '111101101101111',
  '1': '010110010010111',
  '2': '111001111100111',
  '3': '111001011001111',
  '4': '101101111001001',
  '5': '111100111001111',
  '6': '111100111101111',
  '7': '111001010010010',
  '8': '111101111101111',
  '9': '111101111001111',
  '+': '000010111010000',
};

/// Plaquinha de madeira com "+N" (minis que o canteiro não desenha), em
/// pixels de mundo (não HD).
final _signs = <String, ui.Image>{};
ui.Image signSprite(String text) => _signs[text] ??= () {
  final w = text.length * 4 + 3;
  final p = Pix(w, 10)
    ..rect(w ~/ 2 - 1, 6, 2, 4, 0xFF3a2616)
    ..rect(0, 0, w, 8, 0xFF3a2616)
    ..rect(1, 1, w - 2, 6, 0xFFc9964a);
  for (var i = 0; i < text.length; i++) {
    final bits = _digits[text[i]];
    if (bits == null) continue;
    for (var k = 0; k < 15; k++) {
      if (bits[k] == '1') p.set(2 + i * 4 + k % 3, 2 + k ~/ 3, 0xFF3a2616);
    }
  }
  return p.toImage();
}();

// ------------------------------------------------------------------ ícones

/// Ícones 10 x 10 dos balões (os do clodfarm, mais a chama do HUD).
enum FarmIcon {
  terminal,
  zzz,
  pause,
  alert,
  dots,
  scroll,
  quill,
  globe,
  gear,
  tasks,
  heart,
  flame,
}

const _icons = <FarmIcon, (List<String>, Map<String, int>)>{
  FarmIcon.terminal: (
    [
      'oooooooooo', 'osssssssso', 'osgsssssso', 'ossgssssso', 'osgsssssso', //
      'osssggggso', 'osssssssso', 'oooooooooo', '...oooo...', '..oooooo..',
    ],
    {'o': 0xFF1b1f2a, 's': 0xFF22303c, 'g': 0xFF7cfc9a},
  ),
  FarmIcon.zzz: (
    [
      '......oooo', '.......oo.', '......oo..', '..oooooooo', '....oo....', //
      '...oo.....', '..oooo....', 'oooo......', '..oo......', '.oooo.....',
    ],
    {'o': 0xFF3c4a6b},
  ),
  FarmIcon.pause: (
    [
      '..........', '.oo....oo.', '.oo....oo.', '.oo....oo.', '.oo....oo.', //
      '.oo....oo.', '.oo....oo.', '.oo....oo.', '.oo....oo.', '..........',
    ],
    {'o': 0xFF3c4a6b},
  ),
  FarmIcon.alert: (
    [
      '....oo....', '...orro...', '...orro...', '...orro...', '...orro...', //
      '....rr....', '..........', '....rr....', '...orro...', '....oo....',
    ],
    {'o': 0xFF6b1a10, 'r': 0xFFe0513c},
  ),
  FarmIcon.dots: (
    [
      '..........', '..........', '..........', '..........', '.oo.oo.oo.', //
      '.oo.oo.oo.', '..........', '..........', '..........', '..........',
    ],
    {'o': 0xFF3c4a6b},
  ),
  FarmIcon.scroll: (
    [
      '.oooooooo.', 'oyyyyyyyyo', '.oppppppo.', '.opooopo..', '.oppppppo.', //
      '.opoooopo.', '.oppppppo.', '.opooppo..', 'oyyyyyyyyo', '.oooooooo.',
    ],
    {'o': 0xFF5a3d1e, 'p': 0xFFf6ecd0, 'y': 0xFFc9964a},
  ),
  FarmIcon.quill: (
    [
      '........oo', '.......owo', '......owwo', '.....owwo.', '....owwo..', //
      '...owwo...', '..oowo....', '..ooo.....', '.ooo......', 'oo........',
    ],
    {'o': 0xFF3a2a1a, 'w': 0xFFf6ecd0},
  ),
  FarmIcon.globe: (
    [
      '...oooo...', '..obwbbo..', '.obwbbwbo.', 'obbwbbwbbo', 'owwwwwwwwo', //
      'obbwbbwbbo', 'owwwwwwwwo', '.obwbbwbo.', '..obwbbo..', '...oooo...',
    ],
    {'o': 0xFF1b3a5a, 'b': 0xFF1c9fd6, 'w': 0xFFd8eef8},
  ),
  FarmIcon.gear: (
    [
      '....oo....', '.oo.gg.oo.', '.oggggggo.', '..gglogg..', 'oggl..lggo', //
      'ogg....ggo', '..gg..gg..', '.oggggggo.', '.oo.gg.oo.', '....oo....',
    ],
    {'o': 0xFF2f251b, 'g': 0xFF8d8d96, 'l': 0xFFc9c9cf},
  ),
  FarmIcon.tasks: (
    [
      '..oyyyyo..', '.oooooooo.', '.owwwwwwo.', '.ogwllllo.', '.owwwwwwo.', //
      '.ogwllllo.', '.owwwwwwo.', '.ogwllllo.', '.owwwwwwo.', '.oooooooo.',
    ],
    {
      'o': 0xFF5a3d1e,
      'y': 0xFFc9964a,
      'w': 0xFFf6ecd0,
      'g': 0xFF3cc36b,
      'l': 0xFF9aa3b2,
    },
  ),
  FarmIcon.heart: (
    [
      '..........', '.rr...rr..', 'rllr.rrrr.', 'rlrrrrrrr.', 'rrrrrrrrr.', //
      '.rrrrrrr..', '..rrrrr...', '...rrr....', '....r.....', '..........',
    ],
    {'r': 0xFFe0513c, 'l': 0xFFf7a296},
  ),
  FarmIcon.flame: (
    [
      '....o.....', '...oro....', '...orro...', '..orrro.o.', '.orrrrroro', //
      '.orryrrrro', 'orryyyrrro', 'orryyyyrro', '.orryyyro.', '..oooooo..',
    ],
    {'o': 0xFF6b1a10, 'r': 0xFFe0513c, 'y': 0xFFf5c542},
  ),
};

final _iconCache = <FarmIcon, ui.Image>{};
ui.Image iconSprite(FarmIcon icon) => _iconCache[icon] ??= () {
  final (rows, pal) = _icons[icon]!;
  final p = Pix(10, math.max(10, rows.length));
  for (var y = 0; y < rows.length; y++) {
    for (var x = 0; x < rows[y].length; x++) {
      p.set(x, y, pal[rows[y][x]] ?? 0);
    }
  }
  return p.toImage();
}();
