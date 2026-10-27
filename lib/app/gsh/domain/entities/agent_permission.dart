/// Pedido de permissão de um agente numa aba de terminal (hook
/// `PermissionRequest` do Claude Code), esperando decisão na ilha ou na
/// notificação.
class AgentPermissionAsk {
  const AgentPermissionAsk({
    required this.id,
    required this.tabId,
    required this.toolName,
    required this.input,
    this.alwaysRule,
    this.alwaysRaw,
  });

  final String id;
  final String tabId;
  final String toolName;

  /// Input cru da ferramenta (comando do Bash, arquivo do Edit...).
  final Map<String, dynamic> input;

  /// Regra que "Sempre permitir" grava (`Bash(npm test:*)`); `null` = sem o
  /// botão.
  final String? alwaysRule;

  /// A sugestão como o harness mandou, devolvida tal qual no "sempre".
  final Map<String, dynamic>? alwaysRaw;
}

enum AgentPermissionDecision {
  allow,
  allowAlways,
  deny,

  /// Deixa o terminal perguntar (o usuário foi até a aba, ou o GSH não
  /// decide).
  pass,
}
