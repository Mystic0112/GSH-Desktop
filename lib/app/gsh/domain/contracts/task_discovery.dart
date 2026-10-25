import 'package:gsh_desktop/app/gsh/domain/entities/task_definition.dart';

/// Agrega os [TaskAdapter]s e devolve as tasks de um projeto. Também é o ponto
/// onde o `.gsh/tasks.json` (manual) é mesclado sobre as detectadas.
abstract class TaskDiscovery {
  /// Tasks do projeto em [cwd]: detectadas pelos adapters + manuais do JSON.
  Future<List<TaskDefinition>> discover(String cwd);
}
