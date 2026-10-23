import 'dart:io';

import 'package:gsh_desktop/app/core/data/diagnostics/diagnostics_log.dart';
import 'package:gsh_desktop/app/core/data/setup/storage_location.dart';
import 'package:gsh_desktop/app/core/ui/keep_awake_controller.dart';
import 'package:gsh_desktop/app/core/ui/settings_controller.dart';
import 'package:gsh_desktop/app/core/ui/themes/themes.dart';
import 'package:gsh_desktop/app/core/utils/native_folder_picker.dart';
import 'package:gsh_desktop/app/settings/ui/settings_widgets.dart';
import 'package:gsh_desktop/i18n/strings.g.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

/// Aba **Sistema**: o que é desta máquina — iniciar com o login, manter
/// acordada e onde o GSH guarda os dados (vieram do Geral).
class SystemPanel extends StatelessWidget {
  const SystemPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<SettingsController>();
    final keepAwake = context.watch<KeepAwakeController>();
    final general = context.t.settings.page.general;
    final tr = context.t.settings.page.system;
    return SettingsPanelBody(
      children: [
        SettingsSection(
          title: tr.title,
          rows: [
            SettingsRow(title: tr.version, trailing: const _AppVersion()),
            SettingsRow(
              title: general.launchAtStartupTitle,
              description: general.launchAtStartupDesc,
              trailing: Switch(
                value: controller.settings.launchAtStartup,
                onChanged: controller.setLaunchAtStartup,
              ),
            ),
            // Mesmo estado do botão de raio do rodapé do rail (efêmero).
            if (keepAwake.isSupported)
              SettingsRow(
                title: tr.keepAwakeTitle,
                description: tr.keepAwakeDesc,
                trailing: Switch(
                  value: keepAwake.isActive,
                  onChanged: (_) => keepAwake.toggle(),
                ),
              ),
          ],
        ),
        const StorageSection(),
      ],
    );
  }
}

/// Versão do app (a mesma que o self-update usa).
class _AppVersion extends StatelessWidget {
  const _AppVersion();

  @override
  Widget build(BuildContext context) => FutureBuilder<PackageInfo>(
    future: PackageInfo.fromPlatform(),
    builder: (context, snap) => Text(
      snap.data?.version ?? '—',
      style: context.typo.body.copyWith(
        fontSize: 13.5,
        color: context.colors.text2,
      ),
    ),
  );
}

/// Seção "Armazenamento": mostra onde o GSH guarda seu estado, deixa o
/// usuário apontar pra outra pasta (ex.: um diretório sincronizado) e oferece
/// um reset de fábrica. Trocar a pasta ou resetar **exige reiniciar** — a UI
/// informa e oferece fechar o app na hora.
class StorageSection extends StatefulWidget {
  const StorageSection({super.key});

  @override
  State<StorageSection> createState() => _StorageSectionState();
}

