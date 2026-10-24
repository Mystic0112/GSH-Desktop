/// Hosts que nenhum agente pode citar num comando (ssh, scp, workspace
/// remoto…). O `gsh hook` lê a lista no PreToolUse e bloqueia o comando, em
/// qualquer sessão da máquina.
abstract interface class ProtectedHosts {
  Future<List<String>> read();
  Future<void> write(List<String> hosts);
}
