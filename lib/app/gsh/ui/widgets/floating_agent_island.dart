import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' show ValueListenable;
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:gsh_desktop/app/core/domain/entities/harness.dart';
import 'package:gsh_desktop/app/core/domain/entities/app_settings.dart';
import 'package:gsh_desktop/app/core/ui/clamping_scroll_behavior.dart';
import 'package:gsh_desktop/app/core/ui/overlay/app_popover_handler.dart';
import 'package:gsh_desktop/app/core/ui/settings_controller.dart';
import 'package:gsh_desktop/app/core/ui/themes/themes.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/agent_permission.dart';
import 'package:gsh_desktop/app/gsh/ui/document/standalone_settings.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/agent_island.dart';
import 'package:gsh_desktop/i18n/strings.g.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

typedef FloatingIslandSnapshot = ({
  List<IslandAgent> agents,
  List<AgentPermissionAsk> asks,
});

const FloatingIslandSnapshot emptyFloatingIslandSnapshot = (
  agents: [],
  asks: [],
);

/// O snapshot vem do outro engine, via runner nativo. Campos inválidos são
/// ignorados; um payload ruim nunca pode virar aprovação de permissão.
FloatingIslandSnapshot decodeFloatingIslandSnapshot(String raw) {
  try {
    final data = jsonDecode(raw);
    if (data is! Map<String, dynamic>) return emptyFloatingIslandSnapshot;
    final agents = <IslandAgent>[];
    for (final value
        in (data['agents'] is List ? data['agents'] as List : [])) {
      if (value case {
        'tabId': String tabId,
        'title': String title,
        'workspace': String workspace,
        'state': String stateName,
      }) {
        if (tabId.isEmpty) continue;
        final state = IslandAgentState.values
            .where((s) => s.name == stateName)
            .firstOrNull;
        if (state == null) continue;
        final harnessName = value['harness'];
        agents.add((
          tabId: tabId,
          title: title,
          workspace: workspace,
          state: state,
          harness: harnessName is String
              ? HarnessKind.values
                    .where((h) => h.name == harnessName)
                    .firstOrNull
              : null,
        ));
      }
    }
    final asks = <AgentPermissionAsk>[];
    for (final value in (data['asks'] is List ? data['asks'] as List : [])) {
      if (value case {
        'id': String id,
        'tabId': String tabId,
        'toolName': String toolName,
        'input': Map<String, dynamic> input,
      }) {
        if (id.isEmpty || tabId.isEmpty || toolName.isEmpty) continue;
        final alwaysRule = value['alwaysRule'];
        asks.add(
          AgentPermissionAsk(
            id: id,
            tabId: tabId,
            toolName: toolName,
            input: input,
            alwaysRule: alwaysRule is String && alwaysRule.isNotEmpty
                ? alwaysRule
                : null,
          ),
        );
      }
    }
    return (agents: agents, asks: asks);
  } on FormatException {
    return emptyFloatingIslandSnapshot;
  }
}

/// Entrypoint do FlView layer-shell. Não sobe shell, hooks ou notificações:
/// o estado e as ações passam pelo canal com o engine principal.
Future<void> runFloatingAgentIsland() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    stderr.writeln('[agent-island] ${details.exception}');
  };
  try {
    await LocaleSettings.useDeviceLocale();
    final settings = await loadStandaloneSettings();
    final snapshots = ValueNotifier<FloatingIslandSnapshot>(
      emptyFloatingIslandSnapshot,
    );
    var receivedUpdate = false;
    islandWindowChannel.setMethodCallHandler((call) async {
      if (call.method == 'snapshot' && call.arguments is String) {
        receivedUpdate = true;
        snapshots.value = decodeFloatingIslandSnapshot(
          call.arguments as String,
        );
      }
    });
    String? initial;
    try {
      initial = await islandWindowChannel.invokeMethod<String>('ready');
    } on MissingPluginException {
      // Sem canal nativo disponível neste ambiente.
    } on PlatformException {
      // O próximo snapshot atualiza a vista quando a janela principal enviar.
    }
    if (!receivedUpdate) {
      snapshots.value = decodeFloatingIslandSnapshot(initial ?? '{}');
    }
    runApp(
      TranslationProvider(
        child: ModularApp(
          module: createModule(register: (_) {}),
          provide: (s) =>
              s..addChangeNotifier<SettingsController>(() => settings),
          child: FloatingIslandApp(snapshots: snapshots),
        ),
      ),
    );
  } on Object catch (error, stack) {
    stderr.writeln('[agent-island] failed to open: $error\n$stack');
  }
}

Future<void> _send(String method, Object? arguments) async {
  try {
    await islandWindowChannel.invokeMethod<void>(method, arguments);
  } on MissingPluginException {
    // A janela pode ter fechado enquanto a ação era enviada.
  } on PlatformException {
    // O engine principal mantém o pedido pendente para o terminal.
  }
}

class FloatingIslandApp extends StatelessWidget {
  const FloatingIslandApp({super.key, required this.snapshots});

  final ValueListenable<FloatingIslandSnapshot> snapshots;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<SettingsController>();
    final settings = controller.settings;
    final theme = controller.activeTheme;
    return ShadcnApp(
      title: 'GSH Desktop',
      debugShowCheckedModeBanner: false,
      background: Colors.transparent,
      enableThemeAnimation: false,
      popoverHandler: const AppPopoverOverlayHandler(),
      menuHandler: const AppPopoverOverlayHandler(),
      tooltipHandler: const AppPopoverOverlayHandler(),
      scrollBehavior: const ClampingScrollBehavior(),
      theme: buildTheme(
        brightness: Brightness.light,
        settings: settings,
        theme: theme,
      ),
      darkTheme: buildTheme(
        brightness: Brightness.dark,
        settings: settings,
        theme: theme,
      ),
      themeMode: switch (settings.themeMode) {
        AppThemeMode.system => ThemeMode.system,
        AppThemeMode.light => ThemeMode.light,
        AppThemeMode.dark => ThemeMode.dark,
      },
      builder: (context, child) {
        final tokens = buildTokens(
          brightness: Theme.of(context).brightness,
          settings: settings,
          theme: theme,
        );
        return DefaultSelectionStyle(
          selectionColor: tokens.terminal.selection,
          cursorColor: tokens.colors.accent,
          child: GshTheme(
            colors: tokens.colors,
            typo: tokens.typo,
            syntax: tokens.syntax,
            terminal: tokens.terminal,
            child: child ?? const SizedBox.shrink(),
          ),
        );
      },
      home: SizedBox.expand(
        child: Align(
          alignment: Alignment.topCenter,
          child: ValueListenableBuilder<FloatingIslandSnapshot>(
            valueListenable: snapshots,
            builder: (context, snapshot, _) => IslandHorizontalCenter(
              child: AgentIslandView(
                agents: snapshot.agents,
                asks: snapshot.asks,
                onDecide: (id, decision) => unawaited(
                  _send('decide', {'id': id, 'decision': decision.name}),
                ),
                onReveal: (tabId) => unawaited(_send('reveal', tabId)),
                onPanelHeight: (height) => unawaited(_send('shape', height)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
