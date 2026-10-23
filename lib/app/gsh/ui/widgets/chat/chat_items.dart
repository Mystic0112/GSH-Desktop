import 'package:gsh_desktop/app/gsh/domain/entities/chat_attachment.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/chat_event.dart';
import 'package:gsh_desktop/app/core/domain/entities/app_settings.dart';
import 'package:gsh_desktop/app/core/ui/widgets/app_tooltip.dart';
import 'package:gsh_desktop/app/gsh/ui/viewmodels/chat_viewmodel.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/agent_markdown.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/chat/chat_edits_card.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/chat_attachments.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/chat_prompt_cards.dart';
import 'package:gsh_desktop/app/core/ui/themes/themes.dart';
import 'package:gsh_desktop/app/core/ui/widgets/hover_tap.dart';
import 'package:gsh_desktop/i18n/strings.g.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

const _editTools = {'Edit', 'MultiEdit', 'Write'};

/// Linhas da conversa como a tela mostra: cada item, exceto edições de
/// arquivo seguidas, que viram uma lista só (`List<ChatToolItem>`) para o
/// cartão "Editou N arquivos". Edição com erro (negada) fica de fora do grupo.
List<Object> groupChatItems(List<ChatItem> items) {
  final rows = <Object>[];
  for (final i in items) {
    if (i is ChatToolItem && _editTools.contains(i.name) && !i.isError) {
      if (rows.lastOrNull case final List<ChatToolItem> group) {
        group.add(i);
        continue;
      }
      rows.add(<ChatToolItem>[i]);
    } else {
      rows.add(i);
    }
  }
  return rows;
}

/// Uma linha da conversa (item ou grupo de edições).
class ChatRowView extends StatelessWidget {
  const ChatRowView({super.key, required this.row, required this.chat});
  final Object row;
  final ChatController chat;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tr = context.t.gsh.chat;
    return switch (row) {
      final List<ChatToolItem> edits => ChatEditsCard(edits: edits),
      ChatUserItem(:final text, :final attachments) => _UserBubble(
        text: text,
        attachments: attachments,
      ),
      ChatAssistantItem(:final text, :final streaming) => AgentMarkdown(
        streaming ? '$text ▍' : text,
      ),
      final ChatThinkingItem thinking => ChatThinkingBlock(item: thinking),
      final ChatToolItem tool => ChatToolLine(
        tool: tool,
        expanded: chat.view == TranscriptView.verbose,
      ),
      final ChatPermissionItem ask => ChatPermissionCard(ask: ask, chat: chat),
      final ChatQuestionItem q => ChatQuestionCard(item: q, chat: chat),
      final ChatPlanItem plan => ChatPlanCard(item: plan, chat: chat),
      ChatNoticeItem(kind: ChatNoticeKind.handedOff) => SelectableText(
        tr.handedOff,
        style: context.typo.label.copyWith(color: colors.text2),
      ),
      ChatNoticeItem(:final kind, :final detail, :final exitCode) =>
        SelectableText(switch (kind) {
          ChatNoticeKind.handedOff => tr.handedOff,
          ChatNoticeKind.startFailed => tr.startFailed(detail: detail),
          ChatNoticeKind.engineExited =>
            '${tr.engineExited(code: exitCode ?? -1)}'
                '${detail.isEmpty ? '' : '\n$detail'}',
          ChatNoticeKind.turnFailed => tr.turnFailed(detail: detail),
          ChatNoticeKind.attachmentTooLarge => tr.attachmentTooLarge(
            name: detail,
          ),
        }, style: context.typo.label.copyWith(color: colors.error)),
      _ => const SizedBox.shrink(),
    };
  }
}

class _UserBubble extends StatelessWidget {
  const _UserBubble({required this.text, required this.attachments});
  final String text;
  final List<ChatAttachment> attachments;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    // Imagens saem acima do balão, como prévia; o resto vira ficha dentro.
    final images = [
      for (final a in attachments)
        if (a.kind == ChatAttachmentKind.image) a,
    ];
    final files = [
      for (final a in attachments)
        if (a.kind != ChatAttachmentKind.image) a,
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (final a in images) ...[
          ChatImagePreview(a),
          const SizedBox(height: 8),
        ],
        if (text.isNotEmpty || files.isNotEmpty)
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 580),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: colors.panel3,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (text.isNotEmpty)
                    SelectableText(
                      text,
                      style: context.typo.body.copyWith(color: colors.text),
                    ),
                  if (files.isNotEmpty) ...[
                    if (text.isNotEmpty) const SizedBox(height: 6),
                    ChatAttachmentChips(attachments: files),
                  ],
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// Ferramenta recolhida numa linha discreta: a `description` que o agente deu
/// (ou o nome + resumo) e um `>`; clicar mostra o comando e o resultado.
class ChatToolLine extends StatefulWidget {
  const ChatToolLine({super.key, required this.tool, this.expanded = false});
  final ChatToolItem tool;

