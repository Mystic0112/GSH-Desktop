import 'package:cockpit/app/cockpit/domain/entities/agent_message.dart';
import 'package:cockpit/app/cockpit/ui/session/pane_item.dart';
import 'package:cockpit/app/cockpit/ui/viewmodels/agent_message_log.dart';
import 'package:cockpit/app/cockpit/ui/viewmodels/cockpit_cli_handler.dart';
import 'package:cockpit/app/core/domain/result.dart';
import 'package:flutter_test/flutter_test.dart';

class _Tab extends PaneItem {
  _Tab(this.id, [String? label]) {
    restoreManualLabel(label);
  }
  @override
  final String id;
  @override
  String get projectId => 'p1';
  @override
  String get title => 'zsh';
  @override
  String get workingDirectory => '/tmp';
}

void main() {
  group('resolveTabTarget (msg --to / read-tab)', () {
    final tabs = [_Tab('t1', 'Reviewer'), _Tab('t2', 'Dup'), _Tab('t3', 'dup')];

    String? idOf(Result<PaneItem, String> r) =>
        r is Success<PaneItem, String> ? r.value.id : null;

    test('tab-id literal e label exato case-insensitive', () {
      expect(idOf(resolveTabTarget('t3', tabs)), 't3');
      expect(idOf(resolveTabTarget('reviewer', tabs)), 't1');
    });

    test('ambíguo ou ausente = erro, nunca chuta', () {
      expect(resolveTabTarget('DUP', tabs), isA<Failure<PaneItem, String>>());
      expect(
        resolveTabTarget('Review', tabs),
        isA<Failure<PaneItem, String>>(),
      );
    });
  });

  test('formatLine assina com nome e harness', () {
    expect(
      AgentMessage.formatLine(
        senderName: 'Builder',
        senderHarness: 'Antigravity',
        text: 'pronto',
      ),
      '[from: Builder · Antigravity] pronto',
    );
    expect(
      AgentMessage.formatLine(
        senderName: 'zsh',
        senderHarness: null,
        text: 'oi',
      ),
      '[from: zsh] oi',
    );
  });

  test('AgentMessageLog: por workspace, com teto e notificação', () {
    final log = AgentMessageLog();
    var notified = 0;
    log.addListener(() => notified++);
    for (var i = 0; i < AgentMessageLog.maxPerWorkspace + 1; i++) {
      log.record(
        fromTabId: 't1',
        fromWorkspaceId: 'a',
        toTabId: 't2',
        toWorkspaceId: i == 0 ? 'b' : 'a',
        text: 'm$i',
      );
    }
    expect(notified, AgentMessageLog.maxPerWorkspace + 1);
    final a = log.forWorkspace('a');
    expect(a.length, AgentMessageLog.maxPerWorkspace);
    expect(a.first.preview, 'm1', reason: 'a mais antiga saiu');
    expect(log.forWorkspace('b').single.preview, 'm0');
    log.dispose();
  });
}
