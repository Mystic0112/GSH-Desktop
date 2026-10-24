import 'package:gsh_desktop/app/gsh/ui/widgets/realm_dialogs.dart';
import 'package:gsh_desktop/app/core/app_intents.dart' as intents;
import 'package:gsh_desktop/app/core/ui/themes/themes.dart';
import 'package:gsh_desktop/app/core/ui/widgets/app_menu.dart';
import 'package:gsh_desktop/app/settings/domain/claude_info.dart';
import 'package:gsh_desktop/app/settings/ui/claude_info_viewmodel.dart';
import 'package:gsh_desktop/app/settings/ui/plugin_directory.dart';
import 'package:gsh_desktop/app/settings/ui/settings_catalog.dart';
import 'package:gsh_desktop/app/settings/ui/settings_widgets.dart';
import 'package:gsh_desktop/i18n/strings.g.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

/// Aba **Plugins**: Meus = os habilitados no projeto ativo
/// (`.claude/settings.json`) e os instalados dos marketplaces adicionados,
/// com autor/descrição do manifesto. Descobrir = o diretório dos
/// marketplaces. Adicionar marketplace roda no terminal.
class PluginsPanel extends StatefulWidget {
  const PluginsPanel({super.key});

  @override
  State<PluginsPanel> createState() => _PluginsPanelState();
}

class _PluginsPanelState extends State<PluginsPanel> {
  final _search = TextEditingController();
  bool _discover = false;

  @override
  void initState() {
    super.initState();
    _search.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<ClaudeInfoViewModel>()
        ..loadPlugins()
        ..loadProjectPlugins(intents.activeWorkspaceRoot?.call());
    });
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _addMarketplace() async {
    final cat = context.t.settings.page.catalog;
    final source = await showRealmNameDialog(
      context,
      title: cat.addMarketplace,
      confirmLabel: context.t.common.add,
      takenNames: const {},
      placeholder: 'owner/repo',
    );
    if (source == null || !mounted) return;
    runInShellTerminal(
      context,
      'claude plugin marketplace add ${shellQuote(source)}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ClaudeInfoViewModel>();
    final tr = context.t.settings.page.plugins;
    final cat = context.t.settings.page.catalog;
    final header = CatalogHeader(
      title: context.t.settings.page.nav.plugins,
      discover: _discover,
      onDiscoverChanged: (v) => setState(() => _discover = v),
      search: _search,
      searchHint: tr.search,
      actions: [
        if (!_discover)
          SettingsRefreshButton(
            loading: vm.plugins.loading,
            onPressed: () => vm.loadPlugins(force: true),
          ),
        CatalogAddButton<String>(
          items: [
            AppMenuItem(
              value: 'market',
              label: cat.addMarketplace,
              icon: Icons.storefront_outlined,
            ),
          ],
          onPick: (_) => _addMarketplace(),
        ),
      ],
    );
    if (_discover) {
      return CatalogBody(
        header: header,
        children: [PluginDirectory(query: _search.text)],
      );
    }
    final all = [
      for (final p in vm.plugins.value ?? const <ClaudePluginInfo>[])
        if (catalogMatches(_search.text, [p.name, p.description, p.author])) p,
    ];
    final inProject = vm.projectPlugins ?? const <String>[];
    final hasWorkspace = intents.activeWorkspaceRoot?.call() != null;
    return CatalogBody(
      header: header,
      children: [
        CatalogGroupTitle(tr.groupProject, inProject.length),
        if (!hasWorkspace)
          SettingsNote(tr.noWorkspace)
        else if (inProject.isEmpty)
          SettingsNote(tr.projectEmpty)
        else
          for (final id in inProject)
            _PluginRow(
              all.where((p) => p.id == id).firstOrNull ??
                  ClaudePluginInfo(id: id, enabled: true),
            ),
        if (vm.plugins.value == null)
          ...infoLoadRows(context, vm.plugins, (_) => [], empty: tr.empty)
        else ...[
          CatalogGroupTitle(tr.groupMarketplaces, all.length),
          if (all.isEmpty) SettingsNote(tr.empty),
          for (final p in all) _PluginRow(p),
        ],
      ],
    );
  }
}

class _PluginRow extends StatelessWidget {
  const _PluginRow(this.plugin);
  final ClaudePluginInfo plugin;

  @override
  Widget build(BuildContext context) {
    final tr = context.t.settings.page.plugins;
    final colors = context.colors;
    final style = context.typo.body.copyWith(fontSize: 13, color: colors.text3);
    return CatalogRow(
      icon: Icons.power_outlined,
      title: plugin.name,
      chip: plugin.enabled ? null : tr.disabled,
      by: plugin.author == null
          ? plugin.marketplace
          : context.t.settings.page.catalog.by(author: plugin.author!),
      description: plugin.description,
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (plugin.updatedAt case final d?)
            Text(shortDate(context, d), style: style),
          if (plugin.version case final v?)
            Text(
              v.length > 10 ? v.substring(0, 7) : v,
              style: context.typo.mono.copyWith(
                fontSize: 11.5,
                color: colors.text4,
              ),
            ),
        ],
      ),
    );
  }
}
