import 'package:gsh_desktop/app/gsh/domain/contracts/url_opener.dart';
import 'package:gsh_desktop/app/core/ui/themes/themes.dart';
import 'package:gsh_desktop/app/core/ui/widgets/app_menu.dart';
import 'package:gsh_desktop/app/settings/domain/claude_info.dart';
import 'package:gsh_desktop/app/settings/ui/claude_info_viewmodel.dart';
import 'package:gsh_desktop/app/settings/ui/settings_catalog.dart';
import 'package:gsh_desktop/app/settings/ui/settings_widgets.dart';
import 'package:gsh_desktop/i18n/strings.g.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

/// Documentação de MCP do Claude Code (link do Descobrir).
const _mcpDocsUrl = 'https://docs.anthropic.com/en/docs/claude-code/mcp';

/// Aba **Conectores**: servidores MCP do Claude Code (`claude mcp list`).
/// Meus = tabela Conector · Tipo · Status, com "Vincular" (terminal com
/// `claude mcp login`) quando pede autenticação. Descobrir = o diretório do
/// claude.ai não tem API pública, então é um formulário que roda
/// `claude mcp add` num terminal.
class ConnectorsPanel extends StatefulWidget {
  const ConnectorsPanel({super.key});

  @override
  State<ConnectorsPanel> createState() => _ConnectorsPanelState();
}

class _ConnectorsPanelState extends State<ConnectorsPanel> {
  final _search = TextEditingController();
  bool _discover = false;

  @override
  void initState() {
    super.initState();
    _search.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<ClaudeInfoViewModel>().loadMcp();
    });
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ClaudeInfoViewModel>();
    final tr = context.t.settings.page.connectors;
    final header = CatalogHeader(
      title: context.t.settings.page.nav.connectors,
      discover: _discover,
      onDiscoverChanged: (v) => setState(() => _discover = v),
      search: _discover ? null : _search,
      actions: [
        if (!_discover)
          SettingsRefreshButton(
            loading: vm.mcp.loading,
            onPressed: () => vm.loadMcp(force: true),
          ),
        CatalogAddButton<String>(
          items: [
            AppMenuItem(value: 'add', label: tr.addServer, icon: Icons.add),
          ],
          onPick: (_) => setState(() => _discover = true),
        ),
      ],
    );
    if (_discover) {
      return CatalogBody(header: header, children: const [_AddServerForm()]);
    }
    final servers = [
      for (final s in vm.mcp.value ?? const <McpServerInfo>[])
        if (catalogMatches(_search.text, [s.name, s.target])) s,
    ];
    return CatalogBody(
      header: header,
      children: [
        // O health-check de cada servidor leva segundos: avisa no 1º load.
        if (vm.mcp.loading && vm.mcp.result == null)
          SettingsNote(tr.checking)
        else if (vm.mcp.value == null)
          ...infoLoadRows(context, vm.mcp, (_) => [], empty: tr.empty)
        else if (servers.isEmpty)
          SettingsNote(tr.empty)
        else ...[
          _TableRow(
            header: true,
            name: Text(tr.colConnector),
            type: Text(tr.colType),
            status: Text(tr.colStatus),
          ),
          for (final s in servers) _serverRow(context, s),
        ],
      ],
    );
  }

  Widget _serverRow(BuildContext context, McpServerInfo s) {
    final tr = context.t.settings.page.connectors;
    final colors = context.colors;
    final plugin = s.origin == McpOrigin.plugin
        ? s.name.split(':').elementAtOrNull(1)
        : null;
    return _TableRow(
      name: Row(
        children: [
          Icon(
            s.isRemote ? Icons.language : Icons.terminal,
            size: 17,
            color: colors.text2,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.displayName,
                  overflow: TextOverflow.ellipsis,
                  style: context.typo.body.copyWith(
                    fontSize: 14,
                    color: colors.text,
                  ),
                ),
                Text(
                  plugin == null ? s.target : tr.fromPlugin(plugin: plugin),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.typo.body.copyWith(
                    fontSize: 12.5,
                    color: colors.text3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      type: Row(
        children: [
          Text(s.isRemote ? tr.typeWeb : tr.typeLocal),
          if (switch (s.origin) {
                McpOrigin.plugin => tr.originPlugin,
                McpOrigin.claudeAi => 'claude.ai',
                McpOrigin.local => null,
              }
              case final chip?) ...[
            const SizedBox(width: 6),
            SettingsChip(chip),
          ],
        ],
      ),
      status: s.status == McpStatus.needsAuth
          ? Align(
              alignment: Alignment.centerLeft,
              child: SecondaryButton(
                size: ButtonSize.small,
                onPressed: () => runInShellTerminal(
                  context,
                  'claude mcp login ${shellQuote(s.name)}',
                ),
                child: Text(tr.link),
              ),
            )
          : McpStatusChip(s.status),
    );
  }
}

/// Conector · Tipo · Status (cabeçalho ou servidor), com fio embaixo.
class _TableRow extends StatelessWidget {
  const _TableRow({
    required this.name,
    required this.type,
    required this.status,
    this.header = false,
  });
  final Widget name;
  final Widget type;
  final Widget status;
  final bool header;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: EdgeInsets.symmetric(vertical: header ? 8 : 9),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.border)),
      ),
      child: DefaultTextStyle.merge(
        style: context.typo.body.copyWith(
          fontSize: header ? 13 : 13.5,
          color: colors.text2,
        ),
        child: Row(
          children: [
            Expanded(flex: 5, child: name),
            const SizedBox(width: 12),
            Expanded(flex: 2, child: type),
            Expanded(flex: 2, child: status),
          ],
        ),
      ),
    );
  }
}

