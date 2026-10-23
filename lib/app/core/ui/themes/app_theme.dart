import 'package:gsh_desktop/app/core/domain/entities/app_settings.dart';
import 'package:gsh_desktop/app/core/ui/themes/app_colors.dart';
import 'package:gsh_desktop/app/core/ui/themes/color_contrast.dart';
import 'package:gsh_desktop/app/core/ui/themes/app_typography.dart';
import 'package:gsh_desktop/app/core/terminal/xterm/xterm.dart';
import 'package:gsh_desktop/app/core/ui/themes/syntax_colors.dart';
import 'package:gsh_desktop/app/core/ui/themes/theme_registry.dart';
import 'package:gsh_desktop/app/core/ui/themes/theme_spec.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

/// Bundle dos tokens bespoke (cores/tipografia/syntax) calculado para uma
/// `brightness` + `settings`. Instalado na árvore via `GshTheme` (a raiz o
/// monta no `builder`, já com a brightness efetiva). Consumido por
/// `context.colors`/`context.typo`/`context.syntax`.
typedef GshTokens = ({
  AppColors colors,
  AppTypography typo,
  SyntaxColors syntax,
  TerminalTheme terminal,
});

/// Calcula os tokens bespoke para [brightness]/[settings], a partir de [theme]
/// (o tema ativo — built-in ou importado). Sem [theme], usa o tema nativo.
GshTokens buildTokens({
  required Brightness brightness,
  AppSettings settings = const AppSettings(),
  GshThemeSpec? theme,
}) {
  final variant = (theme ?? gshTheme).variantFor(brightness);
  final typo = AppTypography.build(
    uiFont: settings.interfaceFont,
    monoFont: settings.codeFont,
    codeSize: settings.codeSize,
  );
  // Paleta escolhida para o modo vence a do tema; o fundo continua o do tema
  // (campo unificado do `_variant`): só as cores do código mudam.
  final override = SyntaxPalette.byName(
    brightness == Brightness.dark
        ? settings.codeThemeDark
        : settings.codeThemeLight,
  );
  return (
    colors: variant.ui,
    typo: typo,
    syntax:
        override?.colors.copyWith(background: variant.syntax.background) ??
        variant.syntax,
    terminal: variant.terminal,
  );
}

/// Monta o `ThemeData` do shadcn (light ou dark por [brightness]). A paleta é
/// derivada de [AppColors] — a **mesma** fonte das cores bespoke — então os
/// componentes shadcn e os widgets custom ficam coerentes. As `settings` entram
/// só onde o shadcn tem slot equivalente; o resto (fontes/syntax) viaja pelo
/// `GshTheme`.
ThemeData buildTheme({
  required Brightness brightness,
  AppSettings settings = const AppSettings(),
  GshThemeSpec? theme,
}) {
  final colors = (theme ?? gshTheme).variantFor(brightness).ui;
  // Reaproveita a resolução de fontes do AppTypography (Hanken/JetBrains ou as
  // custom das settings) e extrai só a FAMÍLIA para alimentar a Typography do
  // shadcn — assim todo componente shadcn herda a tipografia do GSH (o
  // ShadcnApp instala `typography.sans` no DefaultTextStyle raiz; os
  // modificadores .h3/.base/etc. só ajustam tamanho/peso e herdam a família).
  final appTypo = AppTypography.build(
    uiFont: settings.interfaceFont,
    monoFont: settings.codeFont,
    codeSize: settings.codeSize,
  );
  return ThemeData(
    colorScheme: _schemeFrom(colors, brightness),
    // Raio coerente com o design (cantos suaves, não pílula).
    radius: 0.5,
    typography: Typography.geist(
      sans: TextStyle(
        fontFamily: appTypo.body.fontFamily,
        fontFamilyFallback: appTypo.body.fontFamilyFallback,
      ),
      mono: TextStyle(
        fontFamily: appTypo.mono.fontFamily,
        fontFamilyFallback: appTypo.mono.fontFamilyFallback,
      ),
    ),
  );
}

/// Mapeia os 19 tokens do GSH nos slots semânticos do `ColorScheme` do
/// shadcn. Os tokens excedentes (panel2/panel3 extras, text3/text4, border2,
/// online/edited/warn…) não têm slot aqui e seguem disponíveis via
/// `context.colors`. `chart1..5` herdam da paleta base (zinc).
ColorScheme _schemeFrom(AppColors c, Brightness brightness) {
  final base = brightness == Brightness.dark
      ? ColorSchemes.darkZinc
      : ColorSchemes.lightZinc;
  return ColorScheme(
    brightness: brightness,
    background: c.bg,
    foreground: c.text,
    card: c.panel,
    cardForeground: c.text,
    popover: c.panel,
    popoverForeground: c.text,
    // "primary" = a marca. O texto sobre ela é derivado da luminância: no azul
    // Remote Pi dá branco (como era), mas um accent claro de tema custom recebe
    // texto escuro em vez de branco ilegível.
    primary: c.accent,
    primaryForeground: onColor(c.accent),
    // "secondary" = superfície neutra de botão secundário.
    secondary: c.panel3,
    secondaryForeground: c.text2,
    muted: c.panel2,
    mutedForeground: c.text2,
    // No shadcn "accent" é a superfície de hover/seleção (neutra), NÃO a marca.
    accent: c.panel3,
    accentForeground: c.text,
    destructive: c.error,
    destructiveForeground: onColor(c.error),
    border: c.border,
    input: c.border,
    // Anel de foco usa a marca.
    ring: c.accent,
    chart1: base.chart1,
    chart2: base.chart2,
    chart3: base.chart3,
    chart4: base.chart4,
    chart5: base.chart5,
  );
}
