import 'package:cockpit/app/cockpit/domain/entities/chat_attachment.dart';
import 'package:cockpit/app/cockpit/domain/entities/chat_event.dart';

/// Uma conversa viva com um agente (hoje: Claude Code em `stream-json`). Fica
/// de pé entre turnos: cada [send] é um turno novo na mesma sessão.
abstract interface class ChatEngine {
  Stream<ChatEvent> get events;

  /// Manda uma mensagem do usuário (começa um turno), com [attachments].
  /// Lança [ChatAttachmentTooLarge] se um anexo passa do teto da API.
  Future<void> send(String text, {List<ChatAttachment> attachments = const []});

  /// Responde um [ChatPermissionAsk]. [always] grava a regra sugerida
  /// ([ChatPermissionAsk.alwaysRule]) nas permissões locais do projeto.
  /// [input] substitui o input da ferramenta no `allow` (é como as respostas
  /// do `AskUserQuestion` voltam); [message] explica um `deny` ao agente (é
  /// como "continuar planejando" manda o ajuste do plano).
  void answerPermission(
    String requestId, {
    required bool allow,
    bool always = false,
    Map<String, dynamic>? input,
    String? message,
  });

  /// Troca o modo de permissão da sessão (`plan` = só planeja).
  void setPermissionMode(String mode);

  /// Interrompe o turno em andamento.
  void interrupt();

  Future<void> close();
}

/// Sobe um [ChatEngine] em [cwd]; [resumeSessionId] retoma uma sessão.
abstract interface class ChatEngineFactory {
  Future<ChatEngine> start({required String cwd, String? resumeSessionId});

  /// A conversa já gravada da sessão [sessionId] (para mostrar ao retomar).
  Future<List<ChatEvent>> history({
    required String cwd,
    required String sessionId,
  });
}
