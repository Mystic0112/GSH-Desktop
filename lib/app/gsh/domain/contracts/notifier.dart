import 'package:gsh_desktop/app/core/domain/entities/sound_event.dart';

/// O que o usuário fez numa notificação: [key] é a que foi passada ao
/// mostrar (`tab:<id>` ou `ask:<id>`).
class NotifierAction {
  const NotifierAction(this.key, this.kind);
  final String key;
  final NotifierActionKind kind;
}

enum NotifierActionKind { open, allow, allowAlways, deny }

/// Notificações nativas do SO + sons in-app. Contrato no domínio; a impl
/// (plugin) mora em `data/notifications/`.
abstract class Notifier {
  /// Inicializa o backend (pede permissão no boot).
  Future<void> init();

  /// Notifica que um agente terminou um turno. [key] identifica a aba: a
  /// notificação nova da mesma aba substitui a anterior (não empilha).
  Future<void> agentFinished({
    required String key,
    required String agentName,
    required String workspace,
  });

  /// Notifica que um agente parou esperando ação do usuário (permissão,
  /// pergunta, plano).
  Future<void> agentNeedsAction({
    required String key,
    required String agentName,
    required String workspace,
  });

  /// Pedido de permissão com botões Permitir / Sempre ([canAlways]) / Negar.
  /// [detail] = a ferramenta e o comando/arquivo.
  Future<void> permissionAsk({
    required String key,
    required String agentName,
    required String workspace,
    required String detail,
    required bool canAlways,
  });

  /// Tira a notificação [key] (decidida em outro lugar).
  Future<void> dismiss(String key);

  /// Cliques nas notificações e nos botões delas.
  Stream<NotifierAction> get actions;

  /// Toca o som in-app de [event]. Usado quando a janela está focada — chama
  /// atenção sem banner do SO (distinto do som da notificação do SO, que toca
  /// só desfocada). [customPath] = áudio escolhido pelo usuário; se ausente ou
  /// falhar ao abrir, toca o som embarcado do evento. [volume] em % (0–100).
  Future<void> play(SoundEvent event, {String? customPath, double volume});
}
