import 'package:gsh_desktop/app/core/data/setup/json_state_store.dart';
import 'package:gsh_desktop/app/core/domain/contracts/settings_store.dart';
import 'package:gsh_desktop/app/core/domain/entities/app_settings.dart';

/// Persiste as [AppSettings] num [JsonStateStore] (um único registro JSON sob
/// a chave [_key]). Substitui o antigo `HiveSettingsStore` — mesma semântica.
class JsonSettingsStore implements SettingsStore {
  JsonSettingsStore(this._store);

  final JsonStateStore _store;

  static const String storeName = 'settings';
  static const String _key = 'app';

  @override
  Future<AppSettings> load() async {
    final raw = _store.get(_key);
    if (raw is Map) {
      final settings = AppSettings.fromJson(raw);
      // Migração: registro sem `showGsh` (versão anterior à flag) → liga o
      // workspace de sistema e persiste (default já é true; grava pra não
      // re-migrar). A chave `enableAgent` de versões < 2.0 é ignorada: o
      // agente nativo saiu do binário.
      if (!raw.containsKey('showGsh')) {
        final migrated = settings.copyWith(showGsh: true);
        await save(migrated);
        return migrated;
      }
      return settings;
    }
    return const AppSettings();
  }

  @override
  Future<void> save(AppSettings settings) =>
      _store.put(_key, settings.toJson());
}
