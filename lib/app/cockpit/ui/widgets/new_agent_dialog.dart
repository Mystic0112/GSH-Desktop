import 'dart:io' show Directory;

import 'package:cockpit/app/cockpit/domain/entities/desktop_agent_app.dart';
import 'package:cockpit/app/cockpit/ui/actions/agent_graph_actions.dart';
import 'package:cockpit/app/cockpit/ui/widgets/agent_node_card.dart';
import 'package:cockpit/app/core/domain/entities/harness.dart';
import 'package:cockpit/app/core/ui/themes/themes.dart';
import 'package:cockpit/app/core/utils/native_folder_picker.dart';
import 'package:cockpit/app/core/ui/widgets/app_tooltip.dart';
import 'package:cockpit/i18n/strings.g.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

part 'new_agent_dialog_desktop.dart';
part 'new_agent_dialog_parts.dart';

/// O que o dialog "New agent" devolve. Campos vazios = "não definido".
class NewAgentDraft {
  const NewAgentDraft({
    required this.label,
    required this.command,
    required this.cwd,
    this.monitor = true,
    this.maestro = false,
    this.color,
    this.role = '',
    this.task = '',
    this.desktop,
  });
  final String label;
  final String command;
  final String cwd;
  final bool monitor;
  final bool maestro;
  final Color? color;
  final String role;
  final String task;

  /// App desktop escolhido (nó externo via MCP), com a integração aceita;
  /// `null` = agente de terminal. [command]/[monitor] não se aplicam a ele.
  final DesktopAppIntegration? desktop;

  NewAgentDraft withCwd(String cwd) => NewAgentDraft(
    label: label,
    command: command,
    cwd: cwd,
    monitor: monitor,
    maestro: maestro,
    color: color,
    role: role,
    task: task,
    desktop: desktop,
  );
}

/// Sheet "New agent" (estilo "Novo terminal" do Maestri). [taken] = rótulos em
/// uso (minúsculos); [remote] desliga Browse/validação local da pasta (ela mora
/// no host); [desktopApps] = apps desktop detectados (linha "Desktop apps").
/// Dialogs vivem fora dos providers da rota: tudo chega por parâmetro.
Future<NewAgentDraft?> showNewAgentDialog(
  BuildContext context, {
  required List<HarnessSpec> harnesses,
  List<DesktopAppIntegration> desktopApps = const [],
  required Set<String> taken,
  required String root,
  required bool remote,
  String? currentMaestro,
}) => showDialog<NewAgentDraft>(
  context: context,
  barrierColor: context.colors.scrim,
  builder: (_) => _NewAgentDialog(
    harnesses: harnesses,
    desktopApps: desktopApps,
    taken: taken,
    root: root,
    remote: remote,
    currentMaestro: currentMaestro,
  ),
);

class _NewAgentDialog extends StatefulWidget {
  const _NewAgentDialog({
    required this.harnesses,
    required this.desktopApps,
    required this.taken,
    required this.root,
    required this.remote,
    this.currentMaestro,
  });
  final List<HarnessSpec> harnesses;
  final List<DesktopAppIntegration> desktopApps;
  final Set<String> taken;
  final String root;
  final bool remote;
  final String? currentMaestro;

  @override
  State<_NewAgentDialog> createState() => _NewAgentDialogState();
}

class _NewAgentDialogState extends State<_NewAgentDialog> {
  final _name = TextEditingController();
  final _command = TextEditingController();
  late final _cwd = TextEditingController(text: widget.root);
  final _role = TextEditingController();
  final _task = TextEditingController();
  int _tab = 0;
  bool _monitor = true;
  bool _maestro = false;
  Color? _color;

  /// Modo desktop: app escolhido na linha "Desktop apps" + o aceite da
  /// integração (obrigatório pra criar).
  DesktopAppIntegration? _desktop;
  bool _consent = false;

  /// Último nome posto pelo quick start: trocar de harness troca o nome
  /// enquanto o usuário não digitou o dele.
  String? _autoName;

  @override
  void dispose() {
    for (final c in [_name, _command, _cwd, _role, _task]) {
      c.dispose();
    }
    super.dispose();
  }

  bool get _nameTaken => widget.taken.contains(_name.text.trim().toLowerCase());

  bool get _cwdMissing {
    final cwd = _cwd.text.trim();
    return cwd.isEmpty || (!widget.remote && !Directory(cwd).existsSync());
  }

  void _quickStart(String command, String name) => setState(() {
    _desktop = null;
    _command.text = command;
    _autoNameAs(name);
  });

  void _pickDesktop(DesktopAppIntegration app) => setState(() {
    if (_desktop?.app != app.app) _consent = false;
    _desktop = app;
    _autoNameAs(app.app.label);
  });

  void _autoNameAs(String name) {
    if (_name.text.trim().isEmpty || _name.text == _autoName) {
      _name.text = _autoName = defaultAgentName(name, widget.taken);
    }
  }

  bool get _canCreate =>
      !_nameTaken && (_desktop == null ? !_cwdMissing : _consent);

  Future<void> _browse() async {
    final picked = await NativeFolderPicker.pick(
      initialDirectory: _cwdMissing ? null : _cwd.text.trim(),
    );
    if (picked != null && mounted) setState(() => _cwd.text = picked);
  }

