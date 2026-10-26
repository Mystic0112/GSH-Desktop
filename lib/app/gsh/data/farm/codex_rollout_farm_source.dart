import 'dart:math';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:gsh_desktop/app/gsh/data/farm/farm_hook_status.dart';
import 'package:gsh_desktop/app/gsh/data/farm/farm_scan_cache.dart';
import 'package:gsh_desktop/app/gsh/domain/contracts/farm_source.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/farm_loop.dart';
import 'package:path/path.dart' as p;

/// Loops do **Codex CLI** lidos dos rollouts em
/// `~/.codex/sessions/AAAA/MM/DD/rollout-*.jsonl` (formato do Codex 0.16x:
/// `session_meta`, `turn_context`, `event_msg`, `response_item`,
/// `token_count`). Sem subagentes: cada rollout é um loop.
///
/// Mesma estratégia da fonte do Claude: listagem pelo [FarmScanCache], `stat`
/// só nos rollouts recentes entre listagens.
class CodexRolloutFarmSource implements FarmSource {
  CodexRolloutFarmSource({String? root, FarmHookStatus? hookStatus})
    : _root =
          root ??
          p.join(
            Platform.environment['HOME'] ??
                Platform.environment['USERPROFILE'] ??
                '',
            '.codex',
            'sessions',
          ),
      _hook = hookStatus ?? FarmHookStatus();

  static const window = Duration(minutes: 30);
  static const sleepAfter = Duration(minutes: 10);

  final String _root;
  final FarmHookStatus _hook;
  final _tails = <String, CodexTail>{};

  /// Rollouts da última listagem completa; entre listagens só os que estão
  /// em [_tails] (os recentes) levam `stat`.
  List<File> _files = const [];
  final _cache = FarmScanCache();

  @override
  Future<List<FarmLoop>> scan(DateTime now) async {
    final root = Directory(_root);
    if (!await root.exists()) return const [];
    final loops = <FarmLoop>[];
    final live = <String>{};
    final full = await _cache.due(now);
    if (full) {
      _files = [
        await for (final f in root.list(recursive: true, followLinks: false))
          if (f is File &&
              p.basename(f.path).startsWith('rollout-') &&
              f.path.endsWith('.jsonl'))
            f,
      ];
    }
    // Só os últimos dias: um rollout mais velho que a janela não interessa.
    for (final f
        in full ? _files : _files.where((f) => _tails.containsKey(f.path))) {
      final name = p.basename(f.path);
      final FileStat stat;
      try {
        stat = await f.stat();
      } on FileSystemException {
        continue;
      }
      if (now.difference(stat.modified) > window) continue;
      var tail = _tails[f.path];
      if (tail == null || stat.size < tail.offset) {
        tail = _tails[f.path] = CodexTail();
      }
      if (stat.size > tail.offset) {
        try {
          final raf = await f.open();
          try {
            await raf.setPosition(tail.offset);
            tail.consume(await raf.read(stat.size - tail.offset));
          } finally {
            await raf.close();
          }
        } on FileSystemException {
          continue;
        }
      }
      final sid = tail.sessionId ?? _sidFromName(name);
      if (sid == null) continue;
      live.add(f.path);
      var lastSeen = tail.lastTs ?? stat.modified;
      var activity = tail.activity;
      final waitingAt = await _hook.waitingAt(sid);
      if (waitingAt != null && !waitingAt.isBefore(lastSeen)) {
        activity = FarmActivity.waiting;
        lastSeen = waitingAt;
      } else if (now.difference(lastSeen) > sleepAfter) {
        activity = FarmActivity.sleeping;
      }
      final project = tail.cwd ?? p.dirname(f.path);
      loops.add(
        FarmLoop(
          id: sid,
          harness: 'codex',
          project: project,
          title: tail.title ?? p.basename(project),
          activity: activity,
          tool: tail.tool,
          outputTokens: tail.outputTokens,
          contextTokens: tail.contextTokens,
          inputTokens: tail.inputTokens,
          cacheReadTokens: tail.cacheReadTokens,
          contextWindow: tail.contextWindow,
          lastSeen: lastSeen,
        ),
      );
    }
    _tails.removeWhere((path, _) => !live.contains(path));
    // Rollout novo cai na pasta do dia (ou cria a do dia/mês): vigia a raiz
    // e as pastas acima dos rollouts recentes.
    if (full) {
      await _cache.watch([
        _root,
        for (final path in live)
          for (var d = p.dirname(path); p.isWithin(_root, d); d = p.dirname(d))
            d,
      ]);
    }
    return loops;
  }

