import 'dart:collection';
import 'dart:io' show FileStat, FileSystemEntityType;

import 'package:cockpit/app/cockpit/domain/entities/git_file_status.dart';
import 'package:cockpit/app/cockpit/ui/session/terminal_session.dart';
import 'package:cockpit/app/cockpit/ui/viewmodels/git_controller.dart';
import 'package:flutter/foundation.dart';

/// Um arquivo tocado por um agente: quando, e se foi inferido (heurística de
/// git/mtime) em vez de reportado pelo hook do harness.
class AgentFileTouch {
  const AgentFileTouch({required this.at, required this.inferred});

  final DateTime at;
  final bool inferred;
}

/// "Quem está mexendo no quê": arquivos tocados por agente (aba), por
/// workspace. Em memória, como o [AgentMessageLog]; a aba sai ao fechar.
class AgentFileActivity extends ChangeNotifier {
  final Map<String, String> _workspaceOf = {};
  final Map<String, Map<String, AgentFileTouch>> _byTab = {};

  /// Registra [paths] (absolutos) como tocados por [tabId] agora (ou [at]).
  void record({
    required String tabId,
    required String workspaceId,
    required Iterable<String> paths,
    required bool inferred,
    DateTime? at,
  }) {
    if (paths.isEmpty) return;
    final touch = AgentFileTouch(at: at ?? DateTime.now(), inferred: inferred);
    final files = _byTab.putIfAbsent(tabId, () => {});
    for (final path in paths) {
      files[path] = touch;
    }
    _workspaceOf[tabId] = workspaceId;
    notifyListeners();
  }

  /// Aba fechada: some com o que ela tocou.
  void forgetTab(String tabId) {
    _workspaceOf.remove(tabId);
    if (_byTab.remove(tabId) != null) notifyListeners();
  }

  /// Arquivos tocados por [tabId] (caminho absoluto → toque).
  Map<String, AgentFileTouch> touchedBy(String tabId) =>
      UnmodifiableMapView(_byTab[tabId] ?? const {});

  /// Abas do workspace com algum arquivo registrado.
  Iterable<String> tabsIn(String workspaceId) => _workspaceOf.entries
      .where((e) => e.value == workspaceId)
      .map((e) => e.key);

  /// Quem tocou [path], do toque mais novo ao mais antigo.
  List<({String tabId, AgentFileTouch touch})> touchersOf(String path) {
    final out = <({String tabId, AgentFileTouch touch})>[
      for (final MapEntry(key: tabId, value: files) in _byTab.entries)
        if (files[path] case final touch?) (tabId: tabId, touch: touch),
    ];
    out.sort((a, b) => b.touch.at.compareTo(a.touch.at));
    return out;
  }
}

/// Caminhos (relativos à root) que um turno inferido pela saída do PTY mexeu:
/// sujos no fim do turno com mtime >= [since], mais os removidos que ainda não
/// estavam removidos no início ([before]). Puro, pra testar sem git nem disco.
Set<String> attributeTurnChanges({
  required Map<String, GitFileStatus> before,
  required Map<String, GitFileStatus> after,
  required DateTime since,
  required DateTime? Function(String rel) mtimeOf,
}) => {
  for (final MapEntry(key: rel, value: status) in after.entries)
    if (status == GitFileStatus.deleted
        ? before[rel] != GitFileStatus.deleted
        : !(mtimeOf(rel)?.isBefore(since) ?? true))
      rel,
};

/// Rastreio por heurística para abas SEM hook (Antigravity, Cursor...): no fim
/// de um turno inferido pela saída, o git da root onde a aba está diz o que
/// mudou durante o turno, e isso vai pra aba como `inferred`.
// ponytail: teto conhecido — arquivo fora do git ou ignorado não aparece, e
// com dois agentes no mesmo repo a atribuição é ambígua (só os toques de hook
// de outra aba são descontados). Workspace remoto fica de fora. Upgrade = hook
// nativo por harness, que reporta o arquivo exato.
class OutputTurnFileTracker {
  OutputTurnFileTracker(this._activity, this._git);

  final AgentFileActivity _activity;
  final GitController _git;

  /// Folga sobre o início do turno: mtime tem granularidade de 1-2s em
  /// alguns filesystems.
  static const Duration _mtimeSlack = Duration(seconds: 2);

  final Map<String, _Turn> _turns = {};

  void turnStarted(TerminalSession s) {
    _turns[s.id] = _Turn(DateTime.now().subtract(_mtimeSlack), {
      for (final root in _rootsOf(s))
        root: Map.of(_git.infoForRoot(root)?.files ?? const {}),
    });
  }

  Future<void> turnEnded(TerminalSession s) async {
    final turn = _turns[s.id];
    if (turn == null) return;
    await _git.refresh(s.projectId);
    // Aba fechou (forget) ou outro turno começou durante o refresh: descarta.
    if (!identical(_turns[s.id], turn)) return;
    _turns.remove(s.id);
    final touched = <String>[];
    for (final root in _rootsOf(s)) {
      final after = _git.infoForRoot(root)?.files;
      if (after == null) continue;
      final rels = attributeTurnChanges(
        before: turn.before[root] ?? const {},
        after: after,
        since: turn.since,
        mtimeOf: (rel) {
          final stat = FileStat.statSync('$root/$rel');
          return stat.type == FileSystemEntityType.notFound
              ? null
              : stat.modified;
        },
      );
      for (final rel in rels) {
        final abs = '$root/$rel';
        // Outra aba reportou este arquivo pelo hook durante o turno: é dela.
        final byHook = _activity
            .touchersOf(abs)
            .any(
              (t) =>
                  t.tabId != s.id &&
                  !t.touch.inferred &&
                  !t.touch.at.isBefore(turn.since),
            );
        if (!byHook) touched.add(abs);
      }
    }
    _activity.record(
      tabId: s.id,
      workspaceId: s.projectId,
      paths: touched,
      inferred: true,
    );
  }

  void forget(String tabId) => _turns.remove(tabId);

  /// Roots git do workspace ligadas ao cwd da aba: a que contém o cwd, ou as
  /// que estão abaixo dele (aba na pasta-mãe de um multi-root).
  List<String> _rootsOf(TerminalSession s) {
    final cwd = s.currentDirectory ?? s.workingDirectory;
    bool within(String child, String parent) =>
        child == parent || child.startsWith('$parent/');
    return [
      for (final root in _git.rootsOf(s.projectId))
        if (within(cwd, root) || within(root, cwd)) root,
    ];
  }
}

/// Turno inferido em andamento: início (com folga) e o status git por root no
/// início. Classe (não record) porque o fim compara identidade.
class _Turn {
  _Turn(this.since, this.before);
  final DateTime since;
  final Map<String, Map<String, GitFileStatus>> before;
}
