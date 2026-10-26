import 'package:gsh_desktop/app/core/domain/contracts/claude_code_settings.dart';
import 'package:gsh_desktop/app/core/ui/themes/themes.dart';
import 'package:gsh_desktop/app/core/ui/widgets/hover_tap.dart';
import 'package:gsh_desktop/app/settings/ui/claude_code_setting_switch.dart';
import 'package:gsh_desktop/app/settings/ui/settings_widgets.dart';
import 'package:gsh_desktop/i18n/strings.g.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

/// Aba **Recursos** (lado Claude): a troca de modelo quando uma mensagem é
/// sinalizada e o aviso de que as skills mudaram de lugar, como no Claude
/// Desktop. O que é do GSH (botões da barra, cenário da fazenda, fazenda do
/// time) fica em **Recursos do GSH** ([GshFeaturesPanel]). Os recursos do
/// claude.ai (artefatos, pesquisa de conectores...) não existem no GSH.
class ResourcesPanel extends StatelessWidget {
  const ResourcesPanel({super.key, required this.onOpenSkills});

  /// "As Skills foram movidas para Personalização": abre a aba Skills.
  final VoidCallback onOpenSkills;

  @override
  Widget build(BuildContext context) {
    final tr = context.t.settings.page.resources;
    final cc = context.t.settings.page.claudeCode;
    return SettingsPanelBody(
      children: [
        SettingsSection(
          title: tr.sectionGeneral,
          rows: [
            SettingsRow(
              title: cc.switchModelsTitle,
              description: cc.switchModelsDesc,
              trailing: const ClaudeCodeSettingSwitch(
                settingKey: ClaudeCodeKeys.switchModelsOnFlag,
                unsetValue: true,
              ),
            ),
          ],
        ),
        SettingsSection(
          title: context.t.settings.page.nav.skills,
          rows: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Text(
                    tr.skillsMoved,
                    style: context.typo.body.copyWith(
                      fontSize: 13.5,
                      color: context.colors.text2,
                    ),
                  ),
                  HoverTap(
                    onTap: onOpenSkills,
                    child: Text(
                      context.t.settings.page.nav.groups.personalization,
                      style: context.typo.body.copyWith(
                        fontSize: 13.5,
                        color: context.colors.accentText,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
