import 'package:cockpit/app/cockpit/ui/session/pane_item.dart';
import 'package:flutter_test/flutter_test.dart';

/// [PaneItem] mínimo com título dinâmico mutável — simula o OSC-title do
/// terminal (`onTitleChange` → atualiza o título dinâmico).
class _FakePane extends PaneItem {
  _FakePane(this._title);

  String _title;
  set dynamicTitle(String v) {
    _title = v;
    notifyListeners();
  }

  @override
  String get id => 'p1';
  @override
  String get projectId => 'proj1';
  @override
  String get title => _title;
  @override
  String get workingDirectory => '/tmp';
}

void main() {
  group('PaneItem — rótulo manual + trava de título', () {
    test('sem rótulo, displayTitle segue o título dinâmico', () {
      final p = _FakePane('shell');
      expect(p.titleLocked, isFalse);
      expect(p.manualLabel, isNull);
      expect(p.displayTitle, 'shell');

      p.dynamicTitle = 'claude';
      expect(p.displayTitle, 'claude');
    });

    test('setManualLabel trava: OSC-title não sobrescreve o nome exibido', () {
      final p = _FakePane('shell');
      p.setManualLabel('orquestrador');

      expect(p.titleLocked, isTrue);
      expect(p.manualLabel, 'orquestrador');
      expect(p.displayTitle, 'orquestrador');

      // Simula o claude reescrevendo o título via OSC — o dinâmico muda por
      // baixo, mas o nome exibido continua travado no rótulo manual.
      p.dynamicTitle = '✳ resumindo mudanças';
      expect(p.title, '✳ resumindo mudanças');
      expect(p.displayTitle, 'orquestrador');
    });

    test('clearManualLabel restaura o título automático (dinâmico atual)', () {
      final p = _FakePane('shell');
      p.setManualLabel('orq');
      p.dynamicTitle = '✳ trabalhando';

      p.clearManualLabel();
      expect(p.titleLocked, isFalse);
      expect(p.manualLabel, isNull);
      // Volta pro dinâmico vivo — não pro valor de quando travou.
      expect(p.displayTitle, '✳ trabalhando');
    });

    test('setManualLabel ignora vazio/whitespace e faz trim', () {
      final p = _FakePane('shell');
      p.setManualLabel('   ');
      expect(p.titleLocked, isFalse);

      p.setManualLabel('  build-runner  ');
      expect(p.manualLabel, 'build-runner');
    });

    test('restoreManualLabel semeia sem notificar (restauração Hive)', () {
      final p = _FakePane('shell');
      var notified = false;
      p.addListener(() => notified = true);

      p.restoreManualLabel('daemon');
      expect(p.manualLabel, 'daemon');
      expect(p.displayTitle, 'daemon');
      expect(notified, isFalse);

      // null/vazio limpa a trava.
      p.restoreManualLabel('  ');
      expect(p.manualLabel, isNull);
    });
  });
}
