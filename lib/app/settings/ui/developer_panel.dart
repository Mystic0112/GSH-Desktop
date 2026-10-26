import 'package:gsh_desktop/app/gsh/domain/contracts/url_opener.dart';
import 'package:gsh_desktop/app/core/ui/settings_controller.dart';
import 'package:gsh_desktop/app/core/ui/themes/themes.dart';
import 'package:gsh_desktop/app/core/ui/widgets/hover_tap.dart';
import 'package:gsh_desktop/app/core/utils/user_home.dart';
import 'package:gsh_desktop/app/core/domain/entities/claude_info.dart';
import 'package:gsh_desktop/app/settings/ui/claude_info_viewmodel.dart';
import 'package:gsh_desktop/app/settings/ui/connectors_panel.dart';
import 'package:gsh_desktop/app/settings/ui/settings_widgets.dart';
import 'package:gsh_desktop/i18n/strings.g.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:path/path.dart' as p;
import 'package:shadcn_flutter/shadcn_flutter.dart';

/// Console de chaves de API (cartão "Quer uma chave de API?").
const apiKeysUrl = 'https://console.anthropic.com/settings/keys';

/// Aba **Desenvolvedor**: servidores MCP locais (stdio) do Claude Code com
/// comando e argumentos, atalho para o `~/.claude.json` (onde eles moram), o
/// modo desenvolvedor do GSH e o cartão de chave de API.
class DeveloperPanel extends StatefulWidget {
  const DeveloperPanel({super.key});

  @override
  State<DeveloperPanel> createState() => _DeveloperPanelState();
}

class _DeveloperPanelState extends State<DeveloperPanel> {
  String? _selected;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<ClaudeInfoViewModel>().loadMcp();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<SettingsController>();
    final vm = context.watch<ClaudeInfoViewModel>();
    final general = context.t.settings.page.general;
    final tr = context.t.settings.page.developer;
    final home = userHome();
    final local = [
      for (final s in vm.mcp.value ?? const <McpServerInfo>[])
        if (!s.isRemote) s,
    ];
    final selected =
        local.where((s) => s.name == _selected).firstOrNull ??
        local.firstOrNull;
    return SettingsPanelBody(
      children: [
        SettingsSection(
          title: tr.mcpTitle,
          description: tr.mcpDesc,
          divided: false,
          rows: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  if (home != null)
                    SettingsOpenFileButton(
                      path: p.join(home, '.claude.json'),
                      label: tr.editConfig,
                    ),
                  const SizedBox(width: 8),
                  SettingsRefreshButton(
                    loading: vm.mcp.loading,
                    onPressed: () => vm.loadMcp(force: true),
                  ),
                ],
              ),
            ),
            if (vm.mcp.value == null)
              ...infoLoadRows(context, vm.mcp, (_) => [], empty: '')
            else if (local.isEmpty)
              SettingsNote(tr.mcpEmpty)
            else
              _McpMasterDetail(
                servers: local,
                selected: selected!,
                onSelect: (s) => setState(() => _selected = s.name),
              ),
          ],
        ),
        SettingsSection(
          title: tr.title,
          rows: [
            SettingsRow(
              title: general.developerModeTitle,
              description: general.developerModeDesc,
              trailing: Switch(
                value: controller.settings.developerMode,
                onChanged: controller.setDeveloperMode,
              ),
            ),
            SettingsRow(
              title: tr.telemetryTitle,
              description: tr.telemetryDesc,
            ),
            if (home != null)
              SettingsRow(
                title: tr.claudeSettingsTitle,
                description: tr.claudeSettingsDesc,
                trailing: SettingsOpenFileButton(
                  path: p.join(home, '.claude', 'settings.json'),
                ),
              ),
          ],
        ),
        const _ApiKeyCard(),
      ],
    );
  }
}

/// Lista dos servidores à esquerda, detalhe do escolhido à direita.
class _McpMasterDetail extends StatelessWidget {
  const _McpMasterDetail({
    required this.servers,
    required this.selected,
    required this.onSelect,
  });
  final List<McpServerInfo> servers;
  final McpServerInfo selected;
  final ValueChanged<McpServerInfo> onSelect;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tr = context.t.settings.page.developer;
    final (command, args) = selected.commandLine;
    Widget field(String label, String value) => Padding(
      padding: const EdgeInsets.only(top: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: context.typo.body.copyWith(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: colors.text,
            ),
          ),
          const SizedBox(height: 2),
          SelectableText(
            value.isEmpty ? '—' : value,
            style: context.typo.body.copyWith(
              fontSize: 13.5,
              color: colors.text3,
            ),
          ),
        ],
      ),
    );
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colors.border),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 190,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border(right: BorderSide(color: colors.border)),
              ),
              child: Column(
                children: [
                  for (final s in servers)
                    HoverTap(
                      color: s == selected ? colors.panel3 : null,
                      borderRadius: BorderRadius.circular(6),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 7,
                      ),
                      onTap: () => onSelect(s),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          s.displayName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.typo.body.copyWith(
                            fontSize: 13.5,
                            color: colors.text,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          selected.displayName,
                          style: context.typo.body.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: colors.text,
                          ),
                        ),
                        const SizedBox(width: 10),
                        McpStatusChip(selected.status),
                      ],
                    ),
                    field(tr.command, command),
                    field(tr.arguments, args),
                    if (selected.status == McpStatus.failed)
                      field(tr.error, selected.statusText),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// "Quer uma chave de API?" → console no navegador.
class _ApiKeyCard extends StatelessWidget {
  const _ApiKeyCard();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tr = context.t.settings.page.developer;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.code, size: 17, color: colors.text2),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tr.apiKeyTitle,
                  style: context.typo.body.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colors.text,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tr.apiKeyDesc,
                  style: context.typo.body.copyWith(
                    fontSize: 13.5,
                    color: colors.text2,
                  ),
                ),
                const SizedBox(height: 10),
                OutlineButton(
                  size: ButtonSize.small,
                  trailing: const Icon(Icons.north_east, size: 14),
                  onPressed: () => inject<UrlOpener>().open(apiKeysUrl),
                  child: Text(tr.apiKeyButton),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
