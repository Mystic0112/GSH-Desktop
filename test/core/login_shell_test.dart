import 'dart:io';

import 'package:cockpit/app/core/utils/login_shell.dart';
import 'package:flutter_test/flutter_test.dart';

/// Runner falso: casa por `exe + args` e conta as invocações.
class _FakeRunner {
  _FakeRunner(this.responses);

  /// chave = `'<exe> <args unidos por espaço>'`.
  final Map<String, ProcessResult> responses;
  final calls = <String>[];

  Future<ProcessResult> call(String exe, List<String> args) async {
    final key = '$exe ${args.join(' ')}';
    calls.add(key);
    final res = responses[key];
    if (res == null) throw ProcessException(exe, args, 'not found', 127);
    return res;
  }
}

ProcessResult _ok(String stdout) => ProcessResult(1, 0, stdout, '');

void main() {
  group('LoginShell', () {
    test('\$SHELL setada vence — não consulta o SO', () async {
      final runner = _FakeRunner({});
      final shell = LoginShell(
        environment: const {'SHELL': '/opt/homebrew/bin/fish', 'USER': 'jacob'},
        runProcess: runner.call,
        operatingSystem: 'macos',
      );

      expect(await shell.resolve(), '/opt/homebrew/bin/fish');
      expect(runner.calls, isEmpty);
    });

    test('\$SHELL vazia é ignorada — cai no dscl', () async {
      final runner = _FakeRunner({
        'dscl . -read /Users/jacob UserShell': _ok(
          'UserShell: /opt/homebrew/bin/fish\n',
        ),
      });
      final shell = LoginShell(
        environment: const {'SHELL': '  ', 'USER': 'jacob'},
        runProcess: runner.call,
        operatingSystem: 'macos',
      );

      expect(await shell.resolve(), '/opt/homebrew/bin/fish');
    });

    test('macOS sem \$SHELL (aberto pelo Finder) → dscl', () async {
      final runner = _FakeRunner({
        'dscl . -read /Users/jacob UserShell': _ok(
          'UserShell: /opt/homebrew/bin/fish\n',
        ),
      });
      final shell = LoginShell(
        environment: const {'USER': 'jacob'},
        runProcess: runner.call,
        operatingSystem: 'macos',
      );

      expect(await shell.resolve(), '/opt/homebrew/bin/fish');
      expect(runner.calls, ['dscl . -read /Users/jacob UserShell']);
    });

    test('sem \$USER → descobre o usuário via `id -un`', () async {
      final runner = _FakeRunner({
        'id -un': _ok('jacob\n'),
        'dscl . -read /Users/jacob UserShell': _ok('UserShell: /bin/bash\n'),
      });
      final shell = LoginShell(
        environment: const {},
        runProcess: runner.call,
        operatingSystem: 'macos',
      );

      expect(await shell.resolve(), '/bin/bash');
      expect(runner.calls, contains('id -un'));
    });

    test('Linux sem \$SHELL → getent passwd, 7º campo', () async {
      final runner = _FakeRunner({
        'getent passwd jacob': _ok(
          'jacob:x:1000:1000:Jacob,,,:/home/jacob:/usr/bin/fish\n',
        ),
      });
      final shell = LoginShell(
        environment: const {'USER': 'jacob'},
        runProcess: runner.call,
        operatingSystem: 'linux',
      );

      expect(await shell.resolve(), '/usr/bin/fish');
    });

    test('dscl falhando → fallback /bin/zsh no macOS', () async {
      final runner = _FakeRunner({}); // tudo lança ProcessException
      final shell = LoginShell(
        environment: const {'USER': 'jacob'},
        runProcess: runner.call,
        operatingSystem: 'macos',
      );

      expect(await shell.resolve(), '/bin/zsh');
    });

    test('getent com exitCode != 0 → fallback /bin/sh no Linux', () async {
      final runner = _FakeRunner({
        'getent passwd jacob': ProcessResult(1, 2, '', 'nope'),
      });
      final shell = LoginShell(
        environment: const {'USER': 'jacob'},
        runProcess: runner.call,
        operatingSystem: 'linux',
      );

      expect(await shell.resolve(), '/bin/sh');
    });

    test('saída inesperada do dscl não vira shell inválido', () async {
      final runner = _FakeRunner({
        'dscl . -read /Users/jacob UserShell': _ok(
          '<dscl_cmd> DS Error: -14136 (eDSRecordNotFound)\n',
        ),
      });
      final shell = LoginShell(
        environment: const {'USER': 'jacob'},
        runProcess: runner.call,
        operatingSystem: 'macos',
      );

      expect(await shell.resolve(), '/bin/zsh');
    });

    test('resolve() cacheia — o SO é consultado uma vez só', () async {
      final runner = _FakeRunner({
        'dscl . -read /Users/jacob UserShell': _ok('UserShell: /bin/bash\n'),
      });
      final shell = LoginShell(
        environment: const {'USER': 'jacob'},
        runProcess: runner.call,
        operatingSystem: 'macos',
      );

      final results = await Future.wait([shell.resolve(), shell.resolve()]);
      await shell.resolve();

      expect(results, ['/bin/bash', '/bin/bash']);
      expect(runner.calls.length, 1);
    });

    test('cachedOrFallback: fallback antes, valor resolvido depois', () async {
      final runner = _FakeRunner({
        'dscl . -read /Users/jacob UserShell': _ok(
          'UserShell: /opt/homebrew/bin/fish\n',
        ),
      });
      final shell = LoginShell(
        environment: const {'USER': 'jacob'},
        runProcess: runner.call,
        operatingSystem: 'macos',
      );

      expect(shell.cachedOrFallback, '/bin/zsh');
      await shell.resolve();
      expect(shell.cachedOrFallback, '/opt/homebrew/bin/fish');
    });

    test('cachedOrFallback usa \$SHELL sem esperar resolve()', () {
      final shell = LoginShell(
        environment: const {'SHELL': '/opt/homebrew/bin/fish'},
        runProcess: _FakeRunner({}).call,
        operatingSystem: 'macos',
      );

      expect(shell.cachedOrFallback, '/opt/homebrew/bin/fish');
    });
  });
}
