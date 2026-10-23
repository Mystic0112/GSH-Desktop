import 'package:cockpit/app/core/domain/contracts/claude_code_settings.dart';
import 'package:cockpit/app/core/domain/result.dart';
import 'package:cockpit/app/core/ui/themes/themes.dart';
import 'package:cockpit/i18n/strings.g.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

/// Chave de "Conectar novas sessões ao Remote Control": lê e grava o
/// `remoteControlAtStartup` do `~/.claude/settings.json` (fonte da verdade é
/// o arquivo do Claude Code, não as preferências do GSH).
class RemoteControlSwitch extends StatefulWidget {
  const RemoteControlSwitch({super.key});

  @override
  State<RemoteControlSwitch> createState() => _RemoteControlSwitchState();
}

class _RemoteControlSwitchState extends State<RemoteControlSwitch> {
  final _settings = inject<ClaudeCodeSettings>();
  bool? _on;

  @override
  void initState() {
    super.initState();
    _settings.remoteControlAtStartup().then((on) {
      if (mounted) setState(() => _on = on);
    });
  }

  Future<void> _set(bool on) async {
    setState(() => _on = on);
    final result = await _settings.setRemoteControlAtStartup(on);
    if (!mounted) return;
    if (result case Failure(:final error)) {
      setState(() => _on = !on);
      final tr = context.t.settings.page.general;
      showToast(
        context: context,
        location: ToastLocation.bottomRight,
        builder: (context, overlay) => SurfaceCard(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              tr.remoteControlFailed(detail: error),
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
