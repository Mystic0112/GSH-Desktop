import 'dart:io' show Platform;

import 'package:gsh_desktop/app/core/domain/contracts/settings_store.dart';
import 'package:gsh_desktop/app/gsh/data/chat/claude_cli_engine.dart';
import 'package:gsh_desktop/app/gsh/data/chat/claude_stream_engine.dart';
import 'package:gsh_desktop/app/gsh/domain/contracts/chat_engine.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/chat_event.dart';

/// Escolhe o motor de cada chat novo pela preferência
/// `chatRemoteControl`: `stream-json` (padrão) ou o CLI interativo com
/// Remote Control. Lida ao abrir o chat, então a troca vale para os próximos.
class ChatEngineRouter implements ChatEngineFactory {
  const ChatEngineRouter(this._settings, this._stream, this._cli);

  final SettingsStore _settings;
  final ClaudeStreamEngineFactory _stream;
  final ClaudeCliEngineFactory _cli;

  @override
  Future<ChatEngine> start({
    required String cwd,
    String? resumeSessionId,
    bool showThinking = false,
  }) async {
    // O motor CLI usa `/usr/bin/env` e um hook em sh: só macOS/Linux. No
    // Windows fica o stream-json mesmo com a preferência ligada.
    final useCli =
        !Platform.isWindows && (await _settings.load()).chatRemoteControl;
    return (useCli ? _cli : _stream).start(
      cwd: cwd,
      resumeSessionId: resumeSessionId,
      showThinking: showThinking,
    );
  }

  @override
  Future<List<ChatEvent>> history({
    required String cwd,
    required String sessionId,
  }) => readClaudeHistory(cwd: cwd, sessionId: sessionId);
}
