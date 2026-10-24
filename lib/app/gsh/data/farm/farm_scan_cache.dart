import 'dart:io';

import 'package:flutter/foundation.dart' show visibleForTesting;

/// Quando uma fonte da fazenda precisa relistar as pastas (a parte cara da
/// varredura): entre listagens ela só faz `stat` nos arquivos que estavam na
/// janela, e confere o mtime de umas poucas pastas vigiadas — arquivo novo
/// numa delas muda o mtime e força a listagem na hora.
///
/// ponytail: o mtime das pastas é lido depois da listagem; uma mudança
/// nesse meio-tempo espera a próxima listagem por tempo ([every]).
class FarmScanCache {
  /// Listagem completa no máximo a cada isso: sessão nova numa pasta não
  /// vigiada aparece em até [every].
  static const every = Duration(seconds: 15);

  /// Varredura depois de uma pausa maior que isso (fazenda escondida e
  /// reaberta, `scanOnce`) relista tudo.
  static const gap = Duration(seconds: 5);

  DateTime? _listedAt, _scannedAt;
  Map<String, DateTime> _watch = const {};

  /// Esta varredura deve relistar as pastas? Marca a varredura como feita.
  Future<bool> due(DateTime now) async {
    var full = farmRelistDue(
      now: now,
      listedAt: _listedAt,
      scannedAt: _scannedAt,
    );
    if (!full) {
      for (final MapEntry(key: dir, value: at) in _watch.entries) {
        if (await _mtime(dir) != at) {
          full = true;
          break;
        }
      }
    }
    _scannedAt = now;
    if (full) _listedAt = now;
    return full;
  }

  /// Pastas a vigiar até a próxima listagem (as dos arquivos recentes, e a
  /// raiz). Pasta que ainda não existe também vale: criar muda o mtime.
  Future<void> watch(Iterable<String> dirs) async {
    _watch = {for (final d in dirs.toSet()) d: await _mtime(d)};
  }

  static Future<DateTime> _mtime(String dir) async =>
      (await FileStat.stat(dir)).modified;
}

/// A regra de [FarmScanCache.due] sem disco: relista na primeira vez, a cada
/// [FarmScanCache.every] e depois de uma pausa maior que [FarmScanCache.gap].
@visibleForTesting
bool farmRelistDue({
  required DateTime now,
  DateTime? listedAt,
  DateTime? scannedAt,
}) =>
    listedAt == null ||
    scannedAt == null ||
    now.difference(listedAt) >= FarmScanCache.every ||
    now.difference(scannedAt) > FarmScanCache.gap;
