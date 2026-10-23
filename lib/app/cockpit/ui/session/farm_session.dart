import 'package:cockpit/app/cockpit/ui/session/pane_item.dart';
import 'package:cockpit/i18n/strings.g.dart';

/// Aba da **fazenda**: todos os loops de agente da máquina, agrupados por
/// pasta. O estado vive no `FarmViewModel`; a aba só o mostra.
class FarmSession extends PaneItem {
  FarmSession({
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
  String get title => t.cockpit.farm.tabTitle;
}
