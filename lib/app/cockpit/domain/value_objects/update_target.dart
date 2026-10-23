/// Alvo de atualização resolvido no boot: versão atual do app + plataforma /
/// formato / arch correntes (pra escolher o artefato certo do manifest). É um
/// value object injetável (registrado no `cockpit_module`) para que o
/// `UpdateViewModel` possa ser auto-injetado via `.new`, em vez de receber 4
/// `String` soltas que o `auto_injector` não consegue desambiguar.
class UpdateTarget {
  const UpdateTarget({
    required this.version,
    required this.platform,
    required this.format,
    required this.arch,
    this.selfUpdateFeedUrl,
  });

  /// Versão do app rodando (de `package_info`).
  final String version;

  /// macOS → dmg/universal; Windows → exe/x64; Linux → deb/(arm64|x64).
  final String platform;
  final String format;
  final String arch;

  /// Plano 47 — URL do appcast do self-update nativo (Sparkle/WinSparkle):
  /// `appcast-macos.xml` no macOS, `appcast-windows.xml` no Windows. `null` no
  /// Linux (sem self-update → cai no caminho de notify + download manual).
  final String? selfUpdateFeedUrl;
}
