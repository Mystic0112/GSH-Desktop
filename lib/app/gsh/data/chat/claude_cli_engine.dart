import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:gsh_desktop/app/core/utils/executable_resolver.dart';
import 'package:gsh_desktop/app/gsh/data/chat/claude_stream_engine.dart';
import 'package:gsh_desktop/app/gsh/domain/contracts/chat_engine.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/chat_attachment.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/chat_event.dart';
import 'package:gsh_pty/gsh_pty.dart';

/// Claude Code **interativo** como motor de chat, para ter Remote Control (o
/// `stream-json` não liga). O `claude --remote-control` roda num PTY que
/// ninguém vê; o GSH só faz o papel do teclado e lê o resto por fora:
///
/// - **escreve** colando no terminal (texto, caminho de imagem → `[Image #n]`),
///   Enter envia, Esc interrompe, Shift+Tab troca o modo de permissão;
/// - **lê** a conversa do transcript que o próprio CLI grava (as linhas têm o
///   formato do stream, então o [parseClaudeStreamLine] serve);
/// - **permissão e perguntas** passam por um hook `PermissionRequest` que
///   deixa o pedido numa pasta temporária e espera a resposta do GSH — o
///   diálogo do TUI nem chega a aparecer.
///
/// Sem streaming letra a letra: o transcript grava por mensagem.
class ClaudeCliEngineFactory implements ChatEngineFactory {
  const ClaudeCliEngineFactory();

  @override
  Future<ChatEngine> start({
    required String cwd,
    String? resumeSessionId,
    bool showThinking = false,
  }) async {
    final exe = await resolveExecutable('claude');
    final sid = resumeSessionId ?? _uuidV4();
    final transcript = claudeTranscriptFile(cwd, sid);
    if (transcript == null) throw StateError('sessão inválida: $sid');
    final offset = await transcript.exists() ? await transcript.length() : 0;
    final asks = await Directory.systemTemp.createTemp('gsh-chat-');
    final settings = {
      'hooks': {
        'PermissionRequest': [
          {
            'matcher': '*',
            'hooks': [
              // O usuário pode demorar para responder: sem teto prático.
              {
                'type': 'command',
                'command': permissionHookCommand(asks.path),
                'timeout': 86400,
              },
            ],
          },
        ],
      },
    };
    // Herdadas de uma sessão do Claude Code que abriu o GSH: com elas o CLI
    // se acha sessão-filha e não grava o transcript.
    final strip = [
      for (final k in Platform.environment.keys)
        if (k.startsWith('CLAUDE_CODE_') || k == 'CLAUDECODE') ...['-u', k],
    ];
    final pty = Pty.start(
      '/usr/bin/env',
      arguments: [
        ...strip,
        exe,
        '--remote-control',
        if (resumeSessionId != null) ...[
          '--resume',
          sid,
        ] else ...[
          '--session-id',
          sid,
        ],
        '--settings',
        // Sem `--allow-dangerously-skip-permissions`: no interativo ela abre
        // um aviso de consentimento que não cabe ao GSH aceitar sozinho.
        jsonEncode(settings),
      ],
      workingDirectory: cwd,
      environment: claudeEnvWithDirOnPath(exe),
      rows: 50,
      columns: 160,
    );
    return ClaudeCliEngine(pty, sid, transcript, offset, asks);
  }

  @override
  Future<List<ChatEvent>> history({
    required String cwd,
    required String sessionId,
  }) => readClaudeHistory(cwd: cwd, sessionId: sessionId);
}

/// Comando do hook: grava o pedido (stdin) em `<id>.req` e espera o GSH
/// escrever `<id>.resp`. Pasta sumiu (GSH fechou o chat) = sai sem decidir, e
/// o CLI cai no diálogo normal (que o Remote Control mostra no celular).
String permissionHookCommand(String dir) =>
    "d='$dir'; [ -d \"\$d\" ] || exit 0; id=\"r\$(date +%s%N)\$\$\"; "
    'cat > "\$d/\$id.tmp" && mv "\$d/\$id.tmp" "\$d/\$id.req"; '
    'while [ ! -f "\$d/\$id.resp" ]; do [ -d "\$d" ] || exit 0; '
    'sleep 0.1; done; cat "\$d/\$id.resp"; rm -f "\$d/\$id.resp"';

