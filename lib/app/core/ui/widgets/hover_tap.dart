import 'package:cockpit/app/core/ui/themes/themes.dart';
import 'package:flutter/widgets.dart';

/// Substituto do Material `InkWell` para superfícies clicáveis custom (linhas de
/// lista, itens de menu, chips): hover + clique **sem depender de Material**.
///
/// O hover pinta um fundo sutil (default `context.colors.panel3`). Para ações de
/// verdade (primária/secundária/destrutiva) use os `Button` do shadcn
/// (`PrimaryButton`, `OutlineButton`, `GhostButton`, `DestructiveButton`,
/// `IconButton`). Este widget cobre o caso "área clicável com realce de hover"
/// que o `InkWell` resolvia — é o que o shadcn faz internamente via `Clickable`.
class HoverTap extends StatefulWidget {
  const HoverTap({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.borderRadius = const BorderRadius.all(Radius.circular(7)),
    this.color,
    this.hoverColor,
    this.border,
    this.cursor = SystemMouseCursors.click,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final BorderRadius borderRadius;

  /// Fundo base (sem hover). `null` = transparente.
  final Color? color;

  /// Fundo no hover. `null` → `context.colors.panel3`.
  final Color? hoverColor;

  /// Borda opcional (constante em hover e repouso).
  final BoxBorder? border;
  final MouseCursor cursor;

  @override
  State<HoverTap> createState() => _HoverTapState();
}

class _HoverTapState extends State<HoverTap> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onTap != null;
    final hoverColor = widget.hoverColor ?? context.colors.panel3;
    final bg = _hover && enabled ? hoverColor : widget.color;
    final inner = widget.padding == null
        ? widget.child
        : Padding(padding: widget.padding!, child: widget.child);
    return MouseRegion(
      cursor: enabled ? widget.cursor : MouseCursor.defer,
      onEnter: enabled ? (_) => setState(() => _hover = true) : null,
      onExit: enabled ? (_) => setState(() => _hover = false) : null,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: widget.borderRadius,
            border: widget.border,
          ),
          child: inner,
        ),
      ),
    );
  }
}
