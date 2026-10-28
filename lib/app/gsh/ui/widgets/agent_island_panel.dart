import 'package:gsh_desktop/app/core/domain/entities/harness.dart';
import 'package:gsh_desktop/app/core/ui/themes/themes.dart';
import 'package:gsh_desktop/app/core/ui/widgets/app_tooltip.dart';
import 'package:gsh_desktop/app/core/ui/widgets/hover_tap.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/agent_permission.dart';
import 'package:gsh_desktop/app/gsh/ui/viewmodels/chat_viewmodel.dart'
    show toolSummary;
import 'package:gsh_desktop/app/gsh/ui/widgets/agent_island.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/agent_node_card.dart'
    show HarnessIcon;
import 'package:gsh_desktop/i18n/strings.g.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

/// A ilha aberta: pedidos de permissão primeiro (com os botões), depois quem
/// espera por você, quem terminou e quem trabalha. Clique numa linha vai até
/// a aba.
class AgentIslandPanel extends StatelessWidget {
  const AgentIslandPanel({
    super.key,
    required this.agents,
    required this.asks,
    required this.onDecide,
    required this.onReveal,
  });

  final List<IslandAgent> agents;
  final List<AgentPermissionAsk> asks;
  final void Function(String id, AgentPermissionDecision decision) onDecide;
  final ValueChanged<String> onReveal;

  static const width = 380.0;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tr = context.t.gsh.agentIsland;
    final asked = {for (final a in asks) a.tabId};
    final byTab = {for (final a in agents) a.tabId: a};
    List<IslandAgent> rows(IslandAgentState s) => [
      for (final a in agents)
        if (a.state == s && !asked.contains(a.tabId)) a,
    ];
    final waiting = rows(IslandAgentState.waiting);
    final finished = rows(IslandAgentState.finished);
    final working = rows(IslandAgentState.working);
    return Container(
      width: width,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.7,
      ),
      decoration: BoxDecoration(
        color: colors.panel,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.border2),
        boxShadow: [BoxShadow(color: colors.shadow, blurRadius: 18)],
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (asks.isNotEmpty) ...[
              _Header(tr.asks, colors.warn),
              for (final ask in asks)
                _AskCard(
                  ask: ask,
                  agent: byTab[ask.tabId],
                  onDecide: (d) => onDecide(ask.id, d),
                  // Devolve a pergunta ao terminal e vai até ele.
                  onTerminal: () {
                    onDecide(ask.id, AgentPermissionDecision.pass);
                    onReveal(ask.tabId);
                  },
                ),
            ],
            if (waiting.isNotEmpty) ...[
              _Header(tr.waiting, colors.warn),
              for (final a in waiting)
                _AgentRow(
                  a,
                  color: colors.warn,
                  onTap: () => onReveal(a.tabId),
                  trailing: Text(
                    tr.goToTab,
                    style: context.typo.label.copyWith(
                      fontSize: 12,
                      color: colors.warn,
                    ),
                  ),
                ),
            ],
            if (finished.isNotEmpty) ...[
              _Header(tr.finished, colors.online),
              for (final a in finished)
                _AgentRow(
                  a,
                  color: colors.online,
                  onTap: () => onReveal(a.tabId),
                ),
            ],
            if (working.isNotEmpty) ...[
              _Header(tr.working, colors.accent),
              for (final a in working)
                _AgentRow(
                  a,
                  color: colors.accent,
                  compact: true,
                  onTap: () => onReveal(a.tabId),
                ),
            ],
            if (asks.isEmpty && agents.isEmpty)
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  tr.empty,
                  style: context.typo.body.copyWith(color: colors.text3),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header(this.label, this.color);
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(8, 6, 8, 4),
    child: Text(
      label.toUpperCase(),
      style: context.typo.label.copyWith(
        fontSize: 10.5,
        letterSpacing: 0.6,
        fontWeight: FontWeight.w600,
        color: color,
      ),
    ),
  );
}

/// Ícone do harness, ou a bolinha na cor do estado.
class _Leading extends StatelessWidget {
  const _Leading(this.harness, this.color);
  final HarnessKind? harness;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final spec = harness == null ? null : HarnessCatalog.getSpec(harness!);
    return SizedBox.square(
      dimension: 16,
      child: Center(
        child: spec != null
            ? HarnessIcon(spec, size: 14, color: context.colors.text2)
            : Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
      ),
    );
  }
}

/// Nome do agente + workspace, numa linha.
class _Title extends StatelessWidget {
  const _Title(this.title, this.workspace, {this.compact = false});
  final String title;
  final String workspace;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.typo.body.copyWith(
              fontSize: compact ? 12.5 : 13,
              color: compact ? colors.text2 : colors.text,
            ),
          ),
        ),
        if (workspace.isNotEmpty) ...[
          const SizedBox(width: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 120),
            child: Text(
              workspace,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.typo.label.copyWith(
                fontSize: 11.5,
                color: colors.text3,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _AgentRow extends StatelessWidget {
  const _AgentRow(
    this.agent, {
    required this.color,
    required this.onTap,
    this.trailing,
    this.compact = false,
  });

  final IslandAgent agent;
  final Color color;
  final VoidCallback onTap;
  final Widget? trailing;
  final bool compact;

  @override
  Widget build(BuildContext context) => HoverTap(
    onTap: onTap,
    borderRadius: BorderRadius.circular(7),
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: compact ? 4 : 7),
    child: Row(
      children: [
        _Leading(agent.harness, color),
        const SizedBox(width: 8),
        Expanded(child: _Title(agent.title, agent.workspace, compact: compact)),
        if (trailing case final t?) ...[const SizedBox(width: 10), t],
      ],
    ),
  );
}

class _AskCard extends StatelessWidget {
  const _AskCard({
    required this.ask,
    required this.agent,
    required this.onDecide,
    required this.onTerminal,
  });

  final AgentPermissionAsk ask;
  final IslandAgent? agent;
  final ValueChanged<AgentPermissionDecision> onDecide;
  final VoidCallback onTerminal;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tr = context.t.gsh.agentIsland;
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colors.panel2,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: colors.warn.withValues(alpha: 0.45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _Leading(agent?.harness, colors.warn),
              const SizedBox(width: 8),
              Expanded(
                child: _Title(agent?.title ?? '', agent?.workspace ?? ''),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: colors.panel3,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '${ask.toolName} · ${toolSummary(ask.toolName, ask.input)}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.typo.mono.copyWith(
                fontSize: 12,
                color: colors.text2,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              PrimaryButton(
                size: ButtonSize.small,
                onPressed: () => onDecide(AgentPermissionDecision.allow),
                child: Text(tr.allow),
              ),
              if (ask.alwaysRule case final rule?)
                AppTooltip(
                  message: tr.alwaysTooltip(rule: rule),
                  child: OutlineButton(
                    size: ButtonSize.small,
                    onPressed: () =>
                        onDecide(AgentPermissionDecision.allowAlways),
                    child: Text(tr.always),
                  ),
                ),
              OutlineButton(
                size: ButtonSize.small,
                onPressed: () => onDecide(AgentPermissionDecision.deny),
                child: Text(tr.deny),
              ),
              AppTooltip(
                message: tr.inTerminalTooltip,
                child: GhostButton(
                  size: ButtonSize.small,
                  onPressed: onTerminal,
                  child: Text(tr.inTerminal),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