/// ✓ Conectado / Precisa autenticar / Falhou / Aprovação pendente.
class McpStatusChip extends StatelessWidget {
  const McpStatusChip(this.status, {super.key});
  final McpStatus status;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tr = context.t.settings.page.connectors.status;
    final (label, color, icon) = switch (status) {
      McpStatus.connected => (tr.connected, colors.ok, Icons.check),
      McpStatus.needsAuth => (tr.needsAuth, colors.warn, Icons.key_outlined),
      McpStatus.failed => (tr.failed, colors.error, Icons.error_outline),
      McpStatus.pending => (tr.pending, colors.text3, Icons.pause),
      McpStatus.unknown => (tr.unknown, colors.text3, Icons.help_outline),
    };
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: color),
        const SizedBox(width: 6),
        Text(
          label,
          style: context.typo.body.copyWith(fontSize: 13, color: colors.text2),
        ),
      ],
    );
  }
}

/// Descobrir: explicação + formulário que monta o `claude mcp add`.
class _AddServerForm extends StatefulWidget {
  const _AddServerForm();

  @override
  State<_AddServerForm> createState() => _AddServerFormState();
}

class _AddServerFormState extends State<_AddServerForm> {
  final _name = TextEditingController();
  final _target = TextEditingController();
  bool _http = true;
  String _scope = 'user';

  @override
  void initState() {
    super.initState();
    _name.addListener(() => setState(() {}));
    _target.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _name.dispose();
    _target.dispose();
    super.dispose();
  }

  /// `claude mcp add -s <escopo> [-t http] <nome> <url>` ou
  /// `… <nome> -- <comando e args>` (stdio).
  String get _command {
    final name = shellQuote(_name.text.trim());
    final target = _target.text.trim();
    return _http
        ? 'claude mcp add -s $_scope -t http $name ${shellQuote(target)}'
        : 'claude mcp add -s $_scope $name -- $target';
  }

  @override
  Widget build(BuildContext context) {
    final tr = context.t.settings.page.connectors;
    final colors = context.colors;
    final ready =
        _name.text.trim().isNotEmpty && _target.text.trim().isNotEmpty;
    Widget field(TextEditingController c, String hint) => TextField(
      controller: c,
      placeholder: Text(hint),
      style: context.typo.body.copyWith(fontSize: 13.5, color: colors.text),
      borderRadius: BorderRadius.circular(7),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SettingsNote(tr.discoverIntro),
        SettingsSection(
          title: tr.addServer,
          rows: [
            SettingsRow(
              title: tr.formName,
              trailing: SizedBox(width: 320, child: field(_name, 'github')),
            ),
            SettingsRow(
              title: tr.formType,
              trailing: SettingsSegmented<bool>(
                value: _http,
                onChanged: (v) => setState(() => _http = v),
                options: {true: tr.typeWeb, false: tr.typeLocal},
              ),
            ),
            SettingsRow(
              title: _http ? tr.formUrl : tr.formCommand,
              trailing: SizedBox(
                width: 320,
                child: field(
                  _target,
                  _http ? 'https://…/mcp' : 'npx -y @scope/server',
                ),
              ),
            ),
            SettingsRow(
              title: tr.formScope,
              description: tr.formScopeDesc,
              trailing: SettingsSegmented<String>(
                value: _scope,
                onChanged: (v) => setState(() => _scope = v),
                options: {'user': tr.scopeUser, 'local': tr.scopeLocal},
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: SelectableText(
                      ready ? _command : '',
                      style: context.typo.mono.copyWith(color: colors.text3),
                    ),
                  ),
                  GhostButton(
                    size: ButtonSize.small,
                    trailing: const Icon(Icons.north_east, size: 14),
                    onPressed: () => inject<UrlOpener>().open(_mcpDocsUrl),
                    child: Text(tr.docs),
                  ),
                  const SizedBox(width: 8),
                  PrimaryButton(
                    size: ButtonSize.small,
                    onPressed: ready
                        ? () => runInShellTerminal(context, _command)
                        : null,
                    child: Text(tr.addInTerminal),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
