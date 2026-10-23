import 'package:cockpit/app/core/domain/contracts/claude_code_settings.dart';
import 'package:cockpit/app/core/domain/entities/app_settings.dart';
import 'package:cockpit/app/core/ui/settings_controller.dart';
import 'package:cockpit/app/core/ui/themes/themes.dart';
import 'package:cockpit/app/core/ui/widgets/app_menu.dart';
import 'package:cockpit/app/settings/ui/claude_code_setting_switch.dart';
import 'package:cockpit/app/settings/ui/claude_info_viewmodel.dart';
import 'package:cockpit/app/settings/ui/code_theme_picker.dart';
import 'package:cockpit/app/settings/ui/settings_widgets.dart';
import 'package:cockpit/i18n/strings.g.dart';
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
              trailing: _FontNameField(
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

/// Nome de fonte digitado à mão; grava ao confirmar ou sair do campo. Vazio
/// volta ao padrão.
class _FontNameField extends StatefulWidget {
  const _FontNameField({
    required this.value,
    required this.placeholder,
    required this.onChanged,
  });
  final String? value;
  final String placeholder;
  final ValueChanged<String?> onChanged;

  @override
  State<_FontNameField> createState() => _FontNameFieldState();
}

class _FontNameFieldState extends State<_FontNameField> {
  late final _text = TextEditingController(text: widget.value ?? '');
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(() {
      if (!_focus.hasFocus) _commit();
    });
  }

  @override
  void didUpdateWidget(_FontNameField old) {
    super.didUpdateWidget(old);
    // Mudou por fora (aba Aparência): reflete, a menos que esteja digitando.
    if (old.value != widget.value && !_focus.hasFocus) {
      _text.text = widget.value ?? '';
    }
  }

  @override
  void dispose() {
    _focus.dispose();
    _text.dispose();
    super.dispose();
  }

  void _commit() {
    final v = _text.text.trim();
    if (v != (widget.value ?? '')) widget.onChanged(v.isEmpty ? null : v);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SizedBox(
      width: 224,
      child: TextField(
        controller: _text,
        focusNode: _focus,
        onSubmitted: (_) => _commit(),
        style: context.typo.body.copyWith(fontSize: 13.5, color: colors.text),
        placeholder: Text(
          widget.placeholder,
          style: context.typo.body.copyWith(
            fontSize: 13.5,
            color: colors.text3,
          ),
        ),
        borderRadius: BorderRadius.circular(7),
      ),
    );
  }
}
