import 'dart:convert';
import 'dart:io';

import 'package:gsh_desktop/app/gsh/data/farm/claude_transcript_farm_source.dart';
import 'package:gsh_desktop/app/gsh/data/farm/transcript_tail.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/farm_loop.dart';
import 'package:gsh_desktop/app/gsh/ui/viewmodels/farm_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _assistant(
  String id,
  List<Map<String, dynamic>> content, {
  String? stop,
  int out = 10,
  String ts = '2026-10-23T18:00:00Z',
}) => {
  'type': 'assistant',
  'timestamp': ts,
  'cwd': '/repo',
  'message': {
    'id': id,
    'stop_reason': stop,
    'content': content,
    'usage': {
      'input_tokens': 2,
      'cache_read_input_tokens': 100,
      'output_tokens': out,
    },
  },
};

Map<String, dynamic> _toolUse(String name) => {
  'type': 'tool_use',
  'name': name,
};

void main() {
  group('TranscriptTail', () {
    test('ferramenta pendente vira a atividade; resultado volta a pensar', () {
      final t = TranscriptTail(isSubagent: false)
        ..apply(_assistant('m1', [_toolUse('Edit')]));
      expect(t.activity, FarmActivity.editing);
      expect(t.tool, 'Edit');
      t.apply({
        'type': 'user',
        'message': {
          'content': [
            {'type': 'tool_result'},
          ],
        },
      });
      expect(t.activity, FarmActivity.thinking);
    });

    test('end_turn é ocioso; tokens contam uma vez por mensagem', () {
      final t = TranscriptTail(isSubagent: false)
        // Mesma mensagem em duas linhas (um bloco por linha), mesmo usage.
        ..apply(
          _assistant('m1', [
            {'type': 'thinking'},
          ], out: 50),
        )
        ..apply(_assistant('m1', [_toolUse('Bash')], out: 50))
        ..apply(
          _assistant(
            'm2',
            [
              {'type': 'text'},
            ],
            stop: 'end_turn',
            out: 7,
          ),
        );
      expect(t.activity, FarmActivity.idle);
      expect(t.totalOutputTokens, 57);
      expect(t.contextTokens, 102);
      // Gasto: entrada (2) e cache (100) também uma vez por mensagem.
      expect(t.totalInputTokens, 4);
      expect(t.totalCacheReadTokens, 200);
      expect(t.cwd, '/repo');
    });

    test('janela do contexto vem do modelo; uso zerado não apaga', () {
      final t = TranscriptTail(isSubagent: false)
        ..apply({
          ..._assistant('m1', [_toolUse('Read')]),
          'message': {
            'id': 'm1',
            'model': 'claude-opus-5-5',
            'content': const [],
            'usage': {'input_tokens': 5, 'cache_read_input_tokens': 63000},
          },
        })
        // resposta sintética (erro de API): zeros, modelo `<synthetic>`
        ..apply({
          ..._assistant('m2', const []),
          'message': {
            'id': 'm2',
            'model': '<synthetic>',
            'content': const [],
            'usage': {'input_tokens': 0},
          },
        });
      expect((t.model, t.contextTokens), ('claude-opus-5-5', 63005));
      expect(claudeContextWindow(t.model), farmLongWindow);
      expect(claudeContextWindow('claude-sonnet-4-6[1m]'), farmLongWindow);
      expect(claudeContextWindow('claude-haiku-4-5'), farmDefaultWindow);
      expect(claudeContextWindow('claude-sonnet-4-5'), farmDefaultWindow);
      expect(claudeContextWindow(null), 0);
      // sem modelo: 200k, alargada para 1M se o contexto não cabe
      FarmLoop loop(int ctx, [int w = 0]) => FarmLoop(
        id: 'x',
        harness: 'claude',
        project: '/p',
        title: 'x',
        activity: FarmActivity.thinking,
        lastSeen: DateTime(2026),
        contextTokens: ctx,
        contextWindow: w,
      );
      expect(loop(63000).window, farmDefaultWindow);
      expect(loop(63000).contextFill, closeTo(0.315, 1e-9));
      expect(loop(250000).window, farmLongWindow);
      expect(loop(9000, 258400).window, 258400);
    });

    test('título: custom-title vence agent-name; prompt é fallback', () {
      final t = TranscriptTail(isSubagent: false)
        ..apply({
          'type': 'user',
          'message': {'content': 'arruma o login'},
        })
        ..apply({'type': 'agent-name', 'agentName': 'auto'});
      expect(t.firstPrompt, 'arruma o login');
      expect(t.title, 'auto');
      t.apply({'type': 'custom-title', 'customTitle': 'Login'});
      expect(t.title, 'Login');
    });

    test('linha de sidechain no principal é ignorada', () {
      final t = TranscriptTail(isSubagent: false)
        ..apply({
          ..._assistant('m1', [_toolUse('Read')]),
          'isSidechain': true,
        });
      expect(t.activity, FarmActivity.idle);
    });

    test('consume guarda a linha pela metade para a próxima leitura', () {
      final t = TranscriptTail(isSubagent: false);
      final line = jsonEncode(_assistant('m1', [_toolUse('Grep')]));
      final bytes = utf8.encode('$line\n{"type":"assi');
      t.consume(bytes);
      expect(t.offset, utf8.encode(line).length + 1);
      expect(t.activity, FarmActivity.reading);
    });
  });

  test('scan lê sessão + subagente do disco', () async {
    final root = await Directory.systemTemp.createTemp('farm');
    addTearDown(() => root.delete(recursive: true));
    final proj = Directory('${root.path}/-repo')..createSync();
    final now = DateTime.now().toUtc();
    final ts = now.toIso8601String();
    File('${proj.path}/s1.jsonl').writeAsStringSync(
      '${jsonEncode(_assistant('m1', [_toolUse('Agent')], ts: ts))}\n',
    );
    final subs = Directory('${proj.path}/s1/subagents')
      ..createSync(recursive: true);
    File('${subs.path}/agent-a1.jsonl').writeAsStringSync(
      '${jsonEncode(_assistant('m9', [
        {'type': 'text'},
      ], stop: 'end_turn', ts: ts))}\n',
    );
    File(
      '${subs.path}/agent-a1.meta.json',
    ).writeAsStringSync(jsonEncode({'agentType': 'escanor', 'name': 'api'}));

    final loops = await ClaudeTranscriptFarmSource(
      root: root.path,
      statusDir: '${root.path}/farm',
    ).scan(now);
    expect(loops, hasLength(2));
    final main = loops.firstWhere((l) => !l.isSubagent);
    final sub = loops.firstWhere((l) => l.isSubagent);
    expect(main.id, 's1');
    expect(main.activity, FarmActivity.delegating);
    expect(sub.parentId, 's1');
    expect(sub.agentType, 'escanor');
    expect(sub.title, 'api');
    expect(sub.activity, FarmActivity.done);

    // Hook marcou "waiting" depois da última linha: loop esperando alguém.
    final status = Directory('${root.path}/farm')..createSync();
    void hook(String st, DateTime at) =>
        File('${status.path}/s1.json').writeAsStringSync(
          jsonEncode({'st': st, 'ts': at.millisecondsSinceEpoch}),
        );
    final src = ClaudeTranscriptFarmSource(
      root: root.path,
      statusDir: status.path,
    );
    hook('waiting', now.add(const Duration(seconds: 1)));
    var again = await src.scan(now);
    expect(
      again.firstWhere((l) => l.id == 's1').activity,
      FarmActivity.waiting,
    );
    // Pedido antigo, transcript andou depois: volta a ler o transcript.
    hook('waiting', now.subtract(const Duration(minutes: 1)));
    again = await src.scan(now);
    expect(
      again.firstWhere((l) => l.id == 's1').activity,
      FarmActivity.delegating,
    );
    hook('working', now.add(const Duration(seconds: 1)));
    again = await src.scan(now);
    expect(
      again.firstWhere((l) => l.id == 's1').activity,
      FarmActivity.delegating,
    );

    final plots = groupFarm(loops);
    expect(plots.single.project, '/repo');
    expect(plots.single.loops.map((l) => l.id), ['s1', 'a1']);
  });
}
