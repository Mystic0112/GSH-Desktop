import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:gsh_desktop/app/gsh/domain/contracts/chat_engine.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/chat_attachment.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/chat_event.dart';
import 'package:gsh_desktop/app/core/domain/contracts/claude_code_settings.dart';
import 'package:gsh_desktop/app/core/utils/executable_resolver.dart';

/// Claude Code como motor de chat: `claude -p` com entrada e saída em
/// `stream-json`, e os pedidos de permissão respondidos por nós
/// (`--permission-prompts host`), via `control_request`/`control_response`
/// no mesmo stdin/stdout — o mesmo protocolo que o Agent SDK usa.
///
/// Roda com a assinatura/login de quem usa o GSH: nenhuma chave de API passa
/// por aqui.
class ClaudeStreamEngineFactory implements ChatEngineFactory {
  const ClaudeStreamEngineFactory(this._settings);

  final ClaudeCodeSettings _settings;

  @override
  Future<ChatEngine> start({
    required String cwd,
    String? resumeSessionId,
    bool showThinking = false,
  }) async {
    final exe = await resolveExecutable('claude');
    // Sem escolha explícita em ~/.claude/settings.json, o Claude Code segura a
    // mensagem de outra sessão quando os modos de permissão diferem — e no
    // modo headless ela expira sem ninguém ver. O chat do GSH entrega por
    // padrão: a sessão continua pedindo permissão para o que o peer pedir.
    final inbound = await _settings.getValue(
      ClaudeCodeKeys.crossSessionInbound,
    );
    final acceptPeers = inbound == null;
    final proc = await Process.start(
      exe,
      [
        '-p',
        '--input-format',
        'stream-json',
        '--output-format',
        'stream-json',
        '--verbose',
        '--permission-prompts',
        'host',
        '--permission-prompt-tool',
        'stdio',
        '--include-partial-messages',
        // Ecoa os turnos de usuário: é o único jeito de ver as mensagens que
        // outras sessões injetam (SendMessage entre sessões).
        '--replay-user-messages',
        if (acceptPeers) ...[
          '--settings',
          '{"${ClaudeCodeKeys.crossSessionInbound}":"accept"}',
        ],
        // Só deixa "Ignorar permissões" disponível no seletor de modo; a
        // sessão continua começando em `default` (pedindo permissão).
        '--allow-dangerously-skip-permissions',
        // Resumos de raciocínio (`thinking` com texto). Sem a flag o CLI
        // manda o bloco vazio.
        if (showThinking) ...['--thinking-display', 'summarized'],
        if (resumeSessionId != null) ...['--resume', resumeSessionId],
      ],
      workingDirectory: cwd,
      environment: _withDirOnPath(exe),
    );
    return ClaudeStreamEngine(proc);
  }

  /// Lê o transcript que o próprio Claude Code grava em
  /// `~/.claude/projects/<cwd com não-alfanuméricos trocados por ->/<id>.jsonl`.
  /// As linhas `user`/`assistant` têm o mesmo formato do stream.
  @override
  Future<List<ChatEvent>> history({
    required String cwd,
    required String sessionId,
  }) async {
    final home =
        Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'];
    if (home == null || !RegExp(r'^[A-Za-z0-9-]+$').hasMatch(sessionId)) {
      return const [];
    }
    final dir = cwd.replaceAll(RegExp('[^A-Za-z0-9]'), '-');
    final file = File('$home/.claude/projects/$dir/$sessionId.jsonl');
    if (!await file.exists()) return const [];
    final out = <ChatEvent>[];
    for (final line in await file.readAsLines()) {
      final Object? o;
      try {
        o = jsonDecode(line);
      } on FormatException {
        continue;
      }
      if (o is! Map<String, dynamic> || o['isSidechain'] == true) continue;
      if (o['type'] == 'user' && o['isMeta'] != true) {
        final content = (o['message'] as Map?)?['content'];
        if (content is String && !content.startsWith('<')) {
          out.add(ChatUserText(content));
          continue;
        }
      }
      if (o['type'] == 'user' || o['type'] == 'assistant') {
        out.addAll(parseClaudeStreamLine(o));
      }
    }
    return out;
  }
}

/// O `claude` do npm é um script `#!/usr/bin/env node`. Aberto pelo launcher
/// (sem o PATH do shell, ex.: nvm), o `env` não acha o `node`: põe a pasta do
/// executável — onde o nvm/npm deixa os dois — na frente do PATH.
Map<String, String> _withDirOnPath(String exe) {
  final sep = Platform.isWindows ? ';' : ':';
  final dir = File(exe).parent.path;
  final path = Platform.environment['PATH'] ?? '';
  return {'PATH': path.isEmpty ? dir : '$dir$sep$path'};
}

class ClaudeStreamEngine implements ChatEngine {
  ClaudeStreamEngine(this._proc) {
    _proc.stdout
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen(_onLine, onDone: _onDone);
    _proc.stderr.transform(utf8.decoder).transform(const LineSplitter()).listen(
      (l) {
        _stderr.add(l);
        if (_stderr.length > 20) _stderr.removeAt(0);
      },
    );
  }

