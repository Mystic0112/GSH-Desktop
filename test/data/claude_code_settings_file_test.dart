import 'dart:convert';
import 'dart:io';

import 'package:cockpit/app/core/data/claude_code_settings_file.dart';
import 'package:cockpit/app/core/domain/contracts/claude_code_settings.dart';
import 'package:flutter_test/flutter_test.dart';

const _rc = ClaudeCodeKeys.remoteControlAtStartup;

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
    expect(await s.getBool(_rc), isNull);

    expect((await s.setBool(_rc, true)).isSuccess, isTrue);
    expect(await s.getBool(_rc), isTrue);
    final on = jsonDecode(file.readAsStringSync()) as Map;
    expect(on['model'], 'opus');
    expect(on['hooks'], {'Stop': <Object>[]});

    await s.setBool(_rc, null);
    final off = jsonDecode(file.readAsStringSync()) as Map;
    expect(off.containsKey('remoteControlAtStartup'), isFalse);
    expect(off['model'], 'opus');
  });

  test('cria o arquivo quando não existe', () async {
    final s = ClaudeCodeSettingsFile(home: home.path);
    expect((await s.setBool(_rc, true)).isSuccess, isTrue);
    expect(jsonDecode(file.readAsStringSync()), {
      'remoteControlAtStartup': true,
    });
  });

  test('JSON inválido: recusa e não toca no arquivo', () async {
    file
      ..createSync(recursive: true)
      ..writeAsStringSync('{ "model": "opus", // comentário\n}');
    final s = ClaudeCodeSettingsFile(home: home.path);
    final r = await s.setBool(_rc, true);
    expect(r.isFailure, isTrue);
    expect(file.readAsStringSync(), contains('// comentário'));
  });

  test(
    'false explícito fica gravado; chave de outro tipo lê como null',
    () async {
      file
        ..createSync(recursive: true)
        ..writeAsStringSync(jsonEncode({'switchModelsOnFlag': 'sim'}));
      final s = ClaudeCodeSettingsFile(home: home.path);
      const key = ClaudeCodeKeys.switchModelsOnFlag;
      expect(await s.getBool(key), isNull);
      expect((await s.setBool(key, false)).isSuccess, isTrue);
      expect(await s.getBool(key), isFalse);
      expect(jsonDecode(file.readAsStringSync()), {key: false});
    },
  );

  test('chave com ponto desce no objeto e poda o pai vazio', () async {
    file
      ..createSync(recursive: true)
      ..writeAsStringSync(jsonEncode({'model': 'opus'}));
    final s = ClaudeCodeSettingsFile(home: home.path);
    await s.setValue(ClaudeCodeKeys.sandboxEnabled, true);
    await s.setValue(ClaudeCodeKeys.disableTelemetry, '1');
    expect(await s.getValue(ClaudeCodeKeys.sandboxEnabled), isTrue);
    expect(jsonDecode(file.readAsStringSync()), {
      'model': 'opus',
      'sandbox': {'enabled': true},
      'env': {'DISABLE_TELEMETRY': '1'},
    });
    await s.setValue(ClaudeCodeKeys.disableTelemetry, null);
    await s.setValue(ClaudeCodeKeys.sandboxEnabled, null);
    expect(jsonDecode(file.readAsStringSync()), {'model': 'opus'});
  });
}
