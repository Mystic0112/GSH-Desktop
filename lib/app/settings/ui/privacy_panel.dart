import 'package:cockpit/app/core/domain/contracts/claude_code_settings.dart';
import 'package:cockpit/app/settings/ui/claude_code_setting_switch.dart';
import 'package:cockpit/app/settings/ui/settings_widgets.dart';
import 'package:cockpit/i18n/strings.g.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

/// Aba **Privacidade**: o GSH não manda nada para lugar nenhum; o que dá para
/// desligar é o envio do próprio Claude Code (variáveis `DISABLE_*` no `env`
/// do `~/.claude/settings.json`). Conversas compartilhadas são do claude.ai.
class PrivacyPanel extends StatelessWidget {
  const PrivacyPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final tr = context.t.settings.page.privacy;
    return SettingsPanelBody(
      children: [
        SettingsSection(
          title: tr.title,
          rows: [
            SettingsRow(
              title: tr.gshTelemetry,
              description: tr.gshTelemetryDesc,
            ),
            SettingsRow(
              title: tr.ccTelemetry,
              description: tr.ccTelemetryDesc,
              trailing: const ClaudeCodeSettingSwitch(
                settingKey: ClaudeCodeKeys.disableTelemetry,
                unsetValue: false,
                removeWhenDefault: true,
                onValue: '1',
                offValue: null,
              ),
            ),
            SettingsRow(
              title: tr.ccErrors,
              description: tr.ccErrorsDesc,
              trailing: const ClaudeCodeSettingSwitch(
                settingKey: ClaudeCodeKeys.disableErrorReporting,
                unsetValue: false,
                removeWhenDefault: true,
                onValue: '1',
                offValue: null,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
