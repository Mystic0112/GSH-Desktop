import 'dart:convert';
import 'dart:io';

import 'package:gsh_desktop/app/gsh/data/farm/claude_transcript_farm_source.dart';
import 'package:gsh_desktop/app/gsh/data/farm/farm_scan_cache.dart';
import 'package:flutter_test/flutter_test.dart';

/// Árvore sintética de `~/.claude/projects`: [projects] pastas com
/// [perProject] transcripts cada; só os [recent] primeiros foram escritos
/// agora (o resto tem 2 h), e cada recente tem um subagente.
Future<Directory> _tree({
  int projects = 20,
  int perProject = 15,
  int recent = 10,
}) async {
  final root = await Directory.systemTemp.createTemp('farmbench');
  final old = DateTime.now().subtract(const Duration(hours: 2));
  final ts = DateTime.now().toUtc().toIso8601String();
  final line =
      '${jsonEncode({
        'type': 'assistant',
        'timestamp': ts,
        'cwd': '/repo',
        'message': {
          'id': 'm1',
          'content': [
            {'type': 'tool_use', 'name': 'Bash'},
          ],
          'usage': {'output_tokens': 10},
        },
      })}\n';
  var n = 0;
  for (var d = 0; d < projects; d++) {
    final dir = Directory('${root.path}/-p$d')..createSync();
    for (var s = 0; s < perProject; s++, n++) {
      final f = File('${dir.path}/s$n.jsonl')..writeAsStringSync(line);
      if (n >= recent) {
        f.setLastModifiedSync(old);
        continue;
      }
      final subs = Directory('${dir.path}/s$n/subagents')
        ..createSync(recursive: true);
      File('${subs.path}/agent-a$n.jsonl').writeAsStringSync(line);
    }
  }
  return root;
}

void main() {
  test('relista na primeira vez, a cada 15 s e depois de uma pausa', () {
    final t0 = DateTime(2026, 10, 23, 12);
    DateTime at(int s) => t0.add(Duration(seconds: s));
    expect(farmRelistDue(now: t0), isTrue);
    expect(farmRelistDue(now: at(2), listedAt: t0, scannedAt: t0), isFalse);
    expect(farmRelistDue(now: at(14), listedAt: t0, scannedAt: at(12)), false);
    expect(farmRelistDue(now: at(15), listedAt: t0, scannedAt: at(13)), true);
    // fazenda escondida e reaberta: a primeira varredura é completa
    expect(farmRelistDue(now: at(8), listedAt: t0, scannedAt: at(2)), true);
  });

  test('sessão e subagente novos numa pasta ativa aparecem na hora', () async {
    final root = await _tree(projects: 2, perProject: 3, recent: 1);
    addTearDown(() => root.delete(recursive: true));
    final src = ClaudeTranscriptFarmSource(
      root: root.path,
      statusDir: '${root.path}/farm',
    );
    var now = DateTime.now();
    expect(await src.scan(now), hasLength(2));
    final line = File('${root.path}/-p0/s0.jsonl').readAsStringSync();
    // mtime de pasta tem resolução de ms: garante que a mudança se vê
    await Future<void>.delayed(const Duration(milliseconds: 20));
    File('${root.path}/-p0/novo.jsonl').writeAsStringSync(line);
    File('${root.path}/-p0/s0/subagents/agent-b.jsonl').writeAsStringSync(line);
    now = now.add(const Duration(seconds: 2));
    final ids = (await src.scan(now)).map((l) => l.id).toSet();
    expect(ids, containsAll(['s0', 'a0', 'novo', 'b']));

    // pasta sem nada recente não é vigiada: entra na listagem por tempo
    File('${root.path}/-p1/velho.jsonl').writeAsStringSync(line);
    now = now.add(const Duration(seconds: 2));
    expect((await src.scan(now)).map((l) => l.id), isNot(contains('velho')));
    now = now.add(FarmScanCache.every);
    expect((await src.scan(now)).map((l) => l.id), contains('velho'));
  });

  test('scan de 300 transcripts: parcial acha os mesmos loops', () async {
    final root = await _tree();
    addTearDown(() => root.delete(recursive: true));
    final src = ClaudeTranscriptFarmSource(
      root: root.path,
      statusDir: '${root.path}/farm',
    );
    var now = DateTime.now();
    final first = await src.scan(now);
    expect(first, hasLength(20)); // 10 principais + 10 subagentes

    const rounds = 30;
    final sw = Stopwatch()..start();
    for (var i = 0; i < rounds; i++) {
      now = now.add(const Duration(seconds: 2));
      final loops = await src.scan(now);
      expect(loops.map((l) => l.id).toSet(), first.map((l) => l.id).toSet());
    }
    sw.stop();
    // ignore: avoid_print
    print(
      'farm scan: ${(sw.elapsedMicroseconds / rounds / 1000).toStringAsFixed(2)} '
      'ms/scan (300 transcripts, $rounds varreduras a cada 2 s)',
    );
  });
}