  final Process _proc;
  final _events = StreamController<ChatEvent>.broadcast();
  final _stderr = <String>[];

  /// Por pedido: o input da ferramenta (`allow` devolve em `updatedInput`) e a
  /// sugestão `addRules` que "sempre permitir" manda em `updatedPermissions`.
  final _asked = <String, (Map<String, dynamic>, Map<String, dynamic>?)>{};
  var _closed = false;
  var _seq = 0;

  @override
  Stream<ChatEvent> get events => _events.stream;

  void _onLine(String line) {
    if (line.trim().isEmpty) return;
    final Object? o;
    try {
      o = jsonDecode(line);
    } on FormatException {
      return;
    }
    if (o is! Map<String, dynamic>) return;
    for (final e in parseClaudeStreamLine(o)) {
      if (e is ChatPermissionAsk) {
        _asked[e.requestId] = (e.input, _addRules(o['request']));
      }
      _events.add(e);
    }
  }

  Future<void> _onDone() async {
    final code = await _proc.exitCode;
    if (!_closed) {
      _events.add(ChatEngineFailed(exitCode: code, stderr: _stderr.join('\n')));
    }
    await _events.close();
  }

  void _write(Map<String, dynamic> msg) {
    if (_closed) return;
    _proc.stdin.writeln(jsonEncode(msg));
  }

  @override
  Future<void> send(
    String text, {
    List<ChatAttachment> attachments = const [],
  }) async {
    _write({
      'type': 'user',
      'message': {
        'role': 'user',
        'content': await buildClaudeUserContent(text, attachments),
      },
    });
  }

  @override
  void answerPermission(
    String requestId, {
    required bool allow,
    bool always = false,
    Map<String, dynamic>? input,
    String? message,
  }) {
    final (asked, rule) =
        _asked.remove(requestId) ?? (const <String, dynamic>{}, null);
    _write({
      'type': 'control_response',
      'response': {
        'subtype': 'success',
        'request_id': requestId,
        'response': allow
            ? {
                'behavior': 'allow',
                'updatedInput': input ?? asked,
                if (always && rule != null) 'updatedPermissions': [rule],
              }
            : {
                'behavior': 'deny',
                'message': message ?? 'Negado pelo usuário no GSH',
              },
      },
    });
  }

  @override
  void setPermissionMode(String mode) => _write({
    'type': 'control_request',
    'request_id': 'gsh-${++_seq}',
    'request': {'subtype': 'set_permission_mode', 'mode': mode},
  });

  @override
  void interrupt() => _write({
    'type': 'control_request',
    'request_id': 'gsh-${++_seq}',
    'request': {'subtype': 'interrupt'},
  });

  @override
  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    await _proc.stdin.close();
    _proc.kill();
  }
}

/// Conteúdo da mensagem do usuário. Sem anexo, só o texto. Com anexo: imagem
/// vira bloco `image` (base64), PDF vira `document`, e o resto vira menção
/// `@"caminho"` no texto, que o próprio Claude Code expande lendo o arquivo.
Future<Object> buildClaudeUserContent(
  String text,
  List<ChatAttachment> attachments,
) async {
  if (attachments.isEmpty) return text;
  final mentions = [
    for (final a in attachments)
      if (a.kind == ChatAttachmentKind.file && a.path != null) '@"${a.path}"',
  ];
  final blocks = <Map<String, dynamic>>[
    {
      'type': 'text',
      'text': mentions.isEmpty ? text : '$text\n\n${mentions.join(' ')}',
    },
  ];
  for (final a in attachments) {
    if (a.kind == ChatAttachmentKind.file) continue;
    final bytes = a.bytes ?? await File(a.path!).readAsBytes();
    final max = a.kind == ChatAttachmentKind.image
        ? ChatAttachment.maxImageBytes
        : ChatAttachment.maxPdfBytes;
    if (bytes.length > max) throw ChatAttachmentTooLarge(a.name);
    blocks.add({
      'type': a.kind == ChatAttachmentKind.image ? 'image' : 'document',
      'source': {
        'type': 'base64',
        'media_type': a.mediaType,
        'data': base64Encode(bytes),
      },
    });
  }
  return blocks;
}

