import 'dart:ffi';
import 'dart:io';

/// Resolve a dylib do gsh_pty compilada FORA do Flutter (gate FFI da
/// Wave 0). Ordem: env `GSH_PTY_DYLIB` → ao lado do executável →
/// `../lib/` do executável (layout do bundle `bin/` + `lib/`, que é como o
/// zip do servidor e o cliente por SSH instalam; sem isto rodar
/// `gsh-server` à mão num host morria com "dylib not found") →
/// `build/wave0/` relativo ao cwd (fluxo `dart run` no repo).
DynamicLibrary openPtyDylib() {
  final name = Platform.isMacOS
      ? 'libgsh_pty.dylib'
      : Platform.isLinux
      ? 'libgsh_pty.so'
      : 'gsh_pty.dll';

  final binDir = File(Platform.resolvedExecutable).parent;
  final candidates = <String>[
    ?Platform.environment['GSH_PTY_DYLIB'],
    '${binDir.path}/$name',
    '${binDir.parent.path}/lib/$name',
    'build/wave0/$name',
  ];

  for (final path in candidates) {
    if (File(path).existsSync()) return DynamicLibrary.open(path);
  }
  throw StateError(
    'gsh_pty dylib not found; tried: ${candidates.join(', ')} '
    '(build it with tool/wave0/build_pty_dylib.sh or set GSH_PTY_DYLIB)',
  );
}
