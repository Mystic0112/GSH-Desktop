import 'dart:convert';
import 'dart:io';

import 'package:gsh_desktop/app/gsh/data/farm/codex_rollout_farm_source.dart';
import 'package:gsh_desktop/app/gsh/data/farm/farm_hook_status.dart';
import 'package:gsh_desktop/app/gsh/data/farm/multi_farm_source.dart';
import 'package:gsh_desktop/app/gsh/domain/contracts/farm_source.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/farm_loop.dart';
import 'package:flutter_test/flutter_test.dart';

// Formato real do Codex 0.162 (rollout-*.jsonl), enxugado.
Map<String, dynamic> _ev(
  String type,
  Map<String, dynamic> payload,
  String ts,
) => {
  'timestamp': ts,
  'type': 'event_msg',
  'payload': {'type': type, ...payload},
};

Map<String, dynamic> _resp(
  String type,
  Map<String, dynamic> payload,
  String ts,
) => {
  'timestamp': ts,
  'type': 'response_item',
  'payload': {'type': type, ...payload},
};

const _sid = '01a1418d-a3e6-77e1-9c1a-255024c66d39';

void main() {
  test('CodexTail: meta, título, ferramenta, tokens e fim de turno', () {
    const t = '2026-10-15T21:53:05.000Z';
    final tail = CodexTail()
      ..apply({
        'timestamp': t,
        'type': 'session_meta',
        'payload': {'session_id': _sid, 'cwd': '/repo'},
      })
      ..apply(_ev('task_started', {}, t))
      ..apply(
        _ev('item_completed', {
          'item': {
            'type': 'UserMessage',
            'content': [
              {'type': 'text', 'text': 'Arruma o login\nmais detalhes'},
            ],
          },
        }, t),
      )
      ..apply(_resp('custom_tool_call', {'name': 'exec', 'input': 'ls'}, t));
    expect(tail.sessionId, _sid);
    expect(tail.cwd, '/repo');
    expect(tail.title, 'Arruma o login');
    expect((tail.activity, tail.tool), (FarmActivity.running, 'exec'));

    tail
      ..apply(_resp('custom_tool_call_output', {'output': []}, t))
      ..apply(
        _ev('token_count', {
          'info': {
            'total_token_usage': {
              'input_tokens': 22711,
              'cached_input_tokens': 100,
              'output_tokens': 200,
            },
          },
        }, t),
      );
    expect(tail.activity, FarmActivity.thinking);
    expect((tail.outputTokens, tail.contextTokens), (200, 22811));

    tail.apply(_ev('task_complete', {'last_agent_message': 'ok'}, t));
    expect((tail.activity, tail.tool), (FarmActivity.idle, null));
  });

  test('scan lê rollout do disco; hook waiting vence; Multi junta', () async {
    final root = await Directory.systemTemp.createTemp('codex');
    addTearDown(() => root.delete(recursive: true));
    final now = DateTime.now().toUtc();
    final ts = now.toIso8601String();
    final day = Directory('${root.path}/sessions/2026/10/23')
      ..createSync(recursive: true);
    File(
      '${day.path}/rollout-2026-10-23T10-00-00-$_sid.jsonl',
    ).writeAsStringSync(
      '${[
        jsonEncode({
          'timestamp': ts,
          'type': 'session_meta',
          'payload': {'session_id': _sid, 'cwd': '/repo'},
        }),
        jsonEncode(_resp('custom_tool_call', {'name': 'exec'}, ts)),
      ].join('\n')}\n',
    );
    final hookDir = Directory('${root.path}/farm')..createSync();
    final src = CodexRolloutFarmSource(
      root: '${root.path}/sessions',
      hookStatus: FarmHookStatus(dir: hookDir.path),
    );
    var loops = await src.scan(now);
    final l = loops.single;
    expect((l.id, l.harness, l.project), (_sid, 'codex', '/repo'));
    expect(l.activity, FarmActivity.running);

    File('${hookDir.path}/$_sid.json').writeAsStringSync(
      jsonEncode({
        'st': 'waiting',
        'ts': now.add(const Duration(seconds: 2)).millisecondsSinceEpoch,
      }),
    );
    loops = await src.scan(now);
    expect(loops.single.activity, FarmActivity.waiting);

    final multi = MultiFarmSource([
      src,
      _Fixed([loops.single]),
    ]);
    expect((await multi.scan(now)).length, 2);
  });
}

class _Fixed implements FarmSource {
  const _Fixed(this.loops);
  final List<FarmLoop> loops;
  @override
  Future<List<FarmLoop>> scan(DateTime now) async => loops;
}
