import 'dart:async' show Timer, unawaited;

import 'package:gsh_desktop/app/gsh/domain/entities/desktop_agent_app.dart';
import 'package:gsh_desktop/app/gsh/ui/actions/tab_actions.dart';
import 'package:gsh_desktop/app/gsh/ui/session/external_agent.dart';
import 'package:gsh_desktop/app/gsh/ui/session/pane_item.dart';
import 'package:gsh_desktop/app/gsh/ui/session/terminal_session.dart';
import 'package:gsh_desktop/app/gsh/ui/states/pane_node.dart';
import 'package:gsh_desktop/app/gsh/ui/viewmodels/agent_graph_store.dart';
import 'package:gsh_desktop/app/gsh/ui/viewmodels/agent_message_delivery.dart';
import 'package:gsh_desktop/app/gsh/ui/viewmodels/gsh_viewmodel.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/new_agent_dialog.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/realm_dialogs.dart';
import 'package:gsh_desktop/app/core/domain/result.dart';
import 'package:gsh_desktop/app/core/ui/widgets/app_menu.dart';
import 'package:gsh_desktop/i18n/strings.g.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

/// Rótulos manuais em uso (minúsculos). Globais de propósito: o `--to` do
/// `gsh msg` resolve label entre TODAS as abas, não só do workspace.
Set<String> takenLabels(Iterable<PaneItem> tabs, {String? except}) => {
  for (final t in tabs)
    if (t.id != except)
      if (t.manualLabel case final l?) l.toLowerCase(),
};

/// [base], ou `base 2`, `base 3`… — o primeiro livre em [taken] (minúsculos).
String defaultAgentName(String base, Set<String> taken) {
  if (!taken.contains(base.toLowerCase())) return base;
  for (var n = 2; ; n++) {
    final name = '$base $n';
    if (!taken.contains(name.toLowerCase())) return name;
  }
}

/// Terminal novo **ao lado** do grafo: outra pane se houver, senão split à
/// direita (o canvas segue visível). Devolve o id da aba criada.
String? launchAgentBeside(
  GshViewModel vm,
  String workspaceId,
  String graphTabId, {
  required String cwd,
  String? command,
  String? label,
}) {
  final tree = vm.tree(workspaceId);
  final mine = vm.leafOfTab(workspaceId, graphTabId);
  final other = tree == null
      ? null
      : leaves(tree).map((l) => l.id).where((id) => id != mine).firstOrNull;
  final res = vm.newTerminalTab(
    cwd: cwd,
    title: label,
    startupCommand: command,
    inPane: other ?? mine,
    splitDir: other == null ? SplitDir.vertical : null,
  );
  return res is Success<String, String> ? res.value : null;
}

/// Agentes do workspace — os nós do canvas: abas com harness detectado e os
/// nós externos (apps desktop).
List<PaneItem> workspaceAgents(GshViewModel vm, String ws) =>
    workspaceAgentNodes(vm.agentGraph, ws, vm.allSessions);

/// Tudo que um `--to`/label alcança: abas e nós externos.
List<PaneItem> addressableAgents(GshViewModel vm) => [
  ...vm.allSessions,
  ...vm.agentGraph.externals,
];

/// Nó do grafo por id: aba ou nó externo.
PaneItem? agentById(GshViewModel vm, String id) =>
    vm.session(id) ?? vm.agentGraph.externalById(id);

bool _alive(GshViewModel vm, PaneItem s) =>
    identical(agentById(vm, s.id), s);

List<PaneItem> _peers(GshViewModel vm, String ws, PaneItem s) => [
  ...vm.agentGraph.peersOf(ws, s.id).map((id) => agentById(vm, id)).nonNulls,
];

/// Folga entre o harness ser detectado e a primeira mensagem: a TUI ainda
/// está desenhando quando o processo aparece.
// ponytail: espera fixa; troque por "primeiro prompt desenhado" se perder input.
const Duration kAgentBootSettle = Duration(seconds: 2);

/// Roda [run] uma vez, quando [s] tiver harness detectado e estiver ocioso.
void whenAgentReady(TerminalSession s, VoidCallback run) {
  void check() {
    if (s.activeHarness == null || s.status != TerminalStatus.idle) return;
    s.removeListener(check);
    Timer(kAgentBootSettle, run);
  }

  s.addListener(check);
  check();
}

