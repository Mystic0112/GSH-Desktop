import 'dart:io';

import 'package:gsh_desktop/app/gsh/data/farm/antigravity_farm_source.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/farm_loop.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  test('lê conversas recentes do índice do Antigravity', () async {
    final dir = await Directory.systemTemp.createTemp('agy');
    addTearDown(() => dir.delete(recursive: true));
    final path = '${dir.path}/conversation_summaries.db';
    final db = sqlite3.open(path)
      ..execute('''
        CREATE TABLE conversation_summaries (
          conversation_id text PRIMARY KEY, title text NOT NULL DEFAULT "",
          preview text NOT NULL DEFAULT "", step_count integer NOT NULL DEFAULT 0,
          last_modified_time datetime NOT NULL, workspace_uris text NOT NULL,
          status text NOT NULL DEFAULT "", not_fully_idle numeric NOT NULL DEFAULT false,
          killed numeric NOT NULL DEFAULT false, parent_conversation_id text NOT NULL DEFAULT "")
      ''');
    final now = DateTime.now().toUtc();
    String ts(Duration ago) =>
        now.subtract(ago).toIso8601String().replaceFirst('T', ' ');
    db.execute(
      'INSERT INTO conversation_summaries VALUES '
      "('a1','Civic turbo','', 3, ?, '[\"file:///home/x/proj\"]', 'CASCADE_RUN_STATUS_IDLE', 0, 0, ''), "
      "('a2','', 'Refatorar login', 1, ?, '[\"file:///home/x/proj\"]', 'CASCADE_RUN_STATUS_RUNNING', 1, 0, 'a1'), "
      "('a3','Velha','', 1, ?, '[]', 'CASCADE_RUN_STATUS_IDLE', 0, 0, ''), "
      "('a4','Morta','', 1, ?, '[]', 'CASCADE_RUN_STATUS_IDLE', 0, 1, '')",
      [
        ts(const Duration(minutes: 1)),
        ts(const Duration(seconds: 10)),
        ts(const Duration(hours: 3)),
        ts(const Duration(minutes: 2)),
      ],
    );
    db.close();

    final loops = await AntigravityFarmSource(dbPath: path).scan(now);
    expect(loops.map((l) => l.id), ['a2', 'a1']);
    final a1 = loops.firstWhere((l) => l.id == 'a1');
    expect(
      (a1.harness, a1.project, a1.activity),
      ('antigravity', '/home/x/proj', FarmActivity.idle),
    );
    final a2 = loops.firstWhere((l) => l.id == 'a2');
    expect(
      (a2.title, a2.parentId, a2.activity),
      ('Refatorar login', 'a1', FarmActivity.thinking),
    );
    expect(
      await AntigravityFarmSource(dbPath: '${dir.path}/nao.db').scan(now),
      isEmpty,
    );
  });
}
