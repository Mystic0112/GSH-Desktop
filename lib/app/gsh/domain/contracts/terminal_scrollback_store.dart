/// Persiste o scrollback (saída decodificada da PTY) de cada aba de terminal
/// pra replay histórico após restart. Impl em `data/` (arquivo sob
/// applicationSupport). Chaveado pelo `(projectId, sessionId)` estável que o
/// layout já guarda — o mesmo `id` com que o [TerminalSession] é recriado no
/// restore. Só vale pra abas de terminal (xterm): claude/shell/vim; agentes
/// `pi --mode rpc` restauram via `sessionPath` próprio.
abstract class TerminalScrollbackStore {
  /// Texto pronto pra `terminal.write` (ou `null` se não houver registro).
  Future<String?> load({required String projectId, required String sessionId});

  /// Snapshot completo (overwrite) do scrollback atual da sessão.
  Future<void> save({
    required String projectId,
    required String sessionId,
    required String contents,
  });

  /// Remove o arquivo (aba fechada explicitamente pelo usuário).
  Future<void> delete({required String projectId, required String sessionId});

  /// GC no boot: remove todo registro cujo `sessionId` não está em [keep]
  /// (sessões que sumiram de todos os layouts).
  Future<void> pruneExcept(Set<String> keep);
}
