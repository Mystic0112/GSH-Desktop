import 'dart:async';

import 'package:gsh_desktop/app/gsh/ui/widgets/chat/chat_resume.dart';
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
  // Modo e esforço: os últimos escolhidos no composer (só ao criar).
  late final ChatController _chat = () {
    final s = context.read<SettingsController>().settings;
    return context.read<ChatViewModel>().chatFor(
      widget.session.id,
      cwd: widget.session.workingDirectory,
      resumeSessionId: widget.session.sessionId,
      view: s.transcriptView,
      permissionMode: s.chatPermissionMode,
      effort: s.chatEffort,
      onBusy: (b) => widget.session.working = b,
    );
  }();
  late final GshViewModel _shell = context.read<GshViewModel>();

  @override
  void initState() {
    super.initState();
    _chat.addListener(_remember);
    // Modelos da conta e uso do plano para o composer (sem gastar tokens).
    unawaited(_chat.refreshAccount());
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
      onResume: _resume,
      onImproveHarness: _improveHarness,
    );
  }

  /// "Melhorar harness" (ideia do Harness²): abre um chat novo no mesmo
  /// workspace que lê o transcript desta conversa e propõe mudanças no
  /// CLAUDE.md, skills e hooks, com a evidência. Começa pedindo permissão,
  /// então cada edição chega como diff para aprovar ou negar.
  void _improveHarness() {
    final sid = _chat.sessionId;
    if (sid == null) return;
    final prompt = context.t.gsh.chat.improveHarnessPrompt(sessionId: sid);
    final tab = _shell.openChat(projectId: widget.session.projectId);
    if (tab == null) return;
    unawaited(
      context
          .read<ChatViewModel>()
          .chatFor(
            tab.id,
            cwd: tab.workingDirectory,
            view: context.read<SettingsController>().settings.transcriptView,
            effort: context.read<SettingsController>().settings.chatEffort,
            onBusy: (b) => tab.working = b,
            // Modo de propósito o padrão (pedir permissão), mesmo que o
            // usuário use outro: cada edição do harness chega como diff.
          )
          .send(prompt),
    );
  }

  /// "Retomar conversa": abre numa aba de chat nova (ou foca, se já aberta)
  /// uma conversa recente do Claude Code desta máquina, com o histórico.
  Future<void> _resume(BuildContext anchor) async {
    final s = await pickResumeSession(anchor, exceptId: _chat.sessionId);
    if (s == null || !mounted) return;
    _shell.resumeChat(sessionId: s.id, cwd: s.project);
  }

  /// Leva a conversa para um terminal com Remote Control: fecha o motor do
  /// chat e abre `claude --resume <sessão> --remote-control` na mesma pasta.
  Future<void> _continueInRemoteControl() async {
    final tr = context.t.gsh.chat;
    // O botão fica sempre clicável: quando não dá, o clique explica.
    // Motor CLI: a conversa já está no Remote Control, sem terminal novo.
    if (_chat.remoteControlUrl case final url?) {
      return _toast(tr.remoteControlActive(url: url));
    }
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
