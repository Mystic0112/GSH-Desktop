import 'dart:io';

/// Roda um processo e devolve o resultado — ponto de injeção pros testes.
typedef ProcessRunner =
    Future<ProcessResult> Function(String executable, List<String> arguments);

/// Descobre o **shell de login real** do usuário (POSIX: macOS/Linux).
///
/// `$SHELL` **não é variável de sistema** — ela só existe porque um shell-pai a
/// exporta. Quando o Cockpit é aberto pelo Finder/Dock (launchd, sem shell-pai)
/// a variável fica **ausente** e o antigo `Platform.environment['SHELL'] ??
/// '/bin/zsh'` silenciosamente ignorava o shell de login do usuário — quem usa
/// fish caía no zsh (issue #42). Aberto via `open -a Cockpit` de um terminal o
/// `$SHELL` propaga e tudo funciona, o que explica o "só quebra pelo Finder".
/// O flag `-l`/`-ilc` resolve **PATH**, não **qual** shell.
///
/// Ordem de resolução:
/// 1. `$SHELL`, se setada e não-vazia (correto quando lançado de um terminal).
/// 2. macOS: `dscl . -read /Users/<user> UserShell` (Directory Services).
/// 3. Linux: `getent passwd <user>` → 7º campo.
/// 4. Fallback: `/bin/zsh` no macOS, `/bin/sh` no resto.
///
/// A resolução é estável durante a vida do processo → cacheada. Nunca lança:
/// qualquer erro/timeout cai pro fallback.
///
/// Windows tem seu próprio caminho (`ComSpec`/powershell) nos call-sites; esta
/// classe é POSIX-only.
class LoginShell {
  LoginShell({
    Map<String, String>? environment,
    ProcessRunner? runProcess,
    String? operatingSystem,
  }) : _env = environment ?? Platform.environment,
       _run = runProcess ?? Process.run,
       _os = operatingSystem ?? Platform.operatingSystem;

  final Map<String, String> _env;
  final ProcessRunner _run;
  final String _os;

  static const _timeout = Duration(seconds: 3);

  String? _cached;
  Future<String>? _inFlight;

  /// Fallback por plataforma quando nada resolve.
  String get fallback => _os == 'macos' ? '/bin/zsh' : '/bin/sh';

  /// Último valor resolvido, ou o [fallback] se [resolve] ainda não rodou.
  /// Para os call-sites síncronos (spawn de PTY) — chame [resolve] no bootstrap
  /// pra aquecer o cache antes do primeiro uso.
  String get cachedOrFallback => _cached ?? _shellFromEnv ?? fallback;

  String? get _shellFromEnv {
    final shell = _env['SHELL']?.trim();
    return (shell != null && shell.isNotEmpty) ? shell : null;
  }

  /// Resolve o shell de login (cacheado; chamadas concorrentes compartilham a
  /// mesma resolução em andamento).
  Future<String> resolve() {
    final cached = _cached;
    if (cached != null) return Future.value(cached);
    return _inFlight ??= _resolve().then((shell) {
      _cached = shell;
      _inFlight = null;
      return shell;
    });
  }

  Future<String> _resolve() async {
    final fromEnv = _shellFromEnv;
    if (fromEnv != null) return fromEnv;

    final user = await _currentUser();
    if (user != null) {
      final fromOs = _os == 'macos'
          ? await _dsclUserShell(user)
          : await _getentUserShell(user);
      if (fromOs != null) return fromOs;
    }
    return fallback;
  }

  /// `$USER`, ou `id -un` quando o ambiente do processo GUI não a traz.
  Future<String?> _currentUser() async {
    final fromEnv = _env['USER']?.trim();
    if (fromEnv != null && fromEnv.isNotEmpty) return fromEnv;
    final out = await _stdoutOf('id', const ['-un']);
    final user = out?.trim();
    return (user != null && user.isNotEmpty) ? user : null;
  }

  /// macOS: `dscl . -read /Users/<user> UserShell` → `UserShell: /opt/homebrew/bin/fish`.
  Future<String?> _dsclUserShell(String user) async {
    final out = await _stdoutOf('dscl', [
      '.',
      '-read',
      '/Users/$user',
      'UserShell',
    ]);
    if (out == null) return null;
    for (final line in out.split('\n')) {
      final idx = line.indexOf('UserShell:');
      if (idx < 0) continue;
      final path = line.substring(idx + 'UserShell:'.length).trim();
      if (path.startsWith('/')) return path;
    }
    return null;
  }

  /// Linux: `getent passwd <user>` → `user:x:1000:1000:...:/home/user:/usr/bin/fish`.
  Future<String?> _getentUserShell(String user) async {
    final out = await _stdoutOf('getent', ['passwd', user]);
    if (out == null) return null;
    for (final line in out.split('\n')) {
      if (!line.startsWith('$user:')) continue;
      final shell = line.trim().split(':').last;
      if (shell.startsWith('/')) return shell;
    }
    return null;
  }

  Future<String?> _stdoutOf(String exe, List<String> args) async {
    try {
      final res = await _run(exe, args).timeout(_timeout);
      if (res.exitCode != 0) return null;
      return res.stdout as String?;
    } catch (_) {
      // executável ausente / timeout / stdout binário → sem resposta.
      return null;
    }
  }
}

/// Instância compartilhada pelo app (cache único por processo).
final loginShell = LoginShell();

/// Atalho: resolve (e cacheia) o shell de login do usuário.
Future<String> resolveLoginShell() => loginShell.resolve();

/// Atalho síncrono: o shell já resolvido, ou o melhor palpite disponível.
String loginShellOrFallback() => loginShell.cachedOrFallback;
