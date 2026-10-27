import 'dart:async';
import 'dart:io';

import 'package:gsh_desktop/app/gsh/domain/contracts/notifier.dart';
import 'package:gsh_desktop/app/core/domain/entities/sound_event.dart';
import 'package:gsh_desktop/i18n/strings.g.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:media_kit/media_kit.dart';

/// Notificações nativas via `flutter_local_notifications` (macOS/Windows/Linux)
/// + chime in-app via `media_kit` (cross-platform).
class LocalNotifier implements Notifier {
  /// AppUserModelID do GSH no Windows. Mesmo valor do `app_id` do
  /// empacotamento (`windows/packaging/exe/make_config.yaml`) e do bundle id
  /// do macOS — identifica o app na central de notificações.
  static const String _windowsAppUserModelId = 'work.gorila.gshdesktop';

  /// GUID fixo que o Windows usa pra registrar o callback de ativação do
  /// notificador (COM CLSID). Gerado uma única vez — **NÃO pode mudar entre
  /// releases**, senão o Windows trata como um notificador novo e perde o
  /// registro/histórico do usuário.
  static const String _windowsNotifierGuid =
      '88faed92-a013-44b2-a814-7dd1aebf7d59';

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  /// Uma notificação por chave (aba ou pedido): a nova da mesma aba
  /// substitui a anterior em vez de empilhar.
  final _ids = <String, int>{};
  int _idFor(String key) => _ids.putIfAbsent(key, () => _ids.length + 1);

  final _actions = StreamController<NotifierAction>.broadcast();

  @override
  Stream<NotifierAction> get actions => _actions.stream;

  static const _askCategory = 'gsh-permission';

  void _onResponse(NotificationResponse r) {
    final key = r.payload;
    if (key == null || key.isEmpty) return;
    final kind = switch (r.actionId) {
      'allow' => NotifierActionKind.allow,
      'always' => NotifierActionKind.allowAlways,
      'deny' => NotifierActionKind.deny,
      _ => NotifierActionKind.open,
    };
    _actions.add(NotifierAction(key, kind));
  }

  /// Player dedicado ao chime curto, reusado a cada toque (re-`open` reinicia).
  Player? _chime;

  @override
  Future<void> init() async {
    // O chime (media_kit) vale em TODAS as plataformas, inclusive iOS/Android —
    // é o player do som de turno. Criar SEMPRE, antes de qualquer coisa que
    // possa lançar, senão `play()` fica mudo no mobile (plano 60, Wave G).
    _chime = Player();
    final darwin = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      // Desktop app está sempre em foreground: sem esses flags o
      // UNUserNotificationCenter suprime o banner silenciosamente.
      defaultPresentAlert: true,
      defaultPresentBadge: true,
      defaultPresentSound: true,
      // Os botões do pedido de permissão (no macOS vêm da categoria).
      notificationCategories: [
        DarwinNotificationCategory(
          _askCategory,
          actions: [
            DarwinNotificationAction.plain('allow', t.gsh.notifications.allow),
            DarwinNotificationAction.plain(
              'always',
              t.gsh.notifications.allowAlways,
            ),
            DarwinNotificationAction.plain(
              'deny',
              t.gsh.notifications.deny,
              options: {DarwinNotificationActionOption.destructive},
            ),
          ],
        ),
      ],
    );
    final settings = InitializationSettings(
      // Sem o bloco `iOS` o `initialize` lança "iOS settings must be set" —
      // era por isso que o init morria no mobile (e levava o chime junto).
      iOS: darwin,
      macOS: darwin,
      linux: LinuxInitializationSettings(
        defaultActionName: t.gsh.notifications.open,
      ),
      // Sem este bloco a plataforma Windows nunca é inicializada e todo
      // `show()` lança LateInitializationError (issue #91).
      windows: WindowsInitializationSettings(
        appName: 'GSH Desktop',
        appUserModelId: _windowsAppUserModelId,
        guid: _windowsNotifierGuid,
      ),
    );
    // O init do plugin de notificações do SO é best-effort — se falhar (ex.:
    // Android sem o bloco android:), não pode derrubar o chime já criado.
    try {
      await _plugin.initialize(
        settings: settings,
        onDidReceiveNotificationResponse: _onResponse,
      );
    } catch (_) {
      // notificação do SO indisponível; o chime segue funcionando.
    }
  }

  @override
  Future<void> agentFinished({
    required String key,
    required String agentName,
    required String workspace,
  }) =>
      _show(key, t.gsh.notifications.agentFinished, _who(agentName, workspace));

  @override
  Future<void> agentNeedsAction({
    required String key,
    required String agentName,
    required String workspace,
  }) => _show(
    key,
    t.gsh.notifications.agentNeedsAction,
    _who(agentName, workspace),
  );

  @override
  Future<void> permissionAsk({
    required String key,
    required String agentName,
    required String workspace,
    required String detail,
    required bool canAlways,
  }) {
    final tr = t.gsh.notifications;
    final buttons = [
      ('allow', tr.allow),
      if (canAlways) ('always', tr.allowAlways),
      ('deny', tr.deny),
    ];
    return _show(
      key,
      tr.permissionTitle(agent: _who(agentName, workspace)),
      detail,
      linux: LinuxNotificationDetails(
        actions: [
          for (final (k, label) in buttons)
            LinuxNotificationAction(key: k, label: label),
        ],
        urgency: LinuxNotificationUrgency.critical,
      ),
      windows: WindowsNotificationDetails(
        actions: [
          for (final (k, label) in buttons)
            WindowsAction(content: label, arguments: k),
        ],
      ),
      darwinCategory: _askCategory,
    );
  }

  @override
  Future<void> dismiss(String key) async {
    final id = _ids[key];
    if (id == null) return;
    try {
      await _plugin.cancel(id: id);
    } catch (_) {
      // o servidor de notificação pode já ter fechado
    }
  }

  static String _who(String agentName, String workspace) =>
      workspace.isEmpty ? agentName : '$agentName · $workspace';

  Future<void> _show(
    String key,
    String title,
    String body, {
    LinuxNotificationDetails linux = const LinuxNotificationDetails(),
    WindowsNotificationDetails windows = const WindowsNotificationDetails(),
    String? darwinCategory,
  }) async {
    final darwin = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      categoryIdentifier: darwinCategory,
    );
    await _plugin.show(
      id: _idFor(key),
      title: title,
      body: body,
      payload: key,
      notificationDetails: NotificationDetails(
        macOS: darwin,
        linux: linux,
        windows: windows,
      ),
    );
  }

  @override
  Future<void> play(
    SoundEvent event, {
    String? customPath,
    double volume = 50,
  }) async {
    try {
      await _chime?.setVolume(volume.clamp(0, 100));
    } catch (_) {
      // volume é best-effort; toca no que estiver
    }
    // Custom primeiro; se o arquivo sumiu ou o media_kit não abre, cai no
    // embarcado — nunca fica mudo em silêncio por causa de um override podre.
    if (customPath != null && customPath.isNotEmpty) {
      try {
        if (await File(customPath).exists()) {
          await _chime?.open(Media(customPath));
          return;
        }
      } catch (_) {
        // cai no default abaixo
      }
    }
    try {
      await _chime?.open(Media('asset:///assets/sounds/${event.defaultAsset}'));
    } catch (_) {
      // som é best-effort: nunca quebra o fluxo do evento.
    }
  }
}
