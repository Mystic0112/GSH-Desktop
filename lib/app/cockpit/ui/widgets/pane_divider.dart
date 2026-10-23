import 'package:cockpit/app/cockpit/ui/states/pane_node.dart';
import 'package:cockpit/app/core/ui/themes/themes.dart';
import 'package:flutter/widgets.dart';

/// Handle de redimensionamento de pane. Preenche **toda** a área que recebe (o
/// `Positioned` largo no `Stack` do split) para uma região de arraste generosa,
/// mas desenha só uma **linha de 1px** centralizada — visual fino, pega larga.
/// Vira accent ao passar o mouse / arrastar.
class PaneDivider extends StatefulWidget {
  const PaneDivider({super.key, required this.dir, required this.onDelta});

  final SplitDir dir;

  /// Delta em pixels (dx para vertical, dy para horizontal).
  final ValueChanged<double> onDelta;

  @override
  State<PaneDivider> createState() => _PaneDividerState();
}

class _PaneDividerState extends State<PaneDivider> {
  bool _hot = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isVertical = widget.dir == SplitDir.vertical;
    final color = _hot ? colors.accent : colors.border;

    return MouseRegion(
      cursor: isVertical
          ? SystemMouseCursors.resizeColumn
          : SystemMouseCursors.resizeRow,
      onEnter: (_) => setState(() => _hot = true),
      onExit: (_) => setState(() => _hot = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanStart: (_) => setState(() => _hot = true),
        onPanEnd: (_) => setState(() => _hot = false),
        onPanCancel: () => setState(() => _hot = false),
        onPanUpdate: (details) =>
            widget.onDelta(isVertical ? details.delta.dx : details.delta.dy),
        child: Center(
          child: Container(
            width: isVertical ? 1 : double.infinity,
            height: isVertical ? double.infinity : 1,
            color: color,
          ),
        ),
      ),
    );
  }
}
