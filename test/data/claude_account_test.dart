import 'package:flutter_test/flutter_test.dart';
import 'package:gsh_desktop/app/gsh/data/chat/claude_account.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/chat_usage.dart';

void main() {
  test('modelos do initialize', () {
    final m = parseClaudeModels({
      'models': [
        {
          'value': 'default',
          'resolvedModel': 'claude-opus-5-5',
          'displayName': 'Default (recommended)',
          'description': 'Opus 5.5 · Best for everyday, complex tasks',
          'supportsEffort': true,
          'supportedEffortLevels': ['low', 'high', 'max'],
        },
        {'value': 'haiku', 'displayName': 'Haiku 5.5'},
        {'displayName': 'sem value'},
      ],
    });
    expect(m.map((e) => e.value), ['default', 'haiku']);
    expect(m.first.resolved, 'claude-opus-5-5');
    expect(m.first.efforts, ['low', 'high', 'max']);
    expect(m.last.efforts, isEmpty);
    expect(parseClaudeModels(null), isEmpty);
  });

  test('limites do get_usage (formato novo e antigo)', () {
    final u = parseClaudePlanUsage({
      'subscription_type': 'team',
      'limits': [
        {
          'kind': 'session',
          'percent': 3,
          'severity': 'normal',
          'resets_at': '2026-10-25T07:30:00.337736+00:00',
        },
        {
          'kind': 'weekly_all',
          'percent': 86,
          'severity': 'warning',
          'resets_at': '2026-10-25T20:00:00+00:00',
        },
        {
          'kind': 'weekly_scoped',
          'percent': 59,
          'severity': 'normal',
          'scope': {
            'model': {'display_name': 'Fable'},
          },
        },
        {'kind': 'mystery', 'percent': 10},
      ],
    })!;
    expect(u.plan, 'team');
    expect(u.limits.map((l) => (l.kind, l.percent, l.warning, l.model)), [
      (ChatLimitKind.session, 3, false, null),
      (ChatLimitKind.weekly, 86, true, null),
      (ChatLimitKind.weeklyModel, 59, false, 'Fable'),
    ]);
    expect(u.limits.first.resetsAt!.toUtc().hour, 7);

    final old = parseClaudePlanUsage({
      'rate_limits': {
        'five_hour': {
          'utilization': 12,
          'resets_at': '2026-10-25T07:30:00+00:00',
        },
        'seven_day': {'utilization': 40},
      },
    })!;
    expect(old.limits.map((l) => l.percent), [12, 40]);
    expect(parseClaudePlanUsage({'limits': []}), isNull);
  });

  test('contexto do result', () {
    final c = parseClaudeContext({
      'usage': {
        'input_tokens': 2,
        'cache_creation_input_tokens': 36932,
        'cache_read_input_tokens': 100,
      },
      'modelUsage': {
        'claude-haiku-5-5': {'contextWindow': 1000000},
      },
    })!;
    expect((c.tokens, c.window), (37034, 1000000));
  });

  test('comandos do initialize', () {
    final c = parseClaudeCommands({
      'commands': [
        {
          'name': 'escanor',
          'description': 'Invoca o Escanor, backend PHP/Laravel (user)',
          'argumentHint': '',
        },
        {
          'name': 'review',
          'description': 'Revisa',
          'aliases': ['rev'],
        },
        {'description': 'sem nome'},
      ],
    });
    expect(c.map((e) => e.name), ['escanor', 'review']);
    expect(c.first.description, 'Invoca o Escanor, backend PHP/Laravel');
    expect(c.last.aliases, ['rev']);
  });
}
