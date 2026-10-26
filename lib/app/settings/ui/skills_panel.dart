import 'package:gsh_desktop/app/gsh/ui/widgets/realm_dialogs.dart';
import 'package:gsh_desktop/app/core/app_intents.dart' as intents;
import 'package:gsh_desktop/app/core/ui/themes/themes.dart';
import 'package:gsh_desktop/app/core/ui/widgets/app_menu.dart';
import 'package:gsh_desktop/app/core/domain/entities/claude_info.dart';
import 'package:gsh_desktop/app/settings/ui/claude_info_viewmodel.dart';
import 'package:gsh_desktop/app/settings/ui/plugin_directory.dart';
import 'package:gsh_desktop/app/settings/ui/settings_catalog.dart';
import 'package:gsh_desktop/app/settings/ui/settings_widgets.dart';
import 'package:gsh_desktop/i18n/strings.g.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

/// Aba **Skills**: Meus = as do usuário (`~/.claude/skills`), as dos plugins
/// habilitados e as do projeto ativo, com nome/descrição do frontmatter;
/// clicar abre o `SKILL.md`. Descobrir = o diretório dos marketplaces (as
/// skills chegam dentro de plugins). Adicionar = `claude plugin new` ou um
/// marketplace novo, num terminal.
class SkillsPanel extends StatefulWidget {
  const SkillsPanel({super.key});

  @override
  State<SkillsPanel> createState() => _SkillsPanelState();
}

class _SkillsPanelState extends State<SkillsPanel> {
  final _search = TextEditingController();
  bool _discover = false;

  String? get _workspace => intents.activeWorkspaceRoot?.call();

  @override
  void initState() {
    super.initState();
    _search.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<ClaudeInfoViewModel>().loadSkills(_workspace);
    });
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _add(String action) async {
    final tr = context.t.settings.page.catalog;
    final isSkill = action == 'skill';
    final name = await showRealmNameDialog(
      context,
      title: isSkill ? tr.newSkill : tr.addMarketplace,
      confirmLabel: context.t.common.create,
      takenNames: const {},
      placeholder: isSkill ? 'minha-skill' : 'owner/repo',
    );
    if (name == null || !mounted) return;
    runInShellTerminal(
      context,
      isSkill
          ? 'claude plugin new ${shellQuote(name)}'
          : 'claude plugin marketplace add ${shellQuote(name)}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ClaudeInfoViewModel>();
    final tr = context.t.settings.page.skills;
    final cat = context.t.settings.page.catalog;
    final header = CatalogHeader(
      title: context.t.settings.page.nav.skills,
      discover: _discover,
      onDiscoverChanged: (v) => setState(() => _discover = v),
      search: _search,
      actions: [
        if (!_discover)
          SettingsRefreshButton(
            loading: vm.skills.loading,
            onPressed: () => vm.loadSkills(_workspace, force: true),
          ),
        CatalogAddButton<String>(
          items: [
            AppMenuItem(value: 'skill', label: cat.newSkill, icon: Icons.add),
            AppMenuItem(
              value: 'market',
              label: cat.addMarketplace,
              icon: Icons.storefront_outlined,
            ),
          ],
          onPick: _add,
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
      for (final s in vm.skills.value ?? const <ClaudeSkillInfo>[])
        if (catalogMatches(_search.text, [s.name, s.description, s.plugin])) s,
    ];
    List<ClaudeSkillInfo> of(SkillSource src) =>
        all.where((s) => s.source == src).toList();
    return CatalogBody(
      header: header,
      children: [
        if (vm.skills.value == null)
          ...infoLoadRows(context, vm.skills, (_) => [], empty: tr.empty)
        else if (all.isEmpty)
          SettingsNote(tr.empty)
        else
          for (final (src, title) in [
            (SkillSource.user, tr.groupUser),
            (SkillSource.project, tr.groupProject),
            (SkillSource.plugin, tr.groupPlugins),
          ])
            if (of(src) case final list when list.isNotEmpty) ...[
              CatalogGroupTitle(title, list.length),
              for (final s in list) _SkillRow(s),
            ],
      ],
    );
  }
}

class _SkillRow extends StatelessWidget {
  const _SkillRow(this.skill);
  final ClaudeSkillInfo skill;

  @override
  Widget build(BuildContext context) {
    final tr = context.t.settings.page.skills;
    final open = intents.requestOpenFileTab;
    return CatalogRow(
      icon: Icons.history_edu_outlined,
      title: skill.name,
      by: switch (skill.source) {
        SkillSource.user => tr.byYou,
        SkillSource.project => tr.byProject,
        SkillSource.plugin => skill.plugin?.split('@').first,
      },
      description: skill.description,
      trailing: skill.updatedAt == null
          ? null
          : Text(
              shortDate(context, skill.updatedAt!),
              style: context.typo.body.copyWith(
                fontSize: 13,
                color: context.colors.text3,
              ),
            ),
      onTap: open == null
          ? null
          : () {
              open(skill.path);
              context.pop();
            },
    );
  }
}
