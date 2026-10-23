part of 'new_agent_dialog.dart';

// Peças do dialog "New agent": rótulo, erro inline, linha com switch, cor.

class _Caption extends StatelessWidget {
  const _Caption(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(
      text,
      style: context.typo.label.copyWith(color: context.colors.text2),
    ),
  );
}

class _Problem extends StatelessWidget {
  const _Problem(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 6),
    child: Text(
      text,
      style: context.typo.label.copyWith(color: context.colors.error),
    ),
  );
}

/// Linha título (+ dica ou ícone de info) e o switch à direita.
class _Toggle extends StatelessWidget {
  const _Toggle({
    required this.title,
    required this.value,
    required this.onChanged,
    this.hint,
    this.info,
  });
  final String title;
  final String? hint;
  final String? info;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: context.typo.body.copyWith(color: colors.text),
                  ),
                  if (info case final info?) ...[
                    const SizedBox(width: 6),
                    AppTooltip(
                      message: info,
                      child: Icon(
                        Icons.info_outline,
                        size: 14,
                        color: colors.text3,
                      ),
                    ),
                  ],
                ],
              ),
              if (hint case final hint?)
                Text(
                  hint,
                  style: context.typo.label.copyWith(color: colors.text3),
                ),
            ],
          ),
        ),
        Switch(value: value, onChanged: onChanged),
      ],
    );
  }
}

/// Amostra de cor; [color] `null` = "Automatic" (cor do hash da aba).
class _Swatch extends StatelessWidget {
  const _Swatch({
    required this.color,
    required this.selected,
    required this.onTap,
  });
  final Color? color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final c = color;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: c ?? colors.panel2,
          borderRadius: BorderRadius.circular(7),
          border: Border.all(
            color: selected ? colors.text : colors.border,
            width: selected ? 2 : 1,
          ),
        ),
        child: c == null
            ? Icon(Icons.auto_awesome, size: 14, color: colors.text2)
            : selected
            ? Icon(Icons.check, size: 15, color: onColor(c))
            : null,
      ),
    );
  }
}
