import 'package:gsh_desktop/app/core/ui/themes/themes.dart';
import 'package:gsh_desktop/app/gsh/domain/contracts/farm_source.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/farm_loop.dart';
import 'package:gsh_desktop/app/gsh/ui/viewmodels/farm_viewmodel.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/farm/farm_strip.dart';
import 'package:gsh_desktop/i18n/strings.g.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'shot_harness.dart';

class _Source implements FarmSource {
  _Source(this.loops);
  List<FarmLoop> loops;
  @override
  Future<List<FarmLoop>> scan(DateTime now) async => loops;
}

FarmLoop _loop(
  String id,
  FarmActivity activity, {
  String? title,
  String project = '/home/dev/gsh-desktop',
  String? parent,
  String? agentType,
  int minutesAgo = 0,
}) => FarmLoop(
  id: id,
  harness: 'claude',
  project: project,
  title: title ?? id,
  activity: activity,
  lastSeen: DateTime.now().subtract(Duration(minutes: minutesAgo)),
  parentId: parent,
  agentType: agentType,
);

/// Sete loops: 3 trabalhando, 2 esperando (um principal, um subagente sob
/// um pai que trabalha), 2 parados.
List<FarmLoop> _busy() => [
  _loop('a', FarmActivity.editing, title: 'Refatorar o tab strip'),
  _loop(
    'b',
    FarmActivity.waiting,
    title: 'Migrar o schema de pedidos',
    project: '/home/dev/loja-api',
    minutesAgo: 12,
  ),
  _loop(
    'c',
    FarmActivity.running,
    title: 'Corrigir o build do Windows',
    project: '/home/dev/gsh-desktop',
  ),
  _loop(
    'c1',
    FarmActivity.waiting,
    parent: 'c',
    agentType: 'saitama',
    minutesAgo: 3,
  ),
  _loop('d', FarmActivity.thinking, title: 'Revisar PR #212'),
  _loop('e', FarmActivity.idle, title: 'Docs do hook'),
  _loop('f', FarmActivity.sleeping, title: 'Spike de cache'),
];

class _Root extends StatelessWidget {
  const _Root();

  @override
  Widget build(BuildContext context) => TranslationProvider(
    child: RepaintBoundary(
      key: shotKey,
      // Tema acima do router (como no app): o popover da fila mora no
      // overlay, fora da rota.
      child: shotTheme(
        ShadcnApp.router(
          debugShowCheckedModeBanner: false,
          theme: buildTheme(
            brightness: Brightness.dark,
            settings: shotSettings,
          ).copyWith(platform: () => TargetPlatform.linux),
          routerConfig: ModularApp.routerConfigOf(context),
        ),
      ),
    ),
  );
}

/// Topbar de mentira: só o pedaço da direita, onde a faixa mora.
class _Bar extends StatelessWidget {
  const _Bar(this.opened);
  final List<int> opened;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      color: colors.bg,
      alignment: Alignment.topCenter,
      child: Container(
        height: 46,
        color: colors.panel,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Text('gsh-desktop', style: context.typo.title),
            const Spacer(),
            FarmStrip(onOpenFarm: () => opened.add(1)),
            Icon(Icons.chat_bubble_outline, size: 17, color: colors.text3),
            const SizedBox(width: 12),
            Icon(Icons.grass_outlined, size: 17, color: colors.text3),
            const SizedBox(width: 12),
            Icon(Icons.hub_outlined, size: 17, color: colors.text3),
          ],
        ),
      ),
    );
  }
}

Future<List<int>> _mount(WidgetTester tester, _Source source) async {
  tester.view.physicalSize = const Size(820, 300);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final opened = <int>[];
  final module = createModule(
    register: (c) => c
      ..addInstance<FarmSource>(source)
      ..route(
        '/',
        provide: (s) => s..addChangeNotifier<FarmViewModel>(FarmViewModel.new),
        child: (context, state) => _Bar(opened),
      ),
  );
  await tester.pumpWidget(ModularApp(module: module, child: const _Root()));
  await tester.pumpAndSettle();
  return opened;
}

void main() {
  setUpAll(() async {
    LocaleSettings.setLocale(AppLocale.ptBr);
    await loadShotFonts();
  });

  testWidgets('sem loop nenhum a faixa some', (tester) async {
    await _mount(tester, _Source([]));
    expect(find.byType(FarmStrip), findsOneWidget);
    expect(find.text('0'), findsNothing);
  });

  testWidgets('contagens, pílula e fila', (tester) async {
    final opened = await _mount(tester, _Source(_busy()));
    // 3 trabalhando, 2 esperando (inclui o subagente), 2 parados.
    expect(find.text('3'), findsOneWidget);
    expect(find.text('2'), findsNWidgets(2));
    // A pílula conta linhas da fila (sessões), não loops.
    expect(find.text('2 precisam de você'), findsOneWidget);

    await tester.tap(find.text('3'));
    expect(opened, [1]);

    await tester.tap(find.text('2 precisam de você'));
    // Popover ancorado segue o botão num ticker: nunca "assenta".
    await tester.pump(const Duration(milliseconds: 400));
    // Quem espera há mais tempo primeiro; o subagente sob o título do pai.
    final first = tester.getTopLeft(find.text('Migrar o schema de pedidos'));
    final second = tester.getTopLeft(find.text('Corrigir o build do Windows'));
    expect(first.dy, lessThan(second.dy));
    expect(find.textContaining('saitama'), findsOneWidget);
    expect(find.textContaining('loja-api'), findsOneWidget);
  });

  testWidgets('preview: faixa e fila', tags: ['preview'], (tester) async {
    await _mount(tester, _Source(_busy()));
    await takeShot(tester, 'visibility_1');
    await tester.tap(find.text('2 precisam de você'));
    // Popover ancorado segue o botão num ticker: nunca "assenta".
    await tester.pump(const Duration(milliseconds: 400));
    await takeShot(tester, 'visibility_2');
  });
}
