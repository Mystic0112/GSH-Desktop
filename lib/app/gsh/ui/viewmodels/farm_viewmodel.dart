import 'dart:async';
import 'package:gsh_desktop/app/core/data/diagnostics/diagnostics_log.dart';
import 'package:gsh_desktop/app/gsh/domain/contracts/farm_source.dart';
import 'package:gsh_desktop/app/gsh/domain/contracts/team_farm_channel.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/farm_loop.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/team_farm.dart';
import 'package:gsh_desktop/app/gsh/ui/viewmodels/team_post.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;

/// Um canteiro da fazenda: os loops de uma pasta de trabalho.
class FarmPlot {
  const FarmPlot({required this.project, required this.loops});

  final String project;

  /// Principais primeiro (mais recente no topo); subagentes logo depois do pai.
  final List<FarmLoop> loops;

  Iterable<FarmLoop> get mains => loops.where((l) => !l.isSubagent);

  Iterable<FarmLoop> subagentsOf(String id) =>
      loops.where((l) => l.isSubagent && l.parentId == id);

  DateTime get lastSeen =>
      loops.map((l) => l.lastSeen).reduce((a, b) => a.isAfter(b) ? a : b);
}

/// A fazenda de um colega do time, recebida pela rede local.
class FarmPeer {
  const FarmPeer({required this.id, required this.name, required this.plots});

  final String id;
  final String name;
  final List<FarmPlot> plots;

  Iterable<FarmLoop> get loops => plots.expand((p) => p.loops);
}

/// Estado da fazenda. Faz polling do [FarmSource] enquanto alguém está
/// olhando ([attach]/[detach] por contagem) **ou** a fazenda do time está
/// ligada: sem tela aberta, o GSH ainda precisa anunciar, senão some da rede
/// dos colegas e o correio para (o contato expira em 10 s sem pacote).
///
/// Com a fazenda do time ligada ([configureTeam]), a cada varredura anuncia
/// os loops locais no [TeamFarmChannel] e guarda os dos colegas em [peers].
class FarmViewModel extends ChangeNotifier {
  FarmViewModel(this._source, this._team, this._post) {
    _teamSub = _team.packets.listen(_onPeer);
  }

  final FarmSource _source;
  final TeamFarmChannel _team;
  final TeamPost _post;
  late final StreamSubscription<TeamFarmPacket> _teamSub;
  TeamFarmConfig _teamConfig = const TeamFarmConfig();
  final _peers = <String, (TeamFarmPacket, DateTime)>{};

  /// Colega sem pacote há mais que isso sai da tela (fechou o GSH, saiu da
  /// rede).
  static const peerTimeout = Duration(seconds: 10);

  /// Colegas do time na rede agora, por nome.
  List<FarmPeer> get peers => [
    for (final (pkt, _) in _peers.values)
      FarmPeer(id: pkt.machineId, name: pkt.name, plots: groupFarm(pkt.loops)),
  ]..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

  TeamFarmConfig get teamConfig => _teamConfig;

  /// Aplica as preferências do time (chamado pela página quando mudam).
  Future<void> configureTeam(TeamFarmConfig config) async {
    _teamConfig = config;
    // Erro aqui não pode sumir: a página chama sem `await`, e no app aberto
    // pelo Dock o `debugPrint` não aparece em lugar nenhum.
    try {
      await _post.configure(config);
      await _team.open(config);
    } on Object catch (e, st) {
      DiagnosticsLog.instance.warn(
        'farm',
        'fazenda do time não abriu a rede',
        error: e,
        stack: st,
      );
    }
    if (_disposed) return;
    _syncPolling();
    if (!config.active && _peers.isNotEmpty) {
      _peers.clear();
      if (!_disposed) notifyListeners();
    }
  }

  void _onPeer(TeamFarmPacket p) {
    if (_disposed || !_teamConfig.active) return;
    _peers[p.machineId] = (p, DateTime.now());
    notifyListeners();
  }

