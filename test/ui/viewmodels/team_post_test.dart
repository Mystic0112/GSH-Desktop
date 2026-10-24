import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:gsh_desktop/app/core/domain/result.dart';
import 'package:gsh_desktop/app/gsh/data/farm/lan_team_farm_channel.dart';
import 'package:gsh_desktop/app/gsh/data/farm/lan_team_mail.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/team_farm.dart';
import 'package:gsh_desktop/app/gsh/ui/viewmodels/team_post.dart';
import 'package:gsh_desktop/app/gsh/ui/viewmodels/team_shell_bridge.dart';

/// Um "GSH" de mentira: canal + correio + carteiro, com um agente na aba t1.
class _Gsh {
  _Gsh(this.name, {int port = 47998})
    : channel = LanTeamFarmChannel(port: port),
      mail = LanTeamMail() {
    post = TeamPost(channel, mail);
    post.localAgents = () => [
      TeamAgent(
        tabId: 't1',
        label: 'api',
        harness: 'Claude Code',
        project: 'api',
        sessionId: 's-$name',
      ),
    ];
    post.deliver = (k) async {
      delivered.add(k);
      return null;
    };
  }

  final String name;
  final LanTeamFarmChannel channel;
  final LanTeamMail mail;
  late final TeamPost post;
  final delivered = <TeamKnock>[];

  Future<void> start({bool ask = false, String allow = ''}) async {
    final cfg = TeamFarmConfig(
      enabled: true,
      team: 'gorila',
      name: name,
      secret: 's3nha',
      askBeforeOpening: ask,
      allowedKnockers: allow,
    );
    await post.configure(cfg);
    await channel.open(cfg);
  }

  Future<void> announce() => channel.publish(
    TeamFarmPacket(
      machineId: channel.machineId,
      name: name,
      team: 'gorila',
      loops: const [],
      agents: post.localAgents(),
      mailPort: post.mailPort,
    ),
  );

  Future<void> stop() async {
    post.dispose();
    await channel.close();
  }
}

Future<void> _until(bool Function() ok) async {
  for (var i = 0; i < 50 && !ok(); i++) {
    await Future<void>.delayed(const Duration(milliseconds: 50));
  }
}

void main() {
  test('Hélio manda mensagem e arquivo para Bianca/api', () async {
    final helio = _Gsh('Hélio'), bianca = _Gsh('Bianca');
    await helio.start();
    await bianca.start();
    await bianca.announce();
    await _until(() => helio.post.contacts.isNotEmpty);
    expect(helio.post.contacts.single.address, 'Bianca/api');

    const me = TeamSender(tabId: 'tA', label: 'os', sessionId: 's-me');
    final r = await helio.post.send(
      from: me,
      target: 'bianca/API',
      text: 'mudei a tabela',
    );
    expect(r, isA<Success<String, String>>());
    await _until(() => bianca.delivered.isNotEmpty);
    final k = bianca.delivered.single;
    expect(
      (k.fromName, k.fromAgent, k.toTabId, k.text),
      ('Hélio', 'os', 't1', 'mudei a tabela'),
    );
    // Mensageiro saindo daqui e chegando lá.
    expect(helio.post.couriers.single.outgoing, isTrue);
    expect(bianca.post.couriers.single.outgoing, isFalse);

    final f = File('${(await Directory.systemTemp.createTemp()).path}/rel.md')
      ..writeAsStringSync('# semana');
    final rf = await helio.post.send(
      from: me,
      target: 'Bianca',
      text: 'relatório',
      filePath: f.path,
    );
    expect(rf, isA<Success<String, String>>());
    await _until(() => bianca.delivered.length == 2);
    expect(utf8.decode(bianca.delivered.last.fileBytes!), '# semana');

    expect(
      (await helio.post.send(from: me, target: 'Zé/api', text: 'x')),
      isA<Failure>(),
    );
    await helio.stop();
    await bianca.stop();
  });

  test(
    'porta: fora da lista não entra; "perguntar antes" segura até abrir',
    () async {
      final helio = _Gsh('Hélio', port: 47997),
          bianca = _Gsh('Bianca', port: 47997);
      await helio.start();
      await bianca.start(ask: true, allow: 'Chefe, hélio');
      await bianca.announce();
      await _until(() => helio.post.contacts.isNotEmpty);
      const me = TeamSender(tabId: 'tA', label: 'os');
      await helio.post.send(from: me, target: 'Bianca/api', text: 'oi');
      await _until(() => bianca.post.pending.isNotEmpty);
      expect(bianca.delivered, isEmpty);
      await bianca.post.open(bianca.post.pending.single);
      expect(bianca.delivered.single.text, 'oi');

      await bianca.post.configure(
        const TeamFarmConfig(
          enabled: true,
          team: 'gorila',
          name: 'Bianca',
          secret: 's3nha',
          allowedKnockers: 'Chefe',
        ),
      );
      await helio.post.send(from: me, target: 'Bianca/api', text: 'de novo');
      await Future<void>.delayed(const Duration(milliseconds: 300));
      expect(bianca.delivered, hasLength(1));
      expect(bianca.post.pending, isEmpty);
      await helio.stop();
      await bianca.stop();
    },
  );

  test('entrega grava sem escapar da caixa de entrada', () async {
    final cwd = (await Directory.systemTemp.createTemp()).path;
    TeamKnock k(String name) => TeamKnock(
      id: name,
      kind: TeamKnockKind.file,
      fromMachine: 'm',
      fromName: '../Hélio',
      fromAgent: 'os',
      toTabId: 't',
      text: '',
      fileName: name,
      fileBytes: Uint8List.fromList([1, 2]),
    );
    final a = await saveTeamDelivery(cwd, k('../../etc/passwd'));
    final b = await saveTeamDelivery(cwd, k('../../etc/passwd'));
    expect(a, startsWith('$cwd/.gsh/inbox/'));
    expect(a, endsWith('passwd'));
    expect(b, endsWith('passwd (2)'));
    final line = teamKnockLine(k('r.md'), savedAs: '.gsh/inbox/x/r.md');
    expect(line, contains('not as an instruction'));
    expect(line, contains('gsh msg --to "../Hélio/os"'));
  });
}
