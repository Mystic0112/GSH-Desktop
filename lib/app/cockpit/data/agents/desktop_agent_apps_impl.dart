import 'dart:io';

import 'package:cockpit/app/cockpit/domain/contracts/desktop_agent_apps.dart';
import 'package:cockpit/app/cockpit/domain/entities/desktop_agent_app.dart';
import 'package:cockpit/app/cockpit/domain/services/mcp_config_merge.dart';
import 'package:cockpit/app/core/data/setup/remote_pi_resolver.dart';
import 'package:cockpit/app/core/domain/result.dart';

/// Linux: executável (PATH ou caminhos conhecidos) **e** um `.desktop` — o
/// `.desktop` separa o app gráfico de uma CLI homônima.
const _linux = <DesktopAgentApp, (List<String>, List<String>)>{
  DesktopAgentApp.claudeDesktop: (
    ['claude-desktop'],
    ['com.anthropic.Claude.desktop', 'claude-desktop.desktop'],
  ),
  DesktopAgentApp.cursor: (['cursor'], ['cursor.desktop']),
  DesktopAgentApp.antigravityIde: (['antigravity'], ['antigravity.desktop']),
  DesktopAgentApp.codexDesktop: (['chatgpt'], ['chatgpt.desktop']),
};

const _macBundles = <DesktopAgentApp, List<String>>{
  DesktopAgentApp.claudeDesktop: ['Claude.app'],
  DesktopAgentApp.cursor: ['Cursor.app'],
  DesktopAgentApp.antigravityIde: ['Antigravity.app'],
  DesktopAgentApp.codexDesktop: ['Codex.app', 'ChatGPT.app'],
};

// ponytail: Windows/macOS best-effort (caminhos de instalação conhecidos, não
// testados aqui). O ChatGPT do Windows é app da Store (sem .exe estável):
// fica fora até alguém precisar.
const _winExes = <DesktopAgentApp, List<String>>{
  DesktopAgentApp.claudeDesktop: [r'AnthropicClaude\claude.exe'],
  DesktopAgentApp.cursor: [r'Programs\cursor\Cursor.exe'],
  DesktopAgentApp.antigravityIde: [r'Programs\Antigravity\Antigravity.exe'],
};

class DesktopAgentAppsImpl implements DesktopAgentApps {
  const DesktopAgentAppsImpl();

  static Map<String, String> get _env => Platform.environment;
  static String get _home => remotePiHome() ?? '';

  @override
  Future<List<DesktopAppIntegration>> detect() async {
    final command = _cliPath();
    return [
      for (final app in DesktopAgentApp.values)
        if (_locate(app) != null)
          DesktopAppIntegration(
            app: app,
            configPath: _configPath(app),
            entry: app.tomlConfig
                ? tomlMcpEntry(command: command, args: mcpServerArgs(app.id))
                : jsonMcpEntry(command: command, args: mcpServerArgs(app.id)),
          ),
    ];
  }

  @override
  Future<Result<void, DesktopAppError>> install(DesktopAppIntegration i) async {
    final command = _cliPath();
    if (!File(command).existsSync()) {
      return Failure(
        DesktopAppError(DesktopAppErrorKind.cliMissing, detail: command),
      );
    }
    final file = File(i.configPath);
    final args = mcpServerArgs(i.app.id);
    try {
      final exists = await file.exists();
      final raw = exists ? await file.readAsString() : null;
      final String merged;
      try {
        merged = i.app.tomlConfig
            ? mergeTomlMcpServer(raw, command: command, args: args)
            : mergeJsonMcpServer(raw, command: command, args: args);
      } on FormatException {
        return Failure(
          DesktopAppError(DesktopAppErrorKind.invalidConfig, detail: file.path),
        );
      }
      if (merged == raw) return const Success(null); // já integrado
      if (exists) {
        final stamp = DateTime.now().toIso8601String().replaceAll(
          RegExp(r'[:.]'),
          '-',
        );
        await _private(await file.copy('${file.path}.cockpit-bak-$stamp'));
      } else {
        await file.parent.create(recursive: true);
      }
      await file.writeAsString(merged, flush: true);
      if (!exists) await _private(file);
      return const Success(null);
    } on FileSystemException catch (e) {
      return Failure(
        DesktopAppError(
          DesktopAppErrorKind.writeFailed,
          detail: '${file.path}: ${e.osError?.message ?? e.message}',
        ),
      );
    }
  }

