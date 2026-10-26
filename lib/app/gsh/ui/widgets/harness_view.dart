import 'dart:async';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:gsh_desktop/app/core/ui/themes/themes.dart';
import 'package:gsh_desktop/app/core/ui/widgets/app_tooltip.dart';
import 'package:gsh_desktop/app/core/ui/widgets/hover_tap.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/project_harness.dart';
import 'package:gsh_desktop/app/gsh/ui/session/harness_session.dart';
import 'package:gsh_desktop/app/gsh/ui/viewmodels/gsh_viewmodel.dart';
import 'package:gsh_desktop/app/gsh/ui/viewmodels/harness_viewmodel.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/realm_dialogs.dart';
import 'package:gsh_desktop/i18n/strings.g.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

/// Aba Harness: o que o agente carrega ao rodar nesta pasta, em cartões por
/// seção. Clique abre o arquivo no editor; "Novo" cria pelo modelo.
class HarnessView extends StatefulWidget {
  const HarnessView({super.key, required this.session, required this.active});
  final HarnessSession session;

  /// Aba visível: ao voltar a ela, relê (o usuário pode ter editado).
  final bool active;

  @override
  State<HarnessView> createState() => _HarnessViewState();
}

class _HarnessViewState extends State<HarnessView> {
  late final HarnessViewModel _vm = context.read<HarnessViewModel>();
  String get _ws => widget.session.workingDirectory;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  @override
  void didUpdateWidget(HarnessView old) {
    super.didUpdateWidget(old);
    if (widget.active && !old.active) _reload();
  }

  /// Depois do quadro: o `load` avisa os ouvintes na hora, e aqui ainda
  /// estamos no meio do build.
  void _reload() => WidgetsBinding.instance.addPostFrameCallback((_) {
    if (mounted) unawaited(_vm.load(_ws));
  });

  void _open(String path) =>
      unawaited(context.read<GshViewModel>().openFile(path, isPreview: false));

  Future<void> _create(HarnessKind kind) async {
    final tr = context.t.gsh.harness;
    String? name;
    if (const {
      HarnessKind.skills,
      HarnessKind.agents,
      HarnessKind.commands,
    }.contains(kind)) {
      final taken = {
        for (final e in _vm.of(_ws)?.of(kind) ?? const <HarnessEntry>[])
          e.name.replaceFirst('/', ''),
      };
      name = await showRealmNameDialog(
        context,
        title: tr.newTitle(section: _title(tr, kind)),
        confirmLabel: tr.create,
        takenNames: taken,
        placeholder: tr.namePlaceholder,
      );
      if (name == null || !mounted) return;
    }
    final path = await _vm.create(_ws, kind, name: name);
    if (path != null && mounted) _open(path);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HarnessViewModel>();
    final colors = context.colors;
    final tr = context.t.gsh.harness;
    final harness = vm.of(_ws);
    return ColoredBox(
      color: colors.panel,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tr.tabTitle, style: context.typo.display),
                      const SizedBox(height: 4),
                      Text(
                        tr.subtitle(path: _ws),
                        style: context.typo.label.copyWith(color: colors.text3),
                      ),
                    ],
                  ),
                ),
                AppTooltip(
                  message: tr.refresh,
                  child: HoverTap(
                    onTap: vm.isLoading(_ws) ? null : () => _vm.load(_ws),
                    borderRadius: BorderRadius.circular(6),
                    padding: const EdgeInsets.all(6),
                    child: vm.isLoading(_ws)
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(size: 14),
                          )
                        : Icon(Icons.refresh, size: 18, color: colors.text2),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            if (harness == null)
              const Center(child: CircularProgressIndicator(size: 20))
            else ...[
              _CostCard(harness: harness),
              const SizedBox(height: 16),
              LayoutBuilder(
                builder: (context, box) {
                  final cols = box.maxWidth >= 980 ? 2 : 1;
                  final w = (box.maxWidth - (cols - 1) * 16) / cols;
                  return Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      for (final k in HarnessKind.values)
                        SizedBox(
                          width: w,
                          child: _SectionCard(
                            kind: k,
                            entries: harness.of(k).toList(),
                            perTurnTokens: harness.alwaysOnTokens(k),
                            invalidFiles: [
                              for (final f in harness.invalidFiles)
                                if (_sectionOfFile(f) == k) f,
                            ],
                            onOpen: _open,
                            onCreate: () => _create(k),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Onde avisar de um JSON inválido: `.mcp.json` no MCP; `settings*.json`
/// em Hooks (o arquivo também tem as permissões).
HarnessKind _sectionOfFile(String path) =>
    path.endsWith('.mcp.json') ? HarnessKind.mcp : HarnessKind.hooks;

/// `9.4k` / `820`.
String _tokens(int n) =>
    n >= 1000 ? '${(n / 1000).toStringAsFixed(n >= 10000 ? 0 : 1)}k' : '$n';

/// Resumo do topo: quanto o harness custa em toda mensagem e quantos avisos.
class _CostCard extends StatelessWidget {
  const _CostCard({required this.harness});
  final ProjectHarness harness;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.typo;
    final tr = context.t.gsh.harness;
    final total = harness.alwaysOnTokens();
    final issues = harness.issueCount;
    final parts = [
      for (final k in const [
        HarnessKind.memory,
        HarnessKind.skills,
        HarnessKind.agents,
        HarnessKind.commands,
      ])
        if (harness.alwaysOnTokens(k) > 0)
          '${_title(tr, k)} ${_tokens(harness.alwaysOnTokens(k))}',
    ];
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.panel2,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(tr.costTitle, style: typo.title),
              const SizedBox(width: 10),
              Text(
                tr.costValue(tokens: _tokens(total)),
                style: typo.display.copyWith(fontSize: 20),
              ),
              const Spacer(),
              if (issues > 0)
                Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      size: 16,
                      color: colors.warn,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      tr.issues(n: issues),
                      style: typo.label.copyWith(color: colors.warn),
                    ),
                  ],
                ),
            ],
          ),
          if (parts.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              parts.join('  ·  '),
              style: typo.label.copyWith(color: colors.text2),
            ),
          ],
          const SizedBox(height: 6),
          Text(tr.costHint, style: typo.label.copyWith(color: colors.text3)),
          const SizedBox(height: 2),
          Text(tr.costTip, style: typo.label.copyWith(color: colors.text3)),
        ],
      ),
    );
  }
}

