import 'package:cockpit/app/core/ui/settings_controller.dart';
import 'package:cockpit/app/core/ui/themes/themes.dart';
import 'package:cockpit/app/core/ui/widgets/app_menu.dart';
import 'package:cockpit/app/core/ui/widgets/app_tooltip.dart';
import 'package:cockpit/app/core/ui/widgets/hover_tap.dart';
import 'package:cockpit/i18n/strings.g.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

/// Escolha da paleta de código de um modo ([brightness]): dropdown + prévia
/// de um diff curto pintado como o app vai pintar (fundo do tema ativo,
/// cores da paleta escolhida).
class CodeThemePicker extends StatelessWidget {
  const CodeThemePicker({super.key, required this.brightness});
  final Brightness brightness;

  bool get _dark => brightness == Brightness.dark;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<SettingsController>();
    final s = controller.settings;
    final tr = context.t.settings.page.claudeCode;
    final variant = controller.activeTheme.variantFor(brightness);
    final picked = SyntaxPalette.byName(
      _dark ? s.codeThemeDark : s.codeThemeLight,
    );
    final set = _dark
        ? controller.setCodeThemeDark
        : controller.setCodeThemeLight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTooltip(
          message: _dark ? tr.codeThemeDarkHint : tr.codeThemeLightHint,
          child: _PaletteDropdown(
            label: picked?.label ?? tr.followTheme,
            onTap: () async {
              // `null` = menu dispensado; '' = "Do tema ativo".
              final choice = await showAppMenu<String>(
                context,
                minWidth: 240,
                items: [
                  AppMenuItem(
                    value: '',
                    label: tr.followTheme,
                    selected: picked == null,
                  ),
                  const AppMenuItem.divider(),
                  for (final p in SyntaxPalette.values)
                    AppMenuItem(
                      value: p.name,
                      label: p.label,
                      selected: p == picked,
                    ),
                ],
              );
              if (choice != null) set(choice.isEmpty ? null : choice);
            },
          ),
        ),
        const SizedBox(height: 12),
        CodeDiffPreview(
          syntax: (picked?.colors ?? variant.syntax).copyWith(
            background: variant.syntax.background,
          ),
          ui: variant.ui,
        ),
      ],
    );
  }
}

/// Gatilho do dropdown na largura toda, como o select da referência.
class _PaletteDropdown extends StatelessWidget {
  const _PaletteDropdown({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return HoverTap(
      onTap: onTap,
      color: colors.panel2,
      hoverColor: colors.panel3,
      border: Border.all(color: colors.border2),
      borderRadius: BorderRadius.circular(7),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.typo.body.copyWith(
                fontSize: 14,
                color: colors.text,
              ),
            ),
          ),
          Icon(Icons.keyboard_arrow_down, size: 18, color: colors.text3),
        ],
      ),
    );
  }
}

/// Tipo de cada pedaço da prévia → cor da paleta.
enum _Tok { plain, keyword, fn, param, type, string, meta, punct }

/// Linha da prévia: número, sinal (`-`/`+`/nada) e pedaços. O `bool` marca o
/// trecho que mudou (destaque mais forte dentro da linha).
typedef _Line = (String, String, List<(_Tok, String, bool)>);

const _lines = <_Line>[
  (
    '1',
    ' ',
    [
      (_Tok.keyword, 'function ', false),
      (_Tok.fn, 'greet', false),
      (_Tok.punct, '(', false),
      (_Tok.param, 'name', false),
      (_Tok.punct, ': ', false),
      (_Tok.type, 'string', false),
      (_Tok.punct, ') {', false),
    ],
  ),
  (
    '2',
    '-',
    [
      (_Tok.keyword, '  return ', false),
      (_Tok.string, '"Hello, "', true),
      (_Tok.punct, ' + ', true),
      (_Tok.plain, 'name', false),
      (_Tok.punct, ';', false),
    ],
  ),
  (
    '2',
    '+',
    [
      (_Tok.keyword, '  return ', false),
      (_Tok.string, '`Hello, ', true),
      (_Tok.meta, r'${', true),
      (_Tok.plain, 'name', false),
      (_Tok.meta, '}', true),
      (_Tok.string, '!`', true),
      (_Tok.punct, ';', false),
    ],
  ),
  ('3', ' ', [(_Tok.punct, '}', false)]),
];

/// Diff de quatro linhas pintado com [syntax]; [ui] dá as cores de diff
/// (erro/ok), da borda e dos números de linha do mesmo variant.
class CodeDiffPreview extends StatelessWidget {
  const CodeDiffPreview({super.key, required this.syntax, required this.ui});
  final SyntaxColors syntax;
  final AppColors ui;

  static const _lineHeight = 19.0;
  static const _gutter = 40.0;

  Color _color(_Tok t) => switch (t) {
    _Tok.plain || _Tok.punct => syntax.base,
    _Tok.keyword => syntax.keyword,
    _Tok.fn => syntax.function,
    _Tok.param => syntax.variable,
    _Tok.type => syntax.klass,
    _Tok.string => syntax.string,
    _Tok.meta => syntax.meta,
  };

  @override
  Widget build(BuildContext context) {
    final mono = context.typo.mono.copyWith(fontSize: 13, height: 1.0);
    return Container(
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.symmetric(vertical: 9),
      decoration: BoxDecoration(
        color: syntax.background,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: ui.border2),
      ),
      child: Column(children: [for (final l in _lines) _line(l, mono)]),
    );
  }

  Widget _line(_Line line, TextStyle mono) {
    final (number, sign, toks) = line;
    final diff = switch (sign) {
      '-' => ui.error,
      '+' => ui.ok,
      _ => null,
    };
    final muted = mono.copyWith(color: diff == null ? ui.text4 : syntax.base);
    return Container(
      height: _lineHeight,
      color: diff?.withValues(alpha: 0.16),
      child: Row(
        children: [
          SizedBox(
            width: _gutter,
            child: Text(number, textAlign: TextAlign.right, style: muted),
          ),
          SizedBox(
            width: 22,
            child: Text(sign, textAlign: TextAlign.center, style: muted),
          ),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  for (final (tok, text, changed) in toks)
                    TextSpan(
                      text: text,
                      style: TextStyle(
                        color: _color(tok),
                        fontStyle: tok == _Tok.fn || tok == _Tok.param
                            ? FontStyle.italic
                            : null,
                        backgroundColor: changed
                            ? diff?.withValues(alpha: 0.28)
                            : null,
                      ),
                    ),
                ],
              ),
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.clip,
              style: mono,
            ),
          ),
        ],
      ),
    );
  }
}