/// Cria o agente do dialog "New agent": aba com label/cwd/comando, posição,
/// cor, monitor e links (maestro liga a todos; os outros, ao maestro atual).
/// Role, tarefa e apresentações vão quando o harness subir e ficar ocioso.
String? createAgent(
  GshViewModel vm,
  String ws,
  String graphTabId,
  NewAgentDraft d, {
  Offset? at,
}) {
  final id = launchAgentBeside(
    vm,
    ws,
    graphTabId,
    cwd: d.cwd,
    command: d.command.isEmpty ? null : d.command,
    label: d.label.isEmpty ? null : d.label,
  );
  final s = id == null ? null : vm.session(id);
  if (s is! TerminalSession) return null;
  if (!d.monitor) vm.agentGraph.setMonitored(ws, s.id, false);
  final linked = _attach(vm, ws, s, d, at: at);
  if (d.role.isEmpty && d.task.isEmpty && linked.isEmpty) return s.id;
  whenAgentReady(s, () {
    if (_alive(vm, s)) _greet(vm, ws, s, d, linked);
  });
  return s.id;
}

/// Desktop app do dialog: nó externo no canvas (com cor/maestro/links), o app
/// aberto e role/tarefa/apresentações já na fila dele (o app as lê com
/// `wait_messages` quando carregar o MCP). A integração (config MCP) roda
/// antes, em quem chama.
ExternalAgent createExternalAgent(
  GshViewModel vm,
  String ws,
  DesktopAgentApp app,
  NewAgentDraft d, {
  Offset? at,
}) {
  final e = vm.agentGraph.addExternal(
    ws,
    app,
    label: d.label.isEmpty ? app.label : d.label,
    workingDirectory: d.cwd,
  );
  _greet(vm, ws, e, d, _attach(vm, ws, e, d, at: at));
  unawaited(vm.desktopApps.launch(app, d.cwd));
  return e;
}

/// Posição, cor e links do nó novo [s] (maestro liga a todos; os outros, ao
/// maestro atual). Devolve os ligados agora.
List<PaneItem> _attach(
  GshViewModel vm,
  String ws,
  PaneItem s,
  NewAgentDraft d, {
  Offset? at,
}) {
  final g = vm.agentGraph;
  if (at != null) g.setPosition(ws, s.id, at);
  if (d.color case final c?) g.setColor(ws, s.id, c);
  if (d.maestro) {
    final ids = g.setMaestro(
      ws,
      s.id,
      workspaceAgents(vm, ws).map((a) => a.id),
    );
    return [...ids.map((id) => agentById(vm, id)).nonNulls];
  }
  final maestro = agentById(vm, g.maestroOf(ws) ?? '');
  return [
    if (maestro != null &&
        maestro.id != s.id &&
        g.addLink(ws, s.id, maestro.id))
      maestro,
  ];
}

/// Primeiras mensagens do nó novo [s]: role, tarefa e a apresentação (lista
/// de pares, se maestro); e [s] apresentado a cada um de [linked].
void _greet(
  GshViewModel vm,
  String ws,
  PaneItem s,
  NewAgentDraft d,
  List<PaneItem> linked,
) {
  final via = agentChannel(s);
  deliverQueued(
    log: vm.agentMessages,
    target: s,
    targetAlive: () => _alive(vm, s),
    items: [
      if (d.role.isNotEmpty) (s, d.role),
      if (d.task.isNotEmpty) (s, d.task),
      if (d.maestro)
        (s, maestroIntroText(_peers(vm, ws, s), via: via, selfId: s.id))
      else
        for (final p in linked) (p, linkIntroText(p, via: via, selfId: s.id)),
    ],
  );
  for (final p in linked) {
    _introduce(vm, p, s);
  }
}

/// [self] recebe a apresentação de [peer] (link novo).
void _introduce(GshViewModel vm, PaneItem self, PaneItem peer) =>
    deliverQueued(
      log: vm.agentMessages,
      target: self,
      targetAlive: () => _alive(vm, self),
      items: [
        (peer, linkIntroText(peer, via: agentChannel(self), selfId: self.id)),
      ],
    );

/// Promove [s] (agente já no canvas) a maestro: liga a todos, apresenta-o aos
/// recém-ligados e manda a ele a lista completa.
void makeMaestro(GshViewModel vm, String ws, PaneItem s) {
  final g = vm.agentGraph;
  final added = g.setMaestro(
    ws,
    s.id,
    workspaceAgents(vm, ws).map((a) => a.id),
  );
  for (final p in added.map((id) => agentById(vm, id)).nonNulls) {
    _introduce(vm, p, s);
  }
  deliverQueued(
    log: vm.agentMessages,
    target: s,
    targetAlive: () => _alive(vm, s),
    items: [
      (
        s,
        maestroIntroText(_peers(vm, ws, s), via: agentChannel(s), selfId: s.id),
      ),
    ],
  );
}

