import 'package:cockpit/app/core/ui/themes/themes.dart';
import 'package:cockpit/app/settings/ui/settings_widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

/// Aba sem equivalente no GSH (Cowork, Extensões): o título e as linhas que
/// explicam onde fica o equivalente. Com [icon], o texto vem centralizado
/// como estado vazio (o layout do Extensões no Claude Desktop).
class SettingsPlaceholderPanel extends StatelessWidget {
  const SettingsPlaceholderPanel({
    super.key,
    required this.title,
    required this.lines,
    this.description,
    this.icon,
  });
  final String title;
  final String? description;
  final List<String> lines;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final emptyIcon = icon;
    if (emptyIcon == null) {
      return SettingsPanelBody(
        children: [
          SettingsSection(
            title: title,
            rows: [for (final l in lines) SettingsNote(l)],
          ),
        ],
      );
    }
    return SettingsPanelBody(
      children: [
        SettingsSection(title: title, description: description, rows: const []),
        Icon(emptyIcon, size: 64, color: colors.text3),
        const SizedBox(height: 14),
        for (final (i, l) in lines.indexed)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              l,
              textAlign: TextAlign.center,
              style: context.typo.body.copyWith(
                fontSize: i == 0 ? 14.5 : 13.5,
                color: i == 0 ? colors.text2 : colors.text3,
              ),
            ),
          ),
      ],
    );
  }
}
