import 'package:cockpit/app/core/domain/contracts/claude_code_settings.dart';
import 'package:cockpit/app/core/domain/entities/app_settings.dart';
import 'package:cockpit/app/core/domain/entities/sound_event.dart';
import 'package:cockpit/app/core/ui/settings_controller.dart';
import 'package:cockpit/app/settings/ui/claude_code_setting_switch.dart';
import 'package:cockpit/app/settings/ui/settings_widgets.dart';
import 'package:cockpit/i18n/strings.g.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

/// Tamanhos do "Tamanho do texto da conversa" (o tamanho base da interface).
const _textSizes = (small: 13.0, medium: 14.0, large: 16.0);

/// Aba **Geral**: Aparência (tema, fontes, texto e largura do chat,
/// movimento) e Notificações, como no Claude Desktop, seguidas das seções
/// próprias do GSH ([gshSections]). A seção Voz não existe: o GSH não tem
/// ditado.
class GeneralPanel extends StatelessWidget {
  const GeneralPanel({super.key, this.gshSections});

  /// Terminal do GSH, editor, atualizações, idioma, diagnóstico.
  final Widget? gshSections;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<SettingsController>();
    final s = controller.settings;
    final tr = context.t.settings.page.generalClaude;
    return SettingsPanelBody(
      children: [
        SettingsSection(
          title: tr.sectionAppearance,
          rows: [
            SettingsRow(
              title: tr.theme,
              trailing: SettingsSegmented<AppThemeMode>(
                value: s.themeMode,
                onChanged: controller.setThemeMode,
                options: {
                  AppThemeMode.system: tr.themeSystem,
                  AppThemeMode.light: tr.themeLight,
                  AppThemeMode.dark: tr.themeDark,
                },
                icons: const {
                  AppThemeMode.system: Icons.desktop_windows_outlined,
                  AppThemeMode.light: Icons.light_mode_outlined,
                  AppThemeMode.dark: Icons.dark_mode_outlined,
                },
              ),
            ),
            SettingsRow(
              title: tr.uiFont,
              description: tr.uiFontDesc,
              trailing: SettingsFontField(
                value: s.interfaceFont,
                hint: 'Montserrat · Hanken',
                onChanged: controller.setInterfaceFont,
              ),
            ),
            SettingsRow(
              title: tr.chatFont,
              description: tr.chatFontDesc,
              trailing: SettingsFontField(
                value: s.chatFont,
                hint: tr.chatFontDefault,
                onChanged: controller.setChatFont,
              ),
            ),
            SettingsRow(
              title: tr.textSize,
              description: tr.textSizeDesc,
              trailing: SettingsSegmented<double>(
                value: s.interfaceSize,
                onChanged: controller.setInterfaceSize,
                options: {
                  _textSizes.small: tr.sizeSmall,
                  _textSizes.medium: tr.sizeMedium,
                  _textSizes.large: tr.sizeLarge,
                },
              ),
            ),
            SettingsRow(
              title: tr.transcriptWidth,
              description: tr.transcriptWidthDesc,
              trailing: SettingsSegmented<TranscriptWidth>(
                value: s.transcriptWidth,
                onChanged: controller.setTranscriptWidth,
                options: {
                  TranscriptWidth.narrow: tr.widthNarrow,
                  TranscriptWidth.medium: tr.widthMedium,
                  TranscriptWidth.wide: tr.widthWide,
                },
              ),
            ),
            SettingsRow(
              title: tr.reducedMotion,
              description: tr.reducedMotionDesc,
              trailing: const ClaudeCodeSettingSwitch(
                settingKey: ClaudeCodeKeys.reducedMotion,
                unsetValue: false,
                removeWhenDefault: true,
              ),
            ),
          ],
        ),
        SettingsSection(
          title: tr.sectionNotifications,
          rows: [
            SettingsRow(
              title: tr.notifyTurnDone,
              description: tr.notifyTurnDoneDesc,
              trailing: Switch(
                value: s.notificationsEnabled,
                onChanged: controller.setNotificationsEnabled,
              ),
            ),
            SettingsRow(
              title: tr.notifyPermission,
              description: tr.notifyPermissionDesc,
              trailing: Switch(
                value: s.soundEnabledFor(SoundEvent.actionRequired),
                onChanged: (v) => controller.setSoundEventEnabled(
                  SoundEvent.actionRequired,
                  v,
                ),
              ),
            ),
            SettingsRow(
              title: tr.pushInputNeeded,
              description: tr.pushInputNeededDesc,
              trailing: const ClaudeCodeSettingSwitch(
                settingKey: ClaudeCodeKeys.inputNeededNotif,
                unsetValue: false,
              ),
            ),
            SettingsRow(
              title: tr.pushAgent,
              description: tr.pushAgentDesc,
              trailing: const ClaudeCodeSettingSwitch(
                settingKey: ClaudeCodeKeys.agentPushNotif,
                unsetValue: false,
              ),
            ),
          ],
        ),
        ?gshSections,
      ],
    );
  }
}
