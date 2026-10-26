/// O que um loop de agente está fazendo agora. Deriva da última ferramenta
/// (ou do fim de turno) no transcript da sessão.
enum FarmActivity {
  thinking,
  reading,
  editing,
  running,
  searching,
  delegating,
  tooling,
  waiting,
  idle,
  sleeping,
  done,
}

/// As três cores de status da UI: verde (trabalhando), amarelo (precisa de
/// alguém), azul (parado).
enum FarmStatus { working, waiting, idle }

extension FarmActivityStatus on FarmActivity {
  FarmStatus get status => switch (this) {
    FarmActivity.waiting => FarmStatus.waiting,
    FarmActivity.idle ||
    FarmActivity.sleeping ||
    FarmActivity.done => FarmStatus.idle,
    _ => FarmStatus.working,
  };
}

/// Atividade de uma chamada de ferramenta, pelo nome (Claude Code e Codex).
FarmActivity farmActivityForTool(String name) {
  if (name.startsWith('mcp__')) return FarmActivity.tooling;
  return switch (name) {
    'Read' ||
    'Grep' ||
    'Glob' ||
    'LS' ||
    'NotebookRead' => FarmActivity.reading,
    'Edit' ||
    'Write' ||
    'MultiEdit' ||
    'NotebookEdit' ||
    'apply_patch' => FarmActivity.editing,
    'Bash' ||
    'BashOutput' ||
    'KillShell' ||
    'Monitor' ||
    'shell' ||
    'exec_command' => FarmActivity.running,
    'WebFetch' || 'WebSearch' => FarmActivity.searching,
    'Agent' || 'Task' || 'SendMessage' || 'Workflow' => FarmActivity.delegating,
    'AskUserQuestion' || 'ExitPlanMode' => FarmActivity.waiting,
    'TodoWrite' ||
    'TaskCreate' ||
    'TaskUpdate' ||
    'EnterPlanMode' => FarmActivity.thinking,
    _ => FarmActivity.tooling,
  };
}

/// Janela de contexto padrão (modelos antigos, Haiku, modelo desconhecido)
/// e a longa (linha atual do Claude, `[1m]`).
const farmDefaultWindow = 200000, farmLongWindow = 1000000;

/// Um **loop de agente** na fazenda: uma sessão principal ou um subagente
/// dela. Não é uma aba de terminal — o loop pode rodar fora do GSH (headless,
/// outro terminal) e uma aba pode hospedar vários loops.
class FarmLoop {
  const FarmLoop({
    required this.id,
    required this.harness,
    required this.project,
    required this.title,
    required this.activity,
    required this.lastSeen,
    this.parentId,
    this.teammate,
    this.agentType,
    this.tool,
    this.outputTokens = 0,
    this.contextTokens = 0,
    this.inputTokens = 0,
    this.cacheReadTokens = 0,
    this.contextWindow = 0,
  });

  /// `session_id` (principal) ou `agentId` (subagente).
  final String id;

  /// Sessão dona, para subagentes; o lead, para teammates (quando ele está
  /// à vista). `null` = loop principal.
  final String? parentId;

  /// Nome do colega de time, se o loop é um **teammate** (Claude Code agent
  /// teams): um agente com nome, criado por outro (o lead), com transcript
  /// próprio. Ter nome é o que separa teammate de subagente (glossário do
  /// pixel-agents). Teammate tem lugar próprio na fazenda, não é mini.
  final String? teammate;

  /// `claude` (Codex fica para depois).
  final String harness;

  /// Pasta de trabalho do loop (`cwd`). Agrupa os loops em canteiros.
  final String project;

  final String title;

  /// Tipo do subagente (`escanor`, `Explore`...). `null` no principal.
  final String? agentType;

  final FarmActivity activity;

  /// Nome da última ferramenta, se a atividade veio de uma.
  final String? tool;

  /// Tokens gerados pelo loop (soma do `output_tokens` por mensagem).
  final int outputTokens;

  /// Tamanho do contexto no último turno (input + cache).
  final int contextTokens;

  /// Janela de contexto do modelo do loop, em tokens (`0` = não se sabe).
  final int contextWindow;

  /// Janela usada na barra: a do modelo, senão 200k; um contexto que não
  /// cabe nela prova que a janela é a longa (1M), nunca o contrário.
  int get window {
    final w = contextWindow > 0 ? contextWindow : farmDefaultWindow;
    return contextTokens > w ? farmLongWindow : w;
  }

  /// Quanto da janela o contexto ocupa (0..1).
  double get contextFill =>
      contextTokens <= 0 ? 0 : (contextTokens / window).clamp(0.0, 1.0);

  /// Entrada processada no loop todo (input + escrita de cache), somada por
  /// mensagem.
  final int inputTokens;

  /// Contexto relido do cache no loop todo (mais barato, mas conta).
  final int cacheReadTokens;

  /// Tudo que o loop gastou: entrada + cache + saída.
  int get spentTokens => inputTokens + cacheReadTokens + outputTokens;

  final DateTime lastSeen;

  /// Subagente: tem dono e não tem nome (teammate não é subagente).
  bool get isSubagent => parentId != null && teammate == null;

  bool get isTeammate => teammate != null;
}
