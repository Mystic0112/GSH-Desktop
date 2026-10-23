import 'dart:async';

import 'package:cockpit/app/cockpit/domain/entities/desktop_agent_app.dart';
import 'package:cockpit/app/cockpit/ui/session/pane_item.dart';

/// Mensagem na fila de um [ExternalAgent]; sai pelo `wait_messages` do MCP.
typedef InboxMessage = ({String from, String text, DateTime sentAt});

/// Nó **externo** do grafo de agentes: um app desktop (Claude Desktop, Cursor…)
/// que fala com o Cockpit pelo servidor MCP da CLI (`cockpit mcp --agent`).
/// Não é uma aba (não mora nas sessões da VM): é [PaneItem] só pra entrar nos
/// mesmos caminhos de label, `msg`, `peers` e log que as abas usam.
///
/// Modelo pull: o que chega pra ele vai pra [_inbox] e sai no long-poll
/// ([waitMessages]); presença vem do batimento do processo MCP.
class ExternalAgent extends PaneItem {
  ExternalAgent({
    required this.app,
    required this.projectId,
    required this.workingDirectory,
    required String label,
  }) {
    restoreManualLabel(label);
  }

  /// Um nó por app no Cockpit inteiro: a entrada MCP do app é uma só.
  static String idFor(DesktopAgentApp app) => 'ext:${app.id}';

  static const int inboxCap = 200;

  /// Sem batimento por esse tempo = offline (o MCP bate a cada 5s).
  static const Duration onlineWindow = Duration(seconds: 15);

  // ponytail: "working" = chamou alguma ferramenta nos últimos 10s; o MCP não
  // diz quando o turno do app começa/termina.
  static const Duration workingWindow = Duration(seconds: 10);

  final DesktopAgentApp app;
  @override
  final String projectId;

  /// Pasta que as IDEs abrem no Focus (raiz do workspace; vazio se remoto).
  @override
  final String workingDirectory;

  @override
  String get id => idFor(app);
  @override
  String get title => app.label;

  final List<InboxMessage> _inbox = [];
  Completer<void>? _arrived;
  bool _seen = false, _active = false;
  Timer? _seenTimer, _activeTimer;
  int _waiting = 0;
  bool _disposed = false;

  /// Timers e long-polls podem cair depois do dispose (nó removido).
  void _notify() {
    if (!_disposed) notifyListeners();
  }

  bool get online => _waiting > 0 || _seen;
  @override
  bool get isWorking => _active;

  /// Mensagens esperando um `wait_messages`.
  int get pending => _inbox.length;

  /// Batimento do processo MCP.
  void heartbeat() {
    final was = online;
    _seen = true;
    _seenTimer?.cancel();
    _seenTimer = Timer(onlineWindow, () {
      _seen = false;
      _notify();
    });
    if (!was) _notify();
  }

  /// Chamada de ferramenta (send, peers, wait…): online + working por um tempo.
  void markActive() {
    heartbeat();
    _active = true;
    _activeTimer?.cancel();
    _activeTimer = Timer(workingWindow, () {
      _active = false;
      _notify();
    });
    _notify();
  }

  void enqueue(String from, String text) {
    _inbox.add((from: from, text: text, sentAt: DateTime.now()));
    if (_inbox.length > inboxCap) _inbox.removeAt(0);
    _arrived?.complete();
    _arrived = null;
    _notify();
  }

  /// Esvazia a fila; vazia, espera até [timeout] pela primeira mensagem.
  // ponytail: dois waits simultâneos acordam juntos e só um leva a fila.
  Future<List<InboxMessage>> waitMessages(Duration timeout) async {
    if (_inbox.isEmpty && timeout > Duration.zero) {
      final arrived = _arrived ??= Completer<void>();
      _waiting++;
      try {
        await arrived.future.timeout(timeout, onTimeout: () {});
      } finally {
        _waiting--;
      }
    }
    final out = List.of(_inbox);
    _inbox.clear();
    if (out.isNotEmpty) _notify();
    return out;
  }

  @override
  void dispose() {
    _disposed = true;
    _seenTimer?.cancel();
    _activeTimer?.cancel();
    _arrived?.complete(); // long-poll pendente volta vazio
    _arrived = null;
    super.dispose();
  }
}
