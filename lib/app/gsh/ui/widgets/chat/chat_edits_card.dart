import 'package:gsh_desktop/app/gsh/ui/viewmodels/chat_viewmodel.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/chat_prompt_cards.dart';
import 'package:gsh_desktop/app/core/ui/themes/themes.dart';
import 'package:gsh_desktop/app/core/ui/widgets/app_tooltip.dart';
import 'package:gsh_desktop/app/core/ui/widgets/hover_tap.dart';
import 'package:gsh_desktop/app/core/utils/path_utils.dart';
import 'package:gsh_desktop/i18n/strings.g.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

/// O que uma sequência de edições fez em um arquivo: os trechos e a conta de
/// linhas (antes/depois; Write conta tudo como adicionado).
class ChatFileEdit {
  ChatFileEdit(this.path);
  final String path;
  final hunks = <(String, String)>[];
  int added = 0;
  int removed = 0;

  static int _lines(String s) {
    if (s.isEmpty) return 0;
    final n = '\n'.allMatches(s).length;
    return s.endsWith('\n') ? n : n + 1;
  }

  /// Agrupa por arquivo, na ordem da primeira edição.
  static List<ChatFileEdit> of(List<ChatToolItem> edits) {
    final byPath = <String, ChatFileEdit>{};
    for (final e in edits) {
      final path = e.input['file_path'] as String? ?? e.summary;
      final file = byPath.putIfAbsent(path, () => ChatFileEdit(path));
      for (final (before, after) in ChatEditDiff.hunksOf(e.name, e.input)) {
        file.hunks.add((before, after));
        file.removed += _lines(before);
        file.added += _lines(after);
      }
    }
    return byPath.values.toList();
  }
}

/// "Editou N arquivos  +A -B": edições seguidas viram um cartão só, uma linha
/// por arquivo; clicar no arquivo abre o diff dele.
class ChatEditsCard extends StatefulWidget {
  const ChatEditsCard({super.key, required this.edits});
  final List<ChatToolItem> edits;

  @override
  State<ChatEditsCard> createState() => _ChatEditsCardState();
}

class _ChatEditsCardState extends State<ChatEditsCard> {
  bool _collapsed = false;
  final _open = <String>{};

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final files = ChatFileEdit.of(widget.edits);
    final running = widget.edits.any((e) => !e.done);
    final added = files.fold(0, (s, f) => s + f.added);
    final removed = files.fold(0, (s, f) => s + f.removed);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: colors.border2),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _EditRow(
            icon: Icons.difference_outlined,
            label: context.t.gsh.chat.editedFiles(n: files.length),
            added: added,
            removed: removed,
            open: !_collapsed,
            running: running,
            onTap: () => setState(() => _collapsed = !_collapsed),
          ),
          if (!_collapsed)
            for (final f in files) ...[
              _EditRow(
                icon: Icons.code,
                label: basenameOf(f.path),
                tooltip: f.path,
                added: f.added,
                removed: f.removed,
                open: _open.contains(f.path),
                onTap: () => setState(() {
                  if (!_open.remove(f.path)) _open.add(f.path);
                }),
              ),
              if (_open.contains(f.path))
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 2, 8, 6),
                  child: ChatEditDiff(f.hunks),
                ),
            ],
        ],
      ),
    );
  }
}

class _EditRow extends StatelessWidget {
  const _EditRow({
    required this.icon,
    required this.label,
    required this.added,
    required this.removed,
    required this.open,
    required this.onTap,
    this.tooltip,
    this.running = false,
  });
  final IconData icon;
  final String label;
  final String? tooltip;
  final int added;
  final int removed;
  final bool open;
  final bool running;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final mono = context.typo.mono.copyWith(fontSize: 12.5);
    return HoverTap(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          if (running)
            CircularProgressIndicator(size: 12, color: colors.text3)
          else
            Icon(icon, size: 14, color: colors.text3),
          const SizedBox(width: 8),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: AppTooltip(
                message: tooltip ?? label,
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.typo.body.copyWith(color: colors.text),
                ),
              ),
            ),
          ),
          Text('+$added', style: mono.copyWith(color: colors.online)),
          const SizedBox(width: 2),
          Text('-$removed', style: mono.copyWith(color: colors.error)),
          const SizedBox(width: 8),
          AnimatedRotation(
            turns: open ? 0.25 : 0,
            duration: const Duration(milliseconds: 120),
            child: Icon(Icons.chevron_right, size: 16, color: colors.text3),
          ),
        ],
      ),
    );
  }
}
