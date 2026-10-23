import 'package:gsh_desktop/app/core/app_intents.dart' as intents;
import 'package:gsh_desktop/app/core/ui/font_catalog.dart';
import 'package:gsh_desktop/app/core/ui/themes/themes.dart';
import 'package:gsh_desktop/app/core/ui/widgets/app_tooltip.dart';
import 'package:gsh_desktop/app/core/ui/widgets/hover_tap.dart';
import 'package:gsh_desktop/app/settings/ui/font_picker_dialog.dart';
import 'package:gsh_desktop/app/settings/domain/claude_info.dart';
import 'package:gsh_desktop/app/settings/ui/claude_info_viewmodel.dart';
import 'package:gsh_desktop/i18n/strings.g.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

/// Peças das abas no estilo plano (título de seção em negrito e linhas
/// separadas por um fio), compartilhadas pela aba Claude Code e pelas abas
/// novas do grupo Claude.

/// Corpo rolável de uma aba, centralizado na largura da referência.
class SettingsPanelBody extends StatelessWidget {
  const SettingsPanelBody({super.key, required this.children});
  final List<Widget> children;

  /// Largura máxima do conteúdo (a da referência).
  static const maxWidth = 1010.0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 26, 28, 48),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: maxWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        ),
      ),
    );
  }
}

/// Título em negrito e as linhas abaixo, separadas por um fio. [action] fica
/// à direita do título (ex.: botão "Atualizar").
class SettingsSection extends StatelessWidget {
  const SettingsSection({
    super.key,
    required this.title,
    required this.rows,
    this.action,
    this.description,
    this.divided = true,
  });
  final String title;
  final List<Widget> rows;
  final Widget? action;

  /// Texto apagado logo abaixo do título.
  final String? description;

  /// Fio entre as linhas (`false` para conteúdo livre: listas, cartões).
  final bool divided;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: description == null ? 14 : 4),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: context.typo.body.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: colors.text,
                    ),
                  ),
                ),
                ?action,
              ],
            ),
          ),
          if (description case final d?)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Text(
                d,
                style: context.typo.body.copyWith(
                  fontSize: 13.5,
                  height: 1.45,
                  color: colors.text3,
                ),
              ),
            ),
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0 && divided)
              Divider(height: 1, thickness: 1, color: colors.border),
            rows[i],
          ],
        ],
      ),
    );
  }
}

/// Título + descrição à esquerda, controle à direita (centralizado na altura).
class SettingsRow extends StatelessWidget {
  const SettingsRow({
    super.key,
    required this.title,
    this.trailing,
    this.description,
    this.leading,
  });
  final String title;
  final String? description;
  final Widget? trailing;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          if (leading case final l?) ...[l, const SizedBox(width: 12)],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.typo.body.copyWith(
                    fontSize: 14,
                    color: colors.text,
                  ),
                ),
                if (description case final d?) ...[
                  const SizedBox(height: 4),
                  Text(
                    d,
                    style: context.typo.body.copyWith(
                      fontSize: 13.5,
                      height: 1.45,
                      color: colors.text3,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing case final t?) ...[const SizedBox(width: 40), t],
        ],
      ),
    );
  }
}

/// Linha de texto apagado (vazio, carregando, aviso) dentro de uma seção.
class SettingsNote extends StatelessWidget {
  const SettingsNote(this.text, {super.key, this.error = false});
  final String text;
  final bool error;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        text,
        style: context.typo.body.copyWith(
          fontSize: 13.5,
          height: 1.45,
          color: error ? colors.error : colors.text3,
        ),
      ),
    );
  }
}

/// Botão "Atualizar" das seções que leem a CLI; vira spinner enquanto lê.
class SettingsRefreshButton extends StatelessWidget {
  const SettingsRefreshButton({
    super.key,
    required this.loading,
    required this.onPressed,
  });
  final bool loading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      size: ButtonSize.small,
      onPressed: loading ? null : onPressed,
      leading: loading
          ? const CircularProgressIndicator(size: 12)
          : const Icon(Icons.refresh, size: 14),
      child: Text(context.t.settings.page.claude.refresh),
    );
  }
}

/// "Abrir": abre [path] numa aba do shell e fecha as Configurações para
/// mostrá-la. Desabilitado sem o shell montado (ex.: testes).
class SettingsOpenFileButton extends StatelessWidget {
  const SettingsOpenFileButton({super.key, required this.path, this.label});
  final String path;

  /// Rótulo do botão (`null` = "Abrir").
  final String? label;

  @override
  Widget build(BuildContext context) {
    final open = intents.requestOpenFileTab;
    return OutlineButton(
      size: ButtonSize.small,
      onPressed: open == null
          ? null
          : () {
              open(path);
              context.pop();
            },
      child: Text(label ?? context.t.common.open),
    );
  }
}

/// Linhas de uma seção alimentada por um [InfoLoad]: carregando, erro ou
/// vazio viram uma [SettingsNote]; com valor, [build] monta as linhas.
List<Widget> infoLoadRows<T>(
  BuildContext context,
  InfoLoad<T> load,
  List<Widget> Function(T value) build, {
  required String empty,
}) {
  final tr = context.t.settings.page.claude;
  if (load.error case final e?) {
    return [SettingsNote(claudeInfoErrorMessage(context, e), error: true)];
  }
  final value = load.value;
  if (value == null) return [SettingsNote(tr.loading)];
  final rows = build(value);
  return rows.isEmpty ? [SettingsNote(empty)] : rows;
}

