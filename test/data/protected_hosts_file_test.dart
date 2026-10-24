import 'dart:io';

import 'package:gsh_desktop/app/core/data/protected_hosts_file.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('grava, normaliza e apaga quando vazio', () async {
    final home = await Directory.systemTemp.createTemp('home');
    addTearDown(() => home.delete(recursive: true));
    final s = ProtectedHostsFile(home: home.path);
    expect(await s.read(), isEmpty);
    await s.write([' Prod', 'homolog.gorila.com', '', 'prod']);
    expect(await s.read(), ['prod', 'homolog.gorila.com']);
    expect(
      File('${home.path}/.gsh/protected-hosts.json').readAsStringSync(),
      '["prod","homolog.gorila.com"]\n',
    );
    await s.write(['', ' ']);
    expect(
      File('${home.path}/.gsh/protected-hosts.json').existsSync(),
      isFalse,
    );
  });
}
