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

  Future<SessionEntry?> _read(File f, DateTime modified) async {
    String? title;
    String? firstPrompt;
    String? cwd;
    try {
      await for (final line
          in f
              .openRead()
              .transform(utf8.decoder)
              .transform(const LineSplitter())) {
        // Filtro barato antes do JSON: a maioria das linhas não interessa.
        final wantsTitle =
            line.contains('"custom-title"') || line.contains('"agent-name"');
        if (!wantsTitle && firstPrompt != null && cwd != null) continue;
        final Object? o;
        try {
          o = jsonDecode(line);
        } on FormatException {
          continue;
        }
        if (o is! Map) continue;
        cwd ??= o['cwd'] as String?;
        switch (o['type']) {
          case 'custom-title':
            title = _str(o['customTitle']) ?? title;
          case 'agent-name':
            title ??= _str(o['agentName']);
          case 'user' when firstPrompt == null && o['isMeta'] != true:
            final c = (o['message'] as Map?)?['content'];
            if (c is String && !c.startsWith('<')) firstPrompt = c;
        }
      }
    } on FileSystemException {
      return null;
    }
    final label = title ?? _short(firstPrompt);
    if (label == null) return null;
    return SessionEntry(
      id: p.basenameWithoutExtension(f.path),
      title: label,
      project: cwd ?? p.basename(f.parent.path),
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
