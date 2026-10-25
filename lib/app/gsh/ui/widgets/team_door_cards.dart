import 'package:gsh_desktop/app/core/ui/themes/themes.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/team_farm.dart';
import 'package:gsh_desktop/app/gsh/ui/viewmodels/team_post.dart';
import 'package:gsh_desktop/i18n/strings.g.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

/// A porta, com "perguntar antes de abrir" ligado: um cartão por batida de
/// colega esperando, no canto da tela, com **Abrir a porta** / **Recusar**.
/// Sem batidas, não ocupa nada.
class TeamDoorCards extends StatelessWidget {
  const TeamDoorCards({
    super.key,
    required this.post,
    required this.agentLabel,
  });

  final TeamPost post;

  /// Nome da aba local que vai receber (`tabId` → rótulo).
  final String Function(String tabId) agentLabel;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: post,
    builder: (context, _) {
      final pending = post.pending;
      if (pending.isEmpty) return const SizedBox.shrink();
      return ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final k in pending.take(3)) ...[
              _DoorCard(post: post, knock: k, target: agentLabel(k.toTabId)),
              const SizedBox(height: 8),
            ],
          ],
        ),
      );
    },
  );
}

class _DoorCard extends StatelessWidget {
  const _DoorCard({
    required this.post,
    required this.knock,
    required this.target,
  });

  final TeamPost post;
  final TeamKnock knock;
  final String target;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.typo;
    final tr = context.t.gsh.farm;
    final head = knock.kind == TeamKnockKind.file
        ? tr.doorFile(
            name: knock.fromName,
            agent: knock.fromAgent,
            file: knock.fileName ?? '',
            target: target,
          )
        : tr.doorMessage(
            name: knock.fromName,
            agent: knock.fromAgent,
            target: target,
          );
    final preview = knock.text.trim();
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.panel2,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.warn),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(tr.doorTitle, style: typo.label.copyWith(color: colors.warn)),
          const SizedBox(height: 4),
          Text(head, style: typo.body.copyWith(fontSize: 13.5)),
          if (preview.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              preview,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: typo.label.copyWith(color: colors.text2),
            ),
          ],
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GhostButton(
                onPressed: () => post.refuse(knock),
                child: Text(tr.doorRefuse),
              ),
              const SizedBox(width: 8),
              PrimaryButton(
                onPressed: () => post.open(knock),
                child: Text(tr.doorOpen),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
