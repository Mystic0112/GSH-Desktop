import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

/// Tipografia do GSH Desktop — identidade Gorila: Montserrat (display/títulos,
/// a fonte de heading do gorilash.com.br), Hanken Grotesk (UI/texto),
/// JetBrains Mono (código, também a fonte de corpo do site). Servidas via
/// `google_fonts` (runtime + cache), sem bundle de .ttf.
@immutable
class AppTypography {
  const AppTypography({
    required this.display,
    required this.title,
    required this.body,
    required this.label,
    required this.tab,
    required this.mono,
  });

  /// Montserrat — títulos grandes (heading do transcript).
  final TextStyle display;

  /// Montserrat — nomes de workspace/aba/seção.
  final TextStyle title;

  /// Hanken Grotesk — corpo do transcript e inputs.
  final TextStyle body;

  /// Hanken Grotesk — rótulos pequenos.
  final TextStyle label;

  /// Montserrat — texto das abas.
  final TextStyle tab;

  /// JetBrains Mono — código, args de tool, métricas.
  final TextStyle mono;

  /// Igualdade por valor, pela mesma razão do [AppColors]: o `CockpitTheme`
  /// compara estes objetos para decidir se repinta a árvore.
  List<Object?> get _props => [display, title, body, label, tab, mono];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppTypography && listEquals(_props, other._props);

  @override
  int get hashCode => Object.hashAll(_props);

  /// Monta a tipografia. Sem args = defaults do design. [uiFont]/[monoFont]
  /// vazios mantêm Montserrat/Hanken e JetBrains Mono; preenchidos trocam a
  /// família (resolução pelo SO). [codeSize] define o tamanho do mono. O
  /// "tamanho da interface" NÃO escala aqui — é aplicado globalmente via
  /// `MediaQuery.textScaler` (zoom de texto em todo o app).
  factory AppTypography.build({
    String? uiFont,
    String? monoFont,
    double codeSize = 13,
  }) {
    final hasUi = uiFont != null && uiFont.trim().isNotEmpty;
    final hasMono = monoFont != null && monoFont.trim().isNotEmpty;
    // Display/títulos: Montserrat por padrão; corpo/rótulos: Hanken. Com uma
    // fonte custom de interface, ela manda em tudo.
    final TextStyle displayBase = hasUi
        ? TextStyle(fontFamily: uiFont)
        : GoogleFonts.montserrat();
    final TextStyle ui = hasUi
        ? TextStyle(fontFamily: uiFont)
        : GoogleFonts.hankenGrotesk();
    final TextStyle mono = hasMono
        ? TextStyle(fontFamily: monoFont)
        : GoogleFonts.jetBrainsMono();

    return AppTypography(
      display: displayBase.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 1.25,
        letterSpacing: -0.2,
      ),
      title: displayBase.copyWith(fontSize: 13, fontWeight: FontWeight.w600),
      body: ui.copyWith(fontSize: 14.5, height: 1.6),
      label: ui.copyWith(fontSize: 12, height: 1.3),
      tab: displayBase.copyWith(fontSize: 12.5, fontWeight: FontWeight.w500),
      mono: mono.copyWith(fontSize: codeSize, height: 1.55),
    );
  }

  AppTypography copyWith({
    TextStyle? display,
    TextStyle? title,
    TextStyle? body,
    TextStyle? label,
    TextStyle? tab,
    TextStyle? mono,
  }) {
    return AppTypography(
      display: display ?? this.display,
      title: title ?? this.title,
      body: body ?? this.body,
      label: label ?? this.label,
      tab: tab ?? this.tab,
      mono: mono ?? this.mono,
    );
  }
}
