import 'package:cockpit/app/cockpit/ui/viewmodels/chat_viewmodel.dart';
import 'package:cockpit/app/cockpit/ui/widgets/agent_markdown.dart';
import 'package:cockpit/app/core/ui/themes/themes.dart';
import 'package:cockpit/app/core/ui/widgets/hover_tap.dart';
import 'package:cockpit/i18n/strings.g.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

/// Moldura comum dos cartões que esperam o usuário: borda amarela enquanto
/// pendente, neutra depois.
class _PromptFrame extends StatelessWidget {
  const _PromptFrame({
    required this.pending,
    required this.title,
    required this.child,
  });
  final bool pending;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.panel2,
        border: Border.all(color: pending ? colors.warn : colors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: context.typo.title.copyWith(color: colors.text)),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

/// Pergunta com opções (`AskUserQuestion`): clica nas opções (uma, ou várias
/// quando a pergunta permite), ou escreve em "Outro", e responde.
class ChatQuestionCard extends StatefulWidget {
  const ChatQuestionCard({super.key, required this.item, required this.chat});
  final ChatQuestionItem item;
  final ChatController chat;

  @override
  State<ChatQuestionCard> createState() => _ChatQuestionCardState();
}

class _ChatQuestionCardState extends State<ChatQuestionCard> {
  /// pergunta → rótulos escolhidos.
  final _picked = <String, Set<String>>{};
  final _other = <String, TextEditingController>{};

  @override
  void dispose() {
    for (final c in _other.values) {
      c.dispose();
    }
    super.dispose();
  }

  TextEditingController _otherOf(String q) =>
      _other[q] ??= TextEditingController()..addListener(() => setState(() {}));

  String? _answerOf(ChatQuestion q) {
    final other = _otherOf(q.question).text.trim();
    final picked = [
      for (final (label, _) in q.options)
        if (_picked[q.question]?.contains(label) ?? false) label,
      if (other.isNotEmpty) other,
    ];
    return picked.isEmpty ? null : picked.join(', ');
  }

  void _toggle(ChatQuestion q, String label) => setState(() {
    final set = _picked.putIfAbsent(q.question, () => <String>{});
    if (q.multiSelect) {
      if (!set.remove(label)) set.add(label);
    } else {
      set
        ..clear()
        ..add(label);
      _otherOf(q.question).clear();
    }
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tr = context.t.cockpit.chat;
    final item = widget.item;
    final answered = item.answers;
    final answers = {for (final q in item.questions) q.question: _answerOf(q)};
    final ready = answers.values.every((a) => a != null);

    return _PromptFrame(
      pending: answered == null,
      title: tr.questionTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final q in item.questions) ...[
            if (q.header.isNotEmpty)
              Text(
                q.header.toUpperCase(),
                style: context.typo.label.copyWith(
                  fontSize: 10.5,
                  color: colors.text3,
                  letterSpacing: 0.6,
                ),
              ),
            Text(
              q.question,
              style: context.typo.body.copyWith(color: colors.text),
            ),
            const SizedBox(height: 6),
            if (answered != null)
              Text(
                '→ ${answered[q.question] ?? ''}',
                style: context.typo.body.copyWith(color: colors.online),
              )
            else ...[
              for (final (label, description) in q.options)
                _Option(
                  label: label,
                  description: description,
                  multi: q.multiSelect,
                  selected: _picked[q.question]?.contains(label) ?? false,
                  onTap: () => _toggle(q, label),
                ),
              const SizedBox(height: 4),
              TextField(
                controller: _otherOf(q.question),
                placeholder: Text(
                  tr.other,
                  style: context.typo.body.copyWith(color: colors.text4),
                ),
                style: context.typo.body.copyWith(color: colors.text),
              ),
            ],
            const SizedBox(height: 10),
          ],
          if (answered == null)
            PrimaryButton(
              onPressed: ready
                  ? () => widget.chat.answerQuestions(
                      item,
                      answers.map((k, v) => MapEntry(k, v!)),
                    )
                  : null,
              child: Text(tr.answer),
            ),
        ],
      ),
    );
  }
}

