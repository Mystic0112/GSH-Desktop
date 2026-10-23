import 'package:gsh_desktop/app/gsh/domain/entities/agent_message.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/desktop_agent_app.dart';
import 'package:gsh_desktop/app/gsh/ui/viewmodels/agent_graph_store.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/agent_graph_painter.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/agent_graph_parts.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/new_agent_dialog.dart';
import 'package:gsh_desktop/app/core/domain/entities/harness.dart';
import 'package:gsh_desktop/app/core/ui/themes/themes.dart';
import 'package:gsh_desktop/i18n/strings.g.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

void main() {
  testWidgets('cabos, pulso, tooltip e estado vazio renderizam', (
    tester,
  ) async {
    final observed = observedEdges([
      AgentMessage(
        fromTabId: 't1',
        toTabId: 't2',
        sentAt: DateTime(2026),
        preview: 'diff pronto',
      ),
    ]);
    final cables = buildCables(
      defined: {('t1', 't3')},
      observed: observed,
      nodes: {'t1', 't2', 't3'},
    );
    var created = 0;
    await tester.pumpWidget(
      TranslationProvider(
        child: ShadcnApp(
          theme: buildTheme(brightness: Brightness.dark),
          home: Scaffold(
            child: Column(
              children: [
                SizedBox(
                  width: 600,
                  height: 300,
                  child: CustomPaint(
                    painter: AgentGraphPainter(
                      positions: const {
                        't1': Offset(0, 0),
                        't2': Offset(300, 0),
                        't3': Offset(0, 150),
                      },
                      cables: cables,
                      pulses: const [(from: 't2', to: 't1', progress: 0.5)],
                      lineColor: const Color(0xFF888888),
                      definedColor: const Color(0xFFAAAAAA),
                      hoverColor: const Color(0xFF4F8EF7),
                      hovered: ('t1', 't2'),
                      pendingFrom: Offset.zero,
                      pendingTo: const Offset(50, 50),
                    ),
                  ),
                ),
                CableTip(cable: cables.firstWhere((c) => c.observed != null)),
                Expanded(child: AgentGraphEmpty(onCreate: (_) => created++)),
              ],
            ),
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    expect(find.text('Messages: 1'), findsOneWidget);
    await tester.tap(find.text('New agent'));
    expect(created, 1);
  });

  testWidgets('New agent: quick start preenche nome livre; abas e Create', (
    tester,
  ) async {
    NewAgentDraft? draft;
    await tester.pumpWidget(
      TranslationProvider(
        child: ShadcnApp(
          theme: buildTheme(brightness: Brightness.dark),
          home: Scaffold(
            child: Builder(
              builder: (context) => PrimaryButton(
                onPressed: () async => draft = await showNewAgentDialog(
                  context,
                  harnesses: [HarnessCatalog.getSpec(HarnessKind.claudeCode)!],
                  taken: {'claude code'},
                  root: '/tmp',
                  remote: false,
                  currentMaestro: 'Lead',
                ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Claude Code'));
    await tester.pump();
    expect(find.text('Claude Code 2'), findsOneWidget);
    await tester.tap(find.text('Appearance'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Agent'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();
    expect(draft?.label, 'Claude Code 2');
    expect(draft?.command, 'claude');
    expect(draft?.cwd, '/tmp');
    expect(draft?.monitor, isTrue);
  });

  testWidgets('New agent: desktop app troca o form e exige o aceite', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1200, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    NewAgentDraft? draft;
    const cursor = DesktopAppIntegration(
      app: DesktopAgentApp.cursor,
      configPath: '/home/u/.cursor/mcp.json',
      entry: '"gsh": {}',
    );
    await tester.pumpWidget(
      TranslationProvider(
        child: ShadcnApp(
          theme: buildTheme(brightness: Brightness.dark),
          home: Scaffold(
            child: Builder(
              builder: (context) => PrimaryButton(
                onPressed: () async => draft = await showNewAgentDialog(
                  context,
                  harnesses: const [],
                  desktopApps: const [cursor],
                  taken: const {},
                  root: '/nao/existe',
                  remote: false,
                ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cursor'));
    await tester.pump();
    expect(find.text('/home/u/.cursor/mcp.json'), findsOneWidget);
    expect(find.text('Working directory'), findsNothing);
    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();
    expect(draft, isNull, reason: 'sem o aceite não cria');
    await tester.tap(find.textContaining('Add the GSH MCP server'));
    await tester.pump();
    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();
    expect(draft?.desktop?.app, DesktopAgentApp.cursor);
    expect(draft?.label, 'Cursor');
  });
}
