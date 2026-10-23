import 'package:flutter/painting.dart';

/// Paleta fixa das cores de agente: tons médios (Tailwind 500) que leem bem
/// tanto no tema claro quanto no escuro. Fora do tema de propósito: a cor
/// identifica a ABA, e precisa ser a mesma em todo lugar (árvore de arquivos,
/// grafo de agentes) independente do tema ativo.
const List<Color> agentPalette = <Color>[
  Color(0xFF3B82F6), // blue
  Color(0xFF10B981), // emerald
  Color(0xFFF59E0B), // amber
  Color(0xFFF43F5E), // rose
  Color(0xFF8B5CF6), // violet
  Color(0xFF06B6D4), // cyan
  Color(0xFFF97316), // orange
  Color(0xFFEC4899), // pink
];

/// Cor estável do agente da aba [tabId]: mesmo id → mesma cor, em qualquer
/// execução (hash FNV-1a próprio; `String.hashCode` não promete estabilidade).
Color agentColorFor(String tabId) {
  var h = 0x811c9dc5;
  for (final c in tabId.codeUnits) {
    h = ((h ^ c) * 0x01000193) & 0xFFFFFFFF;
  }
  return agentPalette[h % agentPalette.length];
}
