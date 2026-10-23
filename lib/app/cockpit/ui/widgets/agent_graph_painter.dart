import 'dart:math' as math;

import 'package:cockpit/app/core/ui/themes/agent_colors.dart';
import 'package:cockpit/app/cockpit/ui/viewmodels/agent_graph_store.dart';
import 'package:flutter/rendering.dart';

/// Geometria do nó no canvas (coordenadas de cena).
const double kAgentNodeWidth = 220;
const double kAgentNodeHeight = 88;
const double kAgentPortRadius = 7;

/// Duração do ponto que corre pelo cabo quando chega mensagem.
const Duration kCablePulse = Duration(milliseconds: 1500);

/// Um cabo entre dois nós: definido (link do usuário), observado (trocaram
/// mensagens) ou os dois — aí é um cabo só, sólido, que ainda pulsa.
class GraphCable {
  const GraphCable(this.pair, {required this.defined, this.observed});
  final AgentPair pair;
  final bool defined;
  final ObservedEdge? observed;
}

/// Une links definidos e cabos observados num cabo por par, só entre [nodes]
/// visíveis.
List<GraphCable> buildCables({
  required Set<AgentPair> defined,
  required Map<AgentPair, ObservedEdge> observed,
  required Set<String> nodes,
}) => [
  for (final pair in {...defined, ...observed.keys})
    if (nodes.contains(pair.$1) && nodes.contains(pair.$2))
      GraphCable(
        pair,
        defined: defined.contains(pair),
        observed: observed[pair],
      ),
];

/// Ponto em trânsito de [from] para [to]; [progress] em 0..1.
typedef GraphPulse = ({String from, String to, double progress});

typedef CableCurve = (Offset, Offset, Offset, Offset);

/// Bézier cúbica entre os lados mais próximos dos nós em [a] e [b] (canto
/// superior esquerdo de cada um), sempre orientada de [a] para [b].
CableCurve cableCurve(Offset a, Offset b) {
  const mid = kAgentNodeHeight / 2;
  final forward = b.dx >= a.dx;
  final p0 = a + Offset(forward ? kAgentNodeWidth : 0, mid);
  final p3 = b + Offset(forward ? 0 : kAgentNodeWidth, mid);
  final dx = math.max(48.0, (p3.dx - p0.dx).abs() / 2) * (forward ? 1 : -1);
  return (p0, p0 + Offset(dx, 0), p3 - Offset(dx, 0), p3);
}

Offset bezierAt(CableCurve c, double t) {
  final (p0, p1, p2, p3) = c;
  final u = 1 - t;
  return p0 * (u * u * u) +
      p1 * (3 * u * u * t) +
      p2 * (3 * u * t * t) +
      p3 * (t * t * t);
}

/// Distância aproximada de [p] à curva (amostragem — sobra pra hover).
double distanceToCable(CableCurve c, Offset p) {
  var best = double.infinity;
  for (var i = 0; i <= 32; i++) {
    best = math.min(best, (bezierAt(c, i / 32) - p).distance);
  }
  return best;
}

Path _curvePath(CableCurve c) {
  final (p0, p1, p2, p3) = c;
  return Path()
    ..moveTo(p0.dx, p0.dy)
    ..cubicTo(p1.dx, p1.dy, p2.dx, p2.dy, p3.dx, p3.dy);
}

Path _dashed(Path source, {double on = 6, double off = 5}) {
  final out = Path();
  for (final metric in source.computeMetrics()) {
    for (var d = 0.0; d < metric.length; d += on + off) {
      out.addPath(metric.extractPath(d, d + on), Offset.zero);
    }
  }
  return out;
}

class AgentGraphPainter extends CustomPainter {
  AgentGraphPainter({
    this.colorOf = agentColorFor,
    required this.positions,
    required this.cables,
    required this.pulses,
    required this.lineColor,
    required this.definedColor,
    required this.hoverColor,
    this.hovered,
    this.pendingFrom,
    this.pendingTo,
  });

  /// Cor por aba (pulso do cabo): `AgentGraphStore.colorOf` no app.
  final Color Function(String tabId) colorOf;
  final Map<String, Offset> positions;
  final List<GraphCable> cables;
  final List<GraphPulse> pulses;
  final Color lineColor;
  final Color definedColor;
  final Color hoverColor;
  final AgentPair? hovered;

  /// Link sendo arrastado da porta de um nó até o ponteiro.
  final Offset? pendingFrom;
  final Offset? pendingTo;

  @override
  void paint(Canvas canvas, Size size) {
    final curves = <AgentPair, CableCurve>{};
    for (final cable in cables) {
      final a = positions[cable.pair.$1];
      final b = positions[cable.pair.$2];
      if (a == null || b == null) continue;
      final curve = curves[cable.pair] = cableCurve(a, b);
      final count = cable.observed?.count ?? 0;
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        // Espessura cresce com o volume de mensagens, com teto.
        ..strokeWidth = (cable.defined ? 2.0 : 1.5) + math.min(count, 10) * 0.35
        ..color = cable.pair == hovered
            ? hoverColor
            : (cable.defined ? definedColor : lineColor);
      final path = _curvePath(curve);
      canvas.drawPath(cable.defined ? path : _dashed(path), paint);
    }

    for (final pulse in pulses) {
      final pair = agentPair(pulse.from, pulse.to);
      final curve = curves[pair];
      if (curve == null) continue;
      final t = pulse.from == pair.$1 ? pulse.progress : 1 - pulse.progress;
      final at = bezierAt(curve, t);
      final color = colorOf(pulse.from);
      canvas
        ..drawCircle(at, 8, Paint()..color = color.withValues(alpha: 0.25))
        ..drawCircle(at, 4, Paint()..color = color);
    }

    final from = pendingFrom;
    final to = pendingTo;
    if (from != null && to != null) {
      canvas.drawPath(
        _dashed(
          Path()
            ..moveTo(from.dx, from.dy)
            ..lineTo(to.dx, to.dy),
        ),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = hoverColor,
      );
    }
  }

  // ponytail: repinta sempre — a lista de cabos é recriada a cada build e o
  // canvas só reconstrói em mudança real ou durante um pulso.
  @override
  bool shouldRepaint(AgentGraphPainter oldDelegate) => true;
}
