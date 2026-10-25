/// Um modelo que a conta pode usar no chat (lista do próprio Claude Code).
class ChatModelOption {
  const ChatModelOption({
    required this.value,
    required this.displayName,
    this.description = '',
    this.resolved,
  });

  /// O que vai no `--model` / `set_model` (`opus`, `sonnet`, um id...).
  final String value;
  final String displayName;
  final String description;

  /// Id real que o alias vira (`claude-opus-5-5`).
  final String? resolved;
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

/// O que dá para saber da conta sem conversa aberta: modelos e uso.
class ChatAccountProbe {
  const ChatAccountProbe({required this.models, this.usage});
  final List<ChatModelOption> models;
  final ChatPlanUsage? usage;
}
