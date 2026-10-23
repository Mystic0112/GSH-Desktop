import 'package:cockpit/app/core/domain/contracts/claude_code_settings.dart';
import 'package:cockpit/app/core/domain/entities/app_settings.dart';
import 'package:cockpit/app/core/ui/settings_controller.dart';
import 'package:cockpit/app/core/ui/themes/themes.dart';
import 'package:cockpit/app/core/ui/widgets/hover_tap.dart';
import 'package:cockpit/app/settings/ui/claude_code_setting_switch.dart';
import 'package:cockpit/app/settings/ui/code_theme_picker.dart';
import 'package:cockpit/i18n/strings.g.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

/// Aba **Claude Code** das Configurações: preferências do chat (GSH) e
/// chaves do `~/.claude/settings.json`, em linhas planas sob títulos de seção.
class ClaudeCodePanel extends StatelessWidget {
  const ClaudeCodePanel({super.key});

  /// Largura máxima do conteúdo (a da referência).
  static const maxWidth = 1010.0;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<SettingsController>();
    final s = controller.settings;
    final tr = context.t.settings.page.claudeCode;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 26, 28, 48),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: maxWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Section(
                title: tr.sectionGeneral,
                rows: [
                  _Row(
                    title: tr.classifyTitle,
                    description: tr.classifyDesc,
                    trailing: Switch(
                      value: s.classifySessionStates,
                      onChanged: controller.setClassifySessionStates,
                    ),
                  ),
                  _Row(
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
              _Section(
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
                        Expanded(
                          child: CodeThemePicker(brightness: Brightness.dark),
                        ),
                      ],
                    ),
                  ),
                  _Row(
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
              _Section(
                title: tr.sectionAppearance,
                rows: [
                  _Row(
                    title: tr.transcriptTitle,
                    description: tr.transcriptDesc,
                    trailing: _Segmented<TranscriptView>(
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
              _Section(
                title: tr.sectionRemoteControl,
                rows: [
                  _Row(
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
            ],
          ),
        ),
      ),
    );
  }
}

/// Título em negrito e as linhas abaixo, separadas por um fio.
class _Section extends StatelessWidget {
  const _Section({required this.title, required this.rows});
  final String title;
  final List<Widget> rows;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Text(
              title,
              style: context.typo.body.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: colors.text,
              ),
            ),
          ),
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0) Divider(height: 1, thickness: 1, color: colors.border),
            rows[i],
          ],
        ],
      ),
    );
  }
}

/// Título + descrição à esquerda, controle à direita (centralizado na altura).
class _Row extends StatelessWidget {
  const _Row({required this.title, required this.trailing, this.description});
  final String title;
  final String? description;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.typo.body.copyWith(
                    fontSize: 14,
                    color: colors.text,
                  ),
                ),
                if (description case final d?) ...[
                  const SizedBox(height: 4),
                  Text(
                    d,
                    style: context.typo.body.copyWith(
                      fontSize: 13.5,
                      height: 1.45,
                      color: colors.text3,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 40),
          trailing,
        ],
      ),
    );
  }
}

/// Controle segmentado: uma pílula com as opções, a escolhida em relevo.
class _Segmented<T> extends StatelessWidget {
  const _Segmented({
    required this.value,
    required this.options,
    required this.onChanged,
  });
  final T value;
  final Map<T, String> options;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: colors.panel2,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final MapEntry(:key, value: label) in options.entries)
            HoverTap(
              onTap: () => onChanged(key),
              color: key == value ? colors.panel3 : null,
              hoverColor: key == value ? colors.panel3 : colors.panel,
              border: Border.all(
                color: key == value ? colors.border2 : Colors.transparent,
              ),
              borderRadius: BorderRadius.circular(6),
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
              child: Text(
                label,
                style: context.typo.body.copyWith(
                  fontSize: 13.5,
                  color: key == value ? colors.text : colors.text2,
                  fontWeight: key == value ? FontWeight.w500 : null,
                ),
              ),
            ),
        ],
      ),
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
