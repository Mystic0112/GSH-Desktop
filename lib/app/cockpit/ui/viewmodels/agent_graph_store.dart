import 'dart:ui' show Offset;

import 'package:cockpit/app/cockpit/domain/entities/agent_message.dart';
import 'package:cockpit/app/cockpit/domain/entities/desktop_agent_app.dart';
import 'package:cockpit/app/cockpit/ui/session/external_agent.dart';
import 'package:cockpit/app/cockpit/ui/session/pane_item.dart';
import 'package:cockpit/app/cockpit/ui/session/terminal_session.dart';
import 'package:cockpit/app/core/ui/themes/agent_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart' show Color;

/// Chave do documento de layout com o grafo de agentes do workspace
/// (posições dos nós + links definidos). Mora no mesmo doc das abas, então
/// sobrevive ao restore sem store paralelo.
const String kAgentGraphKey = 'agentGraph';

/// Par **não ordenado** de abas (`(menor, maior)`), chave de cabo.
typedef AgentPair = (String, String);

AgentPair agentPair(String a, String b) =>
    a.compareTo(b) <= 0 ? (a, b) : (b, a);

/// Cabo observado: o par trocou [count] mensagens; [last] é a mais recente.
class ObservedEdge {
  ObservedEdge(this.count, this.last);
  final int count;
  final AgentMessage last;
}

/// Agrega o log de `cockpit msg` em um cabo por par não ordenado.
Map<AgentPair, ObservedEdge> observedEdges(Iterable<AgentMessage> messages) {
  final out = <AgentPair, ObservedEdge>{};
  for (final m in messages) {
    if (m.fromTabId == m.toTabId) continue;
    final key = agentPair(m.fromTabId, m.toTabId);
    out[key] = ObservedEdge((out[key]?.count ?? 0) + 1, m);
  }
  return out;
}

/// Grafo de agentes por workspace: posições dos nós no canvas e os links
/// **definidos** pelo usuário (topologia). Cabos observados não moram aqui —
/// derivam do `AgentMessageLog` ([observedEdges]).
class AgentGraphStore extends ChangeNotifier {
  AgentGraphStore({this.onWorkspaceChanged});

  /// Avisado a cada mudança de um workspace (a VM agenda a gravação do layout).
  final void Function(String workspaceId)? onWorkspaceChanged;

  final Map<String, Map<String, Offset>> _positions = {};
  final Map<String, Set<AgentPair>> _links = {};

  /// Maestro do workspace (no máximo um): ligado a todos os agentes.
  final Map<String, String> _maestro = {};

  /// Cor escolhida no "New agent" (ARGB), sobrepõe [agentColorFor].
  final Map<String, Map<String, int>> _colors = {};

  /// Abas com "Monitor activity" desligado: sem badge/som/notificação de fim.
  final Map<String, Set<String>> _unmonitored = {};

  /// Nós externos (apps desktop via MCP) por workspace, por id `ext:<app>`.
  /// Participam de links/maestro/cor como as abas.
  final Map<String, Map<String, ExternalAgent>> _externals = {};

  Iterable<ExternalAgent> get externals =>
      _externals.values.expand((m) => m.values);

  List<ExternalAgent> externalsOf(String ws) => [...?_externals[ws]?.values];

  ExternalAgent? externalById(String id) {
    for (final m in _externals.values) {
      if (m[id] case final e?) return e;
    }
    return null;
  }

  /// Põe [app] no canvas de [ws]. Um nó por app no Cockpit inteiro (a entrada
  /// MCP do app é uma só): se já estava em outro workspace, sai de lá.
  ExternalAgent addExternal(
    String ws,
    DesktopAgentApp app, {
    required String label,
    required String workingDirectory,
  }) {
    final id = ExternalAgent.idFor(app);
    for (final other in [..._externals.keys]) {
      removeExternal(other, id);
    }
    final e = ExternalAgent(
      app: app,
      projectId: ws,
      workingDirectory: workingDirectory,
      label: label,
    );
    _externals.putIfAbsent(ws, () => {})[id] = e;
    _changed(ws);
    return e;
  }

  /// Tira o nó externo [id] do canvas com seus links, posição, cor e maestro.
  void removeExternal(String ws, String id) {
    final e = _externals[ws]?.remove(id);
    if (e == null) return;
    _links[ws]?.removeWhere((p) => p.$1 == id || p.$2 == id);
    if (_maestro[ws] == id) _maestro.remove(ws);
    _positions[ws]?.remove(id);
    _colors[ws]?.remove(id);
    e.dispose();
    _changed(ws);
  }

  void renameExternal(String id, String label) {
    final e = externalById(id);
    if (e == null) return;
    e.setManualLabel(label);
    _changed(e.projectId);
  }

  String? maestroOf(String ws) => _maestro[ws];

