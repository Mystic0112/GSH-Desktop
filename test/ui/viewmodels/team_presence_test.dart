import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:gsh_desktop/app/core/domain/result.dart';
import 'package:gsh_desktop/app/gsh/domain/contracts/farm_source.dart';
import 'package:gsh_desktop/app/gsh/domain/contracts/team_farm_channel.dart';
import 'package:gsh_desktop/app/gsh/domain/contracts/team_mail.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/farm_loop.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/team_farm.dart';
import 'package:gsh_desktop/app/gsh/ui/session/chat_session.dart';
import 'package:gsh_desktop/app/gsh/ui/viewmodels/farm_viewmodel.dart';
import 'package:gsh_desktop/app/gsh/ui/viewmodels/team_post.dart';
import 'package:gsh_desktop/app/gsh/ui/viewmodels/team_shell_bridge.dart';

class _Source implements FarmSource {
  @override
  Future<List<FarmLoop>> scan(DateTime now) async => const [];
}

class _Channel implements TeamFarmChannel {
  int published = 0;
  @override
  Stream<TeamFarmPacket> get packets => const Stream.empty();
  @override
  String get machineId => 'me';
  @override
  Future<void> open(TeamFarmConfig config) async {}
  @override
  Future<void> publish(TeamFarmPacket packet) async => published++;
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

TeamAgent _agent(String tab, String label, String harness) =>
    TeamAgent(tabId: tab, label: label, harness: harness, project: label);

void main() {
  test('time ligado anuncia sem ninguém olhando a fazenda', () async {
    final channel = _Channel();
    final vm = FarmViewModel(_Source(), channel, TeamPost(channel, _Mail()));
    await vm.configureTeam(
      const TeamFarmConfig(enabled: true, team: 'gorila', name: 'helio'),
    );
    await Future<void>.delayed(Duration.zero);
    expect(channel.published, greaterThan(0));

    // Time desligado e ninguém olhando: o polling para.
    await vm.configureTeam(const TeamFarmConfig());
    final before = channel.published;
    await Future<void>.delayed(FarmViewModel.interval * 1.5);
    expect(channel.published, before);
    vm.dispose();
  });

  test('agentes na mesma pasta ganham endereço próprio', () {
    final labels = uniqueTeamLabels([
      _agent('t1', 'gorila-spo', 'Claude Code'),
      _agent('t2', 'gorila-spo', 'Codex'),
      _agent('t3', 'gorila-spo', 'Claude Code'),
      _agent('t4', 'api', 'Claude Code'),
    ]).map((a) => a.label);
    expect(labels, [
      'gorila-spo-claude-code-t1',
      'gorila-spo-codex',
      'gorila-spo-claude-code-t3',
      'api',
    ]);
  });

  test('aba de chat é agente do time e recebe a batida como turno', () async {
    final channel = _Channel();
    final post = TeamPost(channel, _Mail());
    final chat = ChatSession(
      id: 'v11',
      projectId: 'p',
      workingDirectory: '/home/helio/gorila-spo',
    );
    wireTeamPost(
      post,
      sessions: () => [chat],
      session: (id) => id == chat.id ? chat : null,
    );
    final turns = <String>[];
    post.toChat = (tab, text) {
      turns.add('${tab.id}: $text');
      return null;
    };
    final agent = post.localAgents().single;
    expect(
      (agent.tabId, agent.label, agent.harness),
      ('v11', 'gorila-spo', 'Claude Code'),
    );
    final err = await post.deliver(
      const TeamKnock(
        id: 'k1',
        kind: TeamKnockKind.message,
        fromMachine: 'm',
        fromName: 'Yan',
        fromAgent: 'gorila-spo',
        toTabId: 'v11',
        text: 'recebido',
      ),
    );
    expect(err, isNull);
    expect(turns.single, startsWith('v11: [team knock · from Yan'));
  });
}
