import 'package:gsh_desktop/app/core/ui/themes/themes.dart';
import 'package:gsh_desktop/app/settings/domain/claude_info.dart';
import 'package:gsh_desktop/app/settings/ui/claude_info_viewmodel.dart';
import 'package:gsh_desktop/app/settings/ui/settings_widgets.dart';
import 'package:gsh_desktop/i18n/strings.g.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

/// Aba **Uso**: limites do plano claude.ai (sessão de 5 h e semanais, um
/// por modelo quando o servidor separa), lidos pelo `get_usage` da CLI.
class UsagePanel extends StatefulWidget {
  const UsagePanel({super.key});

  @override
  State<UsagePanel> createState() => _UsagePanelState();
}

class _UsagePanelState extends State<UsagePanel> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<ClaudeInfoViewModel>().loadUsage();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ClaudeInfoViewModel>();
    final tr = context.t.settings.page.usage;
    final colors = context.colors;
    final u = vm.usage.value;
    final session = u?.windows.where((w) => w.kind == UsageWindowKind.session);
    final weekly = u?.windows.where((w) => w.kind != UsageWindowKind.session);
    return SettingsPanelBody(
      children: [
        SettingsSection(
          title: tr.title,
          action: u?.subscriptionType == null
              ? null
              : Text(
                  planLabel(context, u!.subscriptionType!),
                  style: context.typo.body.copyWith(color: colors.text3),
                ),
          rows: [
            if (u == null)
              ...infoLoadRows(context, vm.usage, (_) => [], empty: '')
            else if (!u.available)
              SettingsNote(tr.unavailable)
            else
              for (final w in session!) _WindowRow(w),
          ],
        ),
        if (u != null && u.available && weekly!.isNotEmpty)
          SettingsSection(
            title: tr.weeklyTitle,
            rows: [for (final w in weekly) _WindowRow(w)],
          ),
        if (vm.usage.at case final at?)
          Row(
            children: [
              Text(
                tr.updated(when: _ago(context, at)),
                style: context.typo.body.copyWith(
                  fontSize: 13,
                  color: colors.text3,
                ),
              ),
              const SizedBox(width: 6),
              IconButton.ghost(
                size: ButtonSize.small,
                onPressed: vm.usage.loading
                    ? null
                    : () => vm.loadUsage(force: true),
                icon: vm.usage.loading
                    ? const CircularProgressIndicator(size: 12)
                    : const Icon(Icons.refresh, size: 15),
              ),
            ],
          ),
      ],
    );
  }

  static String _ago(BuildContext context, DateTime at) {
    final tr = context.t.settings.page.usage;
    final min = DateTime.now().difference(at).inMinutes;
    return min < 1 ? tr.justNow : tr.minutesAgo(n: min);
  }
}

/// Nome do plano como o Desktop mostra (`team` → "Equipe"); desconhecido
/// passa cru.
String planLabel(BuildContext context, String plan) {
  final tr = context.t.settings.page.usage.plans;
  return switch (plan.toLowerCase()) {
    'pro' => tr.pro,
    'max' => tr.max,
    'team' => tr.team,
    'enterprise' => tr.enterprise,
    _ => plan,
  };
}

class _WindowRow extends StatelessWidget {
  const _WindowRow(this.window);
  final UsageWindow window;

  @override
  Widget build(BuildContext context) {
    final tr = context.t.settings.page.usage;
    final colors = context.colors;
    final pct = window.percent;
    final title = switch (window.kind) {
      UsageWindowKind.session => tr.windowSession,
      UsageWindowKind.weekly => tr.windowWeekly,
      UsageWindowKind.weeklyModel => window.label ?? '—',
    };
    final fill = pct == null
        ? colors.text4
        : pct >= 100
        ? colors.error
        : pct >= 80
        ? colors.warn
        : colors.accent;
    final reset = window.resetsAt;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 4,
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
                if (reset != null)
                  Text(
                    window.kind == UsageWindowKind.session
                        ? tr.resetsIn(when: _duration(context, reset))
                        : tr.resetsAt(when: _weekdayTime(context, reset)),
                    style: context.typo.body.copyWith(
                      fontSize: 13,
                      color: colors.text3,
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            flex: 5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: SizedBox(
                height: 8,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ColoredBox(color: colors.panel3),
                    FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: ((pct ?? 0) / 100).clamp(0.0, 1.0),
                      child: ColoredBox(color: fill),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: 100,
            child: Text(
              pct == null ? '—' : tr.percentUsed(pct: pct.round()),
              textAlign: TextAlign.right,
              style: context.typo.body.copyWith(
                fontSize: 13,
                color: colors.text2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// "4 h 48 min" até [at].
  static String _duration(BuildContext context, DateTime at) {
    final tr = context.t.settings.page.usage;
    final d = at.difference(DateTime.now());
    if (d.isNegative) return tr.minutes(m: 0);
    final h = d.inHours;
    final m = d.inMinutes % 60;
    return h == 0 ? tr.minutes(m: m) : tr.hoursMinutes(h: h, m: m);
  }

  /// "dom., 17:00".
  static String _weekdayTime(BuildContext context, DateTime at) {
    String two(int n) => n.toString().padLeft(2, '0');
    final day = context.t.settings.page.claude.weekdays.split(
      '|',
    )[at.weekday - 1];
    return '$day, ${two(at.hour)}:${two(at.minute)}';
  }
}
