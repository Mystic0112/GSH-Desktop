import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:gsh_desktop/app/core/domain/result.dart';
import 'package:gsh_desktop/app/gsh/domain/contracts/farm_source.dart';
import 'package:gsh_desktop/app/gsh/domain/contracts/team_farm_channel.dart';
import 'package:gsh_desktop/app/gsh/domain/contracts/team_mail.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/farm_loop.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/team_farm.dart';
import 'package:gsh_desktop/app/gsh/ui/viewmodels/farm_viewmodel.dart';
import 'package:gsh_desktop/app/gsh/ui/viewmodels/team_post.dart';

final _t0 = DateTime(2026, 10, 28, 12);

FarmLoop _loop(String id, {String? parent, int minutesAgo = 0}) => FarmLoop(
  id: id,
  harness: 'claude',
  project: '/p/$id',
  title: 'título $id',
  activity: FarmActivity.idle,
  lastSeen: _t0.subtract(Duration(minutes: minutesAgo)),
  parentId: parent,
);

class _Source implements FarmSource {
  List<FarmLoop> loops = const [];
  @override
  Future<List<FarmLoop>> scan(DateTime now) async => loops;
}

class _Channel implements TeamFarmChannel {
  @override
  Stream<TeamFarmPacket> get packets => const Stream.empty();
  @override
  String get machineId => 'me';
  @override
  Future<void> open(TeamFarmConfig config) async {}
  @override
  Future<void> publish(TeamFarmPacket packet) async {}
  @override
  Future<void> close() async {}
}

class _Mail implements TeamMail {
  @override
  Stream<TeamKnock> get knocks => const Stream.empty();
  @override
  int? get port => null;
  @override
  Future<void> configure(TeamFarmConfig config) async {}
  @override
  Future<Result<void, String>> send(String a, int p, TeamKnock k) async =>
      const Success(null);
  @override
  Future<void> close() async {}
}

void main() {
  late _Source source;
  late FarmViewModel vm;

  Future<void> scan() async {
    // o polling liga no attach(); o primeiro tick roda na hora
    await Future<void>.delayed(const Duration(milliseconds: 20));
  }

  setUp(() async {
    source = _Source()
      ..loops = [_loop('a'), _loop('b'), _loop('sub', parent: 'a')];
    final channel = _Channel();
    vm = FarmViewModel(source, channel, TeamPost(channel, _Mail()))..attach();
    await scan();
  });

  tearDown(() => vm.dispose());

  List<String> ids() => vm.loops.map((l) => l.id).toList()..sort();

  test('ocultar tira o loop e os subagentes dele na hora', () {
    expect(ids(), ['a', 'b', 'sub']);
    vm.hide(vm.loops.firstWhere((l) => l.id == 'a'));
    expect(ids(), ['b']);
    expect(vm.hiddenCount, 1);
  });

  test('mostrar ocultos devolve tudo', () {
    vm.hide(vm.loops.firstWhere((l) => l.id == 'b'));
    expect(ids(), ['a', 'sub']);
    vm.showHidden();
    expect(ids(), ['a', 'b', 'sub']);
    expect(vm.hiddenCount, 0);
  });

  test('loop que volta a escrever reaparece', () async {
    vm.hide(vm.loops.firstWhere((l) => l.id == 'b'));
    source.loops = [_loop('a'), _loop('b', minutesAgo: -5)];
    await vm.scanOnce();
    // o tick do polling relê a fonte
    await Future<void>.delayed(
      FarmViewModel.interval + const Duration(seconds: 1),
    );
    expect(ids(), contains('b'));
    expect(vm.hiddenCount, 0);
  });

  test('oculto que sai da janela do scan some da lista', () async {
    vm.hide(vm.loops.firstWhere((l) => l.id == 'b'));
    source.loops = [_loop('a')];
    await Future<void>.delayed(
      FarmViewModel.interval + const Duration(seconds: 1),
    );
    expect(vm.hiddenCount, 0);
  });
}