class _Option extends StatelessWidget {
  const _Option({
    required this.label,
    required this.description,
    required this.multi,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final String description;
  final bool multi;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final icon = multi
        ? (selected ? Icons.check_box : Icons.check_box_outline_blank)
        : (selected ? Icons.radio_button_checked : Icons.radio_button_off);
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: HoverTap(
        onTap: onTap,
        color: selected ? colors.accentSoft : null,
        hoverColor: colors.panel3,
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 16,
                color: selected ? colors.accentText : colors.text3,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: context.typo.body.copyWith(color: colors.text),
                    ),
                    if (description.isNotEmpty)
                      Text(
                        description,
                        style: context.typo.label.copyWith(color: colors.text3),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Plano do agente (`ExitPlanMode`): o markdown e as duas saídas — aprovar e
/// executar, ou continuar planejando com um ajuste.
class ChatPlanCard extends StatefulWidget {
  const ChatPlanCard({super.key, required this.item, required this.chat});
  final ChatPlanItem item;
  final ChatController chat;

  @override
  State<ChatPlanCard> createState() => _ChatPlanCardState();
}

class _ChatPlanCardState extends State<ChatPlanCard> {
  final _feedback = TextEditingController();
  bool _refining = false;

  @override
  void dispose() {
    _feedback.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tr = context.t.cockpit.chat;
    final item = widget.item;
    final decision = item.decision;
    return _PromptFrame(
      pending: decision == null,
      title: tr.planTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AgentMarkdown(item.plan),
          const SizedBox(height: 10),
          switch (decision) {
            ChatPlanDecision.approved => Text(
              tr.planApproved,
              style: context.typo.label.copyWith(color: colors.online),
            ),
            ChatPlanDecision.refined => Text(
              item.feedback.isEmpty
                  ? tr.planRefined
                  : tr.planRefinedWith(text: item.feedback),
              style: context.typo.label.copyWith(color: colors.warn),
            ),
            null when _refining => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _feedback,
                  minLines: 2,
                  maxLines: 6,
                  placeholder: Text(
                    tr.planRefineHint,
                    style: context.typo.body.copyWith(color: colors.text4),
                  ),
                  style: context.typo.body.copyWith(color: colors.text),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    PrimaryButton(
                      onPressed: () =>
                          widget.chat.refinePlan(item, _feedback.text),
                      child: Text(tr.planSendRefine),
                    ),
                    const SizedBox(width: 8),
                    GhostButton(
                      onPressed: () => setState(() => _refining = false),
                      child: Text(context.t.common.cancel),
                    ),
                  ],
                ),
              ],
            ),
            null => Row(
              children: [
                PrimaryButton(
                  onPressed: () => widget.chat.approvePlan(item),
                  child: Text(tr.planApprove),
                ),
                const SizedBox(width: 8),
                OutlineButton(
                  onPressed: () => setState(() => _refining = true),
                  child: Text(tr.planRefine),
                ),
              ],
            ),
          },
        ],
      ),
    );
  }
}

/// Pedido de permissão de uma ferramenta: Permitir, Sempre permitir (regra
/// sugerida pelo Claude Code) ou Negar, com o diff quando a ferramenta edita.
class ChatPermissionCard extends StatelessWidget {
  const ChatPermissionCard({super.key, required this.ask, required this.chat});
  final ChatPermissionItem ask;
  final ChatController chat;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tr = context.t.cockpit.chat;
    final decided = ask.allowed;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.panel2,
        border: Border.all(
          color: decided == null ? colors.warn : colors.border,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr.askPermission(tool: ask.toolName),
            style: context.typo.title.copyWith(color: colors.text),
          ),
          const SizedBox(height: 6),
          SelectableText(
            ask.summary,
            style: context.typo.mono.copyWith(
              fontSize: 12,
              color: colors.text2,
            ),
          ),
          if (ChatEditDiff.of(ask.toolName, ask.input) case final diff?) ...[
            const SizedBox(height: 8),
            diff,
          ],
          const SizedBox(height: 10),
          if (decided == null)
            Row(
              children: [
                PrimaryButton(
                  onPressed: () => chat.answer(ask, allow: true),
                  child: Text(tr.allow),
                ),
                const SizedBox(width: 8),
                if (ask.alwaysRule case final rule?) ...[
                  const SizedBox(width: 8),
                  OutlineButton(
                    onPressed: () =>
                        chat.answer(ask, allow: true, always: true),
                    child: Text(tr.allowAlways(rule: rule)),
                  ),
                ],
                const SizedBox(width: 8),
                OutlineButton(
                  onPressed: () => chat.answer(ask, allow: false),
                  child: Text(tr.deny),
                ),
              ],
            )
          else
            Text(
              !decided
                  ? tr.denied
                  : ask.always
                  ? tr.allowedAlways(rule: ask.alwaysRule ?? '')
                  : tr.allowed,
              style: context.typo.label.copyWith(
                color: decided ? colors.online : colors.error,
              ),
            ),
        ],
      ),
    );
  }
}

/// O que um Edit/MultiEdit/Write muda, em linhas `-`/`+`. `null` para
/// ferramentas que não editam arquivo.
class ChatEditDiff extends StatelessWidget {
  const ChatEditDiff(this.hunks, {super.key});

  /// Pares (antes, depois); `antes` vazio = arquivo novo/sobrescrito.
  final List<(String, String)> hunks;

  static const _maxLines = 40;

  static Widget? of(String tool, Map<String, dynamic> input) {
    String str(Object? v) => v is String ? v : '';
    final hunks = switch (tool) {
      'Edit' => [(str(input['old_string']), str(input['new_string']))],
      'MultiEdit' => [
        for (final e in (input['edits'] as List? ?? const []).whereType<Map>())
          (str(e['old_string']), str(e['new_string'])),
      ],
      'Write' => [('', str(input['content']))],
      _ => const <(String, String)>[],
    };
    return hunks.isEmpty ? null : ChatEditDiff(hunks);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final style = context.typo.mono.copyWith(fontSize: 11.5, height: 1.4);
    final lines = <(String, Color?, Color)>[];
    for (final (before, after) in hunks) {
      if (lines.isNotEmpty) lines.add(('⋯', null, colors.text4));
      for (final l in before.isEmpty ? const <String>[] : before.split('\n')) {
        lines.add(('- $l', colors.error.withValues(alpha: 0.12), colors.text2));
      }
      for (final l in after.split('\n')) {
        lines.add(('+ $l', colors.online.withValues(alpha: 0.12), colors.text));
      }
    }
    final shown = lines.take(_maxLines).toList();
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.panel,
        border: Border.all(color: colors.border),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (text, bg, fg) in shown)
            Container(
              color: bg,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(text, style: style.copyWith(color: fg)),
            ),
          if (lines.length > shown.length)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              child: Text(
                context.t.cockpit.chat.moreLines(
                  n: lines.length - shown.length,
                ),
                style: style.copyWith(color: colors.text3),
              ),
            ),
        ],
      ),
    );
  }
}