  /// Cor do agente [tabId] em todo lugar (nó, cabo, árvore de arquivos): a
  /// escolhida, senão a do hash. Tab-ids são únicos entre workspaces.
  Color colorOf(String tabId) {
    for (final m in _colors.values) {
      if (m[tabId] case final argb?) return Color(argb);
    }
    return agentColorFor(tabId);
  }

  void setColor(String ws, String tabId, Color color) {
    _colors.putIfAbsent(ws, () => {})[tabId] = color.toARGB32();
    _changed(ws);
  }

  bool isMonitored(String tabId) =>
      !_unmonitored.values.any((s) => s.contains(tabId));

  void setMonitored(String ws, String tabId, bool monitored) {
    final set = _unmonitored.putIfAbsent(ws, () => {});
    if (monitored ? set.remove(tabId) : set.add(tabId)) _changed(ws);
  }

  /// Promove [tabId] a maestro (rebaixa o anterior) e o liga a cada um de
  /// [agents]. Devolve os ids ligados agora (links que já existiam ficam fora:
  /// esses pares já se conhecem).
  List<String> setMaestro(String ws, String tabId, Iterable<String> agents) {
    _maestro[ws] = tabId;
    final set = _links.putIfAbsent(ws, () => {});
    final added = [
      for (final id in agents)
        if (id != tabId && set.add(agentPair(tabId, id))) id,
    ];
    _changed(ws);
    return added;
  }

  void clearMaestro(String ws) {
    if (_maestro.remove(ws) != null) _changed(ws);
  }

  Map<String, Offset> positionsOf(String ws) =>
      Map.unmodifiable(_positions[ws] ?? const <String, Offset>{});

  Set<AgentPair> linksOf(String ws) =>
      Set.unmodifiable(_links[ws] ?? const <AgentPair>{});

  bool isLinked(String ws, String a, String b) =>
      _links[ws]?.contains(agentPair(a, b)) ?? false;

  /// Abas ligadas a [tabId] por link definido.
  List<String> peersOf(String ws, String tabId) => [
    for (final (a, b) in _links[ws] ?? const <AgentPair>{})
      if (a == tabId) b else if (b == tabId) a,
  ];

  void setPosition(String ws, String tabId, Offset position) {
    _positions.putIfAbsent(ws, () => {})[tabId] = position;
    _changed(ws);
  }

  /// Cria o link [a]–[b]. `false` = laço ou link já existente (nada mudou).
  bool addLink(String ws, String a, String b) {
    if (a == b || !_links.putIfAbsent(ws, () => {}).add(agentPair(a, b))) {
      return false;
    }
    _changed(ws);
    return true;
  }

  void removeLink(String ws, String a, String b) {
    if (_links[ws]?.remove(agentPair(a, b)) ?? false) _changed(ws);
  }

  /// Dá posição de grade aos [ids] que ainda não têm: primeira célula livre
  /// (nenhum nó a menos de meia célula). Nós novos não nascem empilhados.
  /// Devolve os ids posicionados agora (nós que o canvas acabou de ver).
  List<String> placeMissing(String ws, Iterable<String> ids) {
    final map = _positions.putIfAbsent(ws, () => {});
    final missing = ids.where((id) => !map.containsKey(id)).toList();
    if (missing.isEmpty) return missing;
    var slot = 0;
    for (final id in missing) {
      Offset at;
      do {
        at = Offset(
          kGraphOrigin + (slot % kGraphColumns) * kGraphCellWidth,
          kGraphOrigin + (slot ~/ kGraphColumns) * kGraphCellHeight,
        );
        slot++;
      } while (map.values.any(
        (p) =>
            (p - at).dx.abs() < kGraphCellWidth / 2 &&
            (p - at).dy.abs() < kGraphCellHeight / 2,
      ));
      map[id] = at;
    }
    _changed(ws);
    return missing;
  }

  /// JSON do workspace, já **sem** o que referencia abas mortas ([tabs]); os
  /// nós externos contam como vivos.
  Map<String, Object?> toJson(String ws, Set<String> tabs) {
    final live = {...tabs, ...?_externals[ws]?.keys};
    return _toJson(ws, live);
  }

  Map<String, Object?> _toJson(String ws, Set<String> live) => {
    'positions': {
      for (final e in (_positions[ws] ?? const <String, Offset>{}).entries)
        if (live.contains(e.key)) e.key: [e.value.dx, e.value.dy],
    },
    'links': [
      for (final (a, b) in _links[ws] ?? const <AgentPair>{})
        if (live.contains(a) && live.contains(b)) [a, b],
    ],
    if (_maestro[ws] case final m? when live.contains(m)) 'maestro': m,
    'colors': {
      for (final e in (_colors[ws] ?? const <String, int>{}).entries)
        if (live.contains(e.key)) e.key: e.value,
    },
    'unmonitored': [
      for (final id in _unmonitored[ws] ?? const <String>{})
        if (live.contains(id)) id,
    ],
    'externals': [
      for (final e in externalsOf(ws))
        {'app': e.app.id, 'label': e.displayTitle, 'cwd': e.workingDirectory},
    ],
  };

