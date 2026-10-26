import 'package:flutter/services.dart';
import 'package:gsh_desktop/app/core/ui/themes/themes.dart';
import 'package:gsh_desktop/app/core/ui/widgets/hover_tap.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/chat_usage.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

/// Menu do `/` no composer: enquanto o texto começa com `/nome` (sem espaço
/// ainda), lista os comandos que batem — seus agentes, skills, comandos do
/// projeto e os do Claude Code. ↑/↓ escolhe, Enter/Tab insere, Esc fecha.
class ChatSlashState extends ChangeNotifier {
  ChatSlashState(this.input, this.commands) {
    input.addListener(_onText);
  }

  final TextEditingController input;
  final List<ChatCommandOption> Function() commands;

  static const maxShown = 8;

  List<ChatCommandOption> matches = const [];
  int index = 0;

  /// Texto em que o usuário deu Esc: o menu só volta quando ele mudar.
  String? _dismissedAt;

  bool get visible => matches.isNotEmpty;

  void _onText() {
    final next = slashMatches(
      input.text,
      commands(),
      dismissed: input.text == _dismissedAt,
    );
    if (next.length == matches.length &&
        next.indexed.every((e) => identical(e.$2, matches[e.$1]))) {
      return;
    }
    matches = next;
    index = 0;
    notifyListeners();
  }

  /// Recalcula (a lista de comandos chegou depois do texto).
  void refresh() => _onText();

  void move(int delta) {
    if (!visible) return;
    index = (index + delta) % matches.length;
    if (index < 0) index += matches.length;
    notifyListeners();
  }

  /// Troca o `/consulta` pelo `/nome ` escolhido.
  void accept([ChatCommandOption? c]) {
    final pick = c ?? (visible ? matches[index] : null);
    if (pick == null) return;
    final text = '/${pick.name} ';
    input.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
    matches = const [];
    notifyListeners();
  }

  void dismiss() {
    _dismissedAt = input.text;
    matches = const [];
    notifyListeners();
  }

  /// Atalhos que valem enquanto o menu está aberto (o mais perto do campo
  /// vence o Enter de enviar).
  Map<ShortcutActivator, VoidCallback> get bindings => {
    const SingleActivator(LogicalKeyboardKey.arrowDown): () => move(1),
    const SingleActivator(LogicalKeyboardKey.arrowUp): () => move(-1),
    const SingleActivator(LogicalKeyboardKey.enter): accept,
    const SingleActivator(LogicalKeyboardKey.tab): accept,
    const SingleActivator(LogicalKeyboardKey.escape): dismiss,
  };

  @override
  void dispose() {
    input.removeListener(_onText);
    super.dispose();
  }
}

/// Comandos que batem com o `/consulta` de [text]: nome que começa com ela,
/// depois apelido, depois nome que contém, depois descrição. Vazio quando
/// não é um `/` no começo, quando já tem espaço (o usuário passou para os
/// argumentos) ou quando foi dispensado.
List<ChatCommandOption> slashMatches(
  String text,
  List<ChatCommandOption> commands, {
  bool dismissed = false,
}) {
  if (dismissed || !text.startsWith('/') || text.contains(RegExp(r'\s'))) {
    return const [];
  }
  final q = text.substring(1).toLowerCase();
  final buckets = List.generate(4, (_) => <ChatCommandOption>[]);
  for (final c in commands) {
    final name = c.name.toLowerCase();
    if (name.startsWith(q)) {
      buckets[0].add(c);
    } else if (c.aliases.any((a) => a.toLowerCase().startsWith(q))) {
      buckets[1].add(c);
    } else if (name.contains(q)) {
      buckets[2].add(c);
    } else if (q.length >= 3 && c.description.toLowerCase().contains(q)) {
      buckets[3].add(c);
    }
  }
  return buckets.expand((b) => b).take(ChatSlashState.maxShown).toList();
}

/// A lista acima do campo.
class ChatSlashList extends StatelessWidget {
  const ChatSlashList({super.key, required this.state});
  final ChatSlashState state;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.typo;
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colors.panel2,
        border: Border.all(color: colors.border2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (i, c) in state.matches.indexed)
            HoverTap(
              onTap: () => state.accept(c),
              color: i == state.index ? colors.panel3 : null,
              borderRadius: BorderRadius.circular(6),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                children: [
                  Text(
                    '/${c.name}',
                    style: typo.mono.copyWith(
                      fontSize: 12.5,
                      color: colors.text,
                    ),
                  ),
                  if (c.argumentHint.isNotEmpty) ...[
                    const SizedBox(width: 6),
                    Text(
                      c.argumentHint,
                      style: typo.mono.copyWith(
                        fontSize: 12,
                        color: colors.text4,
                      ),
                    ),
                  ],
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      c.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: typo.label.copyWith(color: colors.text3),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
