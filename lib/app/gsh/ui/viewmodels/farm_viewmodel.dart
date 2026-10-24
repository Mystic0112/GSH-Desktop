import 'dart:async';

import 'package:gsh_desktop/app/gsh/domain/contracts/farm_source.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/farm_loop.dart';
import 'package:flutter/foundation.dart';

/// Um canteiro da fazenda: os loops de uma pasta de trabalho.
class FarmPlot {
  const FarmPlot({required this.project, required this.loops});

  final String project;

  /// Principais primeiro (mais recente no topo); subagentes logo depois do pai.
  final List<FarmLoop> loops;

  Iterable<FarmLoop> get mains => loops.where((l) => !l.isSubagent);

  Iterable<FarmLoop> subagentsOf(String id) =>
      loops.where((l) => l.parentId == id);

  DateTime get lastSeen =>
      loops.map((l) => l.lastSeen).reduce((a, b) => a.isAfter(b) ? a : b);
}

/// Estado da fazenda. Faz polling do [FarmSource] só enquanto alguém está
/// olhando ([attach]/[detach] por contagem), para não ler disco à toa.
class FarmViewModel extends ChangeNotifier {
  FarmViewModel(this._source);

  final FarmSource _source;

  static const interval = Duration(seconds: 2);

  List<FarmPlot> _plots = const [];
  List<FarmPlot> get plots => _plots;

  int _viewers = 0;
  Timer? _timer;
  bool _scanning = false;
  bool _disposed = false;

  Iterable<FarmLoop> get loops => _plots.expand((p) => p.loops);

  int countBy(FarmStatus status) =>
      loops.where((l) => l.activity.status == status).length;

  int get outputTokens => loops.fold(0, (sum, l) => sum + l.outputTokens);

  void attach() {
    if (_viewers++ > 0) return;
    unawaited(_tick());
    _timer = Timer.periodic(interval, (_) => unawaited(_tick()));
  }

  void detach() {
    if (_viewers == 0 || --_viewers > 0) return;
    _timer?.cancel();
    _timer = null;
  }

  /// Uma varredura avulsa, sem ligar o polling (o seletor de sessões do
  /// chat usa para listar quem está rodando agora).
  Future<List<FarmLoop>> scanOnce() => _source.scan(DateTime.now());

  Future<void> _tick() async {
    if (_scanning) return;
    _scanning = true;
    try {
      final loops = await _source.scan(DateTime.now());
      if (_disposed) return;
      _plots = groupFarm(loops);
      notifyListeners();
    } on Object catch (e) {
      debugPrint('[farm] scan falhou: $e');
    } finally {
      _scanning = false;
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _timer?.cancel();
    super.dispose();
  }
}

/// Agrupa por pasta, canteiro mais recente primeiro; dentro dele, cada
/// principal seguido dos seus subagentes.
@visibleForTesting
List<FarmPlot> groupFarm(List<FarmLoop> loops) {
  final byProject = <String, List<FarmLoop>>{};
  for (final l in loops) {
    (byProject[l.project] ??= []).add(l);
  }
  int recent(FarmLoop a, FarmLoop b) => b.lastSeen.compareTo(a.lastSeen);
  final plots = <FarmPlot>[];
  byProject.forEach((project, all) {
    final mains = all.where((l) => !l.isSubagent).toList()..sort(recent);
    final ordered = <FarmLoop>[];
    for (final m in mains) {
      ordered
        ..add(m)
        ..addAll(all.where((l) => l.parentId == m.id).toList()..sort(recent));
    }
    // Subagente cujo pai saiu da janela: fica no canteiro mesmo assim.
    ordered.addAll(all.where((l) => !ordered.contains(l)));
    plots.add(FarmPlot(project: project, loops: ordered));
  });
  plots.sort((a, b) => b.lastSeen.compareTo(a.lastSeen));
  return plots;
}
