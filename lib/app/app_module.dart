import 'package:gsh_desktop/app/gsh/gsh_module.dart';
import 'package:gsh_desktop/app/core/core_module.dart';
import 'package:gsh_desktop/app/core/data/terminal/terminal_profile_resolver_impl.dart';
import 'package:gsh_desktop/app/core/ui/window_activity_controller.dart';
import 'package:gsh_desktop/app/settings/settings_module.dart';
import 'package:flutter_modular/flutter_modular.dart';

/// Módulo raiz — **só composição**. É o mapa de acoplamento do app: quais módulos
/// existem e como se conectam. Cada submódulo declara seu próprio `path` (ou a
/// ausência dele, no caso do core), então aqui é só `module(...)`.
///
/// `Future` porque o `gsh` faz bootstrap async (abre os próprios stores JSON).
/// O valor threadado é o resolver de perfis de terminal: mora no core
/// (root-owned) e as features o resolvem **upward**; os demais async
/// (boxes/versão/notifier) cada builder resolve sozinho. Construído **uma vez** no `main` — dedup por identidade preservado.
Future<Module> buildAppModule({
  required WindowActivityController windowActivity,
}) async {
  // Plano 50: descobre os perfis de terminal e injeta a instância **já
  // aquecida** — o `+` resolve o padrão de forma síncrona ao criar a aba. Aqui
  // (e não no `core_module`) porque `register` é síncrono e não há bind async;
  // este builder já é `Future`. Precisa ser `addInstance` (não `.new`): o cache
  // é por instância, e um lazySingleton nasceria frio. `discover()` nunca lança.
  final terminalProfiles = TerminalProfileResolverImpl();
  await terminalProfiles.discover();

  final core = buildCoreModule(terminalProfiles: terminalProfiles);
  final gsh = await buildGshModule(windowActivity: windowActivity);
  final settings = buildSettingsModule();
  return createModule(
    register: (c) => c
      ..module(core)
      ..module(gsh)
      ..module(settings),
  );
}
