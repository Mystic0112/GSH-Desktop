import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:gsh_desktop/app/core/domain/result.dart';
import 'package:gsh_desktop/app/core/utils/executable_resolver.dart';
import 'package:gsh_desktop/app/core/utils/user_home.dart';
import 'package:gsh_desktop/app/settings/data/claude_files.dart';
import 'package:gsh_desktop/app/settings/data/claude_info_parsers.dart';
import 'package:gsh_desktop/app/settings/domain/claude_info.dart';

/// [ClaudeInfoSource] sobre a CLI `claude` instalada e o `~/.claude`.
class ClaudeCliInfoSource implements ClaudeInfoSource {
  ClaudeCliInfoSource();

  /// Resolvido uma vez: o `which` via shell de login custa ~100 ms.
  late final Future<String> _exe = resolveExecutable('claude');

  static String get _home => userHome() ?? '';

  /// Instalado via nvm, o `claude` é um script `#!/usr/bin/env node`: a pasta
  /// dele precisa estar no PATH para o `node` ser achado num app GUI.
  Future<Map<String, String>> _env() async {
    final dir = File(await _exe).parent.path;
    final sep = Platform.isWindows ? ';' : ':';
    final path = Platform.environment['PATH'] ?? '';
    return {'PATH': path.isEmpty ? dir : '$dir$sep$path'};
  }

  Future<Result<String, ClaudeInfoError>> _run(
    List<String> args, {
    Duration timeout = const Duration(seconds: 30),
  }) async {
    try {
      final r = await Process.run(
        await _exe,
        args,
        environment: await _env(),
        workingDirectory: _home.isEmpty ? null : _home,
      ).timeout(timeout);
      if (r.exitCode != 0) {
        final err = '${r.stderr}'.trim();
        return Failure(
          ClaudeInfoError(
            ClaudeInfoErrorKind.failed,
            err.isEmpty ? '${r.stdout}'.trim() : err,
          ),
        );
      }
      return Success('${r.stdout}');
    } on ProcessException catch (e) {
      return Failure(
        ClaudeInfoError(ClaudeInfoErrorKind.cliMissing, e.message),
      );
    } on TimeoutException {
      // ponytail: Process.run não mata o filho no timeout; ele termina sozinho
      // (health-check do mcp list tem timeout próprio).
      return const Failure(ClaudeInfoError(ClaudeInfoErrorKind.timeout));
    }
  }

  Result<T, ClaudeInfoError> _parse<T>(
    Result<String, ClaudeInfoError> r,
    T Function(String) parse,
  ) => r.fold((out) {
    try {
      return Success(parse(out));
    } on FormatException catch (e) {
      return Failure(ClaudeInfoError(ClaudeInfoErrorKind.failed, e.message));
    }
  }, Failure.new);

  @override
  Future<Result<ClaudeAccount, ClaudeInfoError>> account() async =>
      _parse(await _run(const ['auth', 'status', '--json']), parseAuthStatus);

  @override
  Future<Result<void, ClaudeInfoError>> logout() async =>
      (await _run(const ['auth', 'logout'])).map((_) {});

  @override
  Future<Result<List<McpServerInfo>, ClaudeInfoError>> mcpServers() async =>
      _parse(
        await _run(const ['mcp', 'list'], timeout: const Duration(seconds: 90)),
        parseMcpList,
      );

