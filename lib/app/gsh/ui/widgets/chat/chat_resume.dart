import 'package:flutter_modular/flutter_modular.dart';
import 'package:gsh_desktop/app/core/ui/widgets/app_menu.dart';
import 'package:gsh_desktop/app/core/utils/path_utils.dart';
import 'package:gsh_desktop/app/gsh/domain/contracts/session_directory.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/confirm_dialog.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/telemetry_case_view.dart';
import 'package:gsh_desktop/i18n/strings.g.dart';
import 'package:path/path.dart' as p;
import 'package:shadcn_flutter/shadcn_flutter.dart';

/// Conversa mexida há menos que isso provavelmente está aberta em outro
/// lugar (Claude Desktop, terminal): retomar aqui pede confirmação.
const resumeLiveWindow = Duration(minutes: 2);

/// "Retomar conversa": as conversas do Claude Code desta máquina nos
/// últimos 7 dias (menos [exceptId], a desta aba), mais recente primeiro.
/// Devolve a escolhida — já confirmada se parecia estar em uso — ou `null`.
Future<SessionEntry?> pickResumeSession(
  BuildContext anchor, {
  String? exceptId,
}) async {
  final tr = anchor.t.gsh.chat;
  final all = await inject<SessionDirectory>().recent(
    within: const Duration(days: 7),
  );
  if (!anchor.mounted) return null;
  // Sem a pasta original o `--resume` não acha a sessão.
  final list = [
    for (final s in all)
      if (s.id != exceptId && p.isAbsolute(s.project)) s,
  ].take(30).toList();
  final id = await showAppMenu<String>(
    anchor,
    minWidth: 360,
    items: [
      for (final s in list)
        AppMenuItem(
          value: s.id,
          label:
              '${s.title}  ·  ${basenameOf(s.project)}  ·  '
              '${telemetryRelative(anchor, s.lastSeen)}',
        ),
      if (list.isEmpty) AppMenuItem(value: '', label: tr.resumeNone),
    ],
  );
  if (id == null || id.isEmpty || !anchor.mounted) return null;
  final picked = list.firstWhere((s) => s.id == id);
  if (DateTime.now().difference(picked.lastSeen) < resumeLiveWindow) {
    final go = await showConfirmDialog(
      anchor,
      title: tr.resumeLiveTitle,
      message: tr.resumeLiveBody(
        ago: telemetryRelative(anchor, picked.lastSeen),
      ),
      confirmLabel: tr.resumeAnyway,
    );
    if (!go) return null;
  }
  return picked;
}
