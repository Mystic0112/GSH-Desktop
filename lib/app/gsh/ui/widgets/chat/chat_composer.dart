import 'package:gsh_desktop/app/gsh/ui/viewmodels/chat_viewmodel.dart';
import 'package:gsh_desktop/app/gsh/ui/viewmodels/farm_viewmodel.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/chat_attachments.dart';
import 'package:gsh_desktop/app/core/ui/themes/themes.dart';
import 'package:gsh_desktop/app/core/ui/widgets/app_menu.dart';
import 'package:gsh_desktop/app/core/ui/widgets/app_tooltip.dart';
import 'package:gsh_desktop/app/core/ui/widgets/hover_tap.dart';
import 'package:gsh_desktop/app/core/utils/path_utils.dart';
import 'package:gsh_desktop/i18n/strings.g.dart';
import 'package:flutter/services.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

/// Os modos de permissão do Claude Code que o seletor oferece.
const chatPermissionModes = [
  'default',
  'acceptEdits',
  'plan',
  'bypassPermissions',
];

/// Nome curto do modelo: `claude-opus-4-5-20251101` → `Opus 4.5`. Id que não
/// segue o padrão volta como veio.
String shortModelName(String? id) {
  if (id == null || id.isEmpty) return 'Claude';
  final m = RegExp(
    r'(opus|sonnet|haiku)-(\d{1,2})(?:-(\d{1,2}))?(?!\d)',
  ).firstMatch(id);
  if (m == null) return id;
  final family = '${m[1]![0].toUpperCase()}${m[1]!.substring(1)}';
  return m[3] == null ? '$family ${m[2]}' : '$family ${m[2]}.${m[3]}';
}

