import 'package:cockpit/app/core/domain/entities/app_settings.dart';
import 'package:flutter_test/flutter_test.dart';

/// Plano 50 — persistência do perfil de terminal padrão. A chave crua importa:
/// é o contrato com o registro já gravado no Hive (um typo aqui = config do
/// usuário perdida em silêncio).
void main() {
  group('AppSettings · terminal.default_profile_id', () {
    test('round-trip preserva o id sob a chave do plano', () {
      const settings = AppSettings(defaultTerminalProfileId: 'wsl:Ubuntu');
      final json = settings.toJson();

      expect(json['terminal.default_profile_id'], 'wsl:Ubuntu');
      expect(AppSettings.fromJson(json).defaultTerminalProfileId, 'wsl:Ubuntu');
    });

    test('sem escolha → chave AUSENTE do json (não grava null)', () {
      expect(
        const AppSettings().toJson().containsKey('terminal.default_profile_id'),
        isFalse,
      );
    });

    test('MIGRAÇÃO: registro antigo (sem a chave) → null = fallback', () {
      // Registro de uma versão anterior ao plano 50: nenhuma chave de terminal.
      final legacy = <String, dynamic>{
        'themeMode': 'dark',
        'enableAgent': true,
      };
      expect(AppSettings.fromJson(legacy).defaultTerminalProfileId, isNull);
    });

    test('string vazia/espaços é tratada como ausência', () {
      expect(
        AppSettings.fromJson(<String, dynamic>{
          'terminal.default_profile_id': '   ',
        }).defaultTerminalProfileId,
        isNull,
      );
    });

    test('copyWith limpa o id (voltar ao fallback de plataforma)', () {
      const settings = AppSettings(defaultTerminalProfileId: 'cmd');
      final cleared = settings.copyWith(clearDefaultTerminalProfileId: true);

      expect(cleared.defaultTerminalProfileId, isNull);
      expect(
        settings
            .copyWith(defaultTerminalProfileId: 'powershell')
            .defaultTerminalProfileId,
        'powershell',
      );
    });
  });
}
