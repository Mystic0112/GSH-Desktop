/// De onde vem um item do harness: do usuário (`~/.claude`, vale em todo
/// projeto), do projeto (versionado, `.claude/` / `.mcp.json`) ou local
/// (só nesta máquina: `settings.local.json`, `CLAUDE.local.md`, `~/.claude.json`).
enum HarnessScope { user, project, local }

/// Seções do painel Harness.
enum HarnessKind { memory, skills, agents, commands, hooks, permissions, mcp }

/// Problema que o linter acha num item (a UI traduz).
enum HarnessIssue {
  /// Skill/subagente sem `description`: o agente não sabe quando usar.
  noDescription,

  /// Hook chama um script que não existe.
  missingScript,

  /// Instrução grande demais: pesa em todo turno e o Claude Code avisa.
  tooLarge,
}

/// Um item do harness: uma instrução, skill, subagente, comando, hook,
/// regra de permissão ou servidor MCP — e o arquivo onde ele mora.
class HarnessEntry {
  const HarnessEntry({
    required this.kind,
    required this.name,
    required this.scope,
    this.detail = '',
    this.path,
    this.issues = const [],
    this.alwaysOnChars = 0,
  });

  final HarnessKind kind;
  final String name;

  /// Descrição, comando, matcher... (uma linha).
  final String detail;
  final HarnessScope scope;

  /// Arquivo que define o item (abre no editor). `null` = não editável aqui.
  final String? path;

  final List<HarnessIssue> issues;

  /// Caracteres que este item põe no contexto em **todo** turno (instrução
  /// inteira; nome + descrição de skill/subagente/comando). 0 = sob demanda.
  final int alwaysOnChars;
}

/// Tudo que o agente carrega ao rodar no workspace.
class ProjectHarness {
  const ProjectHarness(this.entries, {this.invalidFiles = const []});
  final List<HarnessEntry> entries;

  /// JSON que não abre (`settings*.json`, `.mcp.json`): o Claude Code ignora
  /// o arquivo inteiro sem avisar.
  final List<String> invalidFiles;

  /// Tokens fixos por turno (≈ caracteres / 4) da seção [k] — ou de todas.
  int alwaysOnTokens([HarnessKind? k]) =>
      (entries
                  .where((e) => k == null || e.kind == k)
                  .fold(0, (n, e) => n + e.alwaysOnChars) /
              4)
          .round();

  int get issueCount =>
      entries.fold(0, (n, e) => n + e.issues.length) + invalidFiles.length;

  /// Itens da seção [k]: do projeto primeiro (o que é deste repo), depois
  /// os locais, por último os do usuário (valem em todo lugar). Dentro do
  /// escopo, a ordem de leitura.
  List<HarnessEntry> of(HarnessKind k) {
    const rank = {
      HarnessScope.project: 0,
      HarnessScope.local: 1,
      HarnessScope.user: 2,
    };
    final list = entries.where((e) => e.kind == k).toList();
    return [for (final s in rank.keys) ...list.where((e) => e.scope == s)];
  }
}