/// Composer: faixa de contexto (pasta + branch), caixa de texto com o enviar
/// dentro, e a linha de baixo (anexar, modo de permissão, modelo).
class ChatComposer extends StatelessWidget {
  const ChatComposer({
    super.key,
    required this.controller,
    required this.chat,
    required this.onSend,
    this.branch,
  });
  final TextEditingController controller;
  final ChatController chat;
  final VoidCallback onSend;
  final String? branch;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tr = context.t.gsh.chat;
    final mono = context.typo.mono.copyWith(
      fontSize: 12.5,
      color: colors.text3,
    );
    void paste() => pasteIntoChat(chat, controller);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          decoration: BoxDecoration(
            color: colors.panel2,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Text(basenameOf(chat.cwd), style: mono),
              if (branch case final b?) ...[
                const SizedBox(width: 10),
                Flexible(
                  child: Text(b, overflow: TextOverflow.ellipsis, style: mono),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.fromLTRB(4, 4, 6, 4),
          decoration: BoxDecoration(
            color: colors.panel2,
            border: Border.all(color: colors.border2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (chat.attachments.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 6, 8, 2),
                  child: ChatPendingAttachments(
                    attachments: chat.attachments,
                    onRemove: chat.removeAttachment,
                  ),
                ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    // Enter envia; Shift+Enter quebra linha (o atalho mais
                    // perto do campo vence o padrão do editor). Ctrl/Cmd+V
                    // cola imagem como anexo.
                    child: CallbackShortcuts(
                      bindings: {
                        const SingleActivator(LogicalKeyboardKey.enter): onSend,
                        const SingleActivator(
                          LogicalKeyboardKey.keyV,
                          control: true,
                        ): paste,
                        const SingleActivator(
                          LogicalKeyboardKey.keyV,
                          meta: true,
                        ): paste,
                      },
                      child: TextField(
                        controller: controller,
                        minLines: 1,
                        maxLines: 8,
                        decoration: const BoxDecoration(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        placeholder: Text(
                          tr.placeholder,
                          style: context.typo.body.copyWith(
                            color: colors.text4,
                          ),
                        ),
                        style: context.typo.body.copyWith(color: colors.text),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  _IconAction(
                    tooltip: chat.busy ? tr.stop : tr.send,
                    icon: chat.busy
                        ? Icons.stop_rounded
                        : Icons.keyboard_return,
                    onTap: chat.busy ? chat.interrupt : onSend,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        _BottomBar(chat: chat, input: controller),
      ],
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.chat, required this.input});
  final TextEditingController input;
  final ChatController chat;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tr = context.t.gsh.chat;
    final label = context.typo.label.copyWith(
      fontSize: 13,
      color: colors.text2,
    );
    String modeLabel(String mode) => switch (mode) {
      'acceptEdits' => tr.modeAcceptEdits,
      'plan' => tr.modePlan,
      'bypassPermissions' => tr.modeBypass,
      _ => tr.modeDefault,
    };
    Future<void> pickMode(BuildContext anchor) async {
      final mode = await showAppMenu<String>(
        anchor,
        items: [
          for (final m in chatPermissionModes)
            AppMenuItem(
              value: m,
              label: modeLabel(m),
              selected: m == chat.permissionMode,
            ),
        ],
      );
      if (mode != null) chat.setPermissionMode(mode);
    }

    final model = Text(shortModelName(chat.model), style: label);
    return Row(
      children: [
        _IconAction(
          tooltip: tr.attach,
          icon: Icons.add,
          onTap: () => pickChatAttachments(chat),
        ),
        const SizedBox(width: 2),
        Builder(
          builder: (anchor) => _IconAction(
            tooltip: tr.sessions,
            icon: Icons.forum_outlined,
            onTap: () => pickPeerSession(anchor, chat, input),
          ),
        ),
        const SizedBox(width: 2),
        Builder(
          builder: (anchor) => HoverTap(
            onTap: () => pickMode(anchor),
            borderRadius: BorderRadius.circular(6),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  modeLabel(chat.permissionMode),
                  style: label.copyWith(
                    color: chat.permissionMode == 'bypassPermissions'
                        ? colors.warn
                        : colors.text2,
                  ),
                ),
                const SizedBox(width: 2),
                Icon(Icons.expand_more, size: 15, color: colors.text3),
              ],
            ),
          ),
        ),
        const Spacer(),
        if (chat.costUsd > 0)
          AppTooltip(
            message: tr.cost(v: chat.costUsd.toStringAsFixed(2)),
            child: model,
          )
        else
          model,
        if (chat.busy) ...[
          const SizedBox(width: 10),
          AppTooltip(
            message: chat.waitingPermission ? tr.waitingYou : tr.working,
            child: CircularProgressIndicator(
              size: 13,
              color: chat.waitingPermission ? colors.warn : colors.accent,
            ),
          ),
        ],
        const SizedBox(width: 6),
      ],
    );
  }
}

class _IconAction extends StatelessWidget {
  const _IconAction({
    required this.tooltip,
    required this.icon,
    required this.onTap,
  });
  final String tooltip;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => AppTooltip(
    message: tooltip,
    child: HoverTap(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      padding: const EdgeInsets.all(5),
      child: Icon(icon, size: 17, color: context.colors.text2),
    ),
  );
}

/// Seletor de sessões: lista os loops principais do Claude Code rodando
/// nesta máquina (menos esta conversa) e, ao escolher um, põe no campo o
/// pedido para o agente mandar a mensagem via SendMessage.
Future<void> pickPeerSession(
  BuildContext context,
  ChatController chat,
  TextEditingController input,
) async {
  final tr = context.t.gsh.chat;
  final loops = await context.read<FarmViewModel>().scanOnce();
  if (!context.mounted) return;
  final peers = loops
      .where((l) => !l.isSubagent && l.id != chat.sessionId)
      .toList();
  if (peers.isEmpty) {
    await showAppMenu<void>(
      context,
      items: [AppMenuItem(value: null, label: tr.noSessions)],
    );
    return;
  }
  final picked = await showAppMenu<String>(
    context,
    minWidth: 280,
    items: [for (final p in peers) AppMenuItem(value: p.title, label: p.title)],
  );
  if (picked == null) return;
  final prefix = tr.sendToSession(name: picked);
  input.value = TextEditingValue(
    text: '$prefix${input.text}',
    selection: TextSelection.collapsed(
      offset: prefix.length + input.text.length,
    ),
  );
}
