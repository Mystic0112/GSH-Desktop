import 'package:cockpit/app/cockpit/domain/entities/chat_event.dart';

/// Uma conversa viva com um agente (hoje: Claude Code em `stream-json`). Fica
/// de pé entre turnos: cada [send] é um turno novo na mesma sessão.
abstract interface class ChatEngine {
  Stream<ChatEvent> get events;

  /// Manda uma mensagem do usuário (começa um turno).
  void send(String text);

  /// Responde um [ChatPermissionAsk].
  void answerPermission(String requestId, {required bool allow});

  /// Interrompe o turno em andamento.
  void interrupt();

  Future<void> close();
}

/// Sobe um [ChatEngine] em [cwd]; [resumeSessionId] retoma uma sessão.
abstract interface class ChatEngineFactory {
  Future<ChatEngine> start({required String cwd, String? resumeSessionId});
}
