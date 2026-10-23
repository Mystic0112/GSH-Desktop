import 'package:cockpit/app/cockpit/ui/session/pane_item.dart';
import 'package:cockpit/i18n/strings.g.dart';

/// Aba de **chat** com o Claude Code (protótipo do harness estilo Claude
/// Desktop). A conversa vive no `ChatViewModel`, por id da aba.
class ChatSession extends PaneItem {
  ChatSession({
    required this.id,
    required this.projectId,
    required this.workingDirectory,
  });

  @override
  final String id;
  @override
  final String projectId;
  @override
  final String workingDirectory;

  // ponytail: `t` global, mesmo motivo do AgentGraphSession.
  @override
  String get title => t.cockpit.chat.tabTitle;

  /// Chamado quando a aba é fechada: a view pendura aqui o encerramento da
  /// conversa (mata o processo do `claude`).
  void Function()? onDisposed;

  @override
  void dispose() {
    onDisposed?.call();
    super.dispose();
  }
}
