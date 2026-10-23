/// Uma git worktree de um projeto (workspace) — o "fork" pendurado abaixo do
/// workspace no rail. Renderizado como um [Project] filho em runtime (com
/// `parentId`), mas a **existência** vem do git (`git worktree list`), não do
/// Hive. Ver `plan/42-cockpit-worktrees.md` (decisões 1, 4, 5).
class Worktree {
  const Worktree({
    required this.path,
    required this.branch,
    required this.isDetached,
  });

  /// Caminho absoluto do checkout da worktree.
  final String path;

  /// Nome da branch da worktree (ou short SHA se [isDetached]).
  final String branch;

  /// `true` quando a worktree está em detached HEAD (sem branch) — caso de
  /// worktrees criadas por fora (decisão 5: espelho fiel inclui essas).
  final bool isDetached;

  /// Igualdade por path — duas worktrees nunca compartilham diretório.
  @override
  bool operator ==(Object other) => other is Worktree && other.path == path;

  @override
  int get hashCode => path.hashCode;
}
