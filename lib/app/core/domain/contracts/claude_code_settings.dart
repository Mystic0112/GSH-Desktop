import 'package:cockpit/app/core/domain/result.dart';

/// Chaves do `~/.claude/settings.json` que o GSH expõe nas próprias
/// configurações (aba Claude Code).
abstract final class ClaudeCodeKeys {
  /// Toda sessão interativa do `claude` conecta ao Remote Control sozinha
  /// (celular, claude.ai/code). Ausente = desligado.
  static const remoteControlAtStartup = 'remoteControlAtStartup';

  /// Quando as salvaguardas sinalizam uma mensagem, trocar de modelo e seguir
  /// (desligado = a sessão pausa). Ausente = ligado: o CLI 2.1.309 lê
  /// `switchModelsOnFlag` com default `true`.
  static const switchModelsOnFlag = 'switchModelsOnFlag';
}

/// Configurações do Claude Code do usuário (`~/.claude/settings.json`).
abstract interface class ClaudeCodeSettings {
  /// Valor booleano de [key]; `null` se ausente, de outro tipo ou se o
  /// arquivo não dá para ler.
  Future<bool?> getBool(String key);

  /// Grava [value] em [key] (`null` remove a chave). Falha (sem tocar no
  /// arquivo) se o settings.json existente não for um objeto JSON que dê
  /// para regravar.
  Future<Result<void, String>> setBool(String key, bool? value);
}
