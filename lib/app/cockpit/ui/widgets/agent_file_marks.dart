import 'dart:io' show File;

import 'package:cockpit/app/cockpit/ui/session/terminal_session.dart';
import 'package:cockpit/app/cockpit/ui/viewmodels/agent_file_activity.dart';
import 'package:cockpit/app/cockpit/ui/widgets/pane_tab_leading.dart';
import 'package:cockpit/app/core/ui/file_icons/file_icons.dart';
import 'package:cockpit/app/core/ui/themes/themes.dart';
import 'package:cockpit/app/core/ui/widgets/app_menu.dart';
import 'package:cockpit/app/core/ui/widgets/app_tooltip.dart';
import 'package:cockpit/app/core/ui/widgets/hover_tap.dart';
import 'package:cockpit/i18n/strings.g.dart';
import 'package:path/path.dart' as p;
import 'package:shadcn_flutter/shadcn_flutter.dart';

/// "Quem está mexendo no quê" no painel Files: filtro por agente (header),
/// marcas coloridas por linha da árvore e a lista plana do agente filtrado.

const double _dotSize = 6;
const int _maxDots = 3;

/// Janela em que dois agentes no mesmo arquivo viram aviso.
const Duration _concurrentWindow = Duration(minutes: 10);

/// Rótulo da aba [tabId] entre [tabs] (o id cru se a aba já não existe).
String agentLabelOf(List<TerminalSession> tabs, String tabId) {
  for (final s in tabs) {
    if (s.id == tabId) return s.displayTitle;
  }
  return tabId;
}

String _hhmm(DateTime t) =>
    '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

String _touchLine(BuildContext context, String label, AgentFileTouch touch) {
  final tr = context.t.cockpit.fileTreePanel;
  final line = tr.editedBy(label: label, time: _hhmm(touch.at));
  return touch.inferred ? '$line ${tr.inferredSuffix}' : line;
}

class _Dot extends StatelessWidget {
  const _Dot(this.color);
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    width: _dotSize,
    height: _dotSize,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );
}

/// Botão do header da aba Files: dropdown "Todos os agentes" + uma entrada por
/// aba de agente do workspace.
class AgentFilterButton extends StatelessWidget {
  const AgentFilterButton({
    super.key,
    required this.activity,
    required this.tabs,
    this.colorOf = agentColorFor,
    required this.selected,
    required this.onSelected,
  });

  final AgentFileActivity activity;
  final List<TerminalSession> Function() tabs;
  final Color Function(String tabId) colorOf;
  final String? selected;
  final ValueChanged<String?> onSelected;

  Future<void> _open(BuildContext context) async {
    final tr = context.t.cockpit.fileTreePanel;
    final list = tabs();
    final pick = await showAppMenu<String>(
      context,
      minWidth: 240,
      items: [
        AppMenuItem(
          value: '',
          label: tr.allAgents,
          icon: Icons.groups_outlined,
          selected: selected == null,
        ),
        if (list.isNotEmpty) const AppMenuItem.divider(),
        for (final s in list) _entry(context, s),
      ],
    );
    if (pick == null) return;
    onSelected(pick.isEmpty ? null : pick);
  }

