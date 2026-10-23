import 'dart:convert';
import 'dart:io';

import 'package:cockpit/app/cockpit/domain/contracts/task_adapter.dart';
import 'package:cockpit/app/cockpit/data/tasks/project_paths.dart';
import 'package:cockpit/app/cockpit/domain/entities/task_definition.dart';

/// Detecta tasks de projetos Node: cada chave de `package.json > scripts` vira
/// uma task `npm run <script>`. Genérico — não conhece Vite/Next/etc; a
/// heurística de [TaskKind] só olha o nome do script.
class NpmAdapter implements TaskAdapter {
  const NpmAdapter();

  /// Nomes (ou substrings) que sugerem um processo de longa duração (watch).
  static const _watchHints = {'dev', 'start', 'serve', 'watch'};

  @override
  Future<bool> matches(String cwd) =>
      File(joinPath(cwd, 'package.json')).exists();

  @override
  Future<List<TaskDefinition>> tasksFor(String cwd) async {
    final file = File(joinPath(cwd, 'package.json'));
    if (!await file.exists()) return const [];
    final Map<String, dynamic> json;
    try {
      json = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
    } catch (_) {
      return const []; // package.json inválido → sem tasks
    }
    final scripts = json['scripts'];
    if (scripts is! Map) return const [];

    final tasks = <TaskDefinition>[];
    for (final entry in scripts.entries) {
      final name = entry.key.toString();
      tasks.add(
        TaskDefinition(
          id: 'npm:$name',
          label: name,
          cwd: cwd,
          command: 'npm',
          args: ['run', name],
          kind: _isWatch(name) ? TaskKind.watch : TaskKind.oneShot,
        ),
      );
    }
    return tasks;
  }

  bool _isWatch(String name) {
    final lower = name.toLowerCase();
    return _watchHints.any(lower.contains);
  }
}
