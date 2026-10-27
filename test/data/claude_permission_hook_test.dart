import 'package:flutter_test/flutter_test.dart';
import 'package:gsh_desktop/app/gsh/data/hooks/claude_permission_hook.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/agent_permission.dart';
import 'package:gsh_desktop/app/gsh/ui/viewmodels/agent_permission_broker.dart';

void main() {
  final args = {
    'tool_name': 'Bash',
    'tool_input': {'command': 'npm test'},
    'permission_suggestions': [
      {
        'type': 'addRules',
        'behavior': 'allow',
        'destination': 'localSettings',
        'rules': [
          {'toolName': 'Bash', 'ruleContent': 'npm test:*'},
        ],
      },
    ],
  };

  test('pedido do hook e a saída de cada decisão', () {
    final ask = parseClaudePermissionAsk(args, id: 'p1', tabId: 't3');
    expect((ask.toolName, ask.input['command']), ('Bash', 'npm test'));
    expect(ask.alwaysRule, 'Bash(npm test:*)');

    Map<String, dynamic>? decision(AgentPermissionDecision d) =>
        (claudePermissionHookOutput(ask, d)?['hookSpecificOutput']
                as Map?)?['decision']
            as Map<String, dynamic>?;
    expect(decision(AgentPermissionDecision.pass), isNull);
    expect(decision(AgentPermissionDecision.allow), {'behavior': 'allow'});
    expect(
      decision(AgentPermissionDecision.allowAlways)?['updatedPermissions'],
      [(args['permission_suggestions'] as List).first],
    );
    expect(decision(AgentPermissionDecision.deny)?['behavior'], 'deny');
  });

  test('corretor: decide, e ir até a aba devolve ao terminal', () async {
    final b = AgentPermissionBroker();
    final ask = parseClaudePermissionAsk(args, id: 'p1', tabId: 't3');
    final other = parseClaudePermissionAsk(args, id: 'p2', tabId: 't4');
    final first = b.ask(ask);
    final second = b.ask(other);
    expect(b.pending.map((a) => a.id), ['p1', 'p2']);
    b.decide('p1', AgentPermissionDecision.allow);
    expect(await first, AgentPermissionDecision.allow);
    b.releaseTab('t4');
    expect(await second, AgentPermissionDecision.pass);
    expect(b.pending, isEmpty);
  });
}