/// Nós que o canvas acabou de ver ([ids]) se ligam ao maestro atual.
void linkToMaestro(GshViewModel vm, String ws, Iterable<String> ids) {
  final m = agentById(vm, vm.agentGraph.maestroOf(ws) ?? '');
  if (m == null) return;
  final fresh = [
    for (final s in ids.map((id) => agentById(vm, id)).nonNulls)
      if (s.id != m.id && vm.agentGraph.addLink(ws, s.id, m.id)) s,
  ];
  if (fresh.isEmpty) return;
  for (final s in fresh) {
    _introduce(vm, s, m);
  }
  deliverQueued(
    log: vm.agentMessages,
    target: m,
    targetAlive: () => _alive(vm, m),
    items: [
      for (final s in fresh)
        (s, linkIntroText(s, via: agentChannel(m), selfId: m.id)),
    ],
  );
}

/// Liga [a]–[b] no grafo; link novo apresenta um ao outro pelo caminho do
/// `gsh msg`.
void connectAgents(
  GshViewModel vm,
  String workspaceId,
  PaneItem a,
  PaneItem b,
) {
  if (!vm.agentGraph.addLink(workspaceId, a.id, b.id)) return;
  sendLinkIntros(
    log: vm.agentMessages,
    a: a,
    b: b,
    alive: (s) => _alive(vm, s),
  );
}

/// Foca a aba [tabId] do workspace selecionado.
void focusAgentTab(GshViewModel vm, String workspaceId, String tabId) {
  final leaf = vm.leafOfTab(workspaceId, tabId);
  if (leaf != null) vm.selectTab(leaf, tabId);
}

/// Clique no nó: foca a aba; nó externo abre/traz o app pra frente.
void focusAgent(GshViewModel vm, String ws, PaneItem s) =>
    s is ExternalAgent
    ? unawaited(vm.desktopApps.launch(s.app, s.workingDirectory))
    : focusAgentTab(vm, ws, s.id);

/// Clique direito num nó: focar, renomear, maestro, fechar a aba (nó externo:
/// tirar do canvas).
Future<void> showAgentNodeMenu(
  BuildContext context,
  GshViewModel vm,
  String ws,
  PaneItem s,
  Offset globalPosition,
) async {
  final tr = context.t.gsh.agentGraph;
  final isMaestro = vm.agentGraph.maestroOf(ws) == s.id;
  final pick = await showAppMenu<String>(
    context,
    globalPosition: globalPosition,
    items: [
      AppMenuItem(value: 'focus', label: tr.focus, icon: Icons.open_in_new),
      AppMenuItem(value: 'rename', label: tr.rename, icon: Icons.edit_outlined),
      AppMenuItem(
        value: 'maestro',
        label: isMaestro ? tr.removeMaestro : tr.makeMaestro,
        icon: Icons.workspace_premium_outlined,
      ),
      const AppMenuItem.divider(),
      AppMenuItem(
        value: 'close',
        label: s is ExternalAgent ? tr.removeFromCanvas : tr.closeTab,
        icon: Icons.close,
        danger: true,
      ),
    ],
  );
  if (!context.mounted) return;
  switch (pick) {
    case 'focus':
      focusAgent(vm, ws, s);
    case 'rename':
      final name = await showRealmNameDialog(
        context,
        title: tr.renameTitle,
        confirmLabel: tr.rename,
        takenNames: takenLabels(addressableAgents(vm), except: s.id),
        initial: s.manualLabel ?? s.displayTitle,
        placeholder: tr.name,
        duplicateMessage: tr.nameTaken,
      );
      if (name == null || !_alive(vm, s)) return;
      s is ExternalAgent
          ? vm.agentGraph.renameExternal(s.id, name)
          : vm.setPaneLabel(s.id, name);
    case 'maestro':
      isMaestro ? vm.agentGraph.clearMaestro(ws) : makeMaestro(vm, ws, s);
    case 'close' when s is ExternalAgent:
      vm.agentGraph.removeExternal(ws, s.id);
    case 'close':
      final leaf = vm.leafOfTab(ws, s.id);
      if (leaf != null) {
        await requestCloseTab(context, s, () => vm.closeTab(leaf, s.id));
      }
  }
}
