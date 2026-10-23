import 'package:cockpit/app/core/ui/themes/themes.dart';
import 'package:cockpit/app/core/ui/widgets/hover_tap.dart';
import 'package:cockpit/app/core/utils/platform_kind.dart';
import 'package:cockpit/app/settings/ui/settings_widgets.dart';
import 'package:cockpit/i18n/strings.g.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

/// Abas das Configurações, na ordem do menu lateral.
enum SettingsCategory {
  // Configurações
  general,
  account,
  privacy,
  usage,
  resources,
  memory,
  designSystems,
  claudeCode,
  cowork,
  // Este computador
  system,
  extensions,
  developer,
  // Personalização
  skills,
  connectors,
  plugins,
  // GSH Desktop (abas próprias do app)
  gshGeneral,
  appearance,
  terminal,
  languages,
  automations,
  shortcuts,
  notifications,
  remoteHosts,
}

/// Lado do menu: as configurações do próprio GSH ou as do motor Claude.
enum SettingsSide { gsh, claude }

extension SettingsCategorySide on SettingsCategory {
  SettingsSide get side =>
      const {
        SettingsCategory.gshGeneral,
        SettingsCategory.appearance,
        SettingsCategory.terminal,
        SettingsCategory.languages,
        SettingsCategory.automations,
        SettingsCategory.shortcuts,
        SettingsCategory.notifications,
        SettingsCategory.remoteHosts,
      }.contains(this)
      ? SettingsSide.gsh
      : SettingsSide.claude;
}

extension SettingsCategoryPlatform on SettingsCategory {
  /// No mobile (plano 59) só sobram as abas que não dependem do motor local
  /// nem da CLI `claude` desta máquina.
  bool get hiddenOnMobile => !const {
    SettingsCategory.general,
    SettingsCategory.gshGeneral,
    SettingsCategory.appearance,
    SettingsCategory.shortcuts,
    SettingsCategory.notifications,
    SettingsCategory.remoteHosts,
  }.contains(this);
}

/// Item do menu: uma aba ([category]) ou um link externo ([category] nulo).
class _Entry {
  const _Entry(this.icon, this.label, [this.category]);
  final IconData icon;
  final String label;
  final SettingsCategory? category;
}

/// Menu lateral das Configurações: no topo, o lado (GSH Desktop | Claude) e
/// a busca; embaixo, as abas daquele lado em grupos. O lado é o da aba
/// selecionada; trocar de lado seleciona a primeira aba dele. A busca filtra
/// pelo rótulo (contém, sem diferenciar caixa) e esconde os grupos vazios.
class SettingsNav extends StatefulWidget {
  const SettingsNav({
    super.key,
    required this.selected,
    required this.onSelect,
    required this.onOpenApiKeys,
  });
  final SettingsCategory selected;
  final ValueChanged<SettingsCategory> onSelect;

  /// "Chaves de API": abre o console no navegador (não é uma aba).
  final VoidCallback onOpenApiKeys;

  /// Largura do menu (a da referência).
  static const width = 220.0;

  @override
  State<SettingsNav> createState() => _SettingsNavState();
}

class _SettingsNavState extends State<SettingsNav> {
  final _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    _search.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<(String, List<_Entry>)> _groups(BuildContext context) {
    final nav = context.t.settings.page.nav;
    final groups = nav.groups;
    if (widget.selected.side == SettingsSide.gsh) {
      return [
        (
          groups.app,
          [
            _Entry(
              Icons.settings_outlined,
              nav.general,
              SettingsCategory.gshGeneral,
            ),
            _Entry(
              Icons.brightness_6_outlined,
              nav.appearance,
              SettingsCategory.appearance,
            ),
            _Entry(
              Icons.terminal_outlined,
              nav.terminal,
              SettingsCategory.terminal,
            ),
            _Entry(Icons.data_object, nav.language, SettingsCategory.languages),
            _Entry(
              Icons.auto_awesome_outlined,
              nav.automations,
              SettingsCategory.automations,
            ),
            _Entry(
              Icons.keyboard_outlined,
              nav.shortcuts,
              SettingsCategory.shortcuts,
            ),
            _Entry(
              Icons.notifications_outlined,
              nav.notifications,
              SettingsCategory.notifications,
            ),
            _Entry(
              Icons.cloud_outlined,
              nav.remoteHosts,
              SettingsCategory.remoteHosts,
            ),
          ],
        ),
      ];
    }
    return [
      (
        groups.settings,
        [
          _Entry(
            Icons.settings_outlined,
            nav.general,
            SettingsCategory.general,
          ),
          _Entry(
            Icons.account_circle_outlined,
            nav.account,
            SettingsCategory.account,
          ),
          _Entry(Icons.shield_outlined, nav.privacy, SettingsCategory.privacy),
          _Entry(Icons.data_usage, nav.usage, SettingsCategory.usage),
          _Entry(Icons.work_outline, nav.resources, SettingsCategory.resources),
          _Entry(
            Icons.psychology_outlined,
            nav.memory,
            SettingsCategory.memory,
          ),
          _Entry(
            Icons.palette_outlined,
            nav.designSystems,
            SettingsCategory.designSystems,
          ),
          _Entry(Icons.code, nav.claudeCode, SettingsCategory.claudeCode),
          _Entry(Icons.checklist, nav.cowork, SettingsCategory.cowork),
        ],
      ),
      (
        groups.thisComputer,
        [
          _Entry(
            Icons.desktop_windows_outlined,
            nav.system,
            SettingsCategory.system,
          ),
          _Entry(
            Icons.extension_outlined,
            nav.extensions,
            SettingsCategory.extensions,
          ),
          _Entry(
            Icons.build_outlined,
            nav.developer,
            SettingsCategory.developer,
          ),
        ],
      ),
      (
        groups.personalization,
        [
          _Entry(
            Icons.history_edu_outlined,
            nav.skills,
            SettingsCategory.skills,
          ),
          _Entry(
            Icons.widgets_outlined,
            nav.connectors,
            SettingsCategory.connectors,
          ),
          _Entry(Icons.power_outlined, nav.plugins, SettingsCategory.plugins),
        ],
      ),
      (groups.platform, [_Entry(Icons.vpn_key_outlined, nav.apiKeys)]),
    ];
  }

