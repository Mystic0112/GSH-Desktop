import 'package:cockpit/app/cockpit/domain/entities/git_file_status.dart';
import 'package:cockpit/app/cockpit/ui/viewmodels/agent_file_activity.dart';
import 'package:cockpit/app/core/ui/themes/agent_colors.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AgentFileActivity', () {
    test('registra, lista quem tocou (mais novo primeiro) e esquece a aba', () {
      final store = AgentFileActivity();
      var notified = 0;
      store.addListener(() => notified++);

      store.record(
        tabId: 't1',
        workspaceId: 'w',
        paths: ['/r/a.dart'],
        inferred: false,
        at: DateTime(2026, 1, 1, 10),
      );
      store.record(
        tabId: 't2',
        workspaceId: 'w',
        paths: ['/r/a.dart', '/r/b.dart'],
        inferred: true,
        at: DateTime(2026, 1, 1, 11),
      );
      store.record(tabId: 't3', workspaceId: 'w', paths: [], inferred: false);

      expect(notified, 2); // lista vazia não notifica
      expect(store.tabsIn('w'), unorderedEquals(['t1', 't2']));
      expect(store.touchedBy('t2').keys, ['/r/a.dart', '/r/b.dart']);
      expect(store.touchedBy('t2')['/r/a.dart']!.inferred, isTrue);
      expect(store.touchersOf('/r/a.dart').map((t) => t.tabId), ['t2', 't1']);

      store.forgetTab('t2');
      expect(notified, 3);
      expect(store.touchedBy('t2'), isEmpty);
      expect(store.touchersOf('/r/a.dart').map((t) => t.tabId), ['t1']);
      expect(store.tabsIn('w'), ['t1']);
    });
  });

  group('attributeTurnChanges', () {
    final since = DateTime(2026, 1, 1, 12);
    final mtimes = <String, DateTime>{
      'novo.txt': DateTime(2026, 1, 1, 12, 0, 5),
      'velho.txt': DateTime(2026, 1, 1, 11),
      'editado.txt': DateTime(2026, 1, 1, 12, 1),
    };

    test('mtime >= início, untracked incluso, removido novo conta', () {
      final out = attributeTurnChanges(
        before: {
          'velho.txt': GitFileStatus.modified,
          'ja_removido.txt': GitFileStatus.deleted,
        },
        after: {
          'novo.txt': GitFileStatus.untracked,
          'velho.txt': GitFileStatus.modified, // sujo de antes, intocado
          'editado.txt': GitFileStatus.modified,
          'removido.txt': GitFileStatus.deleted,
          'ja_removido.txt': GitFileStatus.deleted, // já estava removido
          'sumiu.txt': GitFileStatus.modified, // sem mtime (corrida): fora
        },
        since: since,
        mtimeOf: (rel) => mtimes[rel],
      );
      expect(out, {'novo.txt', 'editado.txt', 'removido.txt'});
    });
  });

  test('agentColorFor é estável e cai na paleta', () {
    expect(agentColorFor('t12'), agentColorFor('t12'));
    expect(agentPalette, contains(agentColorFor('t12')));
    final colors = {for (var i = 0; i < 40; i++) agentColorFor('t$i')};
    expect(colors.length, greaterThan(4)); // espalha, não colapsa numa cor
  });
}
