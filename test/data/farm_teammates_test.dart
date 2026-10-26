import 'dart:convert';
import 'dart:io';

import 'package:gsh_desktop/app/gsh/data/farm/claude_transcript_farm_source.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/farm_loop.dart';
import 'package:gsh_desktop/app/gsh/ui/viewmodels/farm_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';

/// Teammates do Claude Code (agent teams). O que os dados reais desta
/// máquina mostram: `~/.claude/teams/*/config.json` só com o `team-lead` e
/// os spawns nomeados respondendo `Async agent launched… agentId: <hex>`
/// (subagente nomeado, sem time). O formato de teammate abaixo segue a doc
/// do Claude Code (agent teams) e o pixel-agents: o spawn volta com
/// `agent_id: <nome>@<time>`, o time é `session-<8 do id>` e muda a cada
/// execução (retomada = geração nova), e o teammate de sessão própria marca
/// toda linha com `teamName`/`agentName`.

String _ts(DateTime t) => t.toIso8601String();

Map<String, dynamic> _assistant(
  String id,
  List<Map<String, dynamic>> content,
  DateTime t, {
  String? stop,
}) => {
  'type': 'assistant',
  'timestamp': _ts(t),
  'cwd': '/repo',
  'message': {
    'id': id,
    'stop_reason': stop,
    'content': content,
    'usage': {'input_tokens': 2, 'output_tokens': 5},
  },
};

/// O lead chama o Agent com [name] e recebe [result].
List<Map<String, dynamic>> _spawn(
  String callId,
  String? name,
  String result,
  DateTime t,
) => [
  _assistant('m-$callId', [
    {
      'type': 'tool_use',
      'id': callId,
      'name': 'Agent',
      'input': {'name': ?name, 'prompt': 'faz'},
    },
  ], t),
  {
    'type': 'user',
    'timestamp': _ts(t),
    'message': {
      'content': [
        {
          'type': 'tool_result',
          'tool_use_id': callId,
          'content': [
            {'type': 'text', 'text': result},
          ],
        },
      ],
    },
  },
];

/// Linha de um teammate de sessão própria: sidechain e marcada.
Map<String, dynamic> _mate(
  String team,
  String name,
  DateTime t, {
  String tool = 'Read',
  bool done = false,
}) => {
  ..._assistant(
    'x$name$team',
    done
        ? [
            {'type': 'text'},
          ]
        : [
            {'type': 'tool_use', 'id': 'u', 'name': tool},
          ],
    t,
    stop: done ? 'end_turn' : null,
  ),
  'isSidechain': true,
  'teamName': team,
  'agentName': name,
};

