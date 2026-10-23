/// O que o motor de chat (Claude Code em `stream-json`) avisa. Um evento por
/// bloco: texto, chamada de ferramenta, resultado, pedido de permissão, fim de
/// turno. A UI monta a conversa a partir disto.
sealed class ChatEvent {
  const ChatEvent();
}

/// Sessão no ar (`system/init`).
class ChatReady extends ChatEvent {
  const ChatReady({required this.sessionId, required this.model});
  final String sessionId;
  final String model;
}

/// Texto do assistente (um bloco `text`).
class ChatText extends ChatEvent {
  const ChatText(this.text);
  final String text;
}

/// O assistente chamou uma ferramenta.
class ChatToolCall extends ChatEvent {
  const ChatToolCall({
    required this.id,
    required this.name,
    required this.input,
  });
  final String id;
  final String name;
  final Map<String, dynamic> input;
}

/// Uma ferramenta voltou.
class ChatToolResult extends ChatEvent {
  const ChatToolResult({
    required this.toolUseId,
    required this.isError,
    required this.text,
  });
  final String toolUseId;
  final bool isError;
  final String text;
}

/// O Claude Code pede permissão para rodar uma ferramenta e espera a resposta
/// ([ChatEngine.answerPermission] com o mesmo [requestId]).
class ChatPermissionAsk extends ChatEvent {
  const ChatPermissionAsk({
    required this.requestId,
    required this.toolName,
    required this.input,
    this.description,
  });
  final String requestId;
  final String toolName;
  final Map<String, dynamic> input;
  final String? description;
}

/// Fim do turno (`result`).
class ChatTurnEnd extends ChatEvent {
  const ChatTurnEnd({
    required this.isError,
    required this.text,
    required this.sessionId,
    this.costUsd,
  });
  final bool isError;
  final String text;
  final String sessionId;
  final double? costUsd;
}

/// O processo do motor saiu sem a gente pedir.
class ChatEngineFailed extends ChatEvent {
  const ChatEngineFailed({required this.exitCode, required this.stderr});
  final int exitCode;

  /// Últimas linhas do stderr (pode ser vazio).
  final String stderr;
}