class ClaudeCliEngine implements ChatEngine {
  ClaudeCliEngine(
    this._pty,
    this._sid,
    this._transcript,
    this._offset,
    this._asks,
  ) {
    _pty.output.listen(_onScreen);
    unawaited(_pty.exitCode.then(_onExit));
    _poll = Timer.periodic(const Duration(milliseconds: 250), (_) => _tick());
    // Depois do `listen` de quem pediu o motor (broadcast não guarda).
    Timer.run(() => _events.add(ChatReady(sessionId: _sid, model: '')));
  }

  final Pty _pty;
  final String _sid;
  final File _transcript;
  final Directory _asks;
  final _events = StreamController<ChatEvent>.broadcast();
  final _ready = Completer<void>();
  late final Timer _poll;

  int _offset;
  var _partial = '';
  var _screen = '';

  /// Diálogo de confiança na pasta: 0 não viu, 1 respondendo, 2 respondido.
  var _trust = 0;
  var _closed = false;
  var _ticking = false;
  var _model = '';
  String? _mode;
  String? _screenMode;
  var _bridgeShown = false;
  var _interrupting = false;

  /// Mensagens nossas ainda não vistas no transcript (a UI já as mostrou);
  /// as outras mensagens humanas vieram do celular/claude.ai.
  var _ownPending = 0;
  var _ownSeen = 0;
  final _asked = <String, (Map<String, dynamic>, Map<String, dynamic>?)>{};
  var _imgSeq = 0;

  @override
  Stream<ChatEvent> get events => _events.stream;

  // ---- tela do TUI: só para prontidão, confiança na pasta e modo ----------

  void _onScreen(Uint8List data) {
    final text = utf8
        .decode(data, allowMalformed: true)
        .replaceAll(
          RegExp(r'\x1b\[[0-9;?<>=]*[ -/]*[@-~]|\x1b\][^\x07]*\x07'),
          '',
        );
    _screen += text;
    if (_screen.length > 16000) _screen = _screen.substring(8000);
    final compact = _screen.replaceAll(RegExp(r'\s'), '').toLowerCase();
    // "Is this a project you trust?" vem com "No, exit" marcado. Abrir o
    // workspace no GSH já é a escolha do usuário (o `-p` nem pergunta).
    // Responder na hora não pega: o TUI ainda redesenha e volta para "No".
    if (_trust == 0 && compact.contains('itrustthisfolder')) {
      _trust = 1;
      Timer(const Duration(milliseconds: 1500), () {
        _write('\x1b[B');
        Timer(const Duration(milliseconds: 400), () {
          _screen = '';
          _trust = 2;
          _write('\r');
        });
      });
      return;
    }
    // Pronto = o rodapé do campo apareceu (o `❯` vira `>` sem fonte
    // Unicode, e o do diálogo de confiança não é o campo de mensagem).
    if (_trust != 1 &&
        !_ready.isCompleted &&
        (compact.contains('shift+tab') ||
            compact.contains('forshortcuts') ||
            compact.contains('modeon'))) {
      // O campo aparece antes de o TUI aceitar Enter: um respiro.
      Timer(const Duration(milliseconds: 1500), () {
        if (!_ready.isCompleted) _ready.complete();
      });
    }
    final tail = text.replaceAll(RegExp(r'\s'), '').toLowerCase();
    if (_interrupting && tail.contains('interrupted')) _endInterrupt();
    const modes = {
      'manualmodeon': 'default',
      'accepteditson': 'acceptEdits',
      'planmodeon': 'plan',
      'bypasspermissionson': 'bypassPermissions',
      'automodeon': 'auto',
    };
    var at = -1;
    for (final MapEntry(:key, :value) in modes.entries) {
      final i = tail.lastIndexOf(key);
      if (i > at) {
        at = i;
        _screenMode = value;
      }
    }
  }

  void _write(String s) {
    if (_closed) return;
    _pty.write(Uint8List.fromList(utf8.encode(s)));
  }

  Future<void> _paste(String s) async {
    _write('\x1b[200~$s\x1b[201~');
    await Future<void>.delayed(const Duration(milliseconds: 400));
  }

  // ---- transcript + pedidos do hook ---------------------------------------

