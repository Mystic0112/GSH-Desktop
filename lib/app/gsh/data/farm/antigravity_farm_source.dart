import 'dart:convert';
import 'dart:io';

import 'package:gsh_desktop/app/gsh/domain/contracts/farm_source.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/farm_loop.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

/// Loops do **Antigravity** (`agy`), lidos do índice de conversas que a CLI
/// mantém em `~/.gemini/antigravity-cli/conversation_summaries.db` (SQLite,
/// WAL): título, pasta (`workspace_uris`), status
/// (`CASCADE_RUN_STATUS_*`), `not_fully_idle`, pai (subagentes) e horário.
///
/// O que não dá: a ferramenta em uso e tokens (os passos ficam em protobuf
/// por conversa) e "esperando permissão" (o Antigravity não tem hook).
class AntigravityFarmSource implements FarmSource {
  AntigravityFarmSource({String? dbPath})
    : _dbPath =
          dbPath ??
          p.join(
            Platform.environment['HOME'] ??
                Platform.environment['USERPROFILE'] ??
                '',
            '.gemini',
            'antigravity-cli',
            'conversation_summaries.db',
          );

  static const window = Duration(minutes: 30);
  static const sleepAfter = Duration(minutes: 10);

  final String _dbPath;

  @override
  Future<List<FarmLoop>> scan(DateTime now) async {
    if (!await File(_dbPath).exists()) return const [];
    final Database db;
    try {
      db = sqlite3.open(_dbPath, mode: OpenMode.readOnly);
    } on SqliteException {
      return const [];
    }
    try {
      // O índice grava `AAAA-MM-DD HH:MM:SS.fff+00:00` (espaço, não `T`):
      // compara como texto, então o limite segue o mesmo formato.
      final since = now
          .subtract(window)
          .toUtc()
          .toIso8601String()
          .replaceFirst('T', ' ');
      final rows = db.select(
        'SELECT conversation_id, title, preview, status, not_fully_idle, '
        'killed, last_modified_time, workspace_uris, parent_conversation_id '
        'FROM conversation_summaries WHERE last_modified_time >= ? '
        'ORDER BY last_modified_time DESC LIMIT 200',
        [since],
      );
      return [for (final r in rows) ?_loop(r, now)];
    } on SqliteException {
      return const []; // a CLI pode estar escrevendo; tenta na próxima
    } finally {
      db.close();
    }
  }

  FarmLoop? _loop(Row r, DateTime now) {
    final id = r['conversation_id'] as String?;
    if (id == null || id.isEmpty || r['killed'] == 1) return null;
    final lastSeen =
        DateTime.tryParse(r['last_modified_time'] as String? ?? '') ?? now;
    final status = r['status'] as String? ?? '';
    var activity = status == 'CASCADE_RUN_STATUS_IDLE' || status.isEmpty
        ? FarmActivity.idle
        : FarmActivity.thinking;
    if (r['not_fully_idle'] == 1) activity = FarmActivity.thinking;
    if (activity == FarmActivity.idle &&
        now.difference(lastSeen) > sleepAfter) {
      activity = FarmActivity.sleeping;
    }
    final parent = r['parent_conversation_id'] as String? ?? '';
    final project = _project(r['workspace_uris'] as String? ?? '');
    final title = (r['title'] as String? ?? '').trim();
    final preview = (r['preview'] as String? ?? '').trim();
    return FarmLoop(
      id: id,
      parentId: parent.isEmpty ? null : parent,
      harness: 'antigravity',
      project: project ?? '',
      title: title.isNotEmpty
          ? title
          : preview.isNotEmpty
          ? preview
          : p.basename(project ?? 'antigravity'),
      activity: activity,
      lastSeen: lastSeen,
    );
  }

  /// `["file:///home/x/proj"]` → `/home/x/proj` (a primeira pasta).
  static String? _project(String raw) {
    try {
      final list = jsonDecode(raw);
      if (list is! List) return null;
      for (final u in list.whereType<String>()) {
        final uri = Uri.tryParse(u);
        if (uri != null && uri.scheme == 'file') return uri.toFilePath();
      }
    } on FormatException {
      // workspace_uris não é JSON: sem pasta
    }
    return null;
  }
}
