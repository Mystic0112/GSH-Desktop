import 'package:cockpit/app/cockpit/ui/widgets/confirm_dialog.dart';
import 'package:cockpit/app/core/ui/themes/themes.dart';
import 'package:cockpit/app/settings/domain/claude_info.dart';
import 'package:cockpit/app/settings/ui/claude_info_viewmodel.dart';
import 'package:cockpit/app/settings/ui/settings_catalog.dart';
import 'package:cockpit/app/settings/ui/settings_widgets.dart';
import 'package:cockpit/i18n/strings.g.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

/// Aba **Conta**: Perfil ("Instruções para o Claude" = o `~/.claude/CLAUDE.md`)
/// e o login do Claude Code nesta máquina (`claude auth status`), com Entrar
/// (terminal com `claude auth login`) e Sair (`claude auth logout`). Foto,
/// dispositivos e sessões são do claude.ai: não existem aqui.
class AccountPanel extends StatefulWidget {
  const AccountPanel({super.key});

  @override
  State<AccountPanel> createState() => _AccountPanelState();
}

class _AccountPanelState extends State<AccountPanel> {
  final _text = TextEditingController();
  final _focus = FocusNode();
  bool _filled = false;

  @override
  void initState() {
    super.initState();
    // Pós-frame: carregar notifica, e notificar no initState cai no build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<ClaudeInfoViewModel>()
        ..loadAccount()
        ..loadInstructions();
    });
    _focus.addListener(() {
      if (!_focus.hasFocus) _save();
    });
  }

  @override
  void dispose() {
    _focus.dispose();
    _text.dispose();
    super.dispose();
  }

  void _save() {
    if (_filled) {
      context.read<ClaudeInfoViewModel>().saveInstructions(_text.text);
    }
  }

  Future<void> _logout() async {
    final tr = context.t.settings.page.account;
    final ok = await showConfirmDialog(
      context,
      title: tr.logoutConfirmTitle,
      message: tr.logoutConfirmMessage,
      confirmLabel: tr.logout,
      danger: true,
    );
    if (!ok || !mounted) return;
    await context.read<ClaudeInfoViewModel>().logout();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ClaudeInfoViewModel>();
    final tr = context.t.settings.page.account;
    final colors = context.colors;
    // Preenche o campo uma vez, quando o arquivo chega.
    if (!_filled && vm.instructions != null) {
      _text.text = vm.instructions!;
      _filled = true;
    }
    return SettingsPanelBody(
      children: [
        SettingsSection(
          title: tr.profile,
          rows: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    tr.instructions,
                    style: context.typo.body.copyWith(
                      fontSize: 14,
                      color: colors.text,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tr.instructionsDesc,
                    style: context.typo.body.copyWith(
                      fontSize: 13.5,
                      color: colors.text3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _text,
                    focusNode: _focus,
                    enabled: _filled,
                    minLines: 4,
                    maxLines: 12,
                    placeholder: Text(tr.instructionsHint),
                    style: context.typo.mono.copyWith(color: colors.text),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  if (vm.instructionsError case final e?) ...[
                    const SizedBox(height: 6),
                    SettingsNote(
                      claudeInfoErrorMessage(context, e),
                      error: true,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        SettingsSection(
          title: tr.title,
          action: SettingsRefreshButton(
            loading: vm.account.loading,
            onPressed: () => vm.loadAccount(force: true),
          ),
          rows: [
            ...infoLoadRows(
              context,
              vm.account,
              (a) => _rows(context, a),
              empty: '',
            ),
            if (vm.logoutError case final e?)
              SettingsNote(claudeInfoErrorMessage(context, e), error: true),
          ],
        ),
      ],
    );
  }

  List<Widget> _rows(BuildContext context, ClaudeAccount a) {
    final tr = context.t.settings.page.account;
    final colors = context.colors;
    return [
      SettingsRow(
        title: a.loggedIn ? tr.loggedIn : tr.loggedOut,
        description: a.loggedIn ? tr.loggedInDesc : tr.loggedOutDesc,
        leading: Icon(
          a.loggedIn ? Icons.check_circle : Icons.cancel_outlined,
          size: 18,
          color: a.loggedIn ? colors.ok : colors.text3,
        ),
        trailing: a.loggedIn
            ? OutlineButton(onPressed: _logout, child: Text(tr.logout))
            : PrimaryButton(
                onPressed: () =>
                    runInShellTerminal(context, 'claude auth login'),
                child: Text(tr.login),
              ),
      ),
      if (a.loggedIn) ...[
        if (a.email case final v?)
          SettingsRow(title: tr.email, trailing: _Value(v)),
        if (a.orgName case final v?)
          SettingsRow(title: tr.organization, trailing: _Value(v)),
        if (a.orgId case final v?)
          SettingsRow(title: tr.orgId, trailing: _Value(v, mono: true)),
        if (a.subscriptionType case final v?)
          SettingsRow(title: tr.plan, trailing: SettingsChip(v)),
        if (a.authMethod ?? a.apiProvider case final v?)
          SettingsRow(title: tr.method, trailing: _Value(v)),
      ],
    ];
  }
}

/// Valor lido da CLI, à direita da linha (texto cru, sem tradução).
class _Value extends StatelessWidget {
  const _Value(this.text, {this.mono = false});
  final String text;
  final bool mono;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final style = (mono ? context.typo.mono : context.typo.body).copyWith(
      fontSize: mono ? 12.5 : 13.5,
      color: colors.text2,
    );
    if (!mono) return SelectableText(text, style: style);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: colors.panel2,
        borderRadius: BorderRadius.circular(5),
      ),
      child: SelectableText(text, style: style),
    );
  }
}
