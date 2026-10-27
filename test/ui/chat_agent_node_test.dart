import 'package:flutter_test/flutter_test.dart';
import 'package:gsh_desktop/app/gsh/ui/session/chat_session.dart';
import 'package:gsh_desktop/app/gsh/ui/viewmodels/agent_graph_store.dart';
import 'package:gsh_desktop/app/gsh/ui/viewmodels/agent_message_delivery.dart';
import 'package:gsh_desktop/app/gsh/ui/viewmodels/agent_message_log.dart';

void main() {
  test('aba de chat é nó do grafo e recebe mensagem como turno', () {
    final chat = ChatSession(id: 'v1', projectId: 'ws', workingDirectory: '/r');
    final other = ChatSession(id: 'v2', projectId: 'ws', workingDirectory: '/r');
    final elsewhere = ChatSession(
      id: 'v3',
      projectId: 'outro',
      workingDirectory: '/x',
    );
    final g = AgentGraphStore();
    expect(
      workspaceAgentNodes(g, 'ws', [chat, other, elsewhere]).map((p) => p.id),
      ['v1', 'v2'],
    );
    expect(agentInfo(g, 'ws', chat)['harness'], 'claudeCode');

    final got = <(String, String)>[];
    chatInbox = (tab, text) => got.add((tab.id, text));
    addTearDown(() => chatInbox = (_, _) {});
    final log = AgentMessageLog();
    deliverAgentMessage(
      log: log,
      from: other,
      target: chat,
      senderName: 'gorila-spo',
      senderHarness: 'Antigravity',
      text: 'revisa o PR',
      targetAlive: () => true,
    );
    expect(got, [('v1', '[from: gorila-spo · Antigravity] revisa o PR')]);

    chat.working = true;
    expect(chat.isWorking, isTrue);
  });
}
