import 'package:gsh_desktop/app/core/ui/themes/themes.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

/// Texto curto digitado à mão numa linha de configuração; grava ao
/// confirmar ou sair do campo. Vazio volta ao padrão (`null`).
class SettingsTextField extends StatefulWidget {
  const SettingsTextField({
    super.key,
    required this.value,
    required this.placeholder,
    required this.onChanged,
  });
  final String? value;
  final String placeholder;
  final ValueChanged<String?> onChanged;

  @override
  State<SettingsTextField> createState() => _SettingsTextFieldState();
}

class _SettingsTextFieldState extends State<SettingsTextField> {
  late final _text = TextEditingController(text: widget.value ?? '');
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(() {
      if (!_focus.hasFocus) _commit();
    });
  }

  @override
  void didUpdateWidget(SettingsTextField old) {
    super.didUpdateWidget(old);
    // Mudou por fora: reflete, a menos que esteja digitando.
    if (old.value != widget.value && !_focus.hasFocus) {
      _text.text = widget.value ?? '';
    }
  }

  @override
  void dispose() {
    _focus.dispose();
    _text.dispose();
    super.dispose();
  }

  void _commit() {
    final v = _text.text.trim();
    if (v != (widget.value ?? '')) widget.onChanged(v.isEmpty ? null : v);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SizedBox(
      width: 224,
      child: TextField(
        controller: _text,
        focusNode: _focus,
        onSubmitted: (_) => _commit(),
        style: context.typo.body.copyWith(fontSize: 13.5, color: colors.text),
        placeholder: Text(
          widget.placeholder,
          style: context.typo.body.copyWith(
            fontSize: 13.5,
            color: colors.text3,
          ),
        ),
        borderRadius: BorderRadius.circular(7),
      ),
    );
  }
}
