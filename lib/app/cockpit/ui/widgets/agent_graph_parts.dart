import 'package:cockpit/app/cockpit/domain/entities/desktop_agent_app.dart';
import 'package:cockpit/app/cockpit/ui/widgets/agent_graph_painter.dart';
import 'package:cockpit/app/core/ui/themes/themes.dart';
import 'package:cockpit/i18n/strings.g.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

/// Botão "+ Novo agente" do canvas (abre o menu de harnesses). Quem chama
/// envolve num `Builder` pra ancorar o menu no botão.
class NewAgentButton extends StatelessWidget {
  const NewAgentButton({super.key, required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => OutlineButton(
    onPressed: onPressed,
    leading: const Icon(Icons.add, size: 16),
    child: Text(context.t.cockpit.agentGraph.newAgent),
  );
}

/// Estado vazio: nenhum agente no workspace — dica + a ação de criar.
class AgentGraphEmpty extends StatelessWidget {
  const AgentGraphEmpty({super.key, required this.onCreate});
  final void Function(BuildContext anchor) onCreate;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tr = context.t.cockpit.agentGraph;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.hub_outlined, size: 36, color: colors.text4),
            const SizedBox(height: 12),
            Text(
              tr.emptyTitle,
              style: context.typo.title.copyWith(color: colors.text),
            ),
            const SizedBox(height: 6),
            Text(
              tr.emptyHint,
              textAlign: TextAlign.center,
              style: context.typo.body.copyWith(color: colors.text3),
            ),
            const SizedBox(height: 16),
            Builder(
              builder: (ctx) => NewAgentButton(onPressed: () => onCreate(ctx)),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tooltip de hover do cabo: volume + última mensagem, e como remover o link.
class CableTip extends StatelessWidget {
  const CableTip({super.key, required this.cable});
  final GraphCable cable;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tr = context.t.cockpit.agentGraph;
    final observed = cable.observed;
    final small = context.typo.label.copyWith(
      fontSize: 11,
      color: colors.text2,
    );
    return IgnorePointer(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 280),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: colors.panel3,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: colors.border2),
          boxShadow: [BoxShadow(color: colors.shadow, blurRadius: 6)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (cable.defined)
              Text(tr.linked, style: small.copyWith(color: colors.text)),
            if (observed != null) ...[
              Text(tr.messageCount(n: observed.count), style: small),
              Text(
                tr.lastMessage(preview: observed.last.preview),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: small.copyWith(color: colors.text3),
              ),
            ],
            if (cable.defined)
              Text(
                tr.removeLinkHint,
                style: small.copyWith(color: colors.text4),
              ),
          ],
        ),
      ),
    );
  }
}

/// Frase da falha de integração de um app desktop (erro tipado → i18n).
String desktopAppErrorMessage(BuildContext context, DesktopAppError e) {
  final tr = context.t.cockpit.agentGraph.integrationError;
  final detail = e.detail ?? '';
  return switch (e.kind) {
    DesktopAppErrorKind.invalidConfig => tr.invalidConfig(path: detail),
    DesktopAppErrorKind.cliMissing => tr.cliMissing(path: detail),
    DesktopAppErrorKind.writeFailed => tr.writeFailed(detail: detail),
  };
}

/// Aviso curto do canvas (canto inferior direito).
void showGraphToast(BuildContext context, String message) => showToast(
  context: context,
  location: ToastLocation.bottomRight,
  builder: (context, overlay) => SurfaceCard(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 360),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(message, style: context.typo.label),
      ),
    ),
  ),
);
