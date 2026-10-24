import 'dart:convert';
import 'dart:io';

import 'package:gsh_server/src/host_hook_installer.dart';
import 'package:test/test.dart';

void main() {
  late Directory tmp;
  setUp(() => tmp = Directory.systemTemp.createTempSync('hooks'));
  tearDown(() => tmp.deleteSync(recursive: true));

  Map<String, dynamic> read(File f) =>
      jsonDecode(f.readAsStringSync()) as Map<String, dynamic>;

  List<String> commandsOf(Map<String, dynamic> root, String event) {
    final groups = (root['hooks'] as Map)[event] as List;
    return [
      for (final g in groups)
        for (final h in (g as Map)['hooks'] as List)
          (h as Map)['command'] as String,
    ];
  }

  test('troca o grupo marcado e remove sobras de staging sem marcador', () async {
    final f = File('${tmp.path}/settings.json');
    f.writeAsStringSync(
      jsonEncode({
        'hooks': {
          'Stop': [
            // Hook do usuário: fica.
            {
              'matcher': '',
              'hooks': [
                {'type': 'command', 'command': 'say done'},
              ],
            },
            // Nosso, versão antiga, caminho final: substituído.
            {
              'matcher': '',
              'hooks': [
                {
                  'type': 'command',
                  'command': '/root/.gsh/server/bin/gsh hook',
                  '_gsh': 'v1',
                },
              ],
            },
            // Sobra do smoke test do server 2.0.0 (stage que não existe mais), SEM marcador.
            {
              'matcher': '',
              'hooks': [
                {
                  'type': 'command',
                  'command':
                      '/root/.gsh/server.stage.S7eKIJ/bin/gsh hook',
                },
              ],
            },
            // Sobra do staging do cliente desktop.
            {
              'matcher': '',
              'hooks': [
                {
                  'type': 'command',
                  'command':
                      '/root/.gsh/server.staging-123/bin/gsh hook',
                  '_gsh': 'v1',
                },
              ],
            },
          ],
        },
        'other': true,
      }),
    );

    await HostHookInstaller().writeClaudeConfig(
      f,
      '/root/.gsh/server/bin/gsh hook',
    );

    final root = read(f);
    expect(root['other'], isTrue);
    expect(commandsOf(root, 'Stop'), [
      'say done',
      '/root/.gsh/server/bin/gsh hook',
    ]);
    // Todos os eventos ganham exatamente um grupo nosso.
    for (final ev in ['UserPromptSubmit', 'PreToolUse', 'SessionStart']) {
      expect(commandsOf(root, ev), ['/root/.gsh/server/bin/gsh hook']);
    }
  });

  test('idempotente: rodar duas vezes não duplica', () async {
    final f = File('${tmp.path}/settings.json');
    final installer = HostHookInstaller();
    await installer.writeClaudeConfig(f, '/x/bin/gsh hook');
    await installer.writeClaudeConfig(f, '/x/bin/gsh hook');
    expect(commandsOf(read(f), 'Stop'), ['/x/bin/gsh hook']);
  });
}
