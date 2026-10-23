import 'dart:async';
import 'dart:convert';

import 'package:cockpit/app/cockpit/domain/contracts/chat_engine.dart';
import 'package:cockpit/app/cockpit/domain/entities/chat_event.dart';
import 'package:flutter/foundation.dart';

/// Uma linha da conversa na tela.
sealed class ChatItem {}

class ChatUserItem extends ChatItem {
  ChatUserItem(this.text);
  final String text;
}

class ChatAssistantItem extends ChatItem {
  ChatAssistantItem(this.text, {this.streaming = false});
  String text;

  /// Ainda chegando pedaço a pedaço; o bloco completo fecha.
  bool streaming;
}

class ChatToolItem extends ChatItem {
  ChatToolItem({
    required this.id,
    required this.name,
    required this.summary,
    required this.input,
  });
  final String id;
  final String name;
  final String summary;

  /// Input cru da ferramenta (o diff do Edit/Write sai daqui).
  final Map<String, dynamic> input;
  bool done = false;
  bool isError = false;
  String result = '';
}

class ChatPermissionItem extends ChatItem {
  ChatPermissionItem({
    required this.requestId,
    required this.toolName,
    required this.summary,
    required this.input,
    this.alwaysRule,
  });
  final String requestId;
  final String toolName;
  final String summary;
  final Map<String, dynamic> input;

  /// Regra que "sempre permitir" grava; `null` = sem o botão.
  final String? alwaysRule;

  /// Escolheu "sempre permitir".
  bool always = false;

  /// `null` = esperando o usuário.
  bool? allowed;
}

enum ChatNoticeKind { startFailed, engineExited, turnFailed }

/// Aviso do sistema na conversa (sempre erro, por ora). A UI traduz [kind];
/// [detail] é o texto cru (exceção, stderr, `result`).
class ChatNoticeItem extends ChatItem {
  ChatNoticeItem(this.kind, this.detail, {this.exitCode});
  final ChatNoticeKind kind;
  final String detail;
  final int? exitCode;
}

/// Estado de uma conversa (uma aba de chat). Sobe o motor no primeiro envio.
/// Com [resumeSessionId] (aba restaurada), mostra o histórico gravado e o
/// próximo envio continua aquela sessão.
class ChatController extends ChangeNotifier {
  ChatController(this._factory, {required this.cwd, String? resumeSessionId})
    : sessionId = resumeSessionId {
    if (resumeSessionId != null) unawaited(_loadHistory(resumeSessionId));
  }

  final ChatEngineFactory _factory;
  final String cwd;

  final items = <ChatItem>[];
  String? sessionId;
  bool loadingHistory = false;
  String? model;
  double costUsd = 0;
  bool busy = false;

  ChatEngine? _engine;
  StreamSubscription<ChatEvent>? _sub;
  bool _disposed = false;

  bool get waitingPermission =>
      items.any((i) => i is ChatPermissionItem && i.allowed == null);

  Future<void> send(String text) async {
    final msg = text.trim();
    if (msg.isEmpty || busy) return;
    items.add(ChatUserItem(msg));
    busy = true;
    notifyListeners();
    try {
      final engine = _engine ??= await _startEngine();
      engine.send(msg);
    } on Object catch (e) {
      busy = false;
      _engine = null;
      _add(ChatNoticeItem(ChatNoticeKind.startFailed, '$e'));
    }
  }

  Future<void> _loadHistory(String sid) async {
    loadingHistory = true;
    notifyListeners();
    try {
      final past = await _factory.history(cwd: cwd, sessionId: sid);
      if (_disposed) return;
      final live = List.of(items);
      items.clear();
      past.forEach(_apply);
      items.addAll(live);
    } on Object catch (e) {
      debugPrint('[chat] histórico de $sid: $e');
    } finally {
      loadingHistory = false;
      if (!_disposed) notifyListeners();
    }
  }

  Future<ChatEngine> _startEngine() async {
    final engine = await _factory.start(cwd: cwd, resumeSessionId: sessionId);
    _sub = engine.events.listen(_onEvent);
    return engine;
  }