  void _create() => Navigator.of(context).pop(
    NewAgentDraft(
      label: _name.text.trim(),
      command: _command.text.trim(),
      cwd: _cwd.text.trim(),
      monitor: _monitor,
      maestro: _maestro,
      color: _color,
      role: _role.text.trim(),
      task: _task.text.trim(),
      desktop: _desktop,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tr = context.t.cockpit.agentGraph;
    return AlertDialog(
      title: Text(
        tr.newAgent,
        style: context.typo.title.copyWith(fontSize: 15, color: colors.text),
      ),
      content: SizedBox(
        width: 520,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Caption(tr.quickStart.toUpperCase()),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final h in widget.harnesses)
                  OutlineButton(
                    size: ButtonSize.small,
                    leading: HarnessIcon(h, color: colors.text),
                    onPressed: () => _quickStart(h.primaryEntryPoint, h.label),
                    child: Text(h.label),
                  ),
                OutlineButton(
                  size: ButtonSize.small,
                  leading: const Icon(Icons.terminal, size: 16),
                  onPressed: () => _quickStart('', tr.shell),
                  child: Text(tr.shell),
                ),
              ],
            ),
            if (widget.desktopApps.isNotEmpty)
              _DesktopAppsRow(
                apps: widget.desktopApps,
                selected: _desktop?.app,
                onPick: _pickDesktop,
              ),
            const SizedBox(height: 16),
            Tabs(
              index: _tab,
              onChanged: (i) => setState(() => _tab = i),
              children: [
                TabItem(child: Text(tr.tabDetails)),
                TabItem(child: Text(tr.tabAppearance)),
                TabItem(child: Text(tr.tabAgent)),
              ],
            ),
            const SizedBox(height: 14),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 380),
              child: SingleChildScrollView(
                child: switch (_tab) {
                  0 => _details(context),
                  1 => _appearance(context),
                  _ => _agent(context),
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        OutlineButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.t.common.cancel),
        ),
        PrimaryButton(
          onPressed: _canCreate ? _create : null,
          child: Text(context.t.common.create),
        ),
      ],
    );
  }

  Widget _details(BuildContext context) {
    final tr = context.t.cockpit.agentGraph;
    final desktop = _desktop;
    if (desktop != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Caption(tr.agentName),
          TextField(
            controller: _name,
            placeholder: Text(tr.namePlaceholder),
            onChanged: (_) => setState(() {}),
          ),
          if (_nameTaken) _Problem(tr.nameTaken),
          const SizedBox(height: 12),
          _IntegrationBox(
            integration: desktop,
            consent: _consent,
            onConsent: (v) => setState(() => _consent = v),
          ),
          const SizedBox(height: 14),
          _maestroToggle(context),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Caption(tr.name),
        TextField(
          controller: _name,
          placeholder: Text(tr.namePlaceholder),
          onChanged: (_) => setState(() {}),
        ),
        if (_nameTaken) _Problem(tr.nameTaken),
        const SizedBox(height: 12),
        _Caption(tr.command),
        TextField(
          controller: _command,
          placeholder: Text(tr.commandPlaceholder),
          style: context.typo.mono.copyWith(fontSize: 12.5),
        ),
        const SizedBox(height: 12),
        _Caption(tr.cwd),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _cwd,
                onChanged: (_) => setState(() {}),
                style: context.typo.mono.copyWith(fontSize: 12.5),
              ),
            ),
            if (!widget.remote) ...[
              const SizedBox(width: 8),
              OutlineButton(onPressed: _browse, child: Text(tr.browse)),
            ],
          ],
        ),
        if (_cwdMissing) _Problem(tr.cwdMissing),
        const SizedBox(height: 14),
        _Toggle(
          title: tr.monitor,
          hint: tr.monitorHint,
          value: _monitor,
          onChanged: (v) => setState(() => _monitor = v),
        ),
        const SizedBox(height: 10),
        _maestroToggle(context),
      ],
    );
  }

  Widget _maestroToggle(BuildContext context) {
    final tr = context.t.cockpit.agentGraph;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Toggle(
          title: tr.maestro,
          info: tr.maestroTooltip,
          value: _maestro,
          onChanged: (v) => setState(() => _maestro = v),
        ),
        if (_maestro && widget.currentMaestro != null)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              tr.maestroReplaces(name: widget.currentMaestro!),
              style: context.typo.label.copyWith(color: context.colors.warn),
            ),
          ),
      ],
    );
  }

  Widget _appearance(BuildContext context) {
    final tr = context.t.cockpit.agentGraph;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Caption(tr.color),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            AppTooltip(
              message: tr.colorAuto,
              child: _Swatch(
                color: null,
                selected: _color == null,
                onTap: () => setState(() => _color = null),
              ),
            ),
            for (final c in agentPalette)
              _Swatch(
                color: c,
                selected: _color == c,
                onTap: () => setState(() => _color = c),
              ),
          ],
        ),
      ],
    );
  }

  Widget _agent(BuildContext context) {
    final tr = context.t.cockpit.agentGraph;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Caption(tr.role),
        TextField(
          controller: _role,
          placeholder: Text(tr.rolePlaceholder),
          minLines: 3,
          maxLines: 6,
        ),
        const SizedBox(height: 12),
        _Caption(tr.task),
        TextField(
          controller: _task,
          placeholder: Text(tr.taskPlaceholder),
          minLines: 3,
          maxLines: 6,
        ),
      ],
    );
  }
}