  /// O que sai daqui: só o nome da pasta (nunca o caminho) e, sem
  /// [TeamFarmConfig.showTitles], o título vira o nome da pasta também.
  TeamFarmPacket _outgoing(List<FarmLoop> loops) => TeamFarmPacket(
    machineId: _team.machineId,
    name: _teamConfig.name.trim(),
    team: _teamConfig.team.trim(),
    loops: [
      for (final l in loops)
        FarmLoop(
          id: l.id,
          parentId: l.parentId,
          teammate: l.teammate,
          harness: l.harness,
          project: p.basename(l.project),
          title: _teamConfig.showTitles ? l.title : p.basename(l.project),
          agentType: l.agentType,
          activity: l.activity,
          tool: l.tool,
          outputTokens: l.outputTokens,
          contextTokens: l.contextTokens,
          inputTokens: l.inputTokens,
          cacheReadTokens: l.cacheReadTokens,
          contextWindow: l.contextWindow,
          lastSeen: l.lastSeen,
        ),
    ],
    // Só com correio ligado (senha do time): sem ele ninguém entrega nada.
    agents: _post.mailPort == null ? const [] : _post.localAgents(),
    mailPort: _post.mailPort,
  );

  static const interval = Duration(seconds: 2);

  List<FarmPlot> _plots = const [];
  List<FarmPlot> get plots => _plots;

  /// Última varredura, antes de tirar os ocultos (para ocultar já, sem esperar
  /// o próximo tick).
  List<FarmLoop> _scanned = const [];

  /// Loops que o usuário ocultou: id → `lastSeen` na hora de ocultar. Voltam
  /// sozinhos se o loop escrever de novo; saem daqui quando deixam a janela do
  /// scan. Só vale enquanto o GSH está aberto.
  final _hidden = <String, DateTime>{};

  int get hiddenCount => _hidden.length;

  /// Tira da fazenda (e do anúncio ao time) o loop e os subagentes dele.
  void hide(FarmLoop loop) {
    _hidden[loop.id] = loop.lastSeen;
    _applyScan();
  }

  void showHidden() {
    if (_hidden.isEmpty) return;
    _hidden.clear();
    _applyScan();
  }

  List<FarmLoop> _unhidden(List<FarmLoop> loops) {
    if (_hidden.isEmpty) return loops;
    final byId = {for (final l in loops) l.id: l};
    _hidden.removeWhere((id, seen) {
      final l = byId[id];
      return l == null || l.lastSeen.isAfter(seen);
    });
    return [
      for (final l in loops)
        if (!_hidden.containsKey(l.id) && !_hidden.containsKey(l.parentId)) l,
    ];
  }

  void _applyScan() {
    _plots = groupFarm(_unhidden(_scanned));
    if (!_disposed) notifyListeners();
  }

  int _viewers = 0;
  Timer? _timer;
  bool _scanning = false;
  bool _disposed = false;

  Iterable<FarmLoop> get loops => _plots.expand((p) => p.loops);

  int countBy(FarmStatus status) =>
      loops.where((l) => l.activity.status == status).length;

  int get outputTokens => loops.fold(0, (sum, l) => sum + l.outputTokens);

  /// Tudo que os loops na tela gastaram (entrada + cache + saída).
  int get spentTokens => loops.fold(0, (sum, l) => sum + l.spentTokens);

  /// Fila "precisa de mim" (ver [farmWaitingQueue]).
  List<FarmWaiting> get waiting => farmWaitingQueue(loops);

  void attach() {
    _viewers++;
    _syncPolling();
  }

  void detach() {
    if (_viewers == 0) return;
    _viewers--;
    _syncPolling();
  }

  /// Liga o polling se alguém olha ou o time precisa do anúncio; desliga
  /// quando nenhum dos dois.
  void _syncPolling() {
    final want = _viewers > 0 || _teamConfig.active;
    if (want && _timer == null) {
      unawaited(_tick());
      _timer = Timer.periodic(interval, (_) => unawaited(_tick()));
    } else if (!want) {
      _timer?.cancel();
      _timer = null;
    }
  }

  /// Uma varredura avulsa, sem ligar o polling (o seletor de sessões do
  /// chat usa para listar quem está rodando agora).
  Future<List<FarmLoop>> scanOnce() => _source.scan(DateTime.now());

