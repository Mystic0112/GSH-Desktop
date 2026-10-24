import 'dart:io' show Platform;

import 'package:gsh_desktop/app/core/domain/contracts/claude_code_settings.dart';
import 'package:gsh_desktop/app/core/domain/contracts/protected_hosts.dart';
import 'package:gsh_desktop/app/core/domain/entities/app_settings.dart';
import 'package:gsh_desktop/app/core/ui/settings_controller.dart';
import 'package:gsh_desktop/app/core/ui/widgets/app_menu.dart';
import 'package:gsh_desktop/app/settings/ui/claude_code_setting_switch.dart';
import 'package:gsh_desktop/app/settings/ui/claude_info_viewmodel.dart';
import 'package:gsh_desktop/app/settings/ui/code_theme_picker.dart';
import 'package:gsh_desktop/app/settings/ui/settings_widgets.dart';
import 'package:gsh_desktop/app/settings/ui/settings_text_field.dart';
import 'package:gsh_desktop/i18n/strings.g.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

/// Aba **Claude Code** das Configurações: preferências do chat (GSH) e
/// chaves do `~/.claude/settings.json`, em linhas planas sob títulos de seção.
class ClaudeCodePanel extends StatelessWidget {
  const ClaudeCodePanel({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<SettingsController>();
    final s = controller.settings;
    final tr = context.t.settings.page.claudeCode;

    return SettingsPanelBody(
      children: [
        SettingsSection(
          title: tr.sectionGeneral,
          rows: [
            SettingsRow(
              title: tr.classifyTitle,
              description: tr.classifyDesc,
              trailing: Switch(
                value: s.classifySessionStates,
                onChanged: controller.setClassifySessionStates,
              ),
            ),
            SettingsRow(
              title: tr.switchModelsTitle,
              description: tr.switchModelsDesc,
              // Gravado explícito: o CLI só pergunta a preferência
              // enquanto a chave nunca foi escolhida.
              trailing: const ClaudeCodeSettingSwitch(
                settingKey: ClaudeCodeKeys.switchModelsOnFlag,
                unsetValue: true,
              ),
            ),
          ],
        ),
        SettingsSection(
          title: tr.sectionCodeAppearance,
          rows: [
            const Padding(
              padding: EdgeInsets.only(bottom: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: CodeThemePicker(brightness: Brightness.light),
                  ),
                  SizedBox(width: 16),
                  Expanded(child: CodeThemePicker(brightness: Brightness.dark)),
                ],
              ),
            ),
            SettingsRow(
              title: tr.codeFontTitle,
              description: tr.codeFontDesc,
              trailing: SettingsTextField(
                value: s.codeFont,
                placeholder: tr.codeFontPlaceholder,
                onChanged: controller.setCodeFont,
              ),
            ),
          ],
        ),
        SettingsSection(
          title: tr.sectionAppearance,
          rows: [
            SettingsRow(
              title: tr.transcriptTitle,
              description: tr.transcriptDesc,
              trailing: SettingsSegmented<TranscriptView>(
                value: s.transcriptView,
                onChanged: controller.setTranscriptView,
                options: {
                  TranscriptView.normal: tr.viewNormal,
                  TranscriptView.thinking: tr.viewThinking,
                  TranscriptView.verbose: tr.viewVerbose,
                },
              ),
            ),
          ],
        ),
        SettingsSection(
          title: tr.sectionRemoteControl,
          rows: [
            // Motor CLI só em macOS/Linux (ver ChatEngineRouter).
            if (!Platform.isWindows)
              SettingsRow(
                title: tr.chatRemoteControlTitle,
                description: tr.chatRemoteControlDesc,
                trailing: Switch(
                  value: s.chatRemoteControl,
                  onChanged: controller.setChatRemoteControl,
                ),
              ),
            SettingsRow(
              title: tr.remoteControlTitle,
              description: tr.remoteControlDesc,
              trailing: const ClaudeCodeSettingSwitch(
                settingKey: ClaudeCodeKeys.remoteControlAtStartup,
                unsetValue: false,
                removeWhenDefault: true,
              ),
            ),
          ],
        ),
        SettingsSection(
          title: tr.sectionSessions,
          rows: [
            SettingsRow(
              title: tr.promptSuggestionsTitle,
              description: tr.promptSuggestionsDesc,
              trailing: const ClaudeCodeSettingSwitch(
                settingKey: ClaudeCodeKeys.promptSuggestion,
                unsetValue: true,
                removeWhenDefault: true,
              ),
            ),
            SettingsRow(
              title: tr.outputStyleTitle,
              description: tr.outputStyleDesc,
              trailing: const _OutputStyleDropdown(),
            ),
            SettingsRow(
              title: tr.crossSessionTitle,
              description: tr.crossSessionDesc,
              trailing: const _CrossSessionDropdown(),
            ),
            SettingsRow(
              title: tr.sandboxTitle,
              description: tr.sandboxDesc,
              trailing: const ClaudeCodeSettingSwitch(
                settingKey: ClaudeCodeKeys.sandboxEnabled,
                unsetValue: false,
                removeWhenDefault: true,
              ),
            ),
            SettingsRow(
              title: tr.sandboxStrictTitle,
              description: tr.sandboxStrictDesc,
              // Estrito = `allowUnsandboxedCommands: false`.
              trailing: const ClaudeCodeSettingSwitch(
                settingKey: ClaudeCodeKeys.sandboxAllowUnsandboxed,
                unsetValue: false,
                removeWhenDefault: true,
                onValue: false,
                offValue: true,
              ),
            ),
          ],
        ),
        SettingsSection(
          title: tr.sectionSecurity,
          rows: [
            SettingsRow(
              title: tr.protectedHostsTitle,
              description: tr.protectedHostsDesc,
              trailing: const _ProtectedHostsField(),
            ),
          ],
        ),
        SettingsSection(
          title: tr.sectionBrowser,
          rows: [
            SettingsRow(
              title: tr.linksInAppTitle,
              description: tr.linksInAppDesc,
              trailing: Switch(
                value: s.openLinksInApp,
                onChanged: controller.setOpenLinksInApp,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// "Hosts protegidos": lista separada por vírgula, gravada em
/// `~/.gsh/protected-hosts.json` ao confirmar ou sair do campo.
class _ProtectedHostsField extends StatefulWidget {
  const _ProtectedHostsField();

  @override
  State<_ProtectedHostsField> createState() => _ProtectedHostsFieldState();
}

class _ProtectedHostsFieldState extends State<_ProtectedHostsField> {
  final _store = inject<ProtectedHosts>();
  String? _value;

  @override
  void initState() {
    super.initState();
    _store.read().then((hosts) {
      if (mounted) setState(() => _value = hosts.join(', '));
    });
  }

  @override
  Widget build(BuildContext context) {
    final value = _value;
    if (value == null) return const SizedBox(width: 240);
    return SettingsTextField(
      value: value,
      placeholder: 'prod, homolog.gorila.com',
      onChanged: (text) {
        final hosts = (text ?? '').split(RegExp(r'[,\s]+'));
        _value = hosts.where((h) => h.isNotEmpty).join(', ');
        _store.write(hosts);
      },
    );
  }
}

/// "Mensagens de outras sessões" (`crossSessionInbound`): Padrão (ausente),
/// Aceitar, Segurar ou Recusar.
class _CrossSessionDropdown extends StatefulWidget {
  const _CrossSessionDropdown();

  @override
  State<_CrossSessionDropdown> createState() => _CrossSessionDropdownState();
}

class _CrossSessionDropdownState extends State<_CrossSessionDropdown> {
  final _settings = inject<ClaudeCodeSettings>();
  String? _value;

  @override
  void initState() {
    super.initState();
    _settings.getValue(ClaudeCodeKeys.crossSessionInbound).then((v) {
      if (mounted) setState(() => _value = v is String ? v : null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final tr = context.t.settings.page.claudeCode;
    final labels = <String?, String>{
      'accept': tr.crossSessionAccept,
      'hold': tr.crossSessionHold,
      'refuse': tr.crossSessionRefuse,
    };
    return SettingsDropdown(
      // Ausente = o GSH grava "accept" no boot; mostra como Aceitar.
      label: labels[_value ?? 'accept'] ?? _value!,
      onTap: () async {
        final picked = await showAppMenu<String>(
          context,
          items: [
            for (final e in labels.entries)
              AppMenuItem(
                value: e.key!,
                label: e.value,
                selected: (_value ?? 'accept') == e.key,
              ),
          ],
        );
        if (picked == null || !mounted) return;
        setState(() => _value = picked);
        await _settings.setValue(ClaudeCodeKeys.crossSessionInbound, picked);
      },
    );
  }
}

/// "Estilo de saída" (`outputStyle` do `~/.claude/settings.json`): Padrão
/// (chave ausente), os embutidos e os de `~/.claude/output-styles`.
class _OutputStyleDropdown extends StatefulWidget {
  const _OutputStyleDropdown();

  @override
  State<_OutputStyleDropdown> createState() => _OutputStyleDropdownState();
}

class _OutputStyleDropdownState extends State<_OutputStyleDropdown> {
  final _settings = inject<ClaudeCodeSettings>();
  String? _value;

  @override
  void initState() {
    super.initState();
    _settings.getValue(ClaudeCodeKeys.outputStyle).then((v) {
      if (mounted) setState(() => _value = v is String ? v : null);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<ClaudeInfoViewModel>().loadOutputStyles();
    });
  }

  @override
  Widget build(BuildContext context) {
    final styles = context.watch<ClaudeInfoViewModel>().outputStyles ?? [];
    final standard = context.t.settings.page.claudeCode.outputStyleDefault;
    return SettingsDropdown(
      label: _value ?? standard,
      onTap: () async {
        final picked = await showAppMenu<String>(
          context,
          items: [
            AppMenuItem(value: '', label: standard, selected: _value == null),
            for (final name in styles)
              AppMenuItem(value: name, label: name, selected: _value == name),
          ],
        );
        if (picked == null || !mounted) return;
        final next = picked.isEmpty ? null : picked;
        setState(() => _value = next);
        await _settings.setValue(ClaudeCodeKeys.outputStyle, next);
      },
    );
  }
}
