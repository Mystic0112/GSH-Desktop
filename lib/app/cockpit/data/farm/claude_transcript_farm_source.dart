import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:cockpit/app/cockpit/data/farm/transcript_tail.dart';
import 'package:cockpit/app/cockpit/domain/contracts/farm_source.dart';
import 'package:cockpit/app/cockpit/domain/entities/farm_loop.dart';
import 'package:path/path.dart' as p;

/// Loops do Claude Code lidos dos transcripts em `~/.claude/projects`.
///
/// Lê o arquivo, não o hook: pega toda sessão da máquina (aba do GSH, outro
/// terminal, `claude -p`, subagentes em `<sid>/subagents/`), e não depende de
/// qual versão da CLI `cockpit` está em `~/.cockpit/bin`.
///
/// ponytail: polling com `stat` em todos os `.jsonl` (~200 aqui). Se a pasta
/// crescer para milhares, trocar por watcher (inotify) só nos projetos ativos.
/// Pedido de permissão não aparece no transcript: um loop parado esperando
/// aprovação lê como a ferramenta pendente. Upgrade: cruzar com o status do
/// hook da aba (`waiting`) pelo `session_id`.
class ClaudeTranscriptFarmSource implements FarmSource {
  ClaudeTranscriptFarmSource({String? root})
    : _root =
          root ??
          p.join(
            Platform.environment['HOME'] ??
                Platform.environment['USERPROFILE'] ??
                '',
            '.claude',
            'projects',
          );

  /// Transcript sem escrita há mais que isso sai da fazenda.
  static const window = Duration(minutes: 30);

  /// Loop sem evento há mais que isso dorme.
  static const sleepAfter = Duration(minutes: 10);

  /// Subagente concluído continua visível por este tempo.
  static const doneLinger = Duration(minutes: 5);

  /// Bloco novo acima disso é parseado fora da UI (primeira leitura de um
  /// transcript grande).
  static const _isolateOver = 256 * 1024;

  final String _root;
  final _tails = <String, TranscriptTail>{};
  final _meta = <String, Map<String, dynamic>>{};

  @override
  Future<List<FarmLoop>> scan(DateTime now) async {
    final root = Directory(_root);
    if (!await root.exists()) return const [];
    final loops = <FarmLoop>[];
    final live = <String>{};

    await for (final dir in root.list(followLinks: false)) {
      if (dir is! Directory) continue;
      await for (final f in dir.list(followLinks: false)) {
        if (f is! File || !f.path.endsWith('.jsonl')) continue;
        final main = await _read(f, now, isSubagent: false);
        if (main == null) continue;
        live.add(f.path);
        final sid = p.basenameWithoutExtension(f.path);
        final project = main.cwd ?? p.basename(dir.path);
        loops.add(_loop(main, id: sid, project: project, now: now));

        final subs = Directory(p.join(dir.path, sid, 'subagents'));
        if (!await subs.exists()) continue;
        await for (final s in subs.list(followLinks: false)) {
          final name = p.basename(s.path);
          if (s is! File ||
              !name.startsWith('agent-') ||
              !name.endsWith('.jsonl')) {
            continue;
          }
          final tail = await _read(s, now, isSubagent: true);
          if (tail == null) continue;
          live.add(s.path);
          final meta = await _metaOf(s.path);
          final loop = _loop(
            tail,
            id: p.basenameWithoutExtension(name).substring('agent-'.length),
            parentId: sid,
            project: tail.cwd ?? project,
            now: now,
            agentType: meta['agentType'] as String?,
            title: (meta['name'] ?? meta['description']) as String?,
          );
          if (loop.activity == FarmActivity.done &&
              now.difference(loop.lastSeen) > doneLinger) {
            continue;
          }
          loops.add(loop);
        }
      }
    }
    _tails.removeWhere((path, _) => !live.contains(path));
    _meta.removeWhere((path, _) => !live.contains(path));
    return loops;
  }

  Future<TranscriptTail?> _read(
    File f,
    DateTime now, {
    required bool isSubagent,
  }) async {
    final FileStat stat;
    try {
      stat = await f.stat();
    } on FileSystemException {
      return null;
    }
    if (now.difference(stat.modified) > window) return null;
    var tail = _tails[f.path];
    // Arquivo novo ou truncado (sessão reescrita): recomeça do zero.
    if (tail == null || stat.size < tail.offset) {
      tail = _tails[f.path] = TranscriptTail(isSubagent: isSubagent);
    }
    if (stat.size == tail.offset) return tail;

    final Uint8List bytes;
    try {
      final raf = await f.open();
      try {
        await raf.setPosition(tail.offset);
        bytes = await raf.read(stat.size - tail.offset);
      } finally {
        await raf.close();
      }
    } on FileSystemException {
      return tail;
    }
    if (bytes.length > _isolateOver) {
      final seed = tail;
      tail = _tails[f.path] = await Isolate.run(() => _consumed(seed, bytes));
    } else {
      tail.consume(bytes);
    }
    return tail;
  }

  Future<Map<String, dynamic>> _metaOf(String jsonlPath) async {
    final cached = _meta[jsonlPath];
    if (cached != null) return cached;
    final metaPath =
        '${jsonlPath.substring(0, jsonlPath.length - 6)}.meta.json';
    var meta = const <String, dynamic>{};
    try {
      final decoded = jsonDecode(await File(metaPath).readAsString());
      if (decoded is Map<String, dynamic>) meta = decoded;
    } on Object {
      // Sem meta (versão antiga do Claude Code): só o transcript.
    }
    return _meta[jsonlPath] = meta;
  }

  FarmLoop _loop(
    TranscriptTail t, {
    required String id,
    required String project,
    required DateTime now,
    String? parentId,
    String? agentType,
    String? title,
  }) {
    final lastSeen = t.lastTs ?? now;
    var activity = t.activity;
    if (parentId != null && activity == FarmActivity.idle) {
      activity = FarmActivity.done;
    } else if (now.difference(lastSeen) > sleepAfter) {
      activity = FarmActivity.sleeping;
    }
    return FarmLoop(
      id: id,
      parentId: parentId,
      harness: 'claude',
      project: project,
      title: title ?? t.title ?? _short(t.firstPrompt) ?? p.basename(project),
      agentType: agentType,
      activity: activity,
      tool: t.tool,
      outputTokens: t.totalOutputTokens,
      contextTokens: t.contextTokens,
      lastSeen: lastSeen,
    );
  }
}

TranscriptTail _consumed(TranscriptTail t, Uint8List bytes) {
  t.consume(bytes);
  return t;
}

String? _short(String? s) {
  if (s == null || s.isEmpty) return null;
  final line = s.split('\n').first;
  return line.length <= 48 ? line : '${line.substring(0, 47)}…';
}
