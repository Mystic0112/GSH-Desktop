import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:gsh_desktop/app/gsh/data/farm/farm_hook_status.dart';
import 'package:gsh_desktop/app/gsh/data/farm/farm_scan_cache.dart';
import 'package:gsh_desktop/app/gsh/data/farm/transcript_tail.dart';
import 'package:gsh_desktop/app/gsh/domain/contracts/farm_source.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/farm_loop.dart';
import 'package:path/path.dart' as p;

/// Loops do Claude Code lidos dos transcripts em `~/.claude/projects`.
///
/// Lê o arquivo, não o hook: pega toda sessão da máquina (aba do GSH, outro
/// terminal, `claude -p`, subagentes em `<sid>/subagents/`), e não depende de
/// qual versão da CLI `gsh` está em `~/.gsh/bin`.
///
/// Polling: a listagem das pastas sai do [FarmScanCache] (a cada 15 s ou
/// quando uma pasta ativa muda); entre listagens só os transcripts recentes
/// levam `stat`. ponytail: se a pasta crescer para milhares, trocar por
/// watcher (inotify) só nos projetos ativos.
///
/// Pedido de permissão não aparece no transcript. Ele vem do hook: o
/// `gsh hook` grava o último status de cada sessão em
/// `~/.gsh/farm/<sid>.json` ([statusDir]), e um `waiting` mais novo que a
/// última linha do transcript vira [FarmActivity.waiting]. Sem a CLI do GSH
/// em `~/.gsh/bin` (o GSH original materializa a dele por cima), a
/// pasta não é escrita e o loop segue lendo como a ferramenta pendente.
class ClaudeTranscriptFarmSource implements FarmSource {
  ClaudeTranscriptFarmSource({String? root, String? statusDir})
    : _root = root ?? p.join(_home, '.claude', 'projects'),
      _hook = FarmHookStatus(dir: statusDir);

  static String get _home =>
      Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'] ?? '';

  final FarmHookStatus _hook;

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

  /// Transcripts principais da última listagem completa, os que estavam na
  /// janela na última varredura (os únicos olhados entre listagens) e os
  /// subagentes de cada um.
  List<File> _mains = const [];
  Set<String> _recent = const {};
  final _subs = <String, List<File>>{};
  final _cache = FarmScanCache();

  @override
  Future<List<FarmLoop>> scan(DateTime now) async {
    final root = Directory(_root);
    if (!await root.exists()) return const [];
    final loops = <FarmLoop>[];
    final live = <String>{};
    final full = await _cache.due(now);
    if (full) {
      _mains = [
        await for (final dir in root.list(followLinks: false))
          if (dir is Directory)
            await for (final f in dir.list(followLinks: false))
              if (f is File && f.path.endsWith('.jsonl')) f,
      ];
      _subs.clear();
    }
    final recent = <File>[];

    for (final f
        in full ? _mains : _mains.where((f) => _recent.contains(f.path))) {
      final main = await _read(f, now, isSubagent: false);
      if (main == null) continue;
      live.add(f.path);
      recent.add(f);
      final sid = p.basenameWithoutExtension(f.path);
      final project = main.cwd ?? p.basename(f.parent.path);
      loops.add(
        _loop(
          main,
          id: sid,
          project: project,
          now: now,
          waitingAt: await _hook.waitingAt(sid),
        ),
      );

      for (final s in _subs[f.path] ??= await _listSubs(_subsDir(f))) {
        final tail = await _read(s, now, isSubagent: true);
        if (tail == null) continue;
        live.add(s.path);
        final meta = await _metaOf(s.path);
        final loop = _loop(
          tail,
          id: p.basenameWithoutExtension(s.path).substring('agent-'.length),
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
    _recent = {for (final f in recent) f.path};
    // Sessão nova numa pasta ativa, ou subagente novo de uma sessão ativa,
    // muda o mtime de uma destas e força a próxima listagem.
    if (full) {
      await _cache.watch([
        _root,
        for (final f in recent) ...[f.parent.path, _subsDir(f)],
      ]);
    }
    await _hook.sweep(now);
    _tails.removeWhere((path, _) => !live.contains(path));
    _meta.removeWhere((path, _) => !live.contains(path));
    return loops;
  }

  static String _subsDir(File main) => p.join(
    main.parent.path,
    p.basenameWithoutExtension(main.path),
    'subagents',
  );

  static Future<List<File>> _listSubs(String dir) async {
    final d = Directory(dir);
    if (!await d.exists()) return const [];
    return [
      await for (final s in d.list(followLinks: false))
        if (s is File &&
            p.basename(s.path).startsWith('agent-') &&
            s.path.endsWith('.jsonl'))
          s,
    ];
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
    DateTime? waitingAt,
  }) {
    var lastSeen = t.lastTs ?? now;
    var activity = t.activity;
    // O hook disse "esperando" depois da última linha do transcript: nada
    // aconteceu desde o pedido, então o loop está parado esperando alguém.
    if (waitingAt != null && !waitingAt.isBefore(lastSeen)) {
      activity = FarmActivity.waiting;
      lastSeen = waitingAt;
    } else if (parentId != null && activity == FarmActivity.idle) {
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
      inputTokens: t.totalInputTokens,
      cacheReadTokens: t.totalCacheReadTokens,
      contextWindow: claudeContextWindow(t.model),
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
