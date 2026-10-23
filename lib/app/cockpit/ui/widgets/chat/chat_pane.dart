import 'dart:math' as math;

import 'package:cockpit/app/core/ui/widgets/app_tooltip.dart';
import 'package:cockpit/app/cockpit/ui/viewmodels/chat_viewmodel.dart';
import 'package:cockpit/app/cockpit/ui/widgets/chat/chat_composer.dart';
import 'package:cockpit/app/cockpit/ui/widgets/chat/chat_items.dart';
import 'package:cockpit/app/cockpit/ui/widgets/chat_attachments.dart';
import 'package:cockpit/app/core/ui/themes/themes.dart';
import 'package:cockpit/app/core/utils/path_utils.dart';
import 'package:cockpit/i18n/strings.g.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

/// A conversa em si, sem o shell: cabeçalho, coluna central e composer. Só
/// precisa do [ChatController] (e da [branch] para a faixa de contexto), então
/// dá para montar em teste sem o resto do app.
class ChatPane extends StatefulWidget {
  const ChatPane({
    super.key,
    required this.chat,
    this.branch,
    this.onRemoteControl,
  });
  final ChatController chat;
  final String? branch;

  /// "Continuar no Remote Control"; `null` = sem o botão.
  final VoidCallback? onRemoteControl;

  /// Largura da coluna da conversa.
  static const columnWidth = 760.0;

  @override
  State<ChatPane> createState() => _ChatPaneState();
}

class _ChatPaneState extends State<ChatPane> {
  final _input = TextEditingController();
  final _scroll = ScrollController();

  ChatController get _chat => widget.chat;

  @override
  void initState() {
    super.initState();
    _chat.addListener(_changed);
  }

  @override
  void didUpdateWidget(ChatPane old) {
    super.didUpdateWidget(old);
    if (old.chat != _chat) {
      old.chat.removeListener(_changed);
      _chat.addListener(_changed);
    }
  }

  @override
  void dispose() {
    _chat.removeListener(_changed);
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  /// Segue o fim da conversa só se já estava lá: quem rolou para cima para
  /// ler um detalhe não é puxado de volta a cada pedaço do stream.
  void _changed() {
    if (!mounted) return;
    final atEnd =
        !_scroll.hasClients ||
        _scroll.position.pixels >= _scroll.position.maxScrollExtent - 80;
    setState(() {});
    if (!atEnd) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.jumpTo(_scroll.position.maxScrollExtent);
      }
    });
  }

  void _send() {
    final text = _input.text;
    if ((text.trim().isEmpty && _chat.attachments.isEmpty) || _chat.busy) {
      return;
    }
    _input.clear();
    _chat.send(text);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final rows = groupChatItems(_chat.items);
    return ChatDropZone(
      chat: _chat,
      child: ColoredBox(
        color: colors.panel,
        child: LayoutBuilder(
          builder: (context, box) {
            // Coluna central: margem lateral que sobra, nunca menos de 24.
            final side = math.max(
              24.0,
              (box.maxWidth - ChatPane.columnWidth) / 2,
            );
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Header(chat: _chat, onRemoteControl: widget.onRemoteControl),
                Expanded(
                  child: rows.isEmpty
                      ? _Empty(chat: _chat)
                      : ListView.separated(
                          controller: _scroll,
                          padding: EdgeInsets.fromLTRB(side, 24, side, 32),
                          itemCount: rows.length,
                          separatorBuilder: (_, i) =>
                              SizedBox(height: _gapAfter(rows[i], rows[i + 1])),
                          itemBuilder: (context, i) => ChatRowView(
                            key: ObjectKey(
                              rows[i] is List
                                  ? (rows[i] as List).first
                                  : rows[i],
                            ),
                            row: rows[i],
                            chat: _chat,
                          ),
                        ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(side, 0, side, 10),
                  child: ChatComposer(
                    controller: _input,
                    chat: _chat,
                    branch: widget.branch,
                    onSend: _send,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Ritmo vertical: troca de quem fala ganha mais ar; linhas de ferramenta
  /// seguidas ficam juntas.
  static double _gapAfter(Object a, Object b) {
    if (a is ChatUserItem || b is ChatUserItem) return 28;
    if (a is ChatToolItem && b is ChatToolItem) return 4;
    return 14;
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.chat, this.onRemoteControl});
  final ChatController chat;
  final VoidCallback? onRemoteControl;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final first = chat.items.whereType<ChatUserItem>().firstOrNull?.text;
    final title = first == null || first.trim().isEmpty
        ? context.t.cockpit.chat.newChat
        : first.trim().split('\n').first;
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.border)),
      ),
      child: Row(
        children: [
          Icon(Icons.laptop, size: 15, color: colors.text2),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.typo.body.copyWith(
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
                color: colors.text,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: colors.panel3,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              basenameOf(chat.cwd),
              style: context.typo.label.copyWith(color: colors.text2),
            ),
          ),
          const Spacer(),
          if (onRemoteControl case final open?)
            AppTooltip(
              message: context.t.cockpit.chat.remoteControlHint,
              child: GhostButton(
                size: ButtonSize.small,
                onPressed: chat.canHandOff ? open : null,
                leading: Icon(
                  Icons.phone_iphone,
                  size: 14,
                  color: colors.text2,
                ),
                child: Text(context.t.cockpit.chat.remoteControl),
              ),
            ),
        ],
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty({required this.chat});
  final ChatController chat;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tr = context.t.cockpit.chat;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (chat.loadingHistory) ...[
                CircularProgressIndicator(size: 18, color: colors.text3),
                const SizedBox(height: 14),
              ] else ...[
                Text(
                  tr.emptyTitle,
                  style: context.typo.display.copyWith(
                    fontSize: 20,
                    color: colors.text,
                  ),
                ),
                const SizedBox(height: 10),
              ],
              Text(
                chat.loadingHistory
                    ? tr.loadingHistory
                    : tr.emptyHint(cwd: chat.cwd),
                textAlign: TextAlign.center,
                style: context.typo.body.copyWith(
                  fontSize: 13.5,
                  color: colors.text3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