void main() {
  late Directory root, proj;
  final now = DateTime.now().toUtc();

  setUp(() async {
    root = await Directory.systemTemp.createTemp('farm');
    proj = Directory('${root.path}/-repo')..createSync();
  });
  tearDown(() => root.delete(recursive: true));

  void write(String name, List<Map<String, dynamic>> l, {DateTime? mtime}) {
    final f = File('${proj.path}/$name.jsonl')
      ..writeAsStringSync(l.map((o) => '${jsonEncode(o)}\n').join());
    if (mtime != null) f.setLastModifiedSync(mtime);
  }

  Future<Map<String, FarmLoop>> scan() async => {
    for (final l in await ClaudeTranscriptFarmSource(
      root: root.path,
      statusDir: '${root.path}/farm',
    ).scan(now))
      l.id: l,
  };

  test('time novo: o spawn que volta com time liga o colega ao lead', () async {
    write('lead', [
      ..._spawn(
        'c1',
        'revisor',
        'Spawned.\nagent_id: revisor@session-aaaa',
        now,
      ),
    ]);
    write('mate', [_mate('session-aaaa', 'revisor', now)]);
    final loops = await scan();
    expect(loops['lead']!.isTeammate, isFalse);
    final m = loops['mate']!;
    expect((m.teammate, m.parentId, m.isSubagent), ('revisor', 'lead', false));
    // sidechain do começo ao fim, mas é dele: a atividade aparece
    expect(m.activity, FarmActivity.reading);
    final plot = groupFarm(loops.values.toList()).single;
    expect(plot.loops.map((l) => l.id), ['lead', 'mate']);
  });

  test('retomada: o time novo vale; o colega da geração velha solta', () async {
    write('lead', [
      ..._spawn('c1', 'pesquisa', 'agent_id: pesquisa@session-aaaa', now),
      ..._spawn('c2', 'testes', 'agent_id: testes@session-bbbb', now),
    ]);
    write('novo', [_mate('session-bbbb', 'testes', now)]);
    write('velho', [_mate('session-aaaa', 'pesquisa', now)]);
    write('velhoParado', [_mate('session-aaaa', 'docs', now, done: true)]);
    final loops = await scan();
    expect(loops['novo']!.parentId, 'lead');
    // trabalhando ainda: segue na tela, com canteiro próprio e sem lead
    expect(
      (loops['velho']!.teammate, loops['velho']!.parentId),
      ('pesquisa', null),
    );
    // parado e sem time: o Claude Code não traz de volta, sai da fazenda
    expect(loops.containsKey('velhoParado'), isFalse);
  });

  test('teammate que termina some depois do tempo de despedida', () async {
    final old = now.subtract(
      ClaudeTranscriptFarmSource.doneLinger + const Duration(minutes: 1),
    );
    write('lead', [
      ..._spawn('c1', 'a', 'agent_id: a@session-aaaa', now),
      ..._spawn('c2', 'b', 'agent_id: b@session-aaaa', now),
    ]);
    write('recente', [_mate('session-aaaa', 'a', now, done: true)]);
    write('antigo', [_mate('session-aaaa', 'b', old, done: true)]);
    final loops = await scan();
    expect(loops['recente']!.activity, FarmActivity.done);
    expect(loops.containsKey('antigo'), isFalse);
  });

  test('lead que some: o colega parado sai, o que trabalha fica', () async {
    final gone = now.subtract(const Duration(hours: 2));
    write('lead', [
      ..._spawn('c1', 'a', 'agent_id: a@session-aaaa', gone),
    ], mtime: gone);
    write('ativo', [_mate('session-aaaa', 'a', now)]);
    write('parado', [_mate('session-aaaa', 'b', now, done: true)]);
    final loops = await scan();
    expect(loops.containsKey('lead'), isFalse);
    expect((loops['ativo']!.teammate, loops['ativo']!.parentId), ('a', null));
    expect(loops.containsKey('parado'), isFalse);
  });

  test(
    'sidecar: só é teammate com time; nomeado sem time é subagente',
    () async {
      write('lead', [
        ..._spawn(
          'c1',
          'escanor-api',
          'agent_id: escanor-api@session-aaaa',
          now,
        ),
        // o formato real desta máquina: subagente nomeado, sem time
        ..._spawn(
          'c2',
          'gon-pixel',
          'Async agent launched successfully.\nagentId: a7c77cf06b9d750c9',
          now,
        ),
        // um Read que por acaso traz o padrão não cria colega
        _assistant('r', [
          {'type': 'tool_use', 'id': 'r1', 'name': 'Read'},
        ], now),
        {
          'type': 'user',
          'timestamp': _ts(now),
          'message': {
            'content': [
              {
                'type': 'tool_result',
                'tool_use_id': 'r1',
                'content': 'agent_id: intruso@session-zzzz',
              },
            ],
          },
        },
      ]);
      final subs = Directory('${proj.path}/lead/subagents')
        ..createSync(recursive: true);
      for (final (id, name, cwd) in [
        ('named', 'escanor-api', '/repo/.claude/worktrees/agent-named'),
        ('async', 'gon-pixel', '/repo'),
        ('intruso', 'intruso', '/repo'),
      ]) {
        File('${subs.path}/agent-$id.jsonl').writeAsStringSync(
          '${jsonEncode({
            ..._assistant('s$id', [
              {'type': 'tool_use', 'id': 'u', 'name': 'Bash'},
            ], now),
            'cwd': cwd,
          })}\n',
        );
        File(
          '${subs.path}/agent-$id.meta.json',
        ).writeAsStringSync(jsonEncode({'agentType': 'gon', 'name': name}));
      }
      final loops = await scan();
      final named = loops['named']!;
      expect((named.teammate, named.parentId), ('escanor-api', 'lead'));
      // teammate fica no canteiro do projeto do lead, não no worktree
      expect(named.project, '/repo');
      for (final id in ['async', 'intruso']) {
        expect(loops[id]!.isSubagent, isTrue, reason: id);
        expect(
          loops[id]!.title,
          loops[id]!.id == 'async' ? 'gon-pixel' : 'intruso',
        );
      }
    },
  );

  test(
    'o lead marcado pelo próprio time não vira colega de si mesmo',
    () async {
      write('lead', [
        ..._spawn('c1', 'a', 'agent_id: a@session-aaaa', now),
        {
          ..._assistant('m', const [], now),
          'teamName': 'session-aaaa',
          'agentName': 'team-lead',
        },
      ]);
      final lead = (await scan())['lead']!;
      expect((lead.isTeammate, lead.parentId), (false, null));
    },
  );
}
