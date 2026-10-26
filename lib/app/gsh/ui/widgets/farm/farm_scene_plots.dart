part of 'farm_scene.dart';

/// O que está plantado num canteiro.
class FarmPlotInfo {
  const FarmPlotInfo({
    required this.main,
    required this.title,
    required this.project,
    required this.stage,
    required this.more,
    required this.minis,
    this.team,
  });

  /// O dono do canteiro; `null` no canteiro dos órfãos (subagentes cujo pai
  /// saiu da janela).
  final FarmLoop? main;

  /// A etiqueta embaixo do canteiro.
  final String title;

  /// Nome da pasta, só no primeiro canteiro de cada projeto.
  final String? project;
  final CropStage stage;

  /// Subagentes além dos [subSpots] (a plaquinha "+N").
  final int more;

  /// Minis desenhados em volta (do 3º em diante há minis embaixo).
  final int minis;

  /// Cor do time (a do lead), no canteiro do lead e no de cada teammate;
  /// `null` fora de time.
  final int? team;

  FarmPlotInfo get unlabeled => FarmPlotInfo(
    main: main,
    title: title,
    project: null,
    stage: stage,
    more: more,
    minis: minis,
    team: team,
  );
}

/// Escolher o canteiro de cada projeto (arrastando na fazenda).
extension FarmScenePlots on FarmScene {
  /// Arrasta o projeto do canteiro [from] para a vaga [to]: os canteiros
  /// dele passam a começar ali e o projeto que estava em [to] vai para
  /// [from] (troca). Devolve a vaga nova de cada projeto mexido, para
  /// lembrar entre execuções.
  Map<String, int> movePlot(int from, int to) {
    final a = from < plotProject.length ? plotProject[from] : null;
    final b = to < plotProject.length ? plotProject[to] : null;
    if (a == null || a == b) return const {};
    final moved = {a: to, ?b: from};
    pins = {...pins, ...moved};
    final owners = {
      for (final pl in _last)
        for (final l in pl.loops) l.isSubagent ? l.parentId! : l.id: l.project,
    };
    _plotOf.removeWhere((id, _) => moved.containsKey(owners[id]));
    sync(_last);
    return moved;
  }

  /// Volta às posições automáticas.
  void resetPlots() {
    pins = const {};
    _plotOf.clear();
    sync(_last);
  }

  /// O canteiro sob o ponto (pixels de mundo): a terra e a etiqueta
  /// embaixo (a grama em volta segue arrastando a câmera); [any] também
  /// acha vaga vazia.
  int? plotAt(ui.Offset p, {bool any = false}) {
    final l = layout;
    if (l == null) return null;
    for (var i = 0; i < l.plots.length; i++) {
      final r = l.plots[i];
      if (!any && (i >= plotProject.length || plotProject[i] == null)) {
        continue;
      }
      if (p.dx > r.left - 2 &&
          p.dx < r.right + 2 &&
          p.dy > r.top - 4 &&
          p.dy < r.bottom + 14) {
        return i;
      }
    }
    return null;
  }
}