/// Frase do [ClaudeInfoError] (o stderr da CLI entra cru como detalhe).
String claudeInfoErrorMessage(BuildContext context, ClaudeInfoError e) {
  final tr = context.t.settings.page.claude.error;
  return switch (e.kind) {
    ClaudeInfoErrorKind.cliMissing => tr.cliMissing,
    ClaudeInfoErrorKind.timeout => tr.timeout,
    ClaudeInfoErrorKind.failed => tr.failed(detail: e.detail ?? '—'),
  };
}

/// Controle segmentado: uma pílula com as opções, a escolhida em relevo.
class SettingsSegmented<T> extends StatelessWidget {
  const SettingsSegmented({
    super.key,
    required this.value,
    required this.options,
    required this.onChanged,
    this.icons,
  });
  final T value;
  final Map<T, String> options;
  final ValueChanged<T> onChanged;

  /// Ícone no lugar do rótulo (o rótulo vira tooltip). Ex.: tema.
  final Map<T, IconData>? icons;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: colors.panel2,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final MapEntry(:key, value: label) in options.entries)
            HoverTap(
              onTap: () => onChanged(key),
              color: key == value ? colors.panel3 : null,
              hoverColor: key == value ? colors.panel3 : colors.panel,
              border: Border.all(
                color: key == value ? colors.border2 : Colors.transparent,
              ),
              borderRadius: BorderRadius.circular(6),
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
              child: switch (icons?[key]) {
                final icon? => AppTooltip(
                  message: label,
                  child: Icon(
                    icon,
                    size: 17,
                    color: key == value ? colors.text : colors.text2,
                  ),
                ),
                null => Text(
                  label,
                  style: context.typo.body.copyWith(
                    fontSize: 13.5,
                    color: key == value ? colors.text : colors.text2,
                    fontWeight: key == value ? FontWeight.w500 : null,
                  ),
                ),
              },
            ),
        ],
      ),
    );
  }
}

/// Campo de família de fonte (texto livre; vazio = padrão).
/// Seleção de família de fonte.
///
/// Substituiu um campo de texto livre que falhava em silêncio: nome com erro de
/// digitação ou fonte não instalada caíam no fallback sem nenhum aviso. Agora a
/// escolha sai de uma lista do que a máquina realmente tem (ver
/// [showFontPickerDialog]), o nome escolhido é desenhado **na própria fonte**, e
/// uma família que não resolve é sinalizada aqui no chip.
class SettingsFontField extends StatelessWidget {
  const SettingsFontField({
    super.key,
    required this.value,
    required this.hint,
    required this.onChanged,
    this.monospacedOnly = false,
  });

  final String? value;

  /// Descrição do padrão do design, mostrada quando não há escolha.
  final String hint;
  final ValueChanged<String?> onChanged;
  final bool monospacedOnly;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final family = value;
    final missing = family != null && !isFontAvailable(family);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (missing) ...[
          AppTooltip(
            message: context.t.settings.page.appearance.fontMissing,
            child: Icon(Icons.warning_amber, size: 15, color: colors.warn),
          ),
          const SizedBox(width: 6),
        ],
        HoverTap(
          color: colors.panel3,
          borderRadius: BorderRadius.circular(7),
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
          onTap: () async {
            final choice = await showFontPickerDialog(
              context,
              current: family,
              defaultLabel: hint,
              monospacedOnly: monospacedOnly,
            );
            // Dialog dispensado devolve null; só uma escolha real muda algo.
            if (choice != null) onChanged(choice.family);
          },
          child: SizedBox(
            width: 218,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    family ?? hint,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: family == null
                        ? context.typo.body.copyWith(
                            fontSize: 13,
                            color: colors.text3,
                          )
                        : TextStyle(
                            fontFamily: family,
                            fontSize: 13,
                            color: colors.text,
                          ),
                  ),
                ),
                Icon(Icons.keyboard_arrow_down, size: 16, color: colors.text3),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Aviso rápido no canto (tema importado/removido, erro de gravação).
void showSettingsToast(
  BuildContext context,
  String message, {
  bool isError = false,
}) {
  final colors = context.colors;
  showToast(
    context: context,
    location: ToastLocation.bottomRight,
    builder: (context, overlay) => SurfaceCard(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              size: 18,
              color: isError ? colors.error : colors.ok,
            ),
            const SizedBox(width: 10),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: Text(
                message,
                style: context.typo.label.copyWith(color: colors.text),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

/// "18 de ago." — dia e mês abreviado no idioma da interface.
String shortDate(BuildContext context, DateTime d) {
  final tr = context.t.settings.page.claude;
  return tr.dateShort(day: d.day, month: tr.months.split('|')[d.month - 1]);
}

/// Gatilho de dropdown plano ("Padrão ⌄"), como os do Claude Desktop.
class SettingsDropdown extends StatelessWidget {
  const SettingsDropdown({super.key, required this.label, required this.onTap});
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return HoverTap(
      color: colors.panel2,
      borderRadius: BorderRadius.circular(7),
      border: Border.all(color: colors.border2),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      onTap: onTap,
      child: SizedBox(
        width: 140,
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.typo.body.copyWith(
                  fontSize: 13.5,
                  color: colors.text,
                ),
              ),
            ),
            Icon(Icons.keyboard_arrow_down, size: 16, color: colors.text3),
          ],
        ),
      ),
    );
  }
}