  AppMenuItem<String> _entry(BuildContext context, TerminalSession s) {
    final tr = context.t.cockpit.fileTreePanel;
    final colors = context.colors;
    final count = activity.touchedBy(s.id).length;
    final byHook = s.activeHarness != null && !s.usesOutputHeuristic;
    final unavailable = count == 0 && !byHook;
    return AppMenuItem(
      value: s.id,
      label: s.displayTitle,
      selected: selected == s.id,
      enabled: !unavailable,
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Dot(colorOf(s.id)),
          const SizedBox(width: 6),
          PaneTabLeading(
            item: s,
            defaultIcon: Icons.terminal,
            iconColor: colors.text3,
          ),
        ],
      ),
      labelWidget: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 160),
            child: Text(
              s.displayTitle,
              overflow: TextOverflow.ellipsis,
              style: context.typo.body.copyWith(
                fontSize: 13,
                color: unavailable ? colors.text4 : colors.text,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            unavailable ? tr.trackingUnavailable : '$count',
            style: context.typo.label.copyWith(color: colors.text4),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final sel = selected;
    return AppTooltip(
      message: sel == null
          ? context.t.cockpit.fileTreePanel.agentFilterTooltip
          : agentLabelOf(tabs(), sel),
      child: Builder(
        // Context do próprio botão: o menu ancora embaixo dele.
        builder: (anchor) => HoverTap(
          onTap: () => _open(anchor),
          padding: const EdgeInsets.all(3),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.smart_toy_outlined,
                size: 14,
                color: sel == null ? colors.text3 : colors.text,
              ),
              if (sel != null) ...[
                const SizedBox(width: 3),
                _Dot(colorOf(sel)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Bolinhas por agente numa linha da árvore (máx. [_maxDots], depois `+n`),
/// com tooltip de quem editou e quando. Aviso se 2+ agentes mexeram no
/// arquivo nos últimos [_concurrentWindow].
class AgentFileMarks extends StatelessWidget {
  const AgentFileMarks({
    super.key,
    required this.path,
    required this.activity,
    required this.tabs,
    this.colorOf = agentColorFor,
  });

  final String path;
  final AgentFileActivity activity;
  final List<TerminalSession> Function() tabs;
  final Color Function(String tabId) colorOf;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: activity,
    builder: (context, _) {
      final touchers = activity.touchersOf(path);
      if (touchers.isEmpty) return const SizedBox.shrink();
      final colors = context.colors;
      final list = tabs();
      final now = DateTime.now();
      final recent = touchers
          .where((t) => now.difference(t.touch.at) < _concurrentWindow)
          .length;
      return AppTooltip(
        message: [
          for (final t in touchers)
            _touchLine(context, agentLabelOf(list, t.tabId), t.touch),
          if (recent >= 2) context.t.cockpit.fileTreePanel.concurrentAgentEdits,
        ].join('\n'),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (recent >= 2)
              Padding(
                padding: const EdgeInsets.only(right: 3),
                child: Icon(
                  Icons.warning_amber_rounded,
                  size: 12,
                  color: colors.warn,
                ),
              ),
            for (final t in touchers.take(_maxDots))
              Padding(
                padding: const EdgeInsets.only(left: 2),
                child: _Dot(colorOf(t.tabId)),
              ),
            if (touchers.length > _maxDots)
              Padding(
                padding: const EdgeInsets.only(left: 3),
                child: Text(
                  '+${touchers.length - _maxDots}',
                  style: context.typo.label.copyWith(
                    fontSize: 10,
                    color: colors.text3,
                  ),
                ),
              ),
          ],
        ),
      );
    },
  );
}

/// Lista plana dos arquivos tocados por [tabId], do mais novo ao mais antigo.
// ponytail: lista plana em vez de filtrar a árvore lazy (que carrega pasta a
// pasta e não sabe esconder irmãos sem reescrever o _DirView).
class AgentTouchedList extends StatelessWidget {
  const AgentTouchedList({
    super.key,
    required this.tabId,
    required this.rootPath,
    required this.activity,
    required this.tabs,
    required this.onOpen,
  });

  final String tabId;
  final String rootPath;
  final AgentFileActivity activity;
  final List<TerminalSession> Function() tabs;
  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: activity,
    builder: (context, _) {
      final colors = context.colors;
      final entries = activity.touchedBy(tabId).entries.toList()
        ..sort((a, b) => b.value.at.compareTo(a.value.at));
      if (entries.isEmpty) {
        return Center(
          child: Text(
            context.t.cockpit.fileTreePanel.noTouchedFiles,
            textAlign: TextAlign.center,
            style: context.typo.label.copyWith(color: colors.text3),
          ),
        );
      }
      final label = agentLabelOf(tabs(), tabId);
      return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        itemCount: entries.length,
        itemBuilder: (context, i) {
          final MapEntry(key: path, value: touch) = entries[i];
          final exists = File(path).existsSync();
          final rel = p.isWithin(rootPath, path)
              ? p.relative(path, from: rootPath)
              : path;
          return AppTooltip(
            message: _touchLine(context, label, touch),
            child: HoverTap(
              hoverColor: colors.panel,
              borderRadius: BorderRadius.circular(5),
              onTap: exists ? () => onOpen(path) : null,
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: SizedBox(
                height: 26,
                child: Row(
                  children: [
                    FileTypeIcon.file(p.basename(path), size: 16),
                    const SizedBox(width: 7),
                    Expanded(
                      child: Text(
                        rel,
                        overflow: TextOverflow.ellipsis,
                        style: context.typo.body.copyWith(
                          fontSize: 13,
                          color: exists ? colors.text2 : colors.text4,
                          decoration: exists
                              ? null
                              : TextDecoration.lineThrough,
                          fontStyle: touch.inferred ? FontStyle.italic : null,
                        ),
                      ),
                    ),
                    Text(
                      _hhmm(touch.at),
                      style: context.typo.label.copyWith(
                        fontSize: 11,
                        color: colors.text4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
