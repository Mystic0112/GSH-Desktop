/// Um modelo que a conta pode usar no chat (lista do próprio Claude Code).
class ChatModelOption {
  const ChatModelOption({
    required this.value,
    required this.displayName,
    this.description = '',
    this.resolved,
    this.efforts = const [],
  });

  /// O que vai no `--model` / `set_model` (`opus`, `sonnet`, um id...).
  final String value;
  final String displayName;
  final String description;

  /// Id real que o alias vira (`claude-opus-5-5`).
  final String? resolved;

  /// Níveis de esforço que o modelo aceita (`low`...`max`); vazio = não tem.
  final List<String> efforts;
}

enum ChatLimitKind { session, weekly, weeklyModel, other }

/// Um limite do plano: quanto já foi usado e quando zera.
class ChatLimit {
  const ChatLimit({
    required this.kind,
    required this.percent,
    this.model,
    this.resetsAt,
    this.warning = false,
  });

  final ChatLimitKind kind;

  /// 0–100.
  final int percent;

  /// Nome do modelo, para limite por modelo ("Fable").
  final String? model;
  final DateTime? resetsAt;

  /// O Claude Code marcou como perto do fim.
  final bool warning;
}

/// Limites do plano (sessão de 5 h, semana, por modelo).
class ChatPlanUsage {
  const ChatPlanUsage({required this.limits, this.plan});
  final List<ChatLimit> limits;

  /// `team`, `max`, `pro`... `null` se não veio.
  final String? plan;
}

/// Um comando `/nome` da sessão: comandos do usuário/projeto, skills e os
/// embutidos do Claude Code (lista do `initialize`).
class ChatCommandOption {
  const ChatCommandOption({
    required this.name,
    this.description = '',
    this.argumentHint = '',
    this.aliases = const [],
  });
  final String name;
  final String description;

  /// O que vem depois do nome (`<arquivo>`, `[tarefa]`...).
  final String argumentHint;
  final List<String> aliases;
}

/// O que dá para saber da conta sem conversa aberta: modelos, comandos e
/// uso.
class ChatAccountProbe {
  const ChatAccountProbe({
    required this.models,
    this.usage,
    this.commands = const [],
  });
  final List<ChatModelOption> models;
  final ChatPlanUsage? usage;
  final List<ChatCommandOption> commands;
}
