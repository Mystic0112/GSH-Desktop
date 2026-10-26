/// De onde vem um item do harness: do usuário (`~/.claude`, vale em todo
/// projeto), do projeto (versionado, `.claude/` / `.mcp.json`) ou local
/// (só nesta máquina: `settings.local.json`, `CLAUDE.local.md`, `~/.claude.json`).
enum HarnessScope { user, project, local }

/// Seções do painel Harness.
enum HarnessKind { memory, skills, agents, commands, hooks, permissions, mcp }

/// Um item do harness: uma instrução, skill, subagente, comando, hook,
/// regra de permissão ou servidor MCP — e o arquivo onde ele mora.
class HarnessEntry {
  const HarnessEntry({
    required this.kind,
    required this.name,
    required this.scope,
    this.detail = '',
    this.path,
  });

  final HarnessKind kind;
  final String name;

  /// Descrição, comando, matcher... (uma linha).
  final String detail;
  final HarnessScope scope;

  /// Arquivo que define o item (abre no editor). `null` = não editável aqui.
  final String? path;
}

/// Tudo que o agente carrega ao rodar no workspace.
class ProjectHarness {
  const ProjectHarness(this.entries);
  final List<HarnessEntry> entries;

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