  /// Troca de lado: vai para a primeira aba do outro lado.
  void _switchSide(SettingsSide side) {
    if (side == widget.selected.side) return;
    widget.onSelect(
      side == SettingsSide.gsh
          ? SettingsCategory.gshGeneral
          : SettingsCategory.general,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final query = _search.text.trim().toLowerCase();
    bool visible(_Entry e) =>
        !(isMobilePlatform && (e.category?.hiddenOnMobile ?? false)) &&
        (query.isEmpty || e.label.toLowerCase().contains(query));

    final items = <Widget>[];
    for (final (title, entries) in _groups(context)) {
      final shown = entries.where(visible).toList();
      if (shown.isEmpty) continue;
      items.add(_GroupHeader(title, first: items.isEmpty));
      for (final e in shown) {
        final category = e.category;
        items.add(
          _NavItem(
            icon: e.icon,
            label: e.label,
            external: category == null,
            selected: category == widget.selected,
            onTap: category == null
                ? widget.onOpenApiKeys
                : () => widget.onSelect(category),
          ),
        );
      }
    }

    return Container(
      width: SettingsNav.width,
      // Fundo opaco: no drawer (mobile portrait) o nav fica SOBRE o painel.
      decoration: BoxDecoration(
        color: colors.bg,
        border: Border(right: BorderSide(color: colors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: SettingsSegmented<SettingsSide>(
              value: widget.selected.side,
              onChanged: _switchSide,
              options: {
                SettingsSide.gsh: context.t.settings.page.nav.sideGsh,
                SettingsSide.claude: context.t.settings.page.nav.sideClaude,
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 6),
            child: SizedBox(
              child: TextField(
                controller: _search,
                placeholder: Text(context.t.settings.page.nav.search),
                features: const [
                  InputFeature.leading(Icon(Icons.search, size: 17)),
                  InputFeature.clear(
                    visibility: InputFeatureVisibility.textNotEmpty,
                  ),
                ],
                style: context.typo.body.copyWith(
                  fontSize: 14,
                  color: colors.text,
                ),
                border: Border.all(color: colors.border2),
                borderRadius: BorderRadius.circular(8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              children: items.isEmpty
                  ? [_GroupHeader(context.t.common.noResults, first: true)]
                  : items,
            ),
          ),
          const _VersionFooter(),
        ],
      ),
    );
  }
}

class _GroupHeader extends StatelessWidget {
  const _GroupHeader(this.title, {required this.first});
  final String title;
  final bool first;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(9, first ? 14 : 22, 9, 8),
      child: Text(
        title,
        style: context.typo.label.copyWith(
          fontSize: 12.5,
          color: context.colors.text3,
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.external = false,
  });
  final IconData icon;
  final String label;
  final bool selected;
  final bool external;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: 1),
      child: HoverTap(
        color: selected ? colors.panel3 : Colors.transparent,
        borderRadius: BorderRadius.circular(7),
        onTap: onTap,
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
        child: Row(
          children: [
            Icon(icon, size: 17, color: selected ? colors.text : colors.text2),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.typo.body.copyWith(
                  fontSize: 14,
                  color: selected ? colors.text : colors.text2,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            if (external) Icon(Icons.north_east, size: 15, color: colors.text3),
          ],
        ),
      ),
    );
  }
}

/// Rodapé do nav: "GSH Desktop `version`", pra identificar visualmente qual
/// build está rodando. A versão vem do `PackageInfo` (mesma fonte do
/// self-update), carregada de forma assíncrona.
class _VersionFooter extends StatefulWidget {
  const _VersionFooter();

  @override
  State<_VersionFooter> createState() => _VersionFooterState();
}

class _VersionFooterState extends State<_VersionFooter> {
  String? _version;

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((info) {
      if (mounted) setState(() => _version = info.version);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        _version == null ? 'GSH Desktop' : 'GSH Desktop $_version',
        style: context.typo.label.copyWith(color: context.colors.text4),
      ),
    );
  }
}
