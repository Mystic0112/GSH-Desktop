import 'dart:async';

import 'package:cockpit/app/cockpit/domain/entities/agent_message.dart';
import 'package:flutter/foundation.dart';

/// Log em memória das [AgentMessage] por workspace, das mais antigas às mais
/// novas. Não persiste: some ao fechar o app.
class AgentMessageLog extends ChangeNotifier {
  /// Teto por workspace; acima disso a mais antiga sai.
  static const int maxPerWorkspace = 500;

  /// Tamanho da prévia guardada (o texto inteiro já foi pro PTY do alvo).
  static const int previewLength = 200;

  final Map<String, List<AgentMessage>> _byWorkspace = {};

  List<AgentMessage> forWorkspace(String workspaceId) =>
      List.unmodifiable(_byWorkspace[workspaceId] ?? const <AgentMessage>[]);

  /// Registra [text] de [fromTabId] para [toTabId] em cada workspace
  /// envolvido (o do emissor e, se diferente, o do alvo).
  AgentMessage record({
    required String fromTabId,
    required String fromWorkspaceId,
    required String toTabId,
    required String toWorkspaceId,
    required String text,
    String? signedBy,
  }) {
    final message = AgentMessage(
      fromTabId: fromTabId,
      toTabId: toTabId,
      sentAt: DateTime.now(),
      preview: text.length > previewLength
          ? text.substring(0, previewLength)
          : text,
      signedBy: signedBy,
    );
    for (final ws in {fromWorkspaceId, toWorkspaceId}) {
      final list = _byWorkspace.putIfAbsent(ws, () => <AgentMessage>[]);
      list.add(message);
      if (list.length > maxPerWorkspace) list.removeAt(0);
    }
    notifyListeners();
    return message;
  }

  /// Até onde cada aba já leu pelo [takeFor].
  final Map<String, DateTime> _readUpTo = {};

  /// A partir de agora, [takeFor] de [tabId] só devolve o que chegar depois
  /// (o `cockpit mcp` da aba chama ao subir: o histórico já foi digitado).
  void markRead(String tabId) => _readUpTo[tabId] = DateTime.now();

  /// `wait_messages` do MCP numa ABA de terminal (o Codex, cujo sandbox
  /// bloqueia a CLI de shell): as mensagens pra [tabId] desde a última
  /// chamada; nenhuma, espera até [timeout] pela primeira. A entrega de
  /// verdade continua sendo digitar no PTY — isto só deixa o agente buscar o
  /// que chegou. Devolve a prévia ([previewLength]), não o texto inteiro.
  // ponytail: cursor por horário, não por sequência; duas mensagens no mesmo
  // microssegundo pra mesma aba se fundiriam.
  Future<List<AgentMessage>> takeFor(
    String tabId,
    String workspaceId,
    Duration timeout,
  ) async {
    List<AgentMessage> fresh() {
      final since = _readUpTo[tabId];
      return [
        for (final m in _byWorkspace[workspaceId] ?? const <AgentMessage>[])
          if (m.toTabId == tabId && (since == null || m.sentAt.isAfter(since)))
            m,
      ];
    }

    var out = fresh();
    if (out.isEmpty && timeout > Duration.zero) {
      final arrived = Completer<void>();
      void check() {
        if (!arrived.isCompleted && fresh().isNotEmpty) arrived.complete();
      }

      addListener(check);
      try {
        await arrived.future.timeout(timeout, onTimeout: () {});
      } finally {
        removeListener(check);
      }
      out = fresh();
    }
    if (out.isNotEmpty) _readUpTo[tabId] = out.last.sentAt;
    return out;
  }
}