  Future<void> _tick() async {
    if (_ticking || _closed) return;
    _ticking = true;
    try {
      await _readTranscript();
      await _readAsks();
    } on FileSystemException {
      // arquivo ainda não existe / sendo escrito: tenta no próximo tick
    } finally {
      _ticking = false;
    }
  }

  Future<void> _readTranscript() async {
    if (!await _transcript.exists()) return;
    final len = await _transcript.length();
    if (len <= _offset) return;
    final raf = await _transcript.open();
    try {
      await raf.setPosition(_offset);
      final bytes = await raf.read(len - _offset);
      _offset = len;
      final chunk = _partial + utf8.decode(bytes, allowMalformed: true);
      final lines = chunk.split('\n');
      _partial = lines.removeLast();
      for (final line in lines) {
        if (line.trim().isEmpty) continue;
        final Object? o;
        try {
          o = jsonDecode(line);
        } on FormatException {
          continue;
        }
        if (o is Map<String, dynamic>) _onLine(o);
      }
    } finally {
      await raf.close();
    }
  }

  void _onLine(Map<String, dynamic> o) {
    if (o['isSidechain'] == true) return;
    switch (o['type']) {
      case 'system' when o['subtype'] == 'bridge_status':
        final text = o['content'] as String? ?? '';
        if (!_bridgeShown && text.isNotEmpty) {
          _bridgeShown = true;
          _events.add(ChatInfo(text, warning: false));
        }
      case 'system' when o['subtype'] == 'turn_duration':
        _turnEnd();
      case 'permission-mode':
        final mode = o['permissionMode'];
        if (mode is String && mode != _mode) {
          _mode = mode;
          _events.add(ChatModeChanged(mode));
        }
      case 'user' when o['isMeta'] != true:
        _onUser(o);
      case 'assistant':
        final model = (o['message'] as Map?)?['model'];
        if (model is String && model.isNotEmpty && model != _model) {
          _model = model;
          _events.add(ChatReady(sessionId: _sid, model: model));
        }
        parseClaudeStreamLine(o).forEach(_events.add);
    }
  }

  void _onUser(Map<String, dynamic> o) {
    final content = (o['message'] as Map?)?['content'];
    final origin = o['origin'];
    if (origin is Map && origin['kind'] == 'peer' && content is String) {
      _events.add(
        ChatPeerMessage(
          fromName: origin['name'] as String? ?? '',
          from: origin['from'] as String? ?? '',
          text: peerMessageText(content),
        ),
      );
      return;
    }
    final text = switch (content) {
      String s => s,
      List l =>
        l
            .whereType<Map>()
            .where((b) => b['type'] == 'text')
            .map((b) => b['text'] as String? ?? '')
            .join('\n'),
      _ => '',
    };
    if (text.startsWith('[Request interrupted by user')) {
      _turnEnd();
      return;
    }
    // Só resultado de ferramenta (sem texto do usuário).
    if (text.isEmpty) {
      parseClaudeStreamLine(o).forEach(_events.add);
      return;
    }
    if (text.startsWith('<')) return; // lembretes/comandos internos
    _ownSeen++;
    if (_ownPending > 0) {
      _ownPending--;
    } else {
      _events.add(ChatUserText(text)); // digitado no celular / claude.ai
    }
  }

  void _turnEnd() =>
      _events.add(ChatTurnEnd(isError: false, text: '', sessionId: _sid));

  Future<void> _readAsks() async {
    await for (final f in _asks.list()) {
      if (f is! File || !f.path.endsWith('.req')) continue;
      final id = f.uri.pathSegments.last.replaceAll('.req', '');
      final Object? d;
      try {
        d = jsonDecode(await f.readAsString());
      } on FormatException {
        continue;
      }
      await f.rename('${_asks.path}/$id.seen');
      if (d is! Map) continue;
      final input =
          (d['tool_input'] as Map?)?.cast<String, dynamic>() ?? const {};
      final rule = claudeAddRules({
        'permission_suggestions': d['permission_suggestions'],
      });
      _asked[id] = (input, rule);
      _events.add(
        ChatPermissionAsk(
          requestId: id,
          toolName: d['tool_name'] as String? ?? '',
          input: input,
          alwaysRule: claudeRuleLabel(rule),
        ),
      );
    }
  }

