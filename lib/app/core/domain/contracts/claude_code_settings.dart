import 'package:gsh_desktop/app/core/domain/result.dart';

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

  /// Push no celular quando uma permissão/pergunta espera (default desligado).
  static const inputNeededNotif = 'inputNeededNotifEnabled';

  /// Notificações proativas do Claude no celular (default desligado).
  static const agentPushNotif = 'agentPushNotifEnabled';

  /// Sugestão do próximo prompt depois de cada resposta. Ausente = ligado.
  static const promptSuggestion = 'promptSuggestionEnabled';

  /// Menos animação (shimmer do spinner, flashes). Ausente = desligado.
  static const reducedMotion = 'prefersReducedMotion';

  /// Estilo de saída (`Explanatory`, `Learning` ou um de
  /// `~/.claude/output-styles`). Ausente = padrão.
  static const outputStyle = 'outputStyle';

  /// Mensagens de outras sessões (SendMessage): `accept` entrega, `hold`
  /// segura para você aprovar, `refuse` recusa. Ausente = entrega só quando
  /// as duas sessões estão no mesmo tipo de modo de permissão.
  static const crossSessionInbound = 'crossSessionInbound';

  /// Bash dentro do sandbox. Ausente = desligado.
  static const sandboxEnabled = 'sandbox.enabled';

  /// `false` = modo estrito: comando que não roda no sandbox é bloqueado em
  /// vez de rodar fora dele. Ausente = `true`.
  static const sandboxAllowUnsandboxed = 'sandbox.allowUnsandboxedCommands';

  /// Variáveis de ambiente das sessões (`env` do settings.json).
  static const disableTelemetry = 'env.DISABLE_TELEMETRY';
  static const disableErrorReporting = 'env.DISABLE_ERROR_REPORTING';
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

  /// Valor cru em [key]. Chave com ponto (`sandbox.enabled`) desce nos
  /// objetos aninhados. `null` se ausente ou ilegível.
  Future<Object?> getValue(String key);

  /// Grava [value] (JSON) em [key], criando os objetos do caminho; `null`
  /// remove a chave (e o objeto pai que ficar vazio).
  Future<Result<void, String>> setValue(String key, Object? value);
}
