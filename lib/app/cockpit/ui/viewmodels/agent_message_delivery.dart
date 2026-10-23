import 'dart:async' show Timer;

import 'package:cockpit/app/cockpit/domain/entities/agent_message.dart';
import 'package:cockpit/app/cockpit/ui/session/external_agent.dart';
import 'package:cockpit/app/cockpit/ui/session/pane_item.dart';
import 'package:cockpit/app/cockpit/ui/session/terminal_session.dart';
import 'package:cockpit/app/cockpit/ui/viewmodels/agent_message_log.dart';
import 'package:cockpit/app/core/domain/entities/harness.dart';

/// Pausa entre o texto e o Enter: TUIs (o claude entre elas) tratam um write
/// único com `\r` no fim como colagem, não como submit. Mesma folga do
/// `scripts/cockpit-dispatch.sh`.
const Duration kAgentMessageSubmitDelay = Duration(milliseconds: 400);

/// Caminho único de entrega entre agentes (`cockpit msg` e as apresentações
/// do grafo), assinado como [senderName] · [senderHarness]. Terminal: digita
/// `[from: …] <text>` em [target] e aperta Enter depois do delay; [paste] manda
/// como colagem (bracketed paste, se o TUI pediu): texto multilinha não
/// submete no meio. Nó externo ([ExternalAgent]): vai pra fila dele (sai no
/// `wait_messages` do MCP). Registra [text] no [log] como [from] → [target].
void deliverAgentMessage({
  required AgentMessageLog log,
  required PaneItem from,
  required PaneItem target,
  required String senderName,
  required String? senderHarness,
  required String text,
  required bool Function() targetAlive,
  bool paste = false,
}) {
  switch (target) {
    case ExternalAgent():
      target.enqueue(AgentMessage.signature(senderName, senderHarness), text);
    case TerminalSession():
      final line = AgentMessage.formatLine(
        senderName: senderName,
        senderHarness: senderHarness,
        text: text,
      );
      paste ? target.terminal.paste(line) : target.insertText(line);
      Timer(kAgentMessageSubmitDelay, () {
        // A aba pode ter fechado na janela do delay: PTY morto não recebe.
        if (targetAlive()) target.insertText('\r');
      });
    default:
      return;
  }
  log.record(
    fromTabId: from.id,
    fromWorkspaceId: from.projectId,
    toTabId: target.id,
    toWorkspaceId: target.projectId,
    text: text,
    signedBy: AgentMessage.signature(senderName, senderHarness),
  );
}

/// Nome do harness da aba ou do app desktop do nó externo (assinatura das
/// mensagens e apresentações).
String? agentKindLabel(PaneItem p) => switch (p) {
  TerminalSession(:final activeHarness?) =>
    HarnessCatalog.getSpec(activeHarness)?.label ?? activeHarness.name,
  ExternalAgent(:final app) => app.label,
  _ => null,
};

/// Por onde um agente fala com os outros — muda o texto das apresentações.
enum AgentChannel {
  /// `cockpit msg` / `cockpit peers` no terminal.
  shell,

  /// Nó externo (app desktop): ferramentas do MCP; nada é empurrado, as
  /// respostas esperam o `wait_messages`.
  mcpQueue,

  /// Codex numa aba: o sandbox dele bloqueia a CLI de shell (env e socket),
  /// então fala pelas ferramentas do servidor MCP `cockpit`; o que chega pra
  /// ele continua sendo digitado no terminal.
  mcpTab,
}

AgentChannel agentChannel(PaneItem p) => switch (p) {
  ExternalAgent() => AgentChannel.mcpQueue,
  TerminalSession(activeHarness: HarnessKind.codex) => AgentChannel.mcpTab,
  _ => AgentChannel.shell,
};

/// [selfId] = a aba que recebe: o MCP do Codex é spawnado pelo daemon dele,
/// fora da aba, e só sabe quem chama pelo `from` (ver `resolveMcpFrom`).
String _mcpTabNote(String selfId) =>
    'You are Cockpit tab $selfId. Use the tools of the `cockpit` MCP server '
    '(the `cockpit` shell commands are blocked by your sandbox), and always '
    'pass from: "$selfId" when calling them.';

