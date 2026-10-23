import 'package:cockpit/app/cockpit/ui/session/chat_session.dart';
import 'package:cockpit/app/cockpit/ui/viewmodels/chat_viewmodel.dart';
import 'package:cockpit/app/cockpit/ui/viewmodels/cockpit_viewmodel.dart';
import 'package:cockpit/app/cockpit/ui/widgets/agent_markdown.dart';
import 'package:cockpit/app/core/ui/themes/themes.dart';
import 'package:cockpit/i18n/strings.g.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

/// Chat com o Claude Code (protótipo): conversa, ferramentas, aprovação de
/// permissão com um clique e composer. O motor é o `claude` da máquina.
class ChatView extends StatefulWidget {
  const ChatView({super.key, required this.session});
  final ChatSession session;

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  late final ChatController _chat = context.read<ChatViewModel>().chatFor(
    widget.session.id,
    cwd: widget.session.workingDirectory,
    resumeSessionId: widget.session.sessionId,
  );
  late final CockpitViewModel _shell = context.read<CockpitViewModel>();
  final _input = TextEditingController();
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _chat.addListener(_changed);
    final chats = context.read<ChatViewModel>();
    widget.session.onDisposed ??= () => chats.close(widget.session.id);
  }

  @override
  void dispose() {
    _chat.removeListener(_changed);
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _changed() {
    if (!mounted) return;
    final sid = _chat.sessionId;
    if (sid != null) _shell.rememberChatSession(widget.session.id, sid);
    setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.jumpTo(_scroll.position.maxScrollExtent);
      }
    });
  }

  void _send() {
    final text = _input.text;
    if (text.trim().isEmpty || _chat.busy) return;
    _input.clear();
    _chat.send(text);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ColoredBox(
      color: colors.panel,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Header(chat: _chat),
          Expanded(
            child: _chat.items.isEmpty
                ? _Empty(cwd: _chat.cwd, loading: _chat.loadingHistory)
                : ListView.separated(
                    controller: _scroll,
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                    itemCount: _chat.items.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, i) =>
                        _ItemView(item: _chat.items[i], chat: _chat),
                  ),
          ),
          _Composer(
            controller: _input,
            busy: _chat.busy,
            onSend: _send,
            onStop: _chat.interrupt,
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.chat});
  final ChatController chat;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tr = context.t.cockpit.chat;
    final sid = chat.sessionId;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.border)),
      ),
      child: Row(
        children: [
          Text(
            chat.model ?? 'claude',
            style: context.typo.title.copyWith(color: colors.text),
          ),
          if (sid != null) ...[
            const SizedBox(width: 10),
            Text(
              sid.length > 8 ? sid.substring(0, 8) : sid,
              style: context.typo.mono.copyWith(
                fontSize: 11,
                color: colors.text3,
              ),
            ),
          ],
          const Spacer(),
          if (chat.busy)
            Text(
              chat.waitingPermission ? tr.waitingYou : tr.working,
              style: context.typo.label.copyWith(
                color: chat.waitingPermission ? colors.warn : colors.online,
              ),
            ),
          if (chat.costUsd > 0) ...[
            const SizedBox(width: 12),
            Text(
              tr.cost(v: chat.costUsd.toStringAsFixed(2)),
              style: context.typo.mono.copyWith(
                fontSize: 11,
                color: colors.text3,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty({required this.cwd, required this.loading});
  final String cwd;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tr = context.t.cockpit.chat;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              tr.emptyTitle,
              style: context.typo.title.copyWith(color: colors.text),
            ),
            const SizedBox(height: 8),
            Text(
              loading ? tr.loadingHistory : tr.emptyHint(cwd: cwd),
              textAlign: TextAlign.center,
              style: context.typo.label.copyWith(color: colors.text3),
            ),
          ],
        ),
      ),
    );
  }
}

class _ItemView extends StatelessWidget {
  const _ItemView({required this.item, required this.chat});
  final ChatItem item;
  final ChatController chat;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tr = context.t.cockpit.chat;
    switch (item) {
      case ChatUserItem(:final text):
        return Align(
          alignment: Alignment.centerRight,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: colors.panel3,
                borderRadius: BorderRadius.circular(10),
              ),
              child: SelectableText(
                text,
                style: context.typo.body.copyWith(color: colors.text),
              ),
            ),
          ),
        );
      case ChatAssistantItem(:final text, :final streaming):
        return AgentMarkdown(streaming ? '$text ▍' : text);
      case final ChatToolItem tool:
        return _ToolRow(tool: tool);
      case final ChatPermissionItem ask:
        return _PermissionCard(ask: ask, chat: chat);
      case ChatNoticeItem(:final kind, :final detail, :final exitCode):
        final text = switch (kind) {
          ChatNoticeKind.startFailed => tr.startFailed(detail: detail),
          ChatNoticeKind.engineExited => tr.engineExited(code: exitCode ?? -1),
          ChatNoticeKind.turnFailed => tr.turnFailed(detail: detail),
        };
        return SelectableText(
          kind == ChatNoticeKind.engineExited && detail.isNotEmpty
              ? '$text\n$detail'
              : text,
          style: context.typo.label.copyWith(color: colors.error),
        );
    }
  }
}

