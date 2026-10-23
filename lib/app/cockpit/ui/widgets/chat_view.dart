import 'package:cockpit/app/cockpit/ui/session/chat_session.dart';
import 'package:cockpit/app/cockpit/ui/viewmodels/chat_viewmodel.dart';
import 'package:cockpit/app/cockpit/ui/viewmodels/cockpit_viewmodel.dart';
import 'package:cockpit/app/cockpit/ui/widgets/chat/chat_pane.dart';
import 'package:cockpit/app/core/ui/settings_controller.dart';
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
  late final CockpitViewModel _shell = context.read<CockpitViewModel>();

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
    final branch = context.select<CockpitViewModel, String?>(
      (vm) =>
          (vm.gitInfoForRootIn(s.projectId, s.workingDirectory) ??
                  vm.gitInfo(s.projectId))
              ?.branch,
    );
    final showState = context.select<SettingsController, bool>(
      (c) => c.settings.classifySessionStates,
    );
    return ChatPane(
      chat: _chat,
      branch: branch,
      showSessionState: showState,
      onRemoteControl: _continueInRemoteControl,
    );
  }

  /// Leva a conversa para um terminal com Remote Control: fecha o motor do
  /// chat e abre `claude --resume <sessão> --remote-control` na mesma pasta.
  Future<void> _continueInRemoteControl() async {
    final sid = await _chat.handOff();
    if (sid == null || !mounted) return;
    _shell.continueInRemoteControl(sid, cwd: widget.session.workingDirectory);
  }
}
