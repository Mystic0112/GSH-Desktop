part of 'new_agent_dialog.dart';

// Modo desktop do "New agent": a linha de apps detectados e a caixa que mostra
// exatamente o que entra no config MCP do app (com o aceite).

class _DesktopAppsRow extends StatelessWidget {
  const _DesktopAppsRow({
    required this.apps,
    required this.selected,
    required this.onPick,
  });
  final List<DesktopAppIntegration> apps;
  final DesktopAgentApp? selected;
  final ValueChanged<DesktopAppIntegration> onPick;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Caption(context.t.cockpit.agentGraph.desktopApps.toUpperCase()),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final i in apps)
                OutlineButton(
                  size: ButtonSize.small,
                  leading: switch (HarnessCatalog.getSpec(i.app.icon)) {
                    final spec? => HarnessIcon(spec, color: colors.text),
                    null => const Icon(
                      Icons.desktop_windows_outlined,
                      size: 16,
                    ),
                  },
                  trailing: i.app == selected
                      ? Icon(Icons.check, size: 14, color: colors.accent)
                      : null,
                  onPressed: () => onPick(i),
                  child: Text(i.app.label),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _IntegrationBox extends StatelessWidget {
  const _IntegrationBox({
    required this.integration,
    required this.consent,
    required this.onConsent,
  });
  final DesktopAppIntegration integration;
  final bool consent;
  final ValueChanged<bool> onConsent;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tr = context.t.cockpit.agentGraph;
    final mono = context.typo.mono.copyWith(fontSize: 11.5);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Caption(tr.integration),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: colors.panel3,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: colors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SelectableText(
                integration.configPath,
                style: mono.copyWith(color: colors.text2),
              ),
              const SizedBox(height: 6),
              SelectableText(
                integration.entry,
                style: mono.copyWith(color: colors.text),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          tr.integrationHint,
          style: context.typo.label.copyWith(color: colors.text3),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Checkbox(
              state: consent ? CheckboxState.checked : CheckboxState.unchecked,
              onChanged: (v) => onConsent(v == CheckboxState.checked),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: GestureDetector(
                onTap: () => onConsent(!consent),
                child: Text(
                  tr.integrationConsent(app: integration.app.label),
                  style: context.typo.body.copyWith(color: colors.text),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
