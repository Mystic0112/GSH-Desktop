import 'package:flutter/foundation.dart';
import 'package:gsh_desktop/app/gsh/domain/contracts/harness_source.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/project_harness.dart';

/// Estado das abas Harness: o harness lido de cada workspace. Recarrega
/// quando a aba aparece ou o usuário pede (não fica vigiando arquivos).
class HarnessViewModel extends ChangeNotifier {
  HarnessViewModel(this._source);

  final HarnessSource _source;
  final _byWorkspace = <String, ProjectHarness>{};
  final _loading = <String>{};
  bool _disposed = false;

  ProjectHarness? of(String workspace) => _byWorkspace[workspace];
  bool isLoading(String workspace) => _loading.contains(workspace);

  Future<void> load(String workspace) async {
    if (!_loading.add(workspace)) return;
    notifyListeners();
    try {
      _byWorkspace[workspace] = await _source.read(workspace);
    } on Object catch (e) {
      debugPrint('[harness] leitura de $workspace falhou: $e');
    } finally {
      _loading.remove(workspace);
      if (!_disposed) notifyListeners();
    }
  }

  /// Cria o item pelo modelo (ou só acha o arquivo da seção), recarrega e
  /// devolve o caminho para abrir no editor.
  Future<String?> create(
    String workspace,
    HarnessKind kind, {
    String? name,
  }) async {
    try {
      final path = await _source.create(workspace, kind, name: name);
      await load(workspace);
      return path;
    } on Object catch (e) {
      debugPrint('[harness] criar ${kind.name} falhou: $e');
      return null;
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
