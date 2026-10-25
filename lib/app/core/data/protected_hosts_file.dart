import 'dart:convert';
import 'dart:io';

import 'package:gsh_desktop/app/core/domain/contracts/protected_hosts.dart';

/// [ProtectedHosts] em `~/.gsh/protected-hosts.json` (array de strings), o
/// mesmo arquivo que o `gsh hook` lê.
class ProtectedHostsFile implements ProtectedHosts {
  ProtectedHostsFile({String? home})
    : _file = File(
        '${home ?? Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'] ?? ''}'
        '/.gsh/protected-hosts.json',
      );

  final File _file;

  @override
  Future<List<String>> read() async {
    try {
      final decoded = jsonDecode(await _file.readAsString());
      if (decoded is! List) return const [];
      return [
        for (final v in decoded)
          if (v is String && v.trim().isNotEmpty) v.trim(),
      ];
    } on Object {
      return const []; // sem arquivo ou inválido = nenhum host
    }
  }

  @override
  Future<void> write(List<String> hosts) async {
    final clean = {for (final h in hosts) h.trim().toLowerCase()}..remove('');
    if (clean.isEmpty) {
      if (await _file.exists()) await _file.delete();
      return;
    }
    await _file.parent.create(recursive: true);
    final tmp = File('${_file.path}.$pid.tmp');
    await tmp.writeAsString('${jsonEncode(clean.toList())}\n');
    await tmp.rename(_file.path);
  }
}
