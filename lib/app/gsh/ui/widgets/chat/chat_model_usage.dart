import 'dart:math' as math;

import 'package:gsh_desktop/app/core/ui/themes/themes.dart';
import 'package:gsh_desktop/app/core/ui/widgets/app_menu.dart';
import 'package:gsh_desktop/app/core/ui/widgets/app_tooltip.dart';
import 'package:gsh_desktop/app/core/ui/widgets/hover_tap.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/chat_usage.dart';
import 'package:gsh_desktop/app/gsh/ui/viewmodels/chat_viewmodel.dart';
import 'package:gsh_desktop/i18n/strings.g.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

/// Nome curto do modelo: `claude-opus-4-5-20251101` → `Opus 4.5`. Id que não
/// segue o padrão volta como veio.
String shortModelName(String? id) {
  if (id == null || id.isEmpty) return 'Claude';
  final m = RegExp(
    r'(opus|sonnet|haiku|fable)-(\d{1,2})(?:-(\d{1,2}))?(?!\d)',
  ).firstMatch(id);
  if (m == null) return id;
  final family = '${m[1]![0].toUpperCase()}${m[1]!.substring(1)}';
  return m[3] == null ? '$family ${m[2]}' : '$family ${m[2]}.${m[3]}';
}

/// Botão do modelo no composer: mostra o modelo da conversa e abre a lista
/// de modelos da conta (nome + descrição), como no Claude Desktop.
class ChatModelButton extends StatelessWidget {
  const ChatModelButton({super.key, required this.chat});
  final ChatController chat;

  ChatModelOption? get _chosen {
    final v = chat.modelChoice;
    for (final m in chat.models) {
      if (m.value == v) return m;
    }
    return null;
  }

