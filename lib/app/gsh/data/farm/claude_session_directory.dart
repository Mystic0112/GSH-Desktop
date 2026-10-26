import 'dart:convert';
import 'dart:io';

import 'package:gsh_desktop/app/gsh/domain/contracts/session_directory.dart';
import 'package:path/path.dart' as p;

/// [SessionDirectory] sobre `~/.claude/projects/*/<sid>.jsonl`: o título é o
/// último `custom-title` (ou `agent-name`), senão a primeira mensagem do
/// usuário; a pasta vem do `cwd`. Lê o arquivo inteiro, mas só quando o
/// usuário abre o seletor — não é polling.
class ClaudeSessionDirectory implements SessionDirectory {
  ClaudeSessionDirectory({String? root})
    : _root =
          root ??
          p.join(
            Platform.environment['HOME'] ??
                Platform.environment['USERPROFILE'] ??
                '',
            '.claude',
            'projects',
          );

  final String _root;

  @override
  Future<List<SessionEntry>> recent({
    Duration within = const Duration(hours: 24),
  }) async {
    final root = Directory(_root);
    if (!await root.exists()) return const [];
    final now = DateTime.now();
    final out = <SessionEntry>[];
    await for (final dir in root.list(followLinks: false)) {
      if (dir is! Directory) continue;
      await for (final f in dir.list(followLinks: false)) {
        if (f is! File || !f.path.endsWith('.jsonl')) continue;
        final FileStat stat;
        try {
          stat = await f.stat();
        } on FileSystemException {
          continue;
        }
        if (now.difference(stat.modified) > within) continue;
        final entry = await _read(f, stat.modified);
        if (entry != null) out.add(entry);
      }
    }
    out.sort((a, b) => b.lastSeen.compareTo(a.lastSeen));
    return out;
  }

  /// Começo (pasta, primeiro pedido) e fim (o título mais novo: o Claude
  /// Code regrava `custom-title`/`ai-title` ao longo da conversa) do
  /// transcript — ler inteiro levava segundos com conversas de dezenas de MB.
  static const _head = 64 * 1024, _tail = 512 * 1024;

  Future<SessionEntry?> _read(File f, DateTime modified) async {
    String? custom, agent, ai, firstPrompt, cwd;
    void scan(String line) {
      final Object? o;
      try {
        o = jsonDecode(line);
      } on FormatException {
        return; // linha cortada na borda do pedaço lido
      }
      if (o is! Map) return;
      cwd ??= o['cwd'] as String?;
      switch (o['type']) {
        case 'custom-title':
          custom = _str(o['customTitle']) ?? custom;
        case 'agent-name':
          agent ??= _str(o['agentName']);
        case 'ai-title':
          ai = _str(o['aiTitle']) ?? ai;
        case 'user' when firstPrompt == null && o['isMeta'] != true:
          final c = (o['message'] as Map?)?['content'];
          if (c is String && !c.startsWith('<')) firstPrompt = c;
      }
    }

    try {
      final raf = await f.open();
      try {
        final len = await raf.length();
        final head = await raf.read(len < _head ? len : _head);
        const LineSplitter()
            .convert(utf8.decode(head, allowMalformed: true))
            .forEach(scan);
        if (len > _head) {
          final from = len - _tail > _head ? len - _tail : _head;
          await raf.setPosition(from);
          final tail = await raf.read(len - from);
          const LineSplitter()
              .convert(utf8.decode(tail, allowMalformed: true))
              .forEach(scan);
        }
      } finally {
        await raf.close();
      }
    } on FileSystemException {
      return null;
    }
    final label = custom ?? agent ?? ai ?? _short(firstPrompt);
    if (label == null) return null;
    final project = cwd;
    // Conversas de teste/rascunho em pasta temporária só poluem a lista.
    if (project != null && p.isWithin(Directory.systemTemp.path, project)) {
      return null;
    }
    return SessionEntry(
      id: p.basenameWithoutExtension(f.path),
      title: label,
      project: project ?? p.basename(f.parent.path),
      lastSeen: modified,
      harness: 'claude',
    );
  }

  static String? _str(Object? v) =>
      v is String && v.trim().isNotEmpty ? v.trim() : null;

  static String? _short(String? s) {
    if (s == null || s.trim().isEmpty) return null;
    final line = s.trim().split('\n').first;
    return line.length <= 48 ? line : '${line.substring(0, 47)}…';
  }
}
