import 'package:cockpit/app/core/domain/result.dart';

/// Configurações do Claude Code do usuário (`~/.claude/settings.json`) que o
/// GSH expõe nas próprias configurações.
abstract interface class ClaudeCodeSettings {
  /// `remoteControlAtStartup`: toda sessão interativa do `claude` conecta ao
  /// Remote Control sozinha (celular, claude.ai/code).
  Future<bool> remoteControlAtStartup();

  /// Liga ([on]) ou remove a chave. Falha (sem tocar no arquivo) se o
  /// settings.json existente não for um objeto JSON que dê para regravar.
  Future<Result<void, String>> setRemoteControlAtStartup(bool on);
}
