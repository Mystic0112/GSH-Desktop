import 'dart:io';

/// Junta segmentos com o separador da plataforma (o projeto não depende do
/// pacote `path` — a convenção é `Platform.pathSeparator`, ver os filesystem
/// impls do shell).
String joinPath(String base, String segment) {
  final sep = Platform.pathSeparator;
  if (base.endsWith(sep)) return '$base$segment';
  return '$base$sep$segment';
}

/// `true` se [path] já é absoluto (POSIX `/...` ou Windows `C:\...`).
bool isAbsolutePath(String path) {
  if (path.startsWith('/')) return true;
  return RegExp(r'^[A-Za-z]:[\\/]').hasMatch(path);
}

/// Resolve um [cwd] (possivelmente relativo) contra a raiz [base]. Vazio/null
/// → a própria [base]; absoluto → ele mesmo; relativo → `base/cwd`.
String resolveCwd(String base, String? cwd) {
  if (cwd == null || cwd.isEmpty) return base;
  if (isAbsolutePath(cwd)) return cwd;
  return joinPath(base, cwd);
}