  Future<void> _pick(BuildContext anchor) async {
    await chat.refreshAccount();
    if (!anchor.mounted || chat.models.isEmpty) return;
    final colors = anchor.colors;
    final typo = anchor.typo;
    final current = chat.modelChoice;
    final value = await showAppMenu<String>(
      anchor,
      items: [
        for (final m in chat.models)
          AppMenuItem(
            value: m.value,
            label: m.displayName,
            selected: current != null
                ? m.value == current
                : (m.resolved != null && m.resolved == chat.model),
            labelWidget: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(m.displayName, style: typo.body.copyWith(fontSize: 13)),
                if (m.description.isNotEmpty)
                  Text(
                    m.description,
                    style: typo.label.copyWith(
                      fontSize: 11.5,
                      color: colors.text3,
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
    if (value != null) chat.setModel(value);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final name = _chosen?.displayName ?? shortModelName(chat.model);
    return Builder(
      builder: (anchor) => HoverTap(
        onTap: () => _pick(anchor),
        borderRadius: BorderRadius.circular(6),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              name,
              style: context.typo.label.copyWith(
                fontSize: 13,
                color: colors.text2,
              ),
            ),
            const SizedBox(width: 2),
            Icon(Icons.expand_more, size: 15, color: colors.text3),
          ],
        ),
      ),
    );
  }
}

/// Anel de uso: quanto do contexto a conversa ocupa (ou, antes da primeira
/// resposta, a sessão de 5 h do plano). Clique abre os limites do plano.
class ChatUsageRing extends StatelessWidget {
  const ChatUsageRing({super.key, required this.chat});
  final ChatController chat;

  double? get _fraction {
    if (chat.contextWindow > 0 && chat.contextTokens > 0) {
      return chat.contextTokens / chat.contextWindow;
    }
    final session = chat.planUsage?.limits
        .where((l) => l.kind == ChatLimitKind.session)
        .firstOrNull;
    return session == null ? null : session.percent / 100;
  }

  void _open(BuildContext anchor) {
    showPopover<void>(
      context: anchor,
      alignment: Alignment.bottomRight,
      anchorAlignment: Alignment.topRight,
      offset: const Offset(0, -6),
      builder: (_) => ListenableBuilder(
        listenable: chat,
        builder: (context, _) => _UsagePanel(chat: chat),
      ),
    );
    chat.refreshAccount(fresh: true);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final f = _fraction;
    final warn =
        (f ?? 0) >= 0.8 ||
        (chat.planUsage?.limits.any((l) => l.warning) ?? false);
    return AppTooltip(
      message: context.t.gsh.chat.usage,
      child: Builder(
        builder: (anchor) => HoverTap(
          onTap: () => _open(anchor),
          borderRadius: BorderRadius.circular(6),
          padding: const EdgeInsets.all(5),
          child: SizedBox(
            width: 15,
            height: 15,
            child: CustomPaint(
              painter: _RingPainter(
                fraction: f ?? 0,
                track: colors.border2,
                fill: warn ? colors.warn : colors.text2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.fraction,
    required this.track,
    required this.fill,
  });
  final double fraction;
  final Color track, fill;

  @override
  void paint(Canvas canvas, Size size) {
    final r = Rect.fromLTWH(1.5, 1.5, size.width - 3, size.height - 3);
    final p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(r, 0, math.pi * 2, false, p..color = track);
    if (fraction > 0) {
      canvas.drawArc(
        r,
        -math.pi / 2,
        math.pi * 2 * fraction.clamp(0.02, 1.0),
        false,
        p..color = fill,
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.fraction != fraction || old.fill != fill || old.track != track;
}

class _UsagePanel extends StatelessWidget {
  const _UsagePanel({required this.chat});
  final ChatController chat;

  @override
  Widget build(BuildContext context) {
    final tr = context.t.gsh.chat;
    final colors = context.colors;
    final typo = context.typo;
    String resets(DateTime? at) {
      if (at == null) return '';
      final now = DateTime.now();
      String two(int n) => n.toString().padLeft(2, '0');
      final time = '${two(at.hour)}:${two(at.minute)}';
      final sameDay =
          at.year == now.year && at.month == now.month && at.day == now.day;
      return sameDay
          ? tr.usageResetsToday(time: time)
          : tr.usageResetsOn(
              date: '${two(at.day)}/${two(at.month)}',
              time: time,
            );
    }

    final rows = <(String, double?, String, bool)>[];
    if (chat.contextWindow > 0 && chat.contextTokens > 0) {
      final pct = (chat.contextTokens * 100 / chat.contextWindow).round();
      rows.add((
        tr.usageContext(
          used: _compact(chat.contextTokens),
          window: _compact(chat.contextWindow),
        ),
        chat.contextTokens / chat.contextWindow,
        '$pct%',
        pct >= 80,
      ));
    } else {
      rows.add((tr.usageContextNone, null, '', false));
    }
    for (final l in chat.planUsage?.limits ?? const <ChatLimit>[]) {
      final title = switch (l.kind) {
        ChatLimitKind.session => tr.usageSession,
        ChatLimitKind.weekly => tr.usageWeek,
        ChatLimitKind.weeklyModel => tr.usageModelWeek(model: l.model ?? ''),
        ChatLimitKind.other => '',
      };
      if (title.isEmpty) continue;
      rows.add((
        title,
        l.percent / 100,
        '${l.percent}% · ${resets(l.resetsAt)}',
        l.warning,
      ));
    }
    return Container(
      width: 300,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.panel2,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.border2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(tr.usage, style: typo.title),
          const SizedBox(height: 10),
          for (final (title, frac, detail, warn) in rows) ...[
            Row(
              children: [
                Expanded(
                  child: Text(title, style: typo.body.copyWith(fontSize: 13)),
                ),
                Text(
                  detail,
                  style: typo.label.copyWith(
                    color: warn ? colors.warn : colors.text3,
                  ),
                ),
              ],
            ),
            if (frac != null) ...[
              const SizedBox(height: 5),
              ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(
                  value: frac.clamp(0.0, 1.0),
                  minHeight: 5,
                  backgroundColor: colors.panel3,
                  color: warn ? colors.warn : colors.accent,
                ),
              ),
            ],
            const SizedBox(height: 10),
          ],
          if (chat.planUsage == null)
            Text(
              tr.usageUnavailable,
              style: typo.label.copyWith(color: colors.text3),
            ),
        ],
      ),
    );
  }
}

String _compact(int n) {
  if (n >= 1000000) {
    final m = n / 1000000;
    return m == m.roundToDouble()
        ? '${m.round()}M'
        : '${m.toStringAsFixed(1)}M';
  }
  if (n >= 1000) return '${(n / 1000).round()}k';
  return '$n';
}
