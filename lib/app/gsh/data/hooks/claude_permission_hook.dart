import 'package:gsh_desktop/app/gsh/data/chat/claude_stream_engine.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/agent_permission.dart';

/// Lê o `permission-ask` que o `gsh hook` manda no `PermissionRequest` do
/// Claude Code (`tool_name`, `tool_input`, `permission_suggestions`).
AgentPermissionAsk parseClaudePermissionAsk(
  Map<String, dynamic> args, {
  required String id,
  required String tabId,
}) {
  final rule = claudeAddRules(args);
  return AgentPermissionAsk(
    id: id,
    tabId: tabId,
    toolName: args['tool_name'] as String? ?? '',
    input: (args['tool_input'] as Map?)?.cast<String, dynamic>() ?? const {},
    alwaysRule: claudeRuleLabel(rule),
    alwaysRaw: rule,
  );
}

/// Saída do hook para a decisão (o que o `gsh hook` imprime no stdout);
/// `null` = sem saída, o Claude pergunta no terminal.
Map<String, dynamic>? claudePermissionHookOutput(
  AgentPermissionAsk ask,
  AgentPermissionDecision decision,
) {
  final d = switch (decision) {
    AgentPermissionDecision.pass => null,
    AgentPermissionDecision.deny => {
      'behavior': 'deny',
      'message': 'Negado pelo usuário no GSH',
    },
    AgentPermissionDecision.allow || AgentPermissionDecision.allowAlways => {
      'behavior': 'allow',
      if (decision == AgentPermissionDecision.allowAlways &&
          ask.alwaysRaw != null)
        'updatedPermissions': [ask.alwaysRaw],
    },
  };
  return d == null
      ? null
      : {
          'hookSpecificOutput': {
            'hookEventName': 'PermissionRequest',
            'decision': d,
          },
        };
}
