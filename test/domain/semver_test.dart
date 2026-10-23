import 'package:cockpit/app/cockpit/domain/value_objects/semver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('compareSemver', () {
    test('iguais → 0', () {
      expect(compareSemver('1.0.0', '1.0.0'), 0);
      expect(compareSemver('1.2', '1.2.0'), 0); // componente ausente = 0
    });

    test('maior/menor por componente (numérico, não lexical)', () {
      expect(compareSemver('1.0.10', '1.0.9'), 1); // 10 > 9 numérico
      expect(compareSemver('1.0.9', '1.0.10'), -1);
      expect(compareSemver('2.0.0', '1.9.9'), 1);
      expect(compareSemver('1.1.0', '1.0.99'), 1);
    });

    test('ignora pré-release / build metadata', () {
      expect(compareSemver('1.0.0-beta', '1.0.0'), 0);
      expect(compareSemver('1.0.1+5', '1.0.0'), 1);
    });

    test('componentes não-numéricos contam como 0', () {
      expect(compareSemver('1.x.0', '1.0.0'), 0);
    });
  });

  group('isNewerVersion', () {
    test('só true quando candidato é estritamente maior', () {
      expect(isNewerVersion('1.1.0', '1.0.0'), isTrue);
      expect(isNewerVersion('1.0.0', '1.0.0'), isFalse); // igual
      expect(isNewerVersion('0.9.0', '1.0.0'), isFalse); // menor
      expect(isNewerVersion('1.0.10', '1.0.2'), isTrue);
    });
  });
}
