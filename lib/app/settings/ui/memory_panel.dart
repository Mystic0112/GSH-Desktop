import 'package:gsh_desktop/app/core/app_intents.dart' as intents;
import 'package:gsh_desktop/app/core/ui/themes/themes.dart';
import 'package:gsh_desktop/app/core/ui/widgets/hover_tap.dart';
import 'package:gsh_desktop/app/core/utils/user_home.dart';
import 'package:gsh_desktop/app/settings/domain/claude_info.dart';
import 'package:gsh_desktop/app/settings/ui/claude_info_viewmodel.dart';
import 'package:gsh_desktop/app/settings/ui/settings_widgets.dart';
import 'package:gsh_desktop/i18n/strings.g.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

/// Aba **Memória**: o que uma sessão do Claude Code no workspace ativo
/// carrega — as instruções (CLAUDE.md do usuário e do projeto) e a memória
/// automática que o próprio Claude grava (`MEMORY.md` + um arquivo por
/// memória). Clicar abre o arquivo numa aba do GSH.
class MemoryPanel extends StatefulWidget {
  const MemoryPanel({super.key});

  @override
  State<MemoryPanel> createState() => _MemoryPanelState();
}

class _MemoryPanelState extends State<MemoryPanel> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<ClaudeInfoViewModel>().loadMemory(
        intents.activeWorkspaceRoot?.call(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ClaudeInfoViewModel>();
    final tr = context.t.settings.page.memory;
    final loading = SettingsNote(context.t.settings.page.claude.loading);
    final files = vm.memory;
    final auto = vm.autoMemory;
    final home = userHome();
    String short(String path) => home != null && path.startsWith(home)
        ? '~${path.substring(home.length)}'
        : path;
    return SettingsPanelBody(
      children: [
        SettingsSection(
          title: tr.instructionsTitle,
          description: tr.intro,
          rows: [
            if (files == null)
              loading
            else if (files.isEmpty)
              SettingsNote(tr.empty)
            else
              for (final f in files)
                _MemoryRow(
                  title: short(f.path),
                  description: f.scope == MemoryScope.user
                      ? tr.scopeUser
                      : tr.scopeProject,
                  path: f.path,
                ),
          ],
        ),
        SettingsSection(
          title: tr.autoTitle,
          rows: [
            if (auto == null)
              loading
            else if (auto.isEmpty)
              SettingsNote(tr.autoEmpty)
            else
              for (final m in auto)
                _MemoryRow(
                  title: m.title,
                  description: m.hook,
                  date: m.updatedAt,
                  path: m.path,
                ),
          ],
        ),
      ],
    );
  }
}

/// Nome · descrição · "Atualizado <data>", a linha toda clicável.
class _MemoryRow extends StatelessWidget {
  const _MemoryRow({
    required this.title,
    required this.path,
    this.description,
    this.date,
  });
  final String title;
  final String path;
  final String? description;
  final DateTime? date;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final open = intents.requestOpenFileTab;
    final style = context.typo.body.copyWith(fontSize: 13.5);
    return HoverTap(
      onTap: open == null
          ? null
          : () {
              open(path);
              context.pop();
            },
      padding: const EdgeInsets.symmetric(vertical: 11),
      child: Row(
        children: [
          SizedBox(
            width: 220,
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: style.copyWith(color: colors.text),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              description ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: style.copyWith(color: colors.text2),
            ),
          ),
          if (date case final d?)
            SizedBox(
              width: 160,
              child: Text(
                context.t.settings.page.memory.updated(
                  when: shortDate(context, d),
                ),
                style: style.copyWith(color: colors.text3),
              ),
            ),
        ],
      ),
    );
  }
}