  void answer(
    ChatPermissionItem item, {
    required bool allow,
    bool always = false,
  }) {
    if (item.allowed != null) return;
    item
      ..allowed = allow
      ..always = allow && always;
    _engine?.answerPermission(item.requestId, allow: allow, always: always);
    notifyListeners();
  }

  void interrupt() => _engine?.interrupt();

  void _onEvent(ChatEvent e) {
    if (_disposed) return;
    _apply(e);
    notifyListeners();
  }

  ChatAssistantItem? get _streaming {
    final last = items.lastOrNull;
    return last is ChatAssistantItem && last.streaming ? last : null;
  }

  void _apply(ChatEvent e) {
    switch (e) {
      case ChatReady(:final sessionId, :final model):
        this.sessionId = sessionId;
        this.model = model;
      case ChatUserText(:final text):
        items.add(ChatUserItem(text));
      case ChatTextDelta(:final text):
        final live = _streaming;
        if (live != null) {
          live.text += text;
        } else {
          items.add(ChatAssistantItem(text, streaming: true));
        }
      case ChatText(:final text):
        final live = _streaming;
        if (live != null) {
          live
            ..text = text
            ..streaming = false;
        } else {
          items.add(ChatAssistantItem(text));
        }
      case ChatToolCall(:final id, :final name, :final input):
        items.add(
          ChatToolItem(
            id: id,
            name: name,
            summary: toolSummary(name, input),
            input: input,
          ),
        );
      case ChatToolResult(:final toolUseId, :final isError, :final text):
        for (final i in items.reversed) {
          if (i is ChatToolItem && i.id == toolUseId) {
            i
              ..done = true
              ..isError = isError
              ..result = text;
            break;
          }
        }
      case ChatPermissionAsk(
        :final requestId,
        :final toolName,
        :final input,
        :final alwaysRule,
      ):
        items.add(
          ChatPermissionItem(
            requestId: requestId,
            toolName: toolName,
            summary: toolSummary(toolName, input),
            input: input,
            alwaysRule: alwaysRule,
          ),
        );
      case ChatTurnEnd(
        :final isError,
        :final text,
        :final sessionId,
        :final costUsd,
      ):
        busy = false;
        this.sessionId = sessionId;
        if (costUsd != null) this.costUsd += costUsd;
        if (isError) items.add(ChatNoticeItem(ChatNoticeKind.turnFailed, text));
      case ChatEngineFailed(:final exitCode, :final stderr):
        busy = false;
        _engine = null;
        unawaited(_sub?.cancel());
        items.add(
          ChatNoticeItem(
            ChatNoticeKind.engineExited,
            stderr,
            exitCode: exitCode,
          ),
        );
    }
  }

  void _add(ChatItem item) {
    items.add(item);
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    unawaited(_sub?.cancel());
    unawaited(_engine?.close());
    super.dispose();
  }
}

/// Uma linha que diz o que a ferramenta vai fazer: o comando do Bash, o
/// arquivo do Edit/Read/Write, a URL do WebFetch; senão o input compacto.
String toolSummary(String name, Map<String, dynamic> input) {
  for (final key in const [
    'command',
    'file_path',
    'notebook_path',
    'url',
    'pattern',
    'query',
    'description',
  ]) {
    final v = input[key];
    if (v is String && v.trim().isNotEmpty) return v.trim();
  }
  final raw = jsonEncode(input);
  return raw.length <= 160 ? raw : '${raw.substring(0, 159)}…';
}

/// Conversas abertas, uma por aba de chat. Vive na rota do shell: fechar e
/// reabrir o painel não perde a conversa enquanto a aba existe.
class ChatViewModel extends ChangeNotifier {
  ChatViewModel(this._factory);

  final ChatEngineFactory _factory;
  final _chats = <String, ChatController>{};

  ChatController chatFor(
    String tabId, {
    required String cwd,
    String? resumeSessionId,
  }) => _chats[tabId] ??= ChatController(
    _factory,
    cwd: cwd,
    resumeSessionId: resumeSessionId,
  );

  void close(String tabId) => _chats.remove(tabId)?.dispose();

  @override
  void dispose() {
    for (final c in _chats.values) {
      c.dispose();
    }
    _chats.clear();
    super.dispose();
  }
}