  /// `rollout-2026-10-15T18-52-44-<uuid>.jsonl` → `<uuid>`.
  static String? _sidFromName(String name) {
    final m = RegExp(r'rollout-.*?-([0-9a-f-]{36})\.jsonl$').firstMatch(name);
    return m?.group(1);
  }
}

/// Estado incremental de um rollout do Codex.
class CodexTail {
  int offset = 0;
  String? sessionId;
  String? cwd;
  String? title;
  FarmActivity activity = FarmActivity.idle;
  String? tool;
  int outputTokens = 0;
  int contextTokens = 0;
  int contextWindow = 0;
  int inputTokens = 0;
  int cacheReadTokens = 0;
  DateTime? lastTs;

  void consume(Uint8List bytes) {
    final end = bytes.lastIndexOf(0x0A);
    if (end < 0) return;
    final text = utf8.decode(bytes.sublist(0, end + 1), allowMalformed: true);
    offset += end + 1;
    for (final line in const LineSplitter().convert(text)) {
      if (line.isEmpty) continue;
      final Object? o;
      try {
        o = jsonDecode(line);
      } on FormatException {
        continue;
      }
      if (o is Map<String, dynamic>) apply(o);
    }
  }

  void apply(Map<String, dynamic> o) {
    final payload = o['payload'];
    final pl = payload is Map ? payload : const <String, dynamic>{};
    final ts = DateTime.tryParse(o['timestamp'] as String? ?? '');
    switch (o['type']) {
      case 'session_meta':
        sessionId = pl['session_id'] as String? ?? sessionId;
        cwd = pl['cwd'] as String? ?? cwd;
      case 'turn_context':
        cwd = pl['cwd'] as String? ?? cwd;
      case 'event_msg':
        _touch(ts);
        switch (pl['type']) {
          case 'task_started':
            activity = FarmActivity.thinking;
            tool = null;
          case 'task_complete' || 'turn_aborted':
            activity = FarmActivity.idle;
            tool = null;
          case 'item_completed':
            final item = pl['item'];
            if (item is Map) {
              if (item['type'] == 'UserMessage') title ??= _userText(item);
              if (item['type'] == 'AgentMessage') activity = FarmActivity.idle;
            }
          case 'token_count':
            final info = pl['info'] as Map?;
            final total = info?['total_token_usage'];
            // o contexto é o do último turno (o `input_tokens` já inclui o
            // cache), contra a janela que o próprio Codex declara
            final last = info?['last_token_usage'];
            if (last is Map && _int(last['input_tokens']) > 0) {
              contextTokens = _int(last['input_tokens']);
            }
            contextWindow = _int(info?['model_context_window']);
            if (total is Map) {
              outputTokens = _int(total['output_tokens']);
              // Total acumulado; o `input_tokens` do Codex já inclui o cache.
              cacheReadTokens = _int(total['cached_input_tokens']);
              inputTokens = max(
                0,
                _int(total['input_tokens']) - cacheReadTokens,
              );
            }
        }
      case 'response_item':
        _touch(ts);
        switch (pl['type']) {
          case 'custom_tool_call' || 'function_call' || 'local_shell_call':
            tool = pl['name'] as String? ?? (pl['type'] as String?);
            activity = switch (tool) {
              'exec' || 'shell' || 'local_shell_call' => FarmActivity.running,
              'apply_patch' => FarmActivity.editing,
              'wait' => FarmActivity.thinking,
              _ => FarmActivity.tooling,
            };
          case 'custom_tool_call_output' ||
              'function_call_output' ||
              'local_shell_call_output':
            activity = FarmActivity.thinking;
            tool = null;
          case 'reasoning':
            activity = FarmActivity.thinking;
            tool = null;
        }
    }
  }

  void _touch(DateTime? ts) {
    if (ts != null && (lastTs == null || ts.isAfter(lastTs!))) lastTs = ts;
  }

  static String? _userText(Map item) {
    final content = item['content'];
    if (content is! List) return null;
    final text = content
        .whereType<Map>()
        .map((c) => c['text'])
        .whereType<String>()
        .join(' ')
        .trim();
    if (text.isEmpty) return null;
    final line = text.split('\n').first;
    return line.length <= 48 ? line : '${line.substring(0, 47)}…';
  }

  static int _int(Object? v) => v is int ? v : (v is num ? v.toInt() : 0);
}
