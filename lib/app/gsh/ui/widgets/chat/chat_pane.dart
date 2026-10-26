import 'dart:math' as math;

import 'package:gsh_desktop/app/gsh/ui/widgets/chat/chat_slash_menu.dart';
import 'package:gsh_desktop/app/core/ui/widgets/app_tooltip.dart';
import 'package:gsh_desktop/app/gsh/ui/viewmodels/chat_viewmodel.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/chat/chat_composer.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/chat/chat_items.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/chat_attachments.dart';
import 'package:gsh_desktop/app/core/ui/themes/themes.dart';
import 'package:gsh_desktop/app/core/utils/path_utils.dart';
import 'package:gsh_desktop/i18n/strings.g.dart';
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
    this.onResume,
    this.showSessionState = false,
    this.columnWidth = 760,
    this.fontFamily,
  });
  final ChatController chat;
  final String? branch;

  /// Selo com o estado que o Claude Code classificou no fim do turno.
  final bool showSessionState;

  /// "Continuar no Remote Control"; `null` = sem o botão.
  final VoidCallback? onRemoteControl;

  /// "Retomar conversa" (recebe o widget âncora do menu); `null` = sem o
  /// botão.
  final ValueChanged<BuildContext>? onResume;

  /// Largura da coluna da conversa (preferência "Largura da transcrição").
  final double columnWidth;

  /// Fonte do texto do chat; `null` = a da interface.
  final String? fontFamily;

  @override
  State<ChatPane> createState() => _ChatPaneState();
}

class _ChatPaneState extends State<ChatPane> {
  final _input = TextEditingController();
  final _scroll = ScrollController();

  /// Menu do `/` (comandos da sessão: seus agentes, skills...).
  late final _slash = ChatSlashState(_input, () => widget.chat.commands);

  ChatController get _chat => widget.chat;

  @override
  void initState() {
    super.initState();
    _chat.addListener(_changed);
    // A lista de comandos chega depois (consulta da conta / initialize).
    _chat.addListener(_slash.refresh);
  }

  @override
  void didUpdateWidget(ChatPane old) {
    super.didUpdateWidget(old);
    if (old.chat != _chat) {
      old.chat
        ..removeListener(_changed)
        ..removeListener(_slash.refresh);
      _chat
        ..addListener(_changed)
        ..addListener(_slash.refresh);
    }
  }

  @override
  void dispose() {
    _chat
      ..removeListener(_changed)
      ..removeListener(_slash.refresh);
    _slash.dispose();
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
    final pane = ChatDropZone(
      chat: _chat,
      child: ColoredBox(
        color: colors.panel,
        child: LayoutBuilder(
          builder: (context, box) {
            // Coluna central: margem lateral que sobra, nunca menos de 24.
            final side = math.max(
              24.0,
              (box.maxWidth - widget.columnWidth) / 2,
            );
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Header(
                  chat: _chat,
                  onRemoteControl: widget.onRemoteControl,
                  onResume: widget.onResume,
                  showSessionState: widget.showSessionState,
                ),
                Expanded(
                  child: rows.isEmpty
                      ? _Empty(chat: _chat, onResume: widget.onResume)
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
                    slash: _slash,
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
    final font = widget.fontFamily;
    if (font == null) return pane;
    // Fonte do chat: troca só o corpo do texto, o resto do tema segue igual.
    final theme = GshTheme.of(context);
    return GshTheme(
      colors: theme.colors,
      typo: theme.typo.copyWith(
        body: theme.typo.body.copyWith(fontFamily: font),
      ),
      syntax: theme.syntax,
      terminal: theme.terminal,
      child: pane,
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
  const _Header({
    required this.chat,
    this.onRemoteControl,
    this.onResume,
    this.showSessionState = false,
  });
  final ChatController chat;
  final VoidCallback? onRemoteControl;
  final ValueChanged<BuildContext>? onResume;
  final bool showSessionState;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final first = chat.items.whereType<ChatUserItem>().firstOrNull?.text;
    final title = first == null || first.trim().isEmpty
        ? context.t.gsh.chat.newChat
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
          // Título + pasta ocupam o resto; o que vem depois fica à direita.
          Expanded(
            child: Row(
              children: [
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: colors.panel3,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    basenameOf(chat.cwd),
                    style: context.typo.label.copyWith(color: colors.text2),
                  ),
                ),
              ],
            ),
          ),
          if (chat.sessionState case final state? when showSessionState) ...[
            ChatSessionStateBadge(
              state: state,
              detail: chat.sessionStateDetail,
            ),
            const SizedBox(width: 8),
          ],
          if (onResume case final resume?) ...[
            AppTooltip(
              message: context.t.gsh.chat.resumeHint,
              child: Builder(
                builder: (anchor) => GhostButton(
                  size: ButtonSize.small,
                  onPressed: () => resume(anchor),
                  leading: Icon(Icons.history, size: 14, color: colors.text2),
                  child: Text(context.t.gsh.chat.resume),
                ),
              ),
            ),
            const SizedBox(width: 4),
          ],
          if (onRemoteControl case final open?)
            AppTooltip(
              message: context.t.gsh.chat.remoteControlHint,
              child: GhostButton(
                size: ButtonSize.small,
                onPressed: open,
                leading: Icon(
                  Icons.phone_iphone,
                  size: 14,
                  color: colors.text2,
                ),
                child: Text(context.t.gsh.chat.remoteControl),
              ),
            ),
        ],
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty({required this.chat, this.onResume});
  final ChatController chat;
  final ValueChanged<BuildContext>? onResume;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tr = context.t.gsh.chat;
    if (chat.loadingHistory) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(size: 18, color: colors.text3),
            const SizedBox(height: 14),
            Text(
              tr.loadingHistory,
              style: context.typo.body.copyWith(
                fontSize: 13.5,
                color: colors.text3,
              ),
            ),
          ],
        ),
      );
    }
    // Três dicas curtas do que dá para fazer, no lugar de um texto corrido.
    final hints = <(IconData, String)>[
      (Icons.keyboard_return, tr.emptyHintSend),
      (Icons.image_outlined, tr.emptyHintPaste),
      (Icons.tune, tr.emptyHintMode),
    ];
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Icon(
                  Icons.chat_bubble_outline,
                  size: 28,
                  color: colors.text4,
                ),
              ),
              const SizedBox(height: 14),
              Center(
                child: Text(
                  tr.emptyTitle,
                  style: context.typo.display.copyWith(
                    fontSize: 18,
                    color: colors.text,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Center(
                child: Text(
                  tr.emptySubtitle(folder: basenameOf(chat.cwd)),
                  textAlign: TextAlign.center,
                  style: context.typo.body.copyWith(
                    fontSize: 13,
                    color: colors.text3,
                  ),
                ),
              ),
              const SizedBox(height: 22),
              for (final (icon, text) in hints)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Icon(icon, size: 15, color: colors.text3),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          text,
                          style: context.typo.body.copyWith(
                            fontSize: 13,
                            color: colors.text2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (onResume case final resume?) ...[
                const SizedBox(height: 8),
                Center(
                  child: Builder(
                    builder: (anchor) => OutlineButton(
                      size: ButtonSize.small,
                      onPressed: () => resume(anchor),
                      leading: const Icon(Icons.history, size: 14),
                      child: Text(tr.resumeEmpty),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
