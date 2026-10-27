import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:gsh_desktop/app/core/ui/themes/themes.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/farm/farm_sprites.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

/// O que o gorila da ilha está fazendo.
enum GorillaMood {
  /// Nenhum agente: dorme (um "z" parado).
  sleep,

  /// Ilha recolhida e ninguém trabalhando: quadro parado.
  rest,

  /// Ilha aberta e ninguém trabalhando: respira e pisca.
  breathe,

  /// Alguém trabalhando: digita.
  typing,

  /// Alguém espera por você: acena, com um "!" na cor de aviso.
  wave,

  /// Um agente acabou de terminar: pula de alegria.
  cheer,
}

/// O gorila da fazenda (o mesmo sprite, careca) na ilha de agentes. Anima com
/// um [Timer] no ritmo da pose (5 a 11 quadros por segundo), nunca com ticker
/// de 60 fps; parado ([GorillaMood.rest]/[GorillaMood.sleep]) não agenda
/// nada.
class IslandGorilla extends StatefulWidget {
  const IslandGorilla({super.key, required this.mood});

  final GorillaMood mood;

  /// Tamanho na tela: o recorte do sprite (32 x 25) em 1:1, nítido no 2x.
  static const size = Size(32, 25);

  @override
  State<IslandGorilla> createState() => _IslandGorillaState();
}

class _IslandGorillaState extends State<IslandGorilla> {
  static final _skin = FarmSkin.of('agent-island', clay, fixed: true);
  Timer? _timer;
  int _tick = 0;

  @override
  void initState() {
    super.initState();
    _schedule();
  }

  @override
  void didUpdateWidget(IslandGorilla old) {
    super.didUpdateWidget(old);
    if (old.mood != widget.mood) _schedule();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _schedule() {
    _timer?.cancel();
    _tick = 0;
    final ms = switch (widget.mood) {
      GorillaMood.sleep || GorillaMood.rest => null,
      GorillaMood.breathe => 650,
      GorillaMood.typing => 140,
      GorillaMood.wave => 280,
      GorillaMood.cheer => 90,
    };
    _timer = ms == null
        ? null
        : Timer.periodic(
            Duration(milliseconds: ms),
            (_) => setState(() => _tick++),
          );
  }

  @override
  Widget build(BuildContext context) {
    final t = _tick;
    final (image, dy) = switch (widget.mood) {
      GorillaMood.sleep => (_skin.frame(sleep: true), 0.0),
      GorillaMood.rest => (_skin.frame(), 0.0),
      // afunda 1px a cada outro quadro e pisca de vez em quando
      GorillaMood.breathe => (_skin.frame(blink: t % 7 == 6), (t % 2) * 1.0),
      GorillaMood.typing => (_skin.frame(arms: t.isOdd ? 2 : 3), 0.0),
      GorillaMood.wave => (
        _skin.frame(arms: t.isOdd ? 1 : 0, look: 1),
        t % 4 == 0 ? -1.0 : 0.0,
      ),
      GorillaMood.cheer => (
        _skin.frame(arms: (t ~/ 2).isOdd ? 1 : 0, happy: true),
        -(math.sin(t * math.pi / 5).abs() * 5).roundToDouble(),
      ),
    };
    return RepaintBoundary(
      child: CustomPaint(
        size: IslandGorilla.size,
        painter: _GorillaPainter(
          image: image,
          dy: dy,
          sleeping: widget.mood == GorillaMood.sleep,
          // o "!" pisca junto com o aceno
          alert: widget.mood == GorillaMood.wave && t % 4 != 3
              ? (context.colors.warn, context.colors.bg)
              : null,
        ),
      ),
    );
  }
}

class _GorillaPainter extends CustomPainter {
  _GorillaPainter({
    required this.image,
    required this.dy,
    this.sleeping = false,
    this.alert,
  });

  final ui.Image image;
  final double dy;

  /// O "z" de quem dorme, no alto à direita.
  final bool sleeping;

  /// O selo "!" no alto à direita: (fundo, tinta).
  final (Color, Color)? alert;

  static final _paint = Paint()..filterQuality = FilterQuality.none;

  /// Linhas acima da cabeça careca que o sprite de 32 x 36 deixa vazias.
  static const _top = 11.0;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, _top, 32, 36 - _top),
      Rect.fromLTWH(0, dy, size.width, size.height),
      _paint,
    );
    if (sleeping) {
      canvas.drawImage(zed, Offset(size.width - 5, -3 + dy), _paint);
    }
    if (alert case (final fill, final ink)) {
      final x = size.width - 2, y = 1 + dy;
      canvas
        ..drawCircle(Offset(x, y), 5, Paint()..color = fill)
        ..drawRect(
          Rect.fromLTWH(x - 0.75, y - 3.5, 1.5, 4.5),
          Paint()..color = ink,
        )
        ..drawRect(
          Rect.fromLTWH(x - 0.75, y + 2, 1.5, 1.5),
          Paint()..color = ink,
        );
    }
  }

  @override
  bool shouldRepaint(_GorillaPainter old) =>
      old.image != image ||
      old.dy != dy ||
      old.sleeping != sleeping ||
      old.alert != alert;
}