  /// Re-hidrata do doc de layout. [remap] = ids de aba trocados no restore
  /// (colisão entre workspaces); entrada malformada é ignorada.
  void restore(
    String ws,
    Object? json, {
    Map<String, String> remap = const {},
  }) {
    _positions.remove(ws);
    _links.remove(ws);
    _maestro.remove(ws);
    _colors.remove(ws);
    _unmonitored.remove(ws);
    for (final e in _externals.remove(ws)?.values ?? const <ExternalAgent>[]) {
      e.dispose();
    }
    if (json is! Map) return;
    String id(Object? raw) => remap[raw] ?? raw.toString();
    final positions = json['positions'];
    if (positions is Map) {
      final map = _positions.putIfAbsent(ws, () => {});
      for (final e in positions.entries) {
        final v = e.value;
        if (v is List && v.length == 2 && v[0] is num && v[1] is num) {
          map[id(e.key)] = Offset(
            (v[0] as num).toDouble(),
            (v[1] as num).toDouble(),
          );
        }
      }
    }
    final links = json['links'];
    if (links is List) {
      final set = _links.putIfAbsent(ws, () => {});
      for (final l in links) {
        if (l is List && l.length == 2 && l[0] is String && l[1] is String) {
          if (l[0] != l[1]) set.add(agentPair(id(l[0]), id(l[1])));
        }
      }
    }
    if (json['maestro'] case final String m) _maestro[ws] = id(m);
    if (json['colors'] case final Map colors) {
      _colors[ws] = {
        for (final e in colors.entries)
          if (e.value is int) id(e.key): e.value as int,
      };
    }
    if (json['unmonitored'] case final List ids) {
      _unmonitored[ws] = {for (final i in ids.whereType<String>()) id(i)};
    }
    // ponytail: o mesmo app restaurado em dois workspaces fica nos dois;
    // `externalById` acha o primeiro. Re-adicionar pelo dialog resolve.
    if (json['externals'] case final List list) {
      for (final raw in list) {
        if (raw case {'app': final String appId, 'label': final String label}) {
          final app = DesktopAgentApp.fromId(appId);
          if (app == null) continue;
          _externals.putIfAbsent(ws, () => {})[ExternalAgent.idFor(
            app,
          )] = ExternalAgent(
            app: app,
            projectId: ws,
            workingDirectory: raw['cwd'] is String ? raw['cwd'] : '',
            label: label,
          );
        }
      }
    }
  }

  @override
  void dispose() {
    for (final e in [...externals]) {
      e.dispose();
    }
    super.dispose();
  }

  void _changed(String ws) {
    notifyListeners();
    onWorkspaceChanged?.call(ws);
  }
}

/// Geometria da grade de auto-posicionamento (coordenadas de cena do canvas).
const double kGraphOrigin = 80;
const int kGraphColumns = 4;
const double kGraphCellWidth = 280;
const double kGraphCellHeight = 170;

/// Um agente na saída de `peers`/`agents` (CLI e MCP).
Map<String, Object?> agentInfo(AgentGraphStore graph, String ws, PaneItem p) =>
    {
      'id': p.id,
      'label': p.manualLabel,
      'title': p.title,
      'harness': p is TerminalSession ? p.activeHarness?.name : null,
      'working': p.isWorking,
      'maestro': graph.maestroOf(ws) == p.id,
      if (p is ExternalAgent) ...{'app': p.app.id, 'online': p.online},
    };

/// Saída do `cockpit peers`: os links definidos de [caller] que ainda existem
/// (abas de [sessions] ou nós externos).
List<Map<String, Object?>> agentPeers(
  AgentGraphStore graph,
  PaneItem caller,
  Iterable<PaneItem> sessions,
) {
  final byId = {
    for (final s in [...sessions, ...graph.externals]) s.id: s,
  };
  return [
    for (final id in graph.peersOf(caller.projectId, caller.id))
      if (byId[id] case final peer?) agentInfo(graph, caller.projectId, peer),
  ];
}

/// Nós do canvas de [ws]: abas com agente detectado + nós externos.
List<PaneItem> workspaceAgentNodes(
  AgentGraphStore graph,
  String ws,
  Iterable<PaneItem> sessions,
) => [
  for (final s in sessions)
    if (s is TerminalSession && s.projectId == ws && s.activeHarness != null) s,
  ...graph.externalsOf(ws),
];

/// Saída do `agents` (o `list_agents` do MCP): todo agente do workspace de
/// [caller], com `linked` = ligado a ele.
List<Map<String, Object?>> workspaceAgentList(
  AgentGraphStore graph,
  PaneItem caller,
  Iterable<PaneItem> sessions,
) {
  final ws = caller.projectId;
  return [
    for (final p in workspaceAgentNodes(graph, ws, sessions))
      if (p.id != caller.id)
        {
          ...agentInfo(graph, ws, p),
          'linked': graph.isLinked(ws, caller.id, p.id),
        },
  ];
}
