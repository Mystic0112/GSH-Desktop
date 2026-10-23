import 'package:cockpit/app/cockpit/ui/session/pane_item.dart';
import 'package:cockpit/i18n/strings.g.dart';

/// Aba do **grafo de agentes** do workspace (canvas com os agentes e os cabos
/// entre eles). Uma por workspace; o estado (posições, links) vive no
/// `AgentGraphStore` da VM, não aqui — fechar a aba não perde a topologia.
class AgentGraphSession extends PaneItem {
  AgentGraphSession({
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

  // ponytail: `t` global (sessão não tem context) — o título da aba só troca
  // de idioma quando a aba reconstrói, igual ao 'Browser'/'New tab' literais.
  @override
  String get title => t.cockpit.agentGraph.tabTitle;
}
