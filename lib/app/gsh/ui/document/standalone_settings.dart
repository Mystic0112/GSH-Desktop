import 'dart:async';
import 'dart:io';

import 'package:gsh_desktop/app/core/data/repositories/json_settings_store.dart';
import 'package:gsh_desktop/app/core/data/setup/json_state_store.dart';
import 'package:gsh_desktop/app/core/data/setup/storage_location.dart';
import 'package:gsh_desktop/app/core/data/theme_store.dart';
import 'package:gsh_desktop/app/core/ui/settings_controller.dart';
import 'package:gsh_desktop/i18n/strings.g.dart';

/// Janelas com engine próprio leem as mesmas preferências e acompanham as
/// mudanças gravadas pela janela principal.
Future<SettingsController> loadStandaloneSettings() async {
  final stateDir = await StorageLocation.stateDir();
  final store = await JsonStateStore.open(
    stateDir,
    JsonSettingsStore.storeName,
  );
  final settings = SettingsController(
    JsonSettingsStore(store),
    const ThemeStore(),
  );
  await settings.load();

  final file = File(store.path);
  Timer? debounce;
  try {
    await file.parent.create(recursive: true);
    file.parent
        .watch()
        .listen(
          (event) {
            final hit =
                event.path == file.path ||
                (event is FileSystemMoveEvent &&
                    event.destination == file.path);
            if (!hit) return;
            debounce?.cancel();
            debounce = Timer(const Duration(milliseconds: 200), () async {
              await store.reload();
              await settings.load();
              if (settings.settings.locale == null) {
                await LocaleSettings.useDeviceLocale();
              }
            });
          },
          onError: (Object _) {
            // Sem watcher, a janela conserva as preferências lidas ao abrir.
          },
        );
  } on FileSystemException {
    // Sem watcher, a janela conserva as preferências lidas ao abrir.
  }
  return settings;
}