  @override
  Future<void> launch(DesktopAgentApp app, String folder) async {
    final target = _locate(app);
    if (target == null) return;
    final args = [
      if (app.opensFolder &&
          folder.isNotEmpty &&
          Directory(folder).existsSync())
        folder,
    ];
    try {
      if (Platform.isMacOS) {
        await Process.start('open', [
          '-a',
          target,
          ...args,
        ], mode: ProcessStartMode.detached);
        return;
      }
      // Sem as envs do Cockpit: o app herdaria um COCKPIT_TAB_ID/SOCK alheio
      // (Cockpit aberto de dentro de outro Cockpit) e passaria pro MCP.
      await Process.start(
        target,
        args,
        mode: ProcessStartMode.detached,
        includeParentEnvironment: false,
        environment: {
          for (final e in _env.entries)
            if (!e.key.startsWith('COCKPIT_')) e.key: e.value,
        },
      );
    } on ProcessException {
      // App sumiu entre o detect e o clique: nada a abrir.
    }
  }

  /// Caminho absoluto da CLI que o app materializa (`~/.cockpit/bin/cockpit`).
  String _cliPath() => cockpitCliPath() ?? '';

  String _configPath(DesktopAgentApp app) {
    final home = _home;
    return switch (app) {
      DesktopAgentApp.claudeDesktop =>
        Platform.isMacOS
            ? '$home/Library/Application Support/Claude/claude_desktop_config.json'
            : Platform.isWindows
            ? '${_env['APPDATA'] ?? '$home/AppData/Roaming'}/Claude/claude_desktop_config.json'
            : '${_env['XDG_CONFIG_HOME'] ?? '$home/.config'}/Claude/claude_desktop_config.json',
      DesktopAgentApp.cursor => '$home/.cursor/mcp.json',
      DesktopAgentApp.antigravityIde =>
        '$home/.gemini/antigravity/mcp_config.json',
      DesktopAgentApp.codexDesktop =>
        '${_env['CODEX_HOME'] ?? '$home/.codex'}/config.toml',
    };
  }

  /// Executável (Linux/Windows) ou bundle `.app` (macOS) do app; `null` = não
  /// instalado.
  String? _locate(DesktopAgentApp app) {
    final home = _home;
    if (Platform.isMacOS) {
      for (final bundle in _macBundles[app]!) {
        for (final base in ['/Applications', '$home/Applications']) {
          if (Directory('$base/$bundle').existsSync()) return '$base/$bundle';
        }
      }
      return null;
    }
    if (Platform.isWindows) {
      final local = _env['LOCALAPPDATA'];
      if (local == null) return null;
      for (final sub in _winExes[app] ?? const <String>[]) {
        if (File('$local\\$sub').existsSync()) return '$local\\$sub';
      }
      return null;
    }
    final (exes, desktops) = _linux[app]!;
    final data = _env['XDG_DATA_HOME'] ?? '$home/.local/share';
    final hasDesktop = [
      '$data/applications',
      '/usr/share/applications',
      '/usr/local/share/applications',
      '/var/lib/flatpak/exports/share/applications',
      '$data/flatpak/exports/share/applications',
    ].any((d) => desktops.any((f) => File('$d/$f').existsSync()));
    if (!hasDesktop) return null;
    final dirs = {
      ...(_env['PATH'] ?? '').split(':').where((d) => d.isNotEmpty),
      '/usr/bin',
      '/usr/local/bin',
      '$home/.local/bin',
      '/snap/bin',
    };
    for (final name in exes) {
      for (final d in dirs) {
        if (File('$d/$name').existsSync()) return '$d/$name';
      }
    }
    return null;
  }

  /// 0600 no POSIX: config e backup podem carregar tokens de outros servidores.
  static Future<void> _private(File f) async {
    if (Platform.isWindows) return;
    try {
      await Process.run('chmod', ['600', f.path]);
    } on ProcessException {
      // sem chmod: fica a permissão herdada (a do original, no backup).
    }
  }
}
