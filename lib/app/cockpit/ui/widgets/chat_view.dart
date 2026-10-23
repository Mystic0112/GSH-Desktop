import 'package:cockpit/app/cockpit/ui/session/chat_session.dart';
import 'package:cockpit/app/cockpit/ui/viewmodels/chat_viewmodel.dart';
import 'package:cockpit/app/cockpit/ui/viewmodels/cockpit_viewmodel.dart';
import 'package:cockpit/app/cockpit/ui/widgets/agent_markdown.dart';
import 'package:cockpit/app/cockpit/ui/widgets/chat_prompt_cards.dart';
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
            planMode: _chat.planMode,
            onTogglePlan: _chat.togglePlanMode,
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
        return ChatPermissionCard(ask: ask, chat: chat);
      case final ChatQuestionItem q:
        return ChatQuestionCard(item: q, chat: chat);
      case final ChatPlanItem plan:
        return ChatPlanCard(item: plan, chat: chat);
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
          if (ChatEditDiff.of(tool.name, tool.input) case final diff?)
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

class _Composer extends StatelessWidget {
  const _Composer({
    required this.controller,
    required this.busy,
    required this.planMode,
    required this.onTogglePlan,
    required this.onSend,
    required this.onStop,
  });
  final TextEditingController controller;
  final bool busy;
  final bool planMode;
  final VoidCallback onTogglePlan;
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
          // Modo plano: o agente investiga e apresenta um plano antes de
          // mexer em qualquer coisa.
          if (planMode)
            PrimaryButton(onPressed: onTogglePlan, child: Text(tr.planMode))
          else
            GhostButton(onPressed: onTogglePlan, child: Text(tr.planMode)),
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
