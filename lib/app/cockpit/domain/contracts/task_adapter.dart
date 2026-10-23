import 'package:cockpit/app/cockpit/domain/entities/task_definition.dart';

/// Um adapter por stack. É a ÚNICA borda que conhece "flavor", "scripts",
/// "features" etc — traduz convenções da stack em [TaskDefinition]s genéricas.
/// Mesmo padrão multi-marcador do `core/data/lsp/project_root_finder.dart`.
abstract class TaskAdapter {
  /// `true` se este adapter reconhece o projeto em [cwd] (ex.: tem
  /// `package.json`). Pode ler o filesystem.
  Future<bool> matches(String cwd);

  /// Tasks detectadas pra [cwd] (já com interactiveKeys/watch/progressPatterns
  /// preenchidos quando fizer sentido pra stack). Vazio se nada aplicável.
  Future<List<TaskDefinition>> tasksFor(String cwd);
}
