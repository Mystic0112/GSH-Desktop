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

  final File _file;

  @override
  Future<bool?> getBool(String key) async {
    final v = await getValue(key);
    return v is bool ? v : null;
  }

  @override
  Future<Result<void, String>> setBool(String key, bool? value) =>
      setValue(key, value);

  @override
  Future<Object?> getValue(String key) async {
    final root = await _read();
    if (root case Success(:final value)) {
      Object? node = value;
      for (final part in key.split('.')) {
        if (node is! Map) return null;
        node = node[part];
      }
      return node;
    }
    return null;
  }

  @override
  Future<Result<void, String>> setValue(String key, Object? value) async {
    final read = await _read();
    switch (read) {
      case Failure(:final error):
        return Failure(error);
      case Success(value: final root):
        _put(root, key.split('.'), value);
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

  /// Grava no caminho [path] criando os objetos que faltam; `null` remove a
  /// folha e poda o objeto pai que ficou vazio (ex.: `env: {}`).
  static void _put(Map<String, dynamic> map, List<String> path, Object? value) {
    final key = path.first;
    if (path.length == 1) {
      value == null ? map.remove(key) : map[key] = value;
      return;
    }
    final child = map[key] is Map
        ? Map<String, dynamic>.from(map[key] as Map)
        : <String, dynamic>{};
    if (value == null && map[key] is! Map) return;
    _put(child, path.sublist(1), value);
    child.isEmpty ? map.remove(key) : map[key] = child;
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