class _StorageSectionState extends State<StorageSection> {
  String? _root; // raiz efetiva (pasta que o usuário "vê")
  bool _custom = false;
  bool _loading = true;
  bool _busy = false; // durante copy/pick, evita cliques repetidos

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final root = await StorageLocation.effectiveRoot();
    final custom = await StorageLocation.isCustom();
    if (!mounted) return;
    setState(() {
      _root = root;
      _custom = custom;
      _loading = false;
    });
  }

  Future<void> _changeFolder() async {
    if (_busy) return;
    final tr = context.t.settings.page.storage;
    final picked = await NativeFolderPicker.pick(
      dialogTitle: tr.chooseFolderDialogTitle,
      initialDirectory: _root, // abre na pasta atual do GSH
    );
    if (picked == null || !mounted) return;
    setState(() => _busy = true);
    // Copia os dados atuais pra nova pasta (se estiver vazia) — evita a
    // surpresa de "meus projetos sumiram" após o restart.
    await StorageLocation.migrateStateTo(picked);
    await StorageLocation.setOverrideRoot(picked);
    if (!mounted) return;
    setState(() => _busy = false);
    await _promptRestart(tr.restartChangeFolderMessage(path: picked));
  }

  Future<void> _useDefault() async {
    if (_busy) return;
    await StorageLocation.setOverrideRoot(null);
    if (!mounted) return;
    await _promptRestart(
      context.t.settings.page.storage.restartUseDefaultMessage,
    );
  }

  Future<void> _reset() async {
    final confirmed = await _confirmReset();
    if (confirmed != true || !mounted) return;
    await StorageLocation.resetAll();
    if (!mounted) return;
    await _promptRestart(
      context.t.settings.page.storage.restartResetMessage,
      quitOnly: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tr = context.t.settings.page.storage;
    return SettingsSection(
      title: tr.sectionTitle,
      rows: [
        SettingsRow(
          title: tr.locationTitle,
          description: _loading
              ? context.t.common.loading
              : tr.locationDesc(root: _root ?? '—'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_custom) ...[
                GhostButton(
                  onPressed: _loading || _busy ? null : _useDefault,
                  child: Text(tr.useDefault),
                ),
                const SizedBox(width: 8),
              ],
              OutlineButton(
                onPressed: _loading || _busy ? null : _changeFolder,
                child: Text(_busy ? tr.working : tr.change),
              ),
            ],
          ),
        ),
        SettingsRow(
          title: tr.resetTitle,
          description: tr.resetDesc,
          trailing: DestructiveButton(
            onPressed: _loading ? null : _reset,
            child: Text(tr.resetButton, style: TextStyle(color: colors.error)),
          ),
        ),
      ],
    );
  }

  /// Confirmação destrutiva do reset.
  Future<bool?> _confirmReset() {
    return showDialog<bool>(
      context: context,
      barrierColor: context.colors.scrim,
      builder: (context) {
        final colors = context.colors;
        final tr = context.t.settings.page.storage;
        return AlertDialog(
          title: Text(
            tr.resetDialogTitle,
            style: context.typo.title.copyWith(
              fontSize: 15,
              color: colors.text,
            ),
          ),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 380),
            child: Text(
              tr.resetDialogContent,
              style: context.typo.body.copyWith(
                fontSize: 13.5,
                color: colors.text2,
              ),
            ),
          ),
          actions: [
            GhostButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(context.t.common.cancel),
            ),
            DestructiveButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                tr.resetConfirm,
                style: TextStyle(color: colors.error),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Informa que a mudança só vale no próximo boot e oferece fechar agora.
  /// [quitOnly] esconde o "Later" (reset já apagou tudo — continuar seria
  /// esquisito), mas nunca força o fechamento sem o clique do usuário.
  Future<void> _promptRestart(String message, {bool quitOnly = false}) {
    return showDialog<void>(
      context: context,
      barrierColor: context.colors.scrim,
      builder: (context) {
        final colors = context.colors;
        final tr = context.t.settings.page.storage;
        return AlertDialog(
          title: Text(
            tr.restartRequiredTitle,
            style: context.typo.title.copyWith(
              fontSize: 15,
              color: colors.text,
            ),
          ),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 380),
            child: Text(
              message,
              style: context.typo.body.copyWith(
                fontSize: 13.5,
                color: colors.text2,
              ),
            ),
          ),
          actions: [
            if (!quitOnly)
              GhostButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(tr.later),
              ),
            PrimaryButton(
              // Encerra abrupto de propósito: descarta escritas pendentes nas
              // boxes antigas (já migradas/apagadas), sem recriar arquivos no
              // caminho velho via o save de window_state no onWindowClose.
              // Marca saída limpa antes: `exit()` não dispara o
              // `onExitRequested`, e sem isso o próximo boot acusaria crash.
              onPressed: () {
                DiagnosticsLog.instance.markCleanExit();
                exit(0);
              },
              child: Text(tr.quitGsh),
            ),
          ],
        );
      },
    );
  }
}
