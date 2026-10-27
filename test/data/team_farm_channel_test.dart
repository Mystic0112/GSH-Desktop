import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:gsh_desktop/app/gsh/data/farm/lan_team_farm_channel.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/farm_loop.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/team_farm.dart';

FarmLoop _loop(String id) => FarmLoop(
  id: id,
  harness: 'claude',
  project: 'site',
  title: 'Landing nova',
  activity: FarmActivity.waiting,
  tool: 'Bash',
  outputTokens: 10,
  inputTokens: 5,
  cacheReadTokens: 100,
  lastSeen: DateTime.fromMillisecondsSinceEpoch(1792868400000),
);

void main() {
  test('pacote ida e volta; lixo vira null', () {
    final bytes = encodeTeamPacket(
      TeamFarmPacket(
        machineId: 'a1',
        name: 'Hélio',
        team: 'gorila',
        loops: [_loop('s1')],
      ),
    );
    final p = decodeTeamPacket(bytes)!;
    expect((p.machineId, p.name, p.team), ('a1', 'Hélio', 'gorila'));
    final l = p.loops.single;
    expect(
      (l.id, l.activity, l.tool, l.spentTokens),
      ('s1', FarmActivity.waiting, 'Bash', 115),
    );
    expect(decodeTeamPacket([1, 2, 3]), isNull);
  });

  test('com senha: pacote cifrado, só abre com o mesmo time e senha', () {
    final bytes = encodeTeamPacket(
      TeamFarmPacket(
        machineId: 'a1',
        name: 'Hélio',
        team: 'gorila',
        loops: [_loop('s1')],
      ),
      secret: 's3nha',
    );
    // Nada legível na rede (nem depois de descomprimir, se fosse gzip).
    expect(bytes.first, 2);
    expect(latin1.decode(bytes, allowInvalid: true), isNot(contains('gorila')));
    TeamFarmPacket? open(String team, String secret, [List<int>? b]) =>
        decodeTeamPacket(b ?? bytes, team: team, secret: secret);
    expect(open('gorila', 's3nha')!.loops.single.title, 'Landing nova');
    expect(open('gorila', 'outra'), isNull);
    expect(open('outro-time', 's3nha'), isNull);
    expect(open('gorila', ''), isNull); // sem senha não lê cifrado
    final tampered = [...bytes]..[bytes.length - 1] ^= 1;
    expect(open('gorila', 's3nha', tampered), isNull);
    // Com senha, pacote aberto (sem cifra) não entra.
    final plain = encodeTeamPacket(
      TeamFarmPacket(machineId: 'b2', name: 'X', team: 'gorila', loops: []),
    );
    expect(open('gorila', 's3nha', plain), isNull);
  });

  test('faixa de rede', () {
    expect(ipv4InCidr('192.168.10.37', '192.168.10.0/24'), isTrue);
    expect(ipv4InCidr('192.168.11.37', '192.168.10.0/24'), isFalse);
    expect(ipv4InCidr('10.0.0.1', 'lixo'), isFalse);
  });

  test('dois GSHs do mesmo time se enxergam; outro time não', () async {
    const port = 47999;
    final a = LanTeamFarmChannel(port: port);
    final b = LanTeamFarmChannel(port: port);
    final c = LanTeamFarmChannel(port: port);
    const cfg = TeamFarmConfig(enabled: true, team: 'gorila');
    await a.open(cfg);
    await b.open(cfg);
    await c.open(const TeamFarmConfig(enabled: true, team: 'outro'));
    final atB = b.packets.first.timeout(const Duration(seconds: 5));
    final atC = <TeamFarmPacket>[];
    final sub = c.packets.listen(atC.add);
    // A não recebe o próprio eco.
    final atA = <TeamFarmPacket>[];
    final subA = a.packets.listen(atA.add);
    await a.publish(
      TeamFarmPacket(
        machineId: a.machineId,
        name: 'Hélio',
        team: 'gorila',
        loops: [_loop('s1')],
      ),
    );
    final got = await atB;
    expect(got.name, 'Hélio');
    await Future<void>.delayed(const Duration(milliseconds: 300));
    expect(atC, isEmpty);
    expect(atA, isEmpty);
    await sub.cancel();
    await subA.cancel();
    for (final ch in [a, b, c]) {
      await ch.close();
    }
  });
}