class _ToolRow extends StatelessWidget {
  const _ToolRow({required this.tool});
  final ChatToolItem tool;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final icon = !tool.done
        ? Icons.more_horiz
        : tool.isError
        ? Icons.close
        : Icons.check;
    final iconColor = !tool.done
        ? colors.online
        : tool.isError
        ? colors.error
        : colors.text3;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colors.panel2,
        border: Border.all(color: colors.border),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: iconColor),
              const SizedBox(width: 8),
              Text(
                tool.name,
                style: context.typo.mono.copyWith(
                  fontSize: 12,
                  color: colors.text,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  tool.summary,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.typo.mono.copyWith(
                    fontSize: 12,
                    color: colors.text2,
                  ),
                ),
              ),
            ],
          ),
          if (_EditDiff.of(tool.name, tool.input) case final diff?)
            Padding(
              padding: const EdgeInsets.only(left: 22, top: 6),
              child: diff,
            )
          else if (tool.done && tool.result.trim().isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 22, top: 4),
              child: Text(
                tool.result.trim(),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: context.typo.mono.copyWith(
                  fontSize: 11,
                  color: tool.isError ? colors.error : colors.text3,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _PermissionCard extends StatelessWidget {
  const _PermissionCard({required this.ask, required this.chat});
  final ChatPermissionItem ask;
  final ChatController chat;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tr = context.t.cockpit.chat;
    final decided = ask.allowed;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.panel2,
        border: Border.all(
          color: decided == null ? colors.warn : colors.border,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr.askPermission(tool: ask.toolName),
            style: context.typo.title.copyWith(color: colors.text),
          ),
          const SizedBox(height: 6),
          SelectableText(
            ask.summary,
            style: context.typo.mono.copyWith(
              fontSize: 12,
              color: colors.text2,
            ),
          ),
          if (_EditDiff.of(ask.toolName, ask.input) case final diff?) ...[
            const SizedBox(height: 8),
            diff,
          ],
          const SizedBox(height: 10),
          if (decided == null)
            Row(
              children: [
                PrimaryButton(
                  onPressed: () => chat.answer(ask, allow: true),
                  child: Text(tr.allow),
                ),
                const SizedBox(width: 8),
                if (ask.alwaysRule case final rule?) ...[
                  const SizedBox(width: 8),
                  OutlineButton(
                    onPressed: () =>
                        chat.answer(ask, allow: true, always: true),
                    child: Text(tr.allowAlways(rule: rule)),
                  ),
                ],
                const SizedBox(width: 8),
                OutlineButton(
                  onPressed: () => chat.answer(ask, allow: false),
                  child: Text(tr.deny),
                ),
              ],
            )
          else
            Text(
              !decided
                  ? tr.denied
                  : ask.always
                  ? tr.allowedAlways(rule: ask.alwaysRule ?? '')
                  : tr.allowed,
              style: context.typo.label.copyWith(
                color: decided ? colors.online : colors.error,
              ),
            ),
        ],
      ),
    );
  }
}

/// O que um Edit/MultiEdit/Write muda, em linhas `-`/`+`. `null` para
/// ferramentas que não editam arquivo.
class _EditDiff extends StatelessWidget {
  const _EditDiff(this.hunks);

  /// Pares (antes, depois); `antes` vazio = arquivo novo/sobrescrito.
  final List<(String, String)> hunks;

  static const _maxLines = 40;

  static Widget? of(String tool, Map<String, dynamic> input) {
    String str(Object? v) => v is String ? v : '';
    final hunks = switch (tool) {
      'Edit' => [(str(input['old_string']), str(input['new_string']))],
      'MultiEdit' => [
        for (final e in (input['edits'] as List? ?? const []).whereType<Map>())
          (str(e['old_string']), str(e['new_string'])),
      ],
      'Write' => [('', str(input['content']))],
      _ => const <(String, String)>[],
    };
    return hunks.isEmpty ? null : _EditDiff(hunks);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final style = context.typo.mono.copyWith(fontSize: 11.5, height: 1.4);
    final lines = <(String, Color?, Color)>[];
    for (final (before, after) in hunks) {
      if (lines.isNotEmpty) lines.add(('⋯', null, colors.text4));
      for (final l in before.isEmpty ? const <String>[] : before.split('\n')) {
        lines.add(('- $l', colors.error.withValues(alpha: 0.12), colors.text2));
      }
      for (final l in after.split('\n')) {
        lines.add(('+ $l', colors.online.withValues(alpha: 0.12), colors.text));
      }
    }
    final shown = lines.take(_maxLines).toList();
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.panel,
        border: Border.all(color: colors.border),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (text, bg, fg) in shown)
            Container(
              color: bg,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(text, style: style.copyWith(color: fg)),
            ),
          if (lines.length > shown.length)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              child: Text(
                context.t.cockpit.chat.moreLines(
                  n: lines.length - shown.length,
                ),
                style: style.copyWith(color: colors.text3),
              ),
            ),
        ],
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  const _Composer({
    required this.controller,
    required this.busy,
    required this.onSend,
    required this.onStop,
  });
  final TextEditingController controller;
  final bool busy;
  final VoidCallback onSend;
  final VoidCallback onStop;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tr = context.t.cockpit.chat;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            // Enter envia; Shift+Enter quebra linha (o atalho mais perto do
            // campo vence o padrão do editor).
            child: CallbackShortcuts(
              bindings: {
                const SingleActivator(LogicalKeyboardKey.enter): onSend,
              },
              child: TextField(
                controller: controller,
                minLines: 1,
                maxLines: 8,
                placeholder: Text(
                  tr.placeholder,
                  style: context.typo.body.copyWith(color: colors.text4),
                ),
                style: context.typo.body.copyWith(color: colors.text),
              ),
            ),
          ),
          const SizedBox(width: 8),
          if (busy)
            OutlineButton(onPressed: onStop, child: Text(tr.stop))
          else
            PrimaryButton(onPressed: onSend, child: Text(tr.send)),
        ],
      ),
    );
  }
}