String _title(Translations$gsh$harness$en tr, HarnessKind k) => switch (k) {
  HarnessKind.memory => tr.memory,
  HarnessKind.skills => tr.skills,
  HarnessKind.agents => tr.agents,
  HarnessKind.commands => tr.commands,
  HarnessKind.hooks => tr.hooks,
  HarnessKind.permissions => tr.permissions,
  HarnessKind.mcp => tr.mcp,
};

class _SectionCard extends StatefulWidget {
  const _SectionCard({
    required this.kind,
    required this.entries,
    required this.perTurnTokens,
    required this.invalidFiles,
    required this.onOpen,
    required this.onCreate,
  });

  final HarnessKind kind;
  final List<HarnessEntry> entries;
  final int perTurnTokens;
  final List<String> invalidFiles;
  final ValueChanged<String> onOpen;
  final VoidCallback onCreate;

  @override
  State<_SectionCard> createState() => _SectionCardState();
}

class _SectionCardState extends State<_SectionCard> {
  /// Itens visíveis antes do "mostrar todos" (há quem tenha dezenas de
  /// skills de usuário).
  static const _cap = 6;
  bool _all = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.typo;
    final tr = context.t.gsh.harness;
    final kind = widget.kind;
    final entries = widget.entries;
    final shown = _all ? entries : entries.take(_cap);
    final (icon, desc, newLabel) = switch (kind) {
      HarnessKind.memory => (
        Icons.description_outlined,
        tr.memoryDesc,
        tr.memoryNew,
      ),
      HarnessKind.skills => (
        Icons.auto_awesome_outlined,
        tr.skillsDesc,
        tr.newItem,
      ),
      HarnessKind.agents => (
        Icons.smart_toy_outlined,
        tr.agentsDesc,
        tr.newItem,
      ),
      HarnessKind.commands => (Icons.terminal, tr.commandsDesc, tr.newItem),
      HarnessKind.hooks => (Icons.bolt_outlined, tr.hooksDesc, tr.editFile),
      HarnessKind.permissions => (
        Icons.shield_outlined,
        tr.permissionsDesc,
        tr.editFile,
      ),
      HarnessKind.mcp => (Icons.extension_outlined, tr.mcpDesc, tr.editFile),
    };
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
      decoration: BoxDecoration(
        color: colors.panel2,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: colors.text2),
              const SizedBox(width: 8),
              Text(_title(tr, kind), style: typo.title),
              const SizedBox(width: 6),
              Text(
                '${entries.length}',
                style: typo.label.copyWith(color: colors.text3),
              ),
              if (widget.perTurnTokens > 0) ...[
                const SizedBox(width: 8),
                Text(
                  tr.perTurn(tokens: _tokens(widget.perTurnTokens)),
                  style: typo.label.copyWith(
                    fontSize: 11.5,
                    color: colors.text4,
                  ),
                ),
              ],
              const Spacer(),
              GhostButton(
                size: ButtonSize.small,
                onPressed: widget.onCreate,
                leading: Icon(
                  newLabel == tr.editFile ? Icons.edit_outlined : Icons.add,
                  size: 14,
                ),
                child: Text(newLabel),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(desc, style: typo.label.copyWith(color: colors.text3)),
          const SizedBox(height: 8),
          for (final f in widget.invalidFiles)
            HoverTap(
              onTap: () => widget.onOpen(f),
              borderRadius: BorderRadius.circular(6),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 6),
              child: Row(
                children: [
                  Icon(Icons.error_outline, size: 14, color: colors.error),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      tr.invalidJson(file: f.split(RegExp(r'[/\\]')).last),
                      style: typo.label.copyWith(color: colors.error),
                    ),
                  ),
                ],
              ),
            ),
          if (entries.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                tr.empty,
                style: typo.label.copyWith(color: colors.text4),
              ),
            )
          else ...[
            for (final e in shown) _EntryRow(entry: e, onOpen: widget.onOpen),
            if (entries.length > _cap)
              Align(
                alignment: Alignment.centerLeft,
                child: GhostButton(
                  size: ButtonSize.small,
                  onPressed: () => setState(() => _all = !_all),
                  child: Text(
                    _all ? tr.showLess : tr.showAll(n: entries.length),
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _EntryRow extends StatelessWidget {
  const _EntryRow({required this.entry, required this.onOpen});
  final HarnessEntry entry;
  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.typo;
    final tr = context.t.gsh.harness;
    final mono =
        entry.kind == HarnessKind.commands ||
        entry.kind == HarnessKind.permissions ||
        entry.kind == HarnessKind.hooks;
    // Permissão: a regra é o nome; allow/ask/deny vira a cor do detalhe.
    final ruleColor = switch (entry.detail) {
      'allow' => colors.online,
      'ask' => colors.warn,
      'deny' => colors.error,
      _ => colors.text3,
    };
    final detail = entry.kind == HarnessKind.permissions
        ? switch (entry.detail) {
            'allow' => tr.allow,
            'ask' => tr.ask,
            'deny' => tr.deny,
            _ => entry.detail,
          }
        : entry.detail;
    final path = entry.path;
    final row = Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: (mono ? typo.mono : typo.body).copyWith(
                    fontSize: 13,
                    color: colors.text,
                  ),
                ),
                if (detail.isNotEmpty)
                  Text(
                    detail,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: typo.label.copyWith(
                      fontSize: 11.5,
                      color: entry.kind == HarnessKind.permissions
                          ? ruleColor
                          : colors.text3,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (entry.issues.isNotEmpty) ...[
            AppTooltip(
              message: [
                for (final i in entry.issues)
                  switch (i) {
                    HarnessIssue.noDescription => tr.issueNoDescription,
                    HarnessIssue.missingScript => tr.issueMissingScript,
                    HarnessIssue.tooLarge => tr.issueTooLarge,
                  },
              ].join('\n'),
              child: Icon(
                Icons.warning_amber_rounded,
                size: 15,
                color: colors.warn,
              ),
            ),
            const SizedBox(width: 6),
          ],
          _ScopeChip(scope: entry.scope),
          if (path == null) ...[
            const SizedBox(width: 6),
            AppTooltip(
              message: tr.readOnly,
              child: Icon(Icons.lock_outline, size: 13, color: colors.text4),
            ),
          ],
        ],
      ),
    );
    return path == null
        ? row
        : HoverTap(
            onTap: () => onOpen(path),
            borderRadius: BorderRadius.circular(6),
            child: row,
          );
  }
}

class _ScopeChip extends StatelessWidget {
  const _ScopeChip({required this.scope});
  final HarnessScope scope;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tr = context.t.gsh.harness;
    final (label, bg) = switch (scope) {
      HarnessScope.user => (tr.scopeUser, colors.panel3),
      HarnessScope.project => (tr.scopeProject, colors.accentSoft),
      HarnessScope.local => (tr.scopeLocal, colors.panel3),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        label,
        style: context.typo.label.copyWith(fontSize: 11, color: colors.text2),
      ),
    );
  }
}
