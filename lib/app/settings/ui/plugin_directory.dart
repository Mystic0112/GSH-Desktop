import 'package:gsh_desktop/app/core/ui/themes/themes.dart';
import 'package:gsh_desktop/app/core/ui/widgets/hover_tap.dart';
import 'package:gsh_desktop/app/settings/domain/claude_info.dart';
import 'package:gsh_desktop/app/settings/ui/claude_info_viewmodel.dart';
import 'package:gsh_desktop/app/settings/ui/settings_catalog.dart';
import 'package:gsh_desktop/app/settings/ui/settings_widgets.dart';
import 'package:gsh_desktop/i18n/strings.g.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

/// Descobrir de Skills e Plugins: os plugins que os marketplaces adicionados
/// oferecem (`marketplace.json` de cada um), com um filtro por marketplace e
/// cartões em duas colunas. "+" roda `claude plugin install` num terminal.
class PluginDirectory extends StatefulWidget {
  const PluginDirectory({super.key, required this.query});

  /// Texto da busca do cabeçalho da aba.
  final String query;

  @override
  State<PluginDirectory> createState() => _PluginDirectoryState();
}

class _PluginDirectoryState extends State<PluginDirectory> {
  /// Marketplace filtrado; `null` = todos.
  String? _market;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<ClaudeInfoViewModel>().loadDirectory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ClaudeInfoViewModel>();
    final tr = context.t.settings.page.catalog;
    final all = vm.directory.value;
    if (all == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: infoLoadRows(context, vm.directory, (_) => [], empty: ''),
      );
    }
    final markets = {for (final p in all) p.marketplace}.toList()..sort();
    final shown = [
      for (final p in all)
        if ((_market == null || p.marketplace == _market) &&
            catalogMatches(widget.query, [p.name, p.description, p.author]))
          p,
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final m in [null, ...markets])
                _FilterChip(
                  label: m ?? tr.all,
                  selected: m == _market,
                  onTap: () => setState(() => _market = m),
                ),
            ],
          ),
        ),
        if (shown.isEmpty)
          SettingsNote(context.t.common.noResults)
        else
          LayoutBuilder(
            builder: (context, box) {
              final w = (box.maxWidth - 12) / 2;
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  for (final p in shown)
                    SizedBox(
                      width: w,
                      child: _Card(plugin: p),
                    ),
                ],
              );
            },
          ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return HoverTap(
      onTap: onTap,
      color: selected ? colors.panel3 : null,
      border: Border.all(color: selected ? colors.border2 : colors.border),
      borderRadius: BorderRadius.circular(7),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Text(
        label,
        style: context.typo.body.copyWith(
          fontSize: 13,
          color: selected ? colors.text : colors.text2,
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.plugin});
  final MarketplacePlugin plugin;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tr = context.t.settings.page.catalog;
    return Container(
      height: 112,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.panel2,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.power_outlined, size: 20, color: colors.text2),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plugin.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.typo.body.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colors.text,
                  ),
                ),
                Text(
                  [
                    if (plugin.author case final a?) tr.by(author: a),
                    plugin.marketplace,
                  ].join('  ·  '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.typo.label.copyWith(color: colors.text3),
                ),
                const SizedBox(height: 4),
                Text(
                  plugin.description ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.typo.body.copyWith(
                    fontSize: 13,
                    height: 1.4,
                    color: colors.text2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (plugin.installed)
            Icon(Icons.check, size: 18, color: colors.ok)
          else
            IconButton.outline(
              size: ButtonSize.small,
              icon: const Icon(Icons.add, size: 16),
              onPressed: () => runInShellTerminal(
                context,
                'claude plugin install ${shellQuote(plugin.id)}',
              ),
            ),
        ],
      ),
    );
  }
}
