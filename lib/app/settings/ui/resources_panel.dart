import 'dart:io' show Platform;

import 'package:gsh_desktop/app/core/domain/contracts/claude_code_settings.dart';
import 'package:gsh_desktop/app/core/domain/entities/app_settings.dart';
import 'package:gsh_desktop/app/core/ui/settings_controller.dart';
import 'package:gsh_desktop/app/core/ui/themes/themes.dart';
import 'package:gsh_desktop/app/core/ui/widgets/hover_tap.dart';
import 'package:gsh_desktop/app/settings/ui/claude_code_setting_switch.dart';
import 'package:gsh_desktop/app/settings/ui/settings_text_field.dart';
import 'package:gsh_desktop/app/settings/ui/settings_widgets.dart';
import 'package:gsh_desktop/i18n/strings.g.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

/// Aba **Recursos**: o que o shell oferece (chat, fazenda, grafo, navegador
/// — tirar daqui some com o botão da barra) e a troca de modelo quando uma
/// mensagem é sinalizada. Os recursos do claude.ai (artefatos, pesquisa de
/// conectores...) não existem no GSH.
class ResourcesPanel extends StatelessWidget {
  const ResourcesPanel({super.key, required this.onOpenSkills});

  /// "As Skills foram movidas para Personalização": abre a aba Skills.
  final VoidCallback onOpenSkills;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<SettingsController>();
    final s = controller.settings;
    final tr = context.t.settings.page.resources;
    final cc = context.t.settings.page.claudeCode;
    SettingsRow feature(AppFeature f, String title, String desc) => SettingsRow(
      title: title,
      description: desc,
      trailing: Switch(
        value: s.showsFeature(f),
        onChanged: (v) => controller.setFeatureVisible(f, v),
      ),
    );
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
          title: tr.sectionShell,
          rows: [
            feature(AppFeature.chat, tr.chat, tr.chatDesc),
            feature(AppFeature.farm, tr.farm, tr.farmDesc),
            if (s.showsFeature(AppFeature.farm))
              SettingsRow(
                title: tr.farmScenery,
                description: tr.farmSceneryDesc,
                trailing: SettingsSegmented<FarmScenery>(
                  value: s.farmScenery,
                  onChanged: controller.setFarmScenery,
                  options: {
                    FarmScenery.farm: tr.sceneryFarm,
                    FarmScenery.office: tr.sceneryOffice,
                  },
                ),
              ),
            feature(AppFeature.agentGraph, tr.graph, tr.graphDesc),
            feature(AppFeature.browser, tr.browser, tr.browserDesc),
          ],
        ),
        if (s.showsFeature(AppFeature.farm))
          SettingsSection(
            title: tr.sectionTeamFarm,
            rows: [
              SettingsRow(
                title: tr.teamFarm,
                description: tr.teamFarmDesc,
                trailing: Switch(
                  value: s.teamFarmEnabled,
                  onChanged: (v) => controller.setTeamFarm(enabled: v),
                ),
              ),
              if (s.teamFarmEnabled) ...[
                SettingsRow(
                  title: tr.teamName,
                  description: tr.teamNameDesc,
                  trailing: SettingsTextField(
                    value: s.teamFarmTeam,
                    placeholder: tr.teamNamePlaceholder,
                    onChanged: (v) => controller.setTeamFarm(team: v ?? ''),
                  ),
                ),
                SettingsRow(
                  title: tr.teamMe,
                  description: tr.teamMeDesc,
                  trailing: SettingsTextField(
                    value: s.teamFarmName,
                    placeholder:
                        Platform.environment['USER'] ??
                        Platform.environment['USERNAME'] ??
                        '',
                    onChanged: (v) => controller.setTeamFarm(name: v ?? ''),
                  ),
                ),
                SettingsRow(
                  title: tr.teamShowTitles,
                  description: tr.teamShowTitlesDesc,
                  trailing: Switch(
                    value: s.teamFarmShowTitles,
                    onChanged: (v) => controller.setTeamFarm(showTitles: v),
                  ),
                ),
                SettingsRow(
                  title: tr.teamNetwork,
                  description: tr.teamNetworkDesc,
                  trailing: SettingsTextField(
                    value: s.teamFarmNetwork,
                    placeholder: tr.teamNetworkPlaceholder,
                    onChanged: (v) => controller.setTeamFarm(network: v ?? ''),
                  ),
                ),
              ],
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
