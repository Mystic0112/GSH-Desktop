import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// **Cenário** da fazenda: chão + personagem em pixel art. É a unidade que
/// vai ser trocável (outros cenários no futuro), por isso a paleta mora aqui e
/// não no tema: o cenário é arte, o tema é a interface em volta.
///
/// ponytail: um cenário só, constante. Vira `FarmScene` com várias
/// implementações quando existir o segundo.
abstract final class FarmScene {
  static const grassA = Color(0xFF2B4228);
  static const grassB = Color(0xFF30492C);
  static const soil = Color(0xFF3A2E24);
  static const soilDot = Color(0xFF453729);

  /// Gorila do loop principal: o slate do logo da Gorila.
  static const mainBody = Color(0xFF6E797C);
  static const mainFace = Color(0xFFA9B3B5);
  static const eye = Color(0xFF151515);

  /// Clareia a cor do subagente para o rosto.
  static const highlight = Color(0xFFFFFFFF);

  /// Gorila 12×12. `#` corpo, `f` rosto, `e` olho, `n` nariz.
  static const sprite = <String>[
    '....####....',
    '...######...',
    '..##ffff##..',
    '..#feffef#..',
    '..#ffnnff#..',
    '...#ffff#...',
    '.##########.',
    '############',
    '##.######.##',
    '##.######.##',
    '...###.###..',
    '..####.####.',
  ];
}

/// Chão do canteiro: grama quadriculada com uma faixa de terra na base.
class FarmGroundPainter extends CustomPainter {
  const FarmGroundPainter();

  static const _tile = 8.0;

  @override
  void paint(Canvas canvas, Size size) {
    final a = Paint()..color = FarmScene.grassA;
    final b = Paint()..color = FarmScene.grassB;
    canvas.drawRect(Offset.zero & size, a);
    for (var y = 0.0; y < size.height; y += _tile) {
      for (var x = 0.0; x < size.width; x += _tile) {
        final i = (x / _tile).floor() + (y / _tile).floor();
        if (i.isOdd) canvas.drawRect(Rect.fromLTWH(x, y, _tile, _tile), b);
      }
    }
    const soilH = 10.0;
    final soilTop = size.height - soilH;
    canvas.drawRect(
      Rect.fromLTWH(0, soilTop, size.width, soilH),
      Paint()..color = FarmScene.soil,
    );
    final dot = Paint()..color = FarmScene.soilDot;
    for (var x = 3.0; x < size.width; x += 11) {
      canvas.drawRect(Rect.fromLTWH(x, soilTop + 3 + (x % 3), 2, 2), dot);
    }
  }

  @override
  bool shouldRepaint(FarmGroundPainter oldDelegate) => false;
}

/// Um gorila. [bob] em 0..1 (fase da animação); [bobbing] liga o pulinho de
/// quem está trabalhando. [dim] apaga quem dorme ou já terminou.
class FarmCritterPainter extends CustomPainter {
  FarmCritterPainter({
    required this.body,
    required this.face,
    required this.phase,
    required this.bobbing,
    required this.dim,
  }) : super(repaint: phase);

  final Color body;
  final Color face;
  final Animation<double> phase;
  final bool bobbing;
  final bool dim;

  @override
  void paint(Canvas canvas, Size size) {
    const rows = FarmScene.sprite;
    final px = size.width / rows.first.length;
    final lift = bobbing
        ? (math.sin(phase.value * 2 * math.pi) * 0.5 + 0.5) * px
        : 0.0;
    final alpha = dim ? 0.45 : 1.0;
    final paints = <String, Paint>{
      '#': Paint()..color = body.withValues(alpha: alpha),
      'f': Paint()..color = face.withValues(alpha: alpha),
      'e': Paint()..color = FarmScene.eye.withValues(alpha: alpha),
      'n': Paint()..color = FarmScene.eye.withValues(alpha: alpha * 0.7),
    };
    for (var y = 0; y < rows.length; y++) {
      final row = rows[y];
      for (var x = 0; x < row.length; x++) {
        final paint = paints[row[x]];
        if (paint == null) continue;
        canvas.drawRect(
          Rect.fromLTWH(x * px, y * px - lift, px + 0.5, px + 0.5),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(FarmCritterPainter old) =>
      old.body != body ||
      old.face != face ||
      old.bobbing != bobbing ||
      old.dim != dim;
}
