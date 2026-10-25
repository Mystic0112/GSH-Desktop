import 'dart:convert';
import 'dart:io';

import 'package:gsh_desktop/app/gsh/data/farm/claude_session_directory.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('lista sessões recentes com título, pasta e ordem', () async {
    final root = await Directory.systemTemp.createTemp('sd');
    addTearDown(() => root.delete(recursive: true));
    final proj = Directory('${root.path}/-repo')..createSync();
    String line(Map<String, Object?> o) => '${jsonEncode(o)}\n';

    // Com custom-title (o último vence) e cwd.
    File('${proj.path}/a.jsonl').writeAsStringSync(
      line({
            'type': 'user',
            'cwd': '/repo',
            'message': {'content': 'oi'},
          }) +
          line({'type': 'custom-title', 'customTitle': 'Velho'}) +
          line({'type': 'custom-title', 'customTitle': 'Fazenda do GSH'}),
    );
    // Só o primeiro prompt.
    final b = File('${proj.path}/b.jsonl')
      ..writeAsStringSync(
        line({
          'type': 'user',
          'cwd': '/repo',
          'message': {'content': 'Arruma o login\ndetalhe'},
        }),
      );
    // Velha demais.
    final old = File('${proj.path}/c.jsonl')
      ..writeAsStringSync(line({'type': 'custom-title', 'customTitle': 'x'}));
    old.setLastModifiedSync(DateTime.now().subtract(const Duration(days: 2)));
    b.setLastModifiedSync(DateTime.now().subtract(const Duration(hours: 1)));

    final list = await ClaudeSessionDirectory(root: root.path).recent();
    expect(list.map((e) => e.title), ['Fazenda do GSH', 'Arruma o login']);
    expect(list.first.project, '/repo');
    expect(list.first.id, 'a');
  });
}