  /// Já abre com o comando e o resultado (visualização Detalhado).
  final bool expanded;

  @override
  State<ChatToolLine> createState() => _ChatToolLineState();
}

class _ChatToolLineState extends State<ChatToolLine> {
  late bool _open = widget.expanded;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tool = widget.tool;
    final description = tool.input['description'];
    final fg = tool.isError ? colors.error : colors.text3;
    final style = context.typo.body.copyWith(color: fg);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HoverTap(
          onTap: () => setState(() => _open = !_open),
          hoverColor: colors.panel2,
          borderRadius: BorderRadius.circular(6),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!tool.done) ...[
                CircularProgressIndicator(size: 11, color: colors.text3),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text.rich(
                  description is String && description.trim().isNotEmpty
                      ? TextSpan(text: description.trim())
                      : TextSpan(
                          children: [
                            TextSpan(
                              text: '${tool.name}  ',
                              style: TextStyle(color: colors.text2),
                            ),
                            TextSpan(text: tool.summary),
                          ],
                        ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: style,
                ),
              ),
              const SizedBox(width: 4),
              AnimatedRotation(
                turns: _open ? 0.25 : 0,
                duration: const Duration(milliseconds: 120),
                child: Icon(Icons.chevron_right, size: 16, color: fg),
              ),
            ],
          ),
        ),
        if (_open) ...[const SizedBox(height: 6), _ToolDetails(tool: tool)],
      ],
    );
  }
}

class _ToolDetails extends StatelessWidget {
  const _ToolDetails({required this.tool});
  final ChatToolItem tool;

  static const _maxResultLines = 14;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final mono = context.typo.mono.copyWith(fontSize: 12, height: 1.5);
    final result = tool.result.trim();
    final command = tool.input['command'];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: colors.panel2,
        border: Border.all(color: colors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectableText(
            command is String ? '\$ $command' : '${tool.name} ${tool.summary}',
            style: mono.copyWith(color: colors.text2),
          ),
          if (result.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              result,
              maxLines: _maxResultLines,
              overflow: TextOverflow.ellipsis,
              style: mono.copyWith(
                color: tool.isError ? colors.error : colors.text3,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Resumo de raciocínio do modelo: bloco discreto, aberto por padrão, que
/// recolhe no cabeçalho.
class ChatThinkingBlock extends StatefulWidget {
  const ChatThinkingBlock({super.key, required this.item});
  final ChatThinkingItem item;

  @override
  State<ChatThinkingBlock> createState() => _ChatThinkingBlockState();
}

class _ChatThinkingBlockState extends State<ChatThinkingBlock> {
  bool _open = true;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tr = context.t.gsh.chat;
    final item = widget.item;
    final muted = context.typo.body.copyWith(color: colors.text3);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HoverTap(
          onTap: () => setState(() => _open = !_open),
          hoverColor: colors.panel2,
          borderRadius: BorderRadius.circular(6),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lightbulb_outline, size: 14, color: colors.text3),
              const SizedBox(width: 6),
              Text(
                item.streaming ? tr.thinkingLive : tr.thinkingTitle,
                style: muted,
              ),
              const SizedBox(width: 4),
              AnimatedRotation(
                turns: _open ? 0.25 : 0,
                duration: const Duration(milliseconds: 120),
                child: Icon(Icons.chevron_right, size: 16, color: colors.text3),
              ),
            ],
          ),
        ),
        if (_open)
          Container(
            margin: const EdgeInsets.only(left: 10, top: 4),
            padding: const EdgeInsets.only(left: 12),
            decoration: BoxDecoration(
              border: Border(left: BorderSide(color: colors.border2, width: 2)),
            ),
            child: SelectableText(
              item.text.trim(),
              style: muted.copyWith(fontStyle: FontStyle.italic, height: 1.5),
            ),
          ),
      ],
    );
  }
}

/// Selo do estado classificado no fim do turno (cabeçalho do chat); o
/// `status_detail` do Claude Code vai no tooltip.
class ChatSessionStateBadge extends StatelessWidget {
  const ChatSessionStateBadge({
    super.key,
    required this.state,
    this.detail = '',
  });
  final ChatSessionState state;
  final String detail;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tr = context.t.gsh.chat;
    final (label, color) = switch (state) {
      ChatSessionState.completed => (tr.stateCompleted, colors.ok),
      ChatSessionState.reviewReady => (tr.stateReviewReady, colors.accentText),
      ChatSessionState.blocked => (tr.stateBlocked, colors.warn),
      ChatSessionState.failed => (tr.stateFailed, colors.error),
    };
    final badge = Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(label, style: context.typo.label.copyWith(color: color)),
        ],
      ),
    );
    return detail.isEmpty ? badge : AppTooltip(message: detail, child: badge);
  }
}