  /// Sobe `claude -p` em stream-json, manda o `control_request` `get_usage`
  /// logo de cara (responde em ~1,5 s, sem precisar de turno nem de
  /// `system/init`) e mata o processo assim que a resposta chega.
  @override
  Future<Result<ClaudeUsage, ClaudeInfoError>> usage() async {
    final Process proc;
    try {
      proc = await Process.start(
        await _exe,
        const [
          '-p',
          '--input-format',
          'stream-json',
          '--output-format',
          'stream-json',
          '--verbose',
        ],
        environment: await _env(),
        workingDirectory: _home.isEmpty ? null : _home,
      );
    } on ProcessException catch (e) {
      return Failure(
        ClaudeInfoError(ClaudeInfoErrorKind.cliMissing, e.message),
      );
    }
    unawaited(proc.stderr.drain<void>());
    try {
      proc.stdin.writeln(
        jsonEncode({
          'type': 'control_request',
          'request_id': 'gsh-usage',
          'request': {'subtype': 'get_usage', 'skip_behaviors': true},
        }),
      );
      await proc.stdin.flush();
      await for (final line
          in proc.stdout
              .transform(utf8.decoder)
              .transform(const LineSplitter())
              .timeout(const Duration(seconds: 30))) {
        final Object? o;
        try {
          o = jsonDecode(line);
        } on FormatException {
          continue;
        }
        if (o is! Map || o['type'] != 'control_response') continue;
        final resp = o['response'];
        if (resp is! Map || resp['request_id'] != 'gsh-usage') continue;
        if (resp['subtype'] != 'success' || resp['response'] is! Map) {
          return Failure(
            ClaudeInfoError(ClaudeInfoErrorKind.failed, '${resp['error']}'),
          );
        }
        return Success(
          parseUsageReply(Map<String, dynamic>.from(resp['response'] as Map)),
        );
      }
      return const Failure(ClaudeInfoError(ClaudeInfoErrorKind.failed));
    } on TimeoutException {
      return const Failure(ClaudeInfoError(ClaudeInfoErrorKind.timeout));
    } on IOException catch (e) {
      // stdin fechado: o processo morreu antes de ler o pedido.
      return Failure(ClaudeInfoError(ClaudeInfoErrorKind.failed, '$e'));
    } finally {
      proc.kill();
    }
  }

  late final _files = ClaudeFiles(_home);

  /// Plugins com nome/autor/descrição do manifesto de cada um.
  @override
  Future<Result<List<ClaudePluginInfo>, ClaudeInfoError>> plugins() async {
    final r = _parse(
      await _run(const ['plugin', 'list', '--json']),
      parsePluginList,
    );
    return switch (r) {
      Success(:final value) => Success(await _files.withManifests(value)),
      Failure(:final error) => Failure(error),
    };
  }

  /// `claude plugin marketplace list --json` → `marketplace.json` de cada um.
  @override
  Future<Result<List<MarketplacePlugin>, ClaudeInfoError>> directory() async {
    final list = _parse(
      await _run(const ['plugin', 'marketplace', 'list', '--json']),
      parseMarketplaceList,
    );
    final Map<String, String> locations;
    switch (list) {
      case Failure(:final error):
        return Failure(error);
      case Success(:final value):
        locations = value;
    }
    final installed = switch (await plugins()) {
      Success(:final value) => {for (final p in value) p.id},
      Failure() => const <String>{},
    };
    return Success(await _files.directory(locations, installed));
  }

  @override
  Future<Result<List<ClaudeSkillInfo>, ClaudeInfoError>> skills(
    String? workspace,
  ) async {
    final plugins = switch (await this.plugins()) {
      Success(:final value) => value,
      Failure() => const <ClaudePluginInfo>[],
    };
    return Success(await _files.skills(plugins, workspace));
  }

  @override
  Future<List<MemoryFileInfo>> memoryFiles(String? workspace) =>
      _files.memoryFiles(workspace);

  @override
  Future<List<AutoMemoryEntry>> autoMemory(String? workspace) =>
      _files.autoMemory(workspace);

  @override
  Future<List<String>> outputStyles() => _files.outputStyles();

  @override
  Future<List<String>> projectPlugins(String workspace) =>
      _files.projectPlugins(workspace);

  @override
  Future<String> readUserInstructions() => _files.readUserInstructions();

  @override
  Future<Result<void, ClaudeInfoError>> writeUserInstructions(String text) =>
      _files.writeUserInstructions(text);
}