/// Traduz uma linha do `stream-json` do Claude Code em eventos. Tipos que a
/// conversa não mostra (hooks, rate limit, resumos) viram lista vazia.
List<ChatEvent> parseClaudeStreamLine(Map<String, dynamic> o) {
  switch (o['type']) {
    case 'system' when o['subtype'] == 'init':
      return [
        ChatReady(
          sessionId: o['session_id'] as String? ?? '',
          model: o['model'] as String? ?? '',
          permissionMode: o['permissionMode'] as String?,
        ),
      ];
    case 'system' when o['subtype'] == 'post_turn_summary':
      final state = switch (o['status_category']) {
        'completed' => ChatSessionState.completed,
        'review_ready' => ChatSessionState.reviewReady,
        // `need_input` é como o remoto renomeia o `blocked`.
        'blocked' || 'need_input' => ChatSessionState.blocked,
        'failed' => ChatSessionState.failed,
        _ => null,
      };
      if (state == null) return const [];
      return [
        ChatSessionClassified(
          state,
          detail: (o['status_detail'] as String? ?? '').trim(),
        ),
      ];
    case 'system' when o['subtype'] == 'informational':
      final text = o['content'] as String? ?? '';
      return text.isEmpty
          ? const []
          : [ChatInfo(text, warning: o['level'] == 'warning')];
    case 'system' when o['subtype'] == 'status':
      final mode = o['permissionMode'];
      return mode is String ? [ChatModeChanged(mode)] : const [];
    case 'assistant':
      final content = (o['message'] as Map?)?['content'];
      if (content is! List) return const [];
      return [
        for (final c in content.whereType<Map>())
          if (c['type'] == 'text' && (c['text'] as String? ?? '').isNotEmpty)
            ChatText(c['text'] as String)
          else if (c['type'] == 'thinking' &&
              (c['thinking'] as String? ?? '').trim().isNotEmpty)
            ChatThinking(c['thinking'] as String)
          else if (c['type'] == 'tool_use')
            ChatToolCall(
              id: c['id'] as String? ?? '',
              name: c['name'] as String? ?? '',
              input: (c['input'] as Map?)?.cast<String, dynamic>() ?? const {},
            ),
      ];
    case 'user':
      final content = (o['message'] as Map?)?['content'];
      if (o['isReplay'] == true) {
        // Eco do que nós mesmos mandamos: ignora. Só interessa o turno que
        // outra sessão injetou (origin.kind == peer).
        final origin = o['origin'];
        if (origin is! Map || origin['kind'] != 'peer' || content is! String) {
          return const [];
        }
        return [
          ChatPeerMessage(
            fromName: origin['name'] as String? ?? '',
            from: origin['from'] as String? ?? '',
            text: peerMessageText(content),
          ),
        ];
      }
      if (content is! List) return const [];
      return [
        for (final c in content.whereType<Map>())
          if (c['type'] == 'tool_result')
            ChatToolResult(
              toolUseId: c['tool_use_id'] as String? ?? '',
              isError: c['is_error'] == true,
              text: _resultText(c['content']),
            ),
      ];
    case 'stream_event':
      final ev = o['event'];
      if (ev is! Map || ev['type'] != 'content_block_delta') return const [];
      final delta = ev['delta'];
      if (delta is! Map) return const [];
      if (delta['type'] == 'thinking_delta') {
        final text = delta['thinking'] as String? ?? '';
        return text.isEmpty ? const [] : [ChatThinkingDelta(text)];
      }
      if (delta['type'] != 'text_delta') return const [];
      final text = delta['text'] as String? ?? '';
      return text.isEmpty ? const [] : [ChatTextDelta(text)];
    case 'control_request':
      final req = o['request'];
      if (req is! Map || req['subtype'] != 'can_use_tool') return const [];
      return [
        ChatPermissionAsk(
          requestId: o['request_id'] as String? ?? '',
          toolName: req['tool_name'] as String? ?? '',
          input: (req['input'] as Map?)?.cast<String, dynamic>() ?? const {},
          description: req['description'] as String?,
          alwaysRule: _ruleLabel(_addRules(req)),
        ),
      ];
    case 'result':
      final cost = o['total_cost_usd'];
      return [
        ChatTurnEnd(
          isError: o['is_error'] == true,
          text: o['result'] as String? ?? '',
          sessionId: o['session_id'] as String? ?? '',
          costUsd: cost is num ? cost.toDouble() : null,
        ),
      ];
  }
  return const [];
}

/// A primeira sugestão `addRules` de um `can_use_tool` (o que o Claude Code
/// gravaria com "sempre permitir").
Map<String, dynamic>? _addRules(Object? req) {
  if (req is! Map) return null;
  final list = req['permission_suggestions'];
  if (list is! List) return null;
  for (final s in list) {
    if (s is Map && s['type'] == 'addRules' && s['behavior'] == 'allow') {
      return s.cast<String, dynamic>();
    }
  }
  return null;
}

/// `Bash(npm test *)`: a regra como o settings.json escreve.
String? _ruleLabel(Map<String, dynamic>? sugg) {
  final rules = sugg?['rules'];
  if (rules is! List || rules.isEmpty || rules.first is! Map) return null;
  final r = rules.first as Map;
  final tool = r['toolName'] as String? ?? '';
  final content = r['ruleContent'] as String?;
  return content == null || content.isEmpty ? tool : '$tool($content)';
}

/// O texto que a outra sessão escreveu, sem o envelope
/// `<cross-session-message …>…</cross-session-message>` nem o aviso que o
/// Claude Code acrescenta para o modelo.
String peerMessageText(String content) {
  final m = RegExp(
    r'<cross-session-message[^>]*>\s*([\s\S]*?)\s*</cross-session-message>',
  ).firstMatch(content);
  return (m?.group(1) ?? content).trim();
}

String _resultText(Object? content) {
  if (content is String) return content;
  if (content is List) {
    return content
        .whereType<Map>()
        .where((b) => b['type'] == 'text')
        .map((b) => b['text'])
        .join('\n');
  }
  return '';
}
