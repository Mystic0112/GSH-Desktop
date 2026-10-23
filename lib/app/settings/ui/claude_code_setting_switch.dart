import 'package:cockpit/app/core/domain/contracts/claude_code_settings.dart';
import 'package:cockpit/app/core/domain/result.dart';
import 'package:cockpit/app/core/ui/themes/themes.dart';
import 'package:cockpit/i18n/strings.g.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

/// Chave booleana do `~/.claude/settings.json` (a fonte da verdade é o
/// arquivo do Claude Code, não as preferências do GSH). Chave ausente mostra
/// [unsetValue], o default do próprio CLI.
class ClaudeCodeSettingSwitch extends StatefulWidget {
  const ClaudeCodeSettingSwitch({
    super.key,
    required this.settingKey,
    required this.unsetValue,
    this.removeWhenDefault = false,
    this.onValue = true,
    this.offValue = false,
  });

  final String settingKey;
  final bool unsetValue;

  /// Voltar ao default apaga a chave em vez de gravar o valor. Para chaves
  /// em que o CLI distingue "nunca escolhido" de "escolhido", deixe `false`.
  final bool removeWhenDefault;

  /// Valor gravado com o switch ligado / desligado. Ex.: modo estrito do
  /// sandbox liga gravando `false`; flag de `env` liga gravando `'1'`.
  /// [offValue] `null` = desligar remove a chave.
  final Object onValue;
  final Object? offValue;

  @override
  State<ClaudeCodeSettingSwitch> createState() =>
      _ClaudeCodeSettingSwitchState();
}

class _ClaudeCodeSettingSwitchState extends State<ClaudeCodeSettingSwitch> {
  final _settings = inject<ClaudeCodeSettings>();
  bool? _on;

  @override
  void initState() {
    super.initState();
    _settings.getValue(widget.settingKey).then((v) {
      if (!mounted) return;
      setState(
        () => _on = v == widget.onValue
            ? true
            : v != null && v == widget.offValue
            ? false
            : widget.unsetValue,
      );
    });
  }

  Future<void> _set(bool on) async {
    setState(() => _on = on);
    final value = widget.removeWhenDefault && on == widget.unsetValue
        ? null
        : on
        ? widget.onValue
        : widget.offValue;
    final result = await _settings.setValue(widget.settingKey, value);
    if (!mounted) return;
    if (result case Failure(:final error)) {
      setState(() => _on = !on);
      showToast(
        context: context,
        location: ToastLocation.bottomRight,
        builder: (context, overlay) => SurfaceCard(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              context.t.settings.page.claudeCode.saveFailed(detail: error),
              style: context.typo.label,
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final on = _on;
    return Switch(value: on ?? false, onChanged: on == null ? null : _set);
  }
}
