import 'dart:convert';
import 'dart:io';

import 'package:cockpit/app/core/data/claude_code_settings_file.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Directory home;
  late File file;

  setUp(() async {
    home = await Directory.systemTemp.createTemp('home');
    file = File('${home.path}/.claude/settings.json');
  });
  tearDown(() => home.delete(recursive: true));

  test('liga e desliga sem mexer nas outras chaves', () async {
    file
      ..createSync(recursive: true)
      ..writeAsStringSync(
        jsonEncode({
          'hooks': {'Stop': <Object>[]},
          'model': 'opus',
        }),
      );
    final s = ClaudeCodeSettingsFile(home: home.path);
    expect(await s.remoteControlAtStartup(), isFalse);

    expect((await s.setRemoteControlAtStartup(true)).isSuccess, isTrue);
    expect(await s.remoteControlAtStartup(), isTrue);
    final on = jsonDecode(file.readAsStringSync()) as Map;
    expect(on['model'], 'opus');
    expect(on['hooks'], {'Stop': <Object>[]});

    await s.setRemoteControlAtStartup(false);
    final off = jsonDecode(file.readAsStringSync()) as Map;
    expect(off.containsKey('remoteControlAtStartup'), isFalse);
    expect(off['model'], 'opus');
  });

  test('cria o arquivo quando não existe', () async {
    final s = ClaudeCodeSettingsFile(home: home.path);
    expect((await s.setRemoteControlAtStartup(true)).isSuccess, isTrue);
    expect(jsonDecode(file.readAsStringSync()), {
      'remoteControlAtStartup': true,
    });
  });

  test('JSON inválido: recusa e não toca no arquivo', () async {
    file
      ..createSync(recursive: true)
      ..writeAsStringSync('{ "model": "opus", // comentário\n}');
    final s = ClaudeCodeSettingsFile(home: home.path);
    final r = await s.setRemoteControlAtStartup(true);
    expect(r.isFailure, isTrue);
    expect(file.readAsStringSync(), contains('// comentário'));
  });
}