  Future<void> _tick() async {
    if (_scanning) return;
    _scanning = true;
    try {
      _scanned = await _source.scan(DateTime.now());
      if (_disposed) return;
      final loops = _unhidden(_scanned);
      _plots = groupFarm(loops);
      if (_teamConfig.active) {
        await _team.publish(_outgoing(loops));
        final now = DateTime.now();
        _peers.removeWhere((_, v) => now.difference(v.$2) > peerTimeout);
      }
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
    unawaited(_teamSub.cancel());
    unawaited(_team.close());
    super.dispose();
  }
}

/// Uma linha da fila "precisa de mim": uma sessão principal com alguém
/// esperando um humano — ela mesma e/ou subagentes dela.
class FarmWaiting {
  const FarmWaiting({
    required this.sessionId,
    required this.title,
    required this.project,
    required this.since,
    this.subagents = const [],
  });

  /// Sessão principal a focar (subagente não tem aba própria).
  final String sessionId;
  final String title;
  final String project;

  /// Desde quando o mais antigo do grupo espera (`lastSeen` dele).
  final DateTime since;

  /// Tipo (ou título) dos subagentes esperando sob esta sessão.
  final List<String> subagents;
}

/// Loops esperando um humano, agrupados pela sessão principal (subagente
/// aparece sob o título do pai), quem espera há mais tempo primeiro.
List<FarmWaiting> farmWaitingQueue(Iterable<FarmLoop> loops) {
  final mains = {
    for (final l in loops)
      if (!l.isSubagent) l.id: l,
  };
  final groups = <String, List<FarmLoop>>{};
  for (final l in loops) {
    if (l.activity != FarmActivity.waiting) continue;
    (groups[l.parentId ?? l.id] ??= []).add(l);
  }
  return [
    for (final MapEntry(key: sid, value: group) in groups.entries)
      FarmWaiting(
        sessionId: sid,
        // Pai fora da janela do scan: o próprio subagente dá nome à linha.
        title: (mains[sid] ?? group.first).title,
        project: (mains[sid] ?? group.first).project,
        since: group
            .map((l) => l.lastSeen)
            .reduce((a, b) => a.isBefore(b) ? a : b),
        subagents: [
          for (final l in group)
            if (l.parentId != null) l.teammate ?? l.agentType ?? l.title,
        ],
      ),
  ]..sort((a, b) => a.since.compareTo(b.since));
}

/// Agrupa por pasta, canteiro mais recente primeiro; dentro dele, cada
/// principal seguido dos seus subagentes e dos seus teammates.
@visibleForTesting
List<FarmPlot> groupFarm(List<FarmLoop> loops) {
  final byProject = <String, List<FarmLoop>>{};
  for (final l in loops) {
    (byProject[l.project] ??= []).add(l);
  }
  int recent(FarmLoop a, FarmLoop b) => b.lastSeen.compareTo(a.lastSeen);
  final plots = <FarmPlot>[];
  byProject.forEach((project, all) {
    final ids = {for (final l in all) l.id};
    // teammate com o lead no canteiro vem logo depois dele
    final mains =
        all
            .where(
              (l) =>
                  !l.isSubagent && !(l.isTeammate && ids.contains(l.parentId)),
            )
            .toList()
          ..sort(recent);
    final ordered = <FarmLoop>[];
    void put(FarmLoop m) {
      if (ordered.contains(m)) return;
      ordered
        ..add(m)
        ..addAll(
          all.where((l) => l.isSubagent && l.parentId == m.id).toList()
            ..sort(recent),
        );
      final mates =
          all.where((l) => l.isTeammate && l.parentId == m.id).toList()
            ..sort(recent);
      mates.forEach(put);
    }

    mains.forEach(put);
    // Subagente cujo pai saiu da janela: fica no canteiro mesmo assim.
    ordered.addAll(all.where((l) => !ordered.contains(l)));
    plots.add(FarmPlot(project: project, loops: ordered));
  });
  plots.sort((a, b) => b.lastSeen.compareTo(a.lastSeen));
  return plots;
}
