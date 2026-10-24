import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

/// O último status que o `gsh hook` gravou por sessão em
/// `~/.gsh/farm/<sid>.json` (`st`, `ev`, `ts` em ms, `hn`). É de onde a
/// fazenda sabe de um pedido de permissão: ele não aparece no transcript de
/// nenhum harness, só no hook.
class FarmHookStatus {
  FarmHookStatus({String? dir})
    : dir =
          dir ??
          p.join(
            Platform.environment['HOME'] ??
                Platform.environment['USERPROFILE'] ??
                '',
            '.gsh',
            'farm',
          );

  final String dir;

  /// Status mais velho que isso é lixo de sessão que morreu sem `SessionEnd`.
  static const ttl = Duration(days: 1);

  DateTime _lastSweep = DateTime.fromMillisecondsSinceEpoch(0);

  /// Quando o hook marcou a sessão como `waiting` (permissão, pergunta), ou
  /// `null` se o último status é outro ou não há arquivo.
  Future<DateTime?> waitingAt(String sid) async {
    try {
      final v = jsonDecode(await File(p.join(dir, '$sid.json')).readAsString());
      if (v is! Map || v['st'] != 'waiting') return null;
      final ts = v['ts'];
      return ts is int ? DateTime.fromMillisecondsSinceEpoch(ts) : null;
    } on Object {
      return null; // sem arquivo (hook antigo, sessão sem evento) ou meio escrito
    }
  }

  /// Faxina dos arquivos vencidos, no máximo a cada 10 min.
  Future<void> sweep(DateTime now) async {
    if (now.difference(_lastSweep) < const Duration(minutes: 10)) return;
    _lastSweep = now;
    final d = Directory(dir);
    try {
      if (!await d.exists()) return;
      await for (final f in d.list(followLinks: false)) {
        if (f is! File) continue;
        if (now.difference((await f.stat()).modified) > ttl) await f.delete();
      }
    } on FileSystemException {
      // Varredura é faxina: falhar não importa.
    }
  }
}
