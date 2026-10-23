import 'package:gsh_desktop/app/core/app_intents.dart' as intents;
import 'package:gsh_desktop/app/core/ui/themes/themes.dart';
import 'package:gsh_desktop/app/core/ui/widgets/app_menu.dart';
import 'package:gsh_desktop/app/core/ui/widgets/hover_tap.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/confirm_dialog.dart';
import 'package:gsh_desktop/app/settings/ui/settings_widgets.dart';
import 'package:gsh_desktop/i18n/strings.g.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

/// Peças das abas-catálogo (Skills, Conectores, Plugins): cabeçalho com
/// Meus/Descobrir, busca e "Adicionar", títulos de grupo com contagem e
/// linhas com ícone, selo, subtítulo e data.

/// Largura do conteúdo das abas-catálogo (a da referência).
const catalogMaxWidth = 860.0;

/// Corpo das abas-catálogo: cabeçalho fixo e a lista rolando embaixo.
class CatalogBody extends StatelessWidget {
  const CatalogBody({super.key, required this.header, required this.children});
  final Widget header;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: catalogMaxWidth + 56),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 22, 28, 10),
              child: header,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(28, 4, 28, 40),
                children: children,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Título grande, Meus/Descobrir opcional, busca e ações à direita.
class CatalogHeader extends StatelessWidget {
  const CatalogHeader({
    super.key,
    required this.title,
    this.discover,
    this.onDiscoverChanged,
    this.search,
    this.searchHint,
    this.actions = const [],
  });
  final String title;

  /// `null` = sem o seletor Meus/Descobrir.
  final bool? discover;
  final ValueChanged<bool>? onDiscoverChanged;
  final TextEditingController? search;
  final String? searchHint;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tr = context.t.settings.page.catalog;
    return Row(
      children: [
        Text(
          title,
          style: context.typo.title.copyWith(fontSize: 22, color: colors.text),
        ),
        if (discover case final d?) ...[
          const SizedBox(width: 16),
          SettingsSegmented<bool>(
            value: d,
            onChanged: onDiscoverChanged ?? (_) {},
            options: {false: tr.mine, true: tr.discover},
          ),
        ],
        const Spacer(),
        if (search case final c?)
          SizedBox(
            width: 255,
            child: TextField(
              controller: c,
              placeholder: Text(
                searchHint ?? context.t.settings.page.nav.search,
              ),
              features: const [
                InputFeature.leading(Icon(Icons.search, size: 15)),
                InputFeature.clear(
                  visibility: InputFeatureVisibility.textNotEmpty,
                ),
              ],
              style: context.typo.body.copyWith(
                fontSize: 13.5,
                color: colors.text,
              ),
              border: Border.all(color: colors.border2),
              borderRadius: BorderRadius.circular(8),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            ),
          ),
        for (final a in actions) ...[const SizedBox(width: 10), a],
      ],
    );
  }
}

/// "+ Adicionar ⌄": abre um menu com [items]; devolve a escolha em [onPick].
class CatalogAddButton<T> extends StatelessWidget {
  const CatalogAddButton({
    super.key,
    required this.items,
    required this.onPick,
  });
  final List<AppMenuItem<T>> items;
  final ValueChanged<T> onPick;

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      size: ButtonSize.small,
      leading: const Icon(Icons.add, size: 16),
      trailing: const Icon(Icons.keyboard_arrow_down, size: 16),
      onPressed: () async {
        final v = await showAppMenu<T>(context, items: items, minWidth: 220);
        if (v != null) onPick(v);
      },
      child: Text(context.t.settings.page.catalog.add),
    );
  }
}

/// "Criado por você  2".
class CatalogGroupTitle extends StatelessWidget {
  const CatalogGroupTitle(this.title, this.count, {super.key});
  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 6),
      child: Row(
        children: [
          Text(
            title,
            style: context.typo.body.copyWith(
              fontSize: 14.5,
              fontWeight: FontWeight.w600,
              color: colors.text,
            ),
          ),
          const SizedBox(width: 8),
          SettingsChip('$count'),
        ],
      ),
    );
  }
}

/// Linha de catálogo: ícone em caixa, título (+ selo), "por X · descrição" e
/// uma data/ação à direita. Clicar abre ([onTap]).
class CatalogRow extends StatelessWidget {
  const CatalogRow({
    super.key,
    required this.icon,
    required this.title,
    this.chip,
    this.by,
    this.description,
    this.trailing,
    this.onTap,
  });
  final IconData icon;
  final String title;
  final String? chip;
  final String? by;
  final String? description;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final sub = [?by, ?description].join('  ·  ');
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.border)),
      ),
      child: HoverTap(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: colors.bg,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: colors.border),
              ),
              child: Icon(icon, size: 18, color: colors.text2),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.typo.body.copyWith(
                            fontSize: 14,
                            color: colors.text,
                          ),
                        ),
                      ),
                      if (chip case final c?) ...[
                        const SizedBox(width: 8),
                        SettingsChip(c),
                      ],
                    ],
                  ),
                  if (sub.isNotEmpty)
                    Text(
                      sub,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.typo.body.copyWith(
                        fontSize: 12.5,
                        color: colors.text3,
                      ),
                    ),
                ],
              ),
            ),
            if (trailing case final t?) ...[const SizedBox(width: 16), t],
          ],
        ),
      ),
    );
  }
}

/// Selo pequeno e apagado ("Plugin", "2", "claude.ai").
class SettingsChip extends StatelessWidget {
  const SettingsChip(this.label, {super.key, this.color});
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: colors.panel3,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        label,
        style: context.typo.label.copyWith(
          fontSize: 11.5,
          color: color ?? colors.text2,
        ),
      ),
    );
  }
}

/// `true` se [text] contém [query] (sem diferenciar caixa).
bool catalogMatches(String query, Iterable<String?> fields) {
  final q = query.trim().toLowerCase();
  if (q.isEmpty) return true;
  return fields.any((f) => f != null && f.toLowerCase().contains(q));
}

/// Argumento de shell entre aspas simples (POSIX e PowerShell aceitam).
String shellQuote(String s) => "'${s.replaceAll("'", "'\\''")}'";

/// Roda [command] numa aba de terminal do workspace ativo e fecha as
/// Configurações para mostrá-la. Sem workspace local, explica num dialog.
void runInShellTerminal(BuildContext context, String command) {
  final run = intents.requestRunInTerminal;
  if (run == null || !run(command)) {
    final tr = context.t.settings.page.claude;
    showInfoDialog(context, title: tr.terminalTitle, message: tr.noWorkspace);
    return;
  }
  context.pop();
}
