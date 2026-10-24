/// Uma sessão de agente desta máquina, para o seletor "Sessões" do chat.
class SessionEntry {
  const SessionEntry({
    required this.id,
    required this.title,
    required this.project,
    required this.lastSeen,
    required this.harness,
  });
  final String id;
  final String title;
  final String project;
  final DateTime lastSeen;
  final String harness;
}

/// Sessões recentes da máquina, sem o custo da fazenda: só título, pasta e
/// quando mexeu por último. Quem lista é o disco (transcripts), então
/// sessões na nuvem ou em outra máquina ficam de fora — para essas, o
/// próprio agente usa `ListAgents`.
abstract interface class SessionDirectory {
  Future<List<SessionEntry>> recent({
    Duration within = const Duration(hours: 24),
  });
}
