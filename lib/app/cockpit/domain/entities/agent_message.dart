/// Uma mensagem entre agentes de abas diferentes (`cockpit msg`). Base do
/// grafo de conversa entre abas; o texto completo vai pro PTY do alvo, aqui
/// fica só a prévia.
class AgentMessage {
  const AgentMessage({
    required this.fromTabId,
    required this.toTabId,
    required this.sentAt,
    required this.preview,
    this.signedBy,
  });

  final String fromTabId;
  final String toTabId;
  final DateTime sentAt;
  final String preview;

  /// Assinatura que o alvo viu (`<nome> · <harness>`, ou `cockpit` nas
  /// apresentações). `null` em mensagem registrada sem ela.
  final String? signedBy;

  /// Linha que o agente alvo recebe: `[from: <nome> · <harness>] <texto>`.
  /// Sem harness detectado (script num shell), o `· <harness>` some.
  static String formatLine({
    required String senderName,
    required String? senderHarness,
    required String text,
  }) => '[from: ${signature(senderName, senderHarness)}] $text';

  /// `<nome> · <harness>` (ou só o nome): quem assina a mensagem.
  static String signature(String name, String? harness) =>
      harness == null ? name : '$name · $harness';
}
