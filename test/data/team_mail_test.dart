import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:gsh_desktop/app/core/domain/result.dart';
import 'package:gsh_desktop/app/gsh/data/farm/lan_team_farm_channel.dart';
import 'package:gsh_desktop/app/gsh/data/farm/lan_team_mail.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/team_farm.dart';

TeamKnock _knock(String id, {TeamKnockKind kind = TeamKnockKind.message}) =>
    TeamKnock(
      id: id,
      kind: kind,
      fromMachine: 'm1',
      fromName: 'Hélio',
      fromAgent: 'os',
      toTabId: 't9',
      text: 'mudei a tabela de pagamentos',
      fileName: kind == TeamKnockKind.file ? 'relatorio.md' : null,
      fileBytes: kind == TeamKnockKind.file
          ? Uint8List.fromList(utf8.encode('# oi'))
          : null,
    );

const _cfg = TeamFarmConfig(enabled: true, team: 'gorila', secret: 's3nha');

void main() {
  test('entrega com a senha certa; arquivo chega inteiro', () async {
    final a = LanTeamMail(), b = LanTeamMail();
    await a.configure(_cfg);
    await b.configure(_cfg);
    final got = b.knocks.first;
    final r = await a.send(
      '127.0.0.1',
      b.port!,
      _knock('k1', kind: TeamKnockKind.file),
    );
    expect(r, isA<Success<void, String>>());
    final k = await got;
    expect(
      (k.fromName, k.toTabId, k.fileName),
      ('Hélio', 't9', 'relatorio.md'),
    );
    expect(utf8.decode(k.fileBytes!), '# oi');
    await a.close();
    await b.close();
  });

  test('senha errada e reenvio são recusados', () async {
    final a = LanTeamMail(), b = LanTeamMail();
    await a.configure(
      const TeamFarmConfig(enabled: true, team: 'gorila', secret: 'outra'),
    );
    await b.configure(_cfg);
    final wrong = await a.send('127.0.0.1', b.port!, _knock('k1'));
    expect((wrong as Failure).error, contains('password'));

    await a.configure(_cfg); // mesma senha agora
    expect(await a.send('127.0.0.1', b.port!, _knock('k2')), isA<Success>());
    final dup = await a.send('127.0.0.1', b.port!, _knock('k2'));
    expect((dup as Failure).error, contains('duplicate'));
    await a.close();
    await b.close();
  });

  test('sem senha o correio fica desligado', () async {
    final a = LanTeamMail();
    await a.configure(const TeamFarmConfig(enabled: true, team: 'gorila'));
    expect(a.port, isNull);
    expect(await a.send('127.0.0.1', 1, _knock('k')), isA<Failure>());
  });

  test('batida velha não entra', () {
    final body = encodeKnock(
      _knock('k'),
      team: 'gorila',
      at: DateTime.now().subtract(const Duration(minutes: 10)),
    );
    expect(
      decodeKnock(body, now: DateTime.now(), skew: const Duration(minutes: 5)),
      isNull,
    );
  });

  test('pacote assinado: só abre com a senha; sem senha não mistura', () {
    const p = TeamFarmPacket(
      machineId: 'a',
      name: 'Hélio',
      team: 'gorila',
      loops: [],
      agents: [
        TeamAgent(
          tabId: 't1',
          label: 'os',
          harness: 'Claude Code',
          project: 'os',
        ),
      ],
      mailPort: 5555,
    );
    final signed = encodeTeamPacket(p, secret: 's3nha');
    final ok = decodeTeamPacket(signed, team: 'gorila', secret: 's3nha')!;
    expect((ok.agents.single.label, ok.mailPort), ('os', 5555));
    expect(decodeTeamPacket(signed, team: 'gorila', secret: 'x'), isNull);
    expect(decodeTeamPacket(signed, team: 'gorila'), isNull);
    expect(
      decodeTeamPacket(encodeTeamPacket(p), team: 'gorila', secret: 's3nha'),
      isNull,
    );
  });
}
