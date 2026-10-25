import 'dart:io';

import 'package:gsh_desktop/app/core/ui/settings_controller.dart';
import 'package:gsh_desktop/app/core/ui/theme_store_error_message.dart';
import 'package:gsh_desktop/app/core/ui/themes/themes.dart';
import 'package:gsh_desktop/app/core/ui/widgets/app_menu.dart';
import 'package:gsh_desktop/app/settings/ui/settings_catalog.dart';
import 'package:gsh_desktop/app/settings/ui/settings_widgets.dart';
import 'package:gsh_desktop/i18n/strings.g.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

/// Aba **Design systems**: no GSH, são os temas (cores da interface, do
/// terminal e paleta de código num pacote só). Lista os embutidos e os
/// importados, com busca; "+ Novo design system" importa um `.json`.
class DesignSystemsPanel extends StatefulWidget {
  const DesignSystemsPanel({super.key});

  @override
  State<DesignSystemsPanel> createState() => _DesignSystemsPanelState();
}

class _DesignSystemsPanelState extends State<DesignSystemsPanel> {
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

  Future<void> _menu(BuildContext context, GshThemeSpec theme) async {
    final controller = context.read<SettingsController>();
    final tr = context.t.settings.page.designSystems;
    final custom = controller.isCustomTheme(theme.id);
    final pick = await showAppMenu<String>(
      context,
      items: [
        AppMenuItem(value: 'use', label: tr.activate, icon: Icons.check),
        if (custom)
          AppMenuItem(
            value: 'delete',
            label: tr.remove,
            icon: Icons.delete_outline,
            danger: true,
          ),
      ],
    );
    if (!context.mounted) return;
    switch (pick) {
      case 'use':
        controller.setThemeId(theme.id);
      case 'delete':
        final r = await controller.deleteTheme(theme.id);
        if (!context.mounted) return;
        if (r.isFailure) {
          r.fold(
            (_) {},
            (e) => showSettingsToast(
              context,
              themeStoreErrorMessage(context, e),
              isError: true,
            ),
          );
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<SettingsController>();
    final tr = context.t.settings.page.designSystems;
    final colors = context.colors;
    final all = controller.availableThemes;
    final shown = [
      for (final t in all)
        if (catalogMatches(_search.text, [t.name, t.author])) t,
    ];
    final head = context.typo.body.copyWith(fontSize: 13, color: colors.text2);
    return SettingsPanelBody(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tr.title,
                    style: context.typo.body.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: colors.text,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tr.desc,
                    style: context.typo.body.copyWith(
                      fontSize: 13.5,
                      color: colors.text3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 24),
            OutlineButton(
              size: ButtonSize.small,
              leading: const Icon(Icons.add, size: 16),
              onPressed: () => importThemeWithPicker(context),
              child: Text(tr.add),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            SizedBox(
              width: 450,
              child: TextField(
                controller: _search,
                placeholder: Text(tr.search),
                style: context.typo.body.copyWith(
                  fontSize: 13.5,
                  color: colors.text,
                ),
                borderRadius: BorderRadius.circular(7),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
              ),
            ),
            const Spacer(),
            Text(
              tr.showing(n: shown.length, total: all.length),
              style: head,
            ),
          ],
        ),
        const SizedBox(height: 18),
        _Line(
          name: Text(tr.colName, style: head),
          origin: Text(tr.colOrigin, style: head),
          author: Text(tr.colAuthor, style: head),
        ),
        for (final t in shown)
          _Line(
            name: Row(
              children: [
                Flexible(
                  child: Text(
                    t.name,
                    overflow: TextOverflow.ellipsis,
                    style: context.typo.body.copyWith(
                      fontSize: 14,
                      color: colors.text,
                      decoration: TextDecoration.underline,
                      decorationColor: colors.text3,
                    ),
                  ),
                ),
                if (controller.activeTheme.id == t.id) ...[
                  const SizedBox(width: 8),
                  SettingsChip(tr.active, color: colors.accentText),
                ],
              ],
            ),
            origin: SettingsChip(
              controller.isCustomTheme(t.id) ? tr.imported : tr.builtIn,
            ),
            author: Text(t.author ?? '—', style: head),
            menu: IconButton.secondary(
              size: ButtonSize.small,
              icon: const Icon(Icons.more_vert, size: 16),
              onPressed: () => _menu(context, t),
            ),
          ),
      ],
    );
  }
}

/// Linha da tabela (cabeçalho ou tema), com fio embaixo.
class _Line extends StatelessWidget {
  const _Line({
    required this.name,
    required this.origin,
    required this.author,
    this.menu,
  });
  final Widget name;
  final Widget origin;
  final Widget author;
  final Widget? menu;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(vertical: 9),
    decoration: BoxDecoration(
      border: Border(bottom: BorderSide(color: context.colors.border)),
    ),
    child: Row(
      children: [
        Expanded(flex: 5, child: name),
        Expanded(
          flex: 3,
          child: Align(alignment: Alignment.centerLeft, child: origin),
        ),
        Expanded(flex: 3, child: author),
        SizedBox(width: 40, child: menu),
      ],
    ),
  );
}

/// Escolhe um `.json` de tema e importa (já ativando). Usado pela aba
/// Aparência e pelo "+ Novo design system".
Future<void> importThemeWithPicker(BuildContext context) async {
  final controller = context.read<SettingsController>();
  final tr = context.t.settings.page.appearance;
  final picked = await FilePicker.platform.pickFiles(
    dialogTitle: tr.importThemeDialog,
    type: FileType.custom,
    allowedExtensions: const ['json'],
  );
  final path = picked?.files.singleOrNull?.path;
  if (path == null) return;

  final result = await controller.importTheme(File(path));
  if (!context.mounted) return;
  result.fold(
    (theme) => showSettingsToast(context, tr.themeImported(name: theme.name)),
    (error) => showSettingsToast(
      context,
      themeStoreErrorMessage(context, error),
      isError: true,
    ),
  );
}
