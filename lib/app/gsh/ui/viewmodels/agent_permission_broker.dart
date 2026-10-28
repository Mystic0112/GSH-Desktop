import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/agent_permission.dart';

/// Pedidos de permissão dos agentes de terminal esperando decisão (a ilha e
/// a notificação mostram; quem decide completa). Enquanto um pedido espera,
/// o terminal não mostra o prompt do Claude: por isso ir até a aba devolve o
/// pedido ao terminal ([releaseTab]).
class AgentPermissionBroker extends ChangeNotifier {
  final _pending =
      <String, (AgentPermissionAsk, Completer<AgentPermissionDecision>)>{};

  /// Mais antigos primeiro.
  List<AgentPermissionAsk> get pending => [
    for (final p in _pending.values) p.$1,
  ];

  AgentPermissionAsk? forTab(String tabId) =>
      _pending.values.where((p) => p.$1.tabId == tabId).firstOrNull?.$1;

  Future<AgentPermissionDecision> ask(AgentPermissionAsk ask) {
    final done = Completer<AgentPermissionDecision>();
    _pending[ask.id] = (ask, done);
    notifyListeners();
    return done.future;
  }

  void decide(String id, AgentPermissionDecision decision) {
    final p = _pending.remove(id);
    if (p == null) return;
    p.$2.complete(decision);
    notifyListeners();
  }

  /// O usuário foi até a aba (ou ela fechou): os pedidos dela voltam para o
  /// prompt do terminal.
  void releaseTab(String tabId) {
    for (final p in [..._pending.values]) {
      if (p.$1.tabId == tabId) decide(p.$1.id, AgentPermissionDecision.pass);
    }
  }

  @override
  void dispose() {
    for (final p in _pending.values) {
      p.$2.complete(AgentPermissionDecision.pass);
    }
    _pending.clear();
    super.dispose();
  }
}
