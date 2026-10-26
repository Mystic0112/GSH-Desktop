import 'package:gsh_desktop/app/gsh/ui/session/pane_item.dart';
import 'package:gsh_desktop/i18n/strings.g.dart';

/// Aba **Harness** do workspace: o que o agente carrega ao rodar nesta
/// pasta (instruções, skills, subagentes, comandos, hooks, permissões, MCP).
/// O estado vive no `HarnessViewModel`; a aba só o mostra.
class HarnessSession extends PaneItem {
  HarnessSession({
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

  // ponytail: `t` global, mesmo motivo da FarmSession.
  @override
  String get title => t.gsh.harness.tabTitle;
}