  // ---- ChatEngine ----------------------------------------------------------

  @override
  Future<void> send(
    String text, {
    List<ChatAttachment> attachments = const [],
  }) async {
    await _ready.future;
    final mentions = <String>[];
    for (final a in attachments) {
      if (a.kind != ChatAttachmentKind.image) {
        if (a.path != null) mentions.add('@"${a.path}"');
        continue;
      }
      final bytes = a.bytes ?? await File(a.path!).readAsBytes();
      if (bytes.length > ChatAttachment.maxImageBytes) {
        throw ChatAttachmentTooLarge(a.name);
      }
      // O TUI transforma caminho de imagem colado em `[Image #n]`.
      final path =
          a.path ??
          '${_asks.path}/img-${++_imgSeq}.${(a.mediaType ?? 'image/png').split('/').last}';
      if (a.path == null) await File(path).writeAsBytes(bytes);
      await _paste(path);
      await _paste(' ');
    }
    await _paste(mentions.isEmpty ? text : '$text\n\n${mentions.join(' ')}');
    _ownPending++;
    final before = _ownSeen;
    _write('\r');
    // Enter que chega enquanto o TUI ainda processa a colagem se perde.
    await Future<void>.delayed(const Duration(milliseconds: 2500));
    if (_ownSeen == before) _write('\r');
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
    final decision = allow
        ? {
            'behavior': 'allow',
            if (input != null) 'updatedInput': input else 'updatedInput': asked,
            if (always && rule != null) 'updatedPermissions': [rule],
          }
        : {
            'behavior': 'deny',
            'message': message ?? 'Negado pelo usuário no GSH',
          };
    final tmp = File('${_asks.path}/$requestId.resp.tmp');
    tmp.writeAsStringSync(
      jsonEncode({
        'hookSpecificOutput': {
          'hookEventName': 'PermissionRequest',
          'decision': decision,
        },
      }),
    );
    tmp.renameSync('${_asks.path}/$requestId.resp');
  }

  /// Shift+Tab gira os modos; o rodapé do TUI diz em qual parou.
  @override
  void setPermissionMode(String mode) => unawaited(_cycleTo(mode));

  Future<void> _cycleTo(String mode) async {
    await _ready.future;
    for (var i = 0; i < 6 && !_closed; i++) {
      if (_screenMode == mode) {
        if (_mode != mode) {
          _mode = mode;
          _events.add(ChatModeChanged(mode));
        }
        return;
      }
      _write('\x1b[Z');
      await Future<void>.delayed(const Duration(milliseconds: 500));
    }
  }

  /// Esc. O transcript não registra a interrupção no meio da geração; quem
  /// avisa é a tela ("Interrupted"), e sem ela fecha o turno em 3 s.
  @override
  void interrupt() {
    _interrupting = true;
    _write('\x1b');
    Timer(const Duration(seconds: 3), _endInterrupt);
  }

  void _endInterrupt() {
    if (!_interrupting) return;
    _interrupting = false;
    _turnEnd();
  }

  void _onExit(int code) {
    _poll.cancel();
    if (!_closed) {
      final last = _screen.trim();
      _events.add(
        ChatEngineFailed(
          exitCode: code,
          stderr: last.length > 800 ? last.substring(last.length - 800) : last,
        ),
      );
      unawaited(_cleanup());
    }
    unawaited(_events.close());
  }

  Future<void> _cleanup() async {
    try {
      // Sem a pasta, hooks pendentes saem sem decidir.
      await _asks.delete(recursive: true);
    } on FileSystemException {
      // já foi
    }
  }

  @override
  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    _poll.cancel();
    _pty.kill();
    await _cleanup();
  }
}

String _uuidV4() {
  final r = Random.secure();
  final b = List<int>.generate(16, (_) => r.nextInt(256));
  b[6] = (b[6] & 0x0f) | 0x40;
  b[8] = (b[8] & 0x3f) | 0x80;
  final h = b.map((x) => x.toRadixString(16).padLeft(2, '0')).join();
  return '${h.substring(0, 8)}-${h.substring(8, 12)}-${h.substring(12, 16)}-'
      '${h.substring(16, 20)}-${h.substring(20)}';
}
