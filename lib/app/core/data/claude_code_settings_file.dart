import 'dart:convert';
import 'dart:io';

import 'package:cockpit/app/core/domain/contracts/claude_code_settings.dart';
import 'package:cockpit/app/core/domain/result.dart';

/// [ClaudeCodeSettings] sobre o `~/.claude/settings.json` do usuário.
///
/// Mexe só na chave pedida: lê o objeto inteiro, troca a chave, regrava tudo
/// (tmp + rename, para o Claude Code nunca ler meio arquivo). Arquivo que não
/// é um objeto JSON não é regravado — melhor recusar do que apagar as
/// configurações de alguém.
class ClaudeCodeSettingsFile implements ClaudeCodeSettings {
  ClaudeCodeSettingsFile({String? home})
    : _file = File(
        '${home ?? Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'] ?? ''}'
        '/.claude/settings.json',
      );

  static const _remoteControlKey = 'remoteControlAtStartup';

  final File _file;

  @override
  Future<bool> remoteControlAtStartup() async {
    final root = await _read();
    return root is Success<Map<String, dynamic>, String> &&
        root.value[_remoteControlKey] == true;
  }

  @override
  Future<Result<void, String>> setRemoteControlAtStartup(bool on) async {
    final read = await _read();
    switch (read) {
      case Failure(:final error):
        return Failure(error);
      case Success(value: final root):
        if (on) {
          root[_remoteControlKey] = true;
        } else {
          root.remove(_remoteControlKey);
        }
        try {
          await _file.parent.create(recursive: true);
          final tmp = File('${_file.path}.gsh-$pid.tmp');
          await tmp.writeAsString(
            '${const JsonEncoder.withIndent('  ').convert(root)}\n',
          );
          await tmp.rename(_file.path);
          return const Success(null);
        } on FileSystemException catch (e) {
          return Failure('${_file.path}: ${e.message}');
        }
    }
  }

  Future<Result<Map<String, dynamic>, String>> _read() async {
    try {
      if (!await _file.exists()) return Success(<String, dynamic>{});
      final text = await _file.readAsString();
      if (text.trim().isEmpty) return Success(<String, dynamic>{});
      final decoded = jsonDecode(text);
      if (decoded is! Map) {
        return Failure('${_file.path}: não é um objeto JSON');
      }
      return Success(Map<String, dynamic>.from(decoded));
    } on FormatException catch (e) {
      return Failure('${_file.path}: JSON inválido (${e.message})');
    } on FileSystemException catch (e) {
      return Failure('${_file.path}: ${e.message}');
    }
  }
}
