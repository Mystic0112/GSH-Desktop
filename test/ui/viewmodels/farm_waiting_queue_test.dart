import 'package:gsh_desktop/app/gsh/domain/entities/farm_loop.dart';
import 'package:gsh_desktop/app/gsh/ui/viewmodels/farm_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';

final _t0 = DateTime(2026, 10, 23, 12);

FarmLoop _loop(
  String id, {
  String? parent,
  FarmActivity activity = FarmActivity.running,
  int minutesAgo = 0,
  String? agentType,
}) => FarmLoop(
  id: id,
  harness: 'claude',
  project: '/p/$id',
  title: 'título $id',
  activity: activity,
  lastSeen: _t0.subtract(Duration(minutes: minutesAgo)),
  parentId: parent,
  agentType: agentType,
);

void main() {
  const w = FarmActivity.waiting;

  test('só entra quem espera um humano', () {
    final q = farmWaitingQueue([
      _loop('a'),
      _loop('b', activity: w),
      _loop('c', activity: FarmActivity.idle),
      _loop('d', activity: FarmActivity.done),
    ]);
    expect(q.map((e) => e.sessionId), ['b']);
    expect(q.single.title, 'título b');
    expect(q.single.project, '/p/b');
    expect(q.single.subagents, isEmpty);
  });

  test('quem espera há mais tempo vem primeiro', () {
    final q = farmWaitingQueue([
      _loop('novo', activity: w, minutesAgo: 1),
      _loop('velho', activity: w, minutesAgo: 30),
      _loop('meio', activity: w, minutesAgo: 5),
    ]);
    expect(q.map((e) => e.sessionId), ['velho', 'meio', 'novo']);
  });

  test('subagente esperando aparece sob o título do pai', () {
    final q = farmWaitingQueue([
      _loop('pai'),
      _loop('s1', parent: 'pai', activity: w, agentType: 'escanor'),
      _loop('s2', parent: 'pai', activity: w, minutesAgo: 9),
    ]);
    expect(q, hasLength(1));
    expect(q.single.sessionId, 'pai');
    expect(q.single.title, 'título pai');
    expect(q.single.project, '/p/pai');
    // Sem agentType, o título do subagente nomeia.
    expect(q.single.subagents, ['escanor', 'título s2']);
    expect(q.single.since, _t0.subtract(const Duration(minutes: 9)));
  });

  test('pai e subagente esperando viram uma linha só', () {
    final q = farmWaitingQueue([
      _loop('pai', activity: w, minutesAgo: 2),
      _loop('s1', parent: 'pai', activity: w, agentType: 'levi'),
      _loop('outro', activity: w, minutesAgo: 1),
    ]);
    expect(q.map((e) => e.sessionId), ['pai', 'outro']);
    expect(q.first.subagents, ['levi']);
  });

  test('pai fora da janela: o subagente dá nome, o foco vai para o pai', () {
    final q = farmWaitingQueue([_loop('s1', parent: 'sumiu', activity: w)]);
    expect(q.single.sessionId, 'sumiu');
    expect(q.single.title, 'título s1');
  });
}
