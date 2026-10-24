import 'package:gsh_desktop/app/gsh/ui/session/chat_session.dart';
import 'package:gsh_desktop/app/gsh/ui/viewmodels/chat_viewmodel.dart';
import 'package:gsh_desktop/app/gsh/ui/viewmodels/gsh_viewmodel.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/chat/chat_pane.dart';
import 'package:gsh_desktop/app/core/ui/settings_controller.dart';
import 'package:gsh_desktop/app/core/ui/themes/themes.dart';
import 'package:gsh_desktop/i18n/strings.g.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

/// Aba de chat com o Claude Code: liga a aba ao [ChatController] dela, guarda
/// o id da sessão no layout e passa a branch do workspace. A tela é o
/// [ChatPane]; o motor é o `claude` da máquina.
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
    view: context.read<SettingsController>().settings.transcriptView,
  );
  late final GshViewModel _shell = context.read<GshViewModel>();

  @override
  void initState() {
    super.initState();
    _chat.addListener(_remember);
    final chats = context.read<ChatViewModel>();
    widget.session.onDisposed ??= () => chats.close(widget.session.id);
  }

  @override
  void dispose() {
    _chat.removeListener(_remember);
    super.dispose();
  }

  void _remember() {
    final sid = _chat.sessionId;
    if (sid != null) _shell.rememberChatSession(widget.session.id, sid);
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.session;
    final branch = context.select<GshViewModel, String?>(
      (vm) =>
          (vm.gitInfoForRootIn(s.projectId, s.workingDirectory) ??
                  vm.gitInfo(s.projectId))
              ?.branch,
    );
    final showState = context.select<SettingsController, bool>(
      (c) => c.settings.classifySessionStates,
    );
    final width = context.select<SettingsController, double>(
      (c) => c.settings.transcriptWidth.px,
    );
    final font = context.select<SettingsController, String?>(
      (c) => c.settings.chatFont,
    );
    return ChatPane(
      chat: _chat,
      branch: branch,
      showSessionState: showState,
      columnWidth: width,
      fontFamily: font,
      onRemoteControl: _continueInRemoteControl,
    );
  }

  /// Leva a conversa para um terminal com Remote Control: fecha o motor do
  /// chat e abre `claude --resume <sessão> --remote-control` na mesma pasta.
  Future<void> _continueInRemoteControl() async {
    final tr = context.t.gsh.chat;
    // O botão fica sempre clicável: quando não dá, o clique explica.
    if (_chat.sessionId == null) return _toast(tr.remoteControlNoSession);
    if (_chat.busy) return _toast(tr.remoteControlBusy);
    final sid = await _chat.handOff();
    if (sid == null || !mounted) return;
    final ok = _shell.continueInRemoteControl(
      sid,
      cwd: widget.session.workingDirectory,
    );
    if (!ok) _toast(tr.remoteControlFailed);
  }

  void _toast(String message) {
    if (!mounted) return;
    showToast(
      context: context,
      location: ToastLocation.bottomRight,
      builder: (context, overlay) => SurfaceCard(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Text(message, style: context.typo.label),
        ),
      ),
    );
  }
}