/// Apresentação que [self] recebe ao ser ligado a [peer] no grafo. Texto pro
/// agente (inglês de propósito, como toda saída da CLI). [via] = o canal de
/// quem RECEBE ([agentChannel] dele); [selfId] = o id dele (usado no
/// [AgentChannel.mcpTab]).
String linkIntroText(
  PaneItem peer, {
  AgentChannel via = AgentChannel.shell,
  String selfId = '',
}) {
  final name = agentKindLabel(peer);
  final raw = peer.manualLabel ?? peer.id;
  // Label com espaço/parêntese ("Claude Desktop", "Codex (ChatGPT)") quebraria
  // o `--to` no shell: vai entre aspas.
  final address = RegExp(r'^[\w.:-]+$').hasMatch(raw) ? raw : '"$raw"';
  return 'You are now connected to ${peer.displayTitle}'
      '${name == null ? '' : ' ($name)'}. '
      '${switch (via) {
        AgentChannel.shell => 'Talk to it with: cockpit msg --to $address "..."',
        AgentChannel.mcpQueue => 'Talk to it with the send tool (to: $address); its replies are queued for you: collect them with wait_messages.',
        AgentChannel.mcpTab => '${_mcpTabNote(selfId)} Talk to it with the send tool (to: $address); its replies are typed into your terminal (wait_messages also returns them).',
      }}';
}

/// Apresentação que o maestro recebe: todos os [peers] e como coordená-los.
/// [via] = o canal do maestro ([agentChannel]); [selfId] = o id dele.
String maestroIntroText(
  Iterable<PaneItem> peers, {
  AgentChannel via = AgentChannel.shell,
  String selfId = '',
}) {
  final list = [
    for (final p in peers)
      switch (agentKindLabel(p)) {
        final kind? => '${p.manualLabel ?? p.id} ($kind)',
        null => p.manualLabel ?? p.id,
      },
  ];
  return 'You are the maestro of this workspace: you are connected to every '
      'agent on the canvas and coordinate them. Agents: '
      '${list.isEmpty ? '(none yet)' : list.join(', ')}. '
      '${switch (via) {
        AgentChannel.shell => 'Message one with: cockpit msg --to <label> "..."; list them anytime with: cockpit peers',
        AgentChannel.mcpQueue => 'Message one with the send tool (to: <label>). Replies are not pushed to you: they are queued, so call wait_messages after dispatching work to collect them. List agents anytime with peers (connected) or list_agents (whole workspace).',
        AgentChannel.mcpTab => '${_mcpTabNote(selfId)} Message one with the send tool (to: <label>); replies are typed into your terminal (wait_messages also returns them). List agents anytime with peers (connected) or list_agents (whole workspace).',
      }}';
}

/// Intervalo entre mensagens seguidas pro MESMO alvo: a anterior precisa
/// receber o Enter ([kAgentMessageSubmitDelay]) antes da próxima ser digitada.
const Duration kAgentMessageQueueGap = Duration(milliseconds: 1200);

/// Entrega [items] (`(from, text)`) em ordem pra [target], como
/// `[from: cockpit] <text>`, espaçadas por [kAgentMessageQueueGap].
// ponytail: espaçamento fixo, sem fila por alvo — duas rajadas pro mesmo alvo
// ao mesmo tempo ainda podem se misturar; fila real se isso aparecer.
void deliverQueued({
  required AgentMessageLog log,
  required PaneItem target,
  required List<(PaneItem, String)> items,
  required bool Function() targetAlive,
}) {
  // Fila de nó externo não tem Enter a esperar: tudo de uma vez.
  final gap = target is ExternalAgent ? Duration.zero : kAgentMessageQueueGap;
  for (final (i, (from, text)) in items.indexed) {
    Timer(gap * i, () {
      if (!targetAlive()) return;
      deliverAgentMessage(
        log: log,
        from: from,
        target: target,
        senderName: 'cockpit',
        senderHarness: null,
        text: text,
        targetAlive: targetAlive,
        paste: true,
      );
    });
  }
}

/// Manda a apresentação pros dois lados de um link novo [a]–[b]. Cada uma é
/// registrada como vinda do par apresentado (o cabo pulsa na criação).
void sendLinkIntros({
  required AgentMessageLog log,
  required PaneItem a,
  required PaneItem b,
  required bool Function(PaneItem) alive,
}) {
  for (final (self, peer) in [(a, b), (b, a)]) {
    final text = linkIntroText(peer, via: agentChannel(self), selfId: self.id);
    deliverAgentMessage(
      log: log,
      from: peer,
      target: self,
      senderName: 'cockpit',
      senderHarness: null,
      text: text,
      targetAlive: () => alive(self),
    );
  }
}
