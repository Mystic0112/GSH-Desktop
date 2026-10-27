import 'package:gsh_desktop/app/gsh/domain/entities/chat_usage.dart';

/// O que o motor de chat (Claude Code em `stream-json`) avisa. Um evento por
/// bloco: texto, chamada de ferramenta, resultado, pedido de permissão, fim de
/// turno. A UI monta a conversa a partir disto.
sealed class ChatEvent {
  const ChatEvent();
}

/// Sessão no ar (`system/init`).
class ChatReady extends ChatEvent {
  const ChatReady({
    required this.sessionId,
    required this.model,
    this.permissionMode,
  });
  final String sessionId;
  final String model;
  final String? permissionMode;
}

/// O modo de permissão mudou (`plan`, `default`, `acceptEdits`...): o usuário
/// pediu, ou o agente saiu do plano ao ser aprovado.
class ChatModeChanged extends ChatEvent {
  const ChatModeChanged(this.mode);
  final String mode;
}

/// Pedaço de texto do assistente chegando enquanto o modelo escreve
/// (`--include-partial-messages`). O [ChatText] completo vem depois.
class ChatTextDelta extends ChatEvent {
  const ChatTextDelta(this.text);
  final String text;
}

/// Pedaço do resumo de raciocínio chegando (`thinking_delta`, só com
/// `--thinking-display summarized`). O [ChatThinking] completo vem depois.
class ChatThinkingDelta extends ChatEvent {
  const ChatThinkingDelta(this.text);
  final String text;
}

/// Resumo de raciocínio do modelo (um bloco `thinking` com texto).
class ChatThinking extends ChatEvent {
  const ChatThinking(this.text);
  final String text;
}

/// Estado que o Claude Code classifica ao fim do turno
/// (`system/post_turn_summary`, `status_category`).
enum ChatSessionState { completed, reviewReady, blocked, failed }

/// O Claude Code classificou a sessão ao fim do turno. [detail] é o
/// `status_detail` (texto do modelo, cru).
class ChatSessionClassified extends ChatEvent {
  const ChatSessionClassified(this.state, {this.detail = ''});
  final ChatSessionState state;
  final String detail;
}

/// Mensagem de OUTRA sessão do Claude Code (SendMessage entre sessões): o
/// Claude Code a injeta como turno do usuário; o host só vê porque o motor
/// roda com `--replay-user-messages`.
class ChatPeerMessage extends ChatEvent {
  const ChatPeerMessage({
    required this.fromName,
    required this.from,
    required this.text,
  });
  final String fromName;

  /// Endereço (socket) da sessão que mandou.
  final String from;
  final String text;
}

/// Aviso do próprio Claude Code (`system/informational`), ex.: mensagem
/// para outra sessão ficou retida.
class ChatInfo extends ChatEvent {
  const ChatInfo(this.text, {required this.warning});
  final String text;
  final bool warning;
}

/// Mensagem do usuário lida do histórico (retomar conversa).
class ChatUserText extends ChatEvent {
  const ChatUserText(this.text, {this.at});
  final String text;

  /// Quando foi escrita (do transcript); `null` = agora.
  final DateTime? at;
}

/// Texto do assistente (um bloco `text`).
class ChatText extends ChatEvent {
  const ChatText(this.text, {this.at});
  final String text;

  /// Quando chegou (do transcript); `null` = agora.
  final DateTime? at;
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
    this.alwaysRule,
  });
  final String requestId;
  final String toolName;
  final Map<String, dynamic> input;
  final String? description;

  /// Regra que "sempre permitir" grava (ex.: `Bash(npm test *)`), vinda das
  /// sugestões do próprio Claude Code. `null` = não oferece.
  final String? alwaysRule;
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

/// Modelos que a conta pode usar (resposta do `initialize`).
class ChatModels extends ChatEvent {
  const ChatModels(this.models);
  final List<ChatModelOption> models;
}

/// O modelo da conversa mudou (pedido do usuário). [model] é o id real.
class ChatModelChanged extends ChatEvent {
  const ChatModelChanged(this.model);
  final String model;
}

/// Quanto do contexto a conversa ocupa (a cada resposta do modelo) e a
/// janela do modelo (ao fim do turno).
class ChatContext extends ChatEvent {
  const ChatContext({required this.tokens, required this.window});

  /// 0 = não veio.
  final int tokens;

  /// Janela do modelo (200k, 1M...). 0 = não veio.
  final int window;
}

/// Comandos `/nome` da sessão (resposta do `initialize`).
class ChatCommands extends ChatEvent {
  const ChatCommands(this.commands);
  final List<ChatCommandOption> commands;
}
