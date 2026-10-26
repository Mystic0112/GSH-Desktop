import 'dart:io' show Platform;

import 'package:gsh_desktop/app/core/domain/entities/app_settings.dart';
import 'package:gsh_desktop/app/core/ui/settings_controller.dart';
import 'package:gsh_desktop/app/settings/ui/settings_text_field.dart';
import 'package:gsh_desktop/app/settings/ui/settings_widgets.dart';
import 'package:gsh_desktop/i18n/strings.g.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

/// Aba **Recursos do GSH** (lado GSH): os botões da barra (chat, fazenda,
/// harness, grafo, navegador — tirar daqui some com o botão), o cenário da
/// fazenda e a fazenda do time na rede local.
class GshFeaturesPanel extends StatelessWidget {
  const GshFeaturesPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<SettingsController>();
    final s = controller.settings;
    final tr = context.t.settings.page.resources;
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
            feature(
              AppFeature.harness,
              tr.harnessFeature,
              tr.harnessFeatureDesc,
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
                  title: tr.teamSecret,
                  description: tr.teamSecretDesc,
                  trailing: SettingsTextField(
                    value: s.teamFarmSecret,
                    placeholder: tr.teamSecretPlaceholder,
                    obscure: true,
                    onChanged: (v) => controller.setTeamFarm(secret: v ?? ''),
                  ),
                ),
                if (s.teamFarmSecret.isNotEmpty) ...[
                  SettingsRow(
                    title: tr.teamDoorAllow,
                    description: tr.teamDoorAllowDesc,
                    trailing: SettingsTextField(
                      value: s.teamDoorAllow,
                      placeholder: tr.teamDoorAllowPlaceholder,
                      onChanged: (v) =>
                          controller.setTeamFarm(doorAllow: v ?? ''),
                    ),
                  ),
                  SettingsRow(
                    title: tr.teamDoorAsk,
                    description: tr.teamDoorAskDesc,
                    trailing: Switch(
                      value: s.teamDoorAsk,
                      onChanged: (v) => controller.setTeamFarm(doorAsk: v),
                    ),
                  ),
                ],
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
      ],
    );
  }
}
