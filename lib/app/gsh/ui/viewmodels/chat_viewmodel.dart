import 'dart:async';
import 'dart:convert';

import 'package:gsh_desktop/app/gsh/domain/contracts/chat_engine.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/chat_attachment.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/chat_event.dart';
import 'package:gsh_desktop/app/core/domain/entities/app_settings.dart';
import 'package:flutter/foundation.dart';

/// Uma linha da conversa na tela.
sealed class ChatItem {}

class ChatUserItem extends ChatItem {
  ChatUserItem(this.text, {this.attachments = const []});
  final String text;
  final List<ChatAttachment> attachments;
}

class ChatAssistantItem extends ChatItem {
  ChatAssistantItem(this.text, {this.streaming = false});
  String text;

  /// Ainda chegando pedaço a pedaço; o bloco completo fecha.
  bool streaming;
}

/// Resumo de raciocínio do modelo (só nas visualizações Raciocínio e
/// Detalhado).
class ChatThinkingItem extends ChatItem {
  ChatThinkingItem(this.text, {this.streaming = false});
  String text;
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

/// Uma pergunta do `AskUserQuestion`.
class ChatQuestion {
  ChatQuestion({
    required this.question,
    required this.header,
    required this.options,
    required this.multiSelect,
  });
  final String question;
  final String header;

  /// (rótulo, descrição).
  final List<(String, String)> options;
  final bool multiSelect;

  static List<ChatQuestion> parse(Map<String, dynamic> input) => [
    for (final q in (input['questions'] as List? ?? const []).whereType<Map>())
      ChatQuestion(
        question: q['question'] as String? ?? '',
        header: q['header'] as String? ?? '',
        multiSelect: q['multiSelect'] == true,
        options: [
          for (final o in (q['options'] as List? ?? const []).whereType<Map>())
            (o['label'] as String? ?? '', o['description'] as String? ?? ''),
        ],
      ),
  ];
}

/// O agente perguntou algo com opções (`AskUserQuestion`) e espera.
class ChatQuestionItem extends ChatItem {
  ChatQuestionItem({
    required this.requestId,
    required this.questions,
    required this.input,
  });
  final String requestId;
  final List<ChatQuestion> questions;
  final Map<String, dynamic> input;

  /// pergunta → resposta, depois de respondido; `null` = esperando.
  Map<String, String>? answers;
}

enum ChatPlanDecision { approved, refined }

/// O agente apresentou um plano (`ExitPlanMode`) e espera aprovação.
class ChatPlanItem extends ChatItem {
  ChatPlanItem({required this.requestId, required this.plan});
  final String requestId;
  final String plan;

  /// `null` = esperando.
  ChatPlanDecision? decision;
  String feedback = '';
}

enum ChatNoticeKind {
  /// A conversa foi para um terminal com Remote Control (não é erro).
  handedOff,
  startFailed,
  engineExited,
  turnFailed,
  attachmentTooLarge,
}

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
  ChatController(
    this._factory, {
    required this.cwd,
    String? resumeSessionId,
    this.view = TranscriptView.normal,
  }) : sessionId = resumeSessionId {
    if (resumeSessionId != null) unawaited(_loadHistory(resumeSessionId));
  }

  final ChatEngineFactory _factory;
  final String cwd;

  /// Visualização da conversa, fixada ao abrir: decide se o motor pede os
  /// resumos de raciocínio e se as ferramentas já abrem expandidas.
  final TranscriptView view;

  bool get showsThinking => view != TranscriptView.normal;

  /// Estado que o Claude Code classificou no fim do último turno; `null`
  /// enquanto um turno roda ou se o CLI não classificou.
  ChatSessionState? sessionState;
  String sessionStateDetail = '';

  final items = <ChatItem>[];
  String? sessionId;
  bool loadingHistory = false;

  /// Modo de permissão da sessão (os do Claude Code): `default` pede
  /// permissão, `acceptEdits` aceita edições, `plan` só investiga e planeja,
  /// `bypassPermissions` não pergunta nada.
  String permissionMode = 'default';

  /// Anexos esperando o próximo envio.
  final attachments = <ChatAttachment>[];
  var _pasted = 0;

  void attachFiles(Iterable<String> paths) {
    attachments.addAll(paths.map(ChatAttachment.file));
    notifyListeners();
  }

  void attachPastedImage(Uint8List png) {
    attachments.add(
      ChatAttachment.pastedImage(png, name: 'imagem-${++_pasted}.png'),
    );
    notifyListeners();
  }

  void removeAttachment(ChatAttachment a) {
    attachments.remove(a);
    notifyListeners();
  }

  String? model;
  double costUsd = 0;
  bool busy = false;

  ChatEngine? _engine;
  StreamSubscription<ChatEvent>? _sub;
  bool _disposed = false;

  bool get waitingPermission => items.any(
    (i) => switch (i) {
      ChatPermissionItem(:final allowed) => allowed == null,
      ChatQuestionItem(:final answers) => answers == null,
      ChatPlanItem(:final decision) => decision == null,
      _ => false,
    },
  );

  /// Troca o modo de permissão. Sem motor no ar ainda, vale para o primeiro
  /// envio.
  void setPermissionMode(String mode) {
    if (mode == permissionMode) return;
    permissionMode = mode;
    _engine?.setPermissionMode(mode);
    notifyListeners();
  }

  void answerQuestions(ChatQuestionItem item, Map<String, String> answers) {
    if (item.answers != null) return;
    item.answers = answers;
    _engine?.answerPermission(
      item.requestId,
      allow: true,
      input: {...item.input, 'answers': answers},
    );
    notifyListeners();
  }

  void approvePlan(ChatPlanItem item) {
    if (item.decision != null) return;
    item.decision = ChatPlanDecision.approved;
    _engine?.answerPermission(item.requestId, allow: true);
    notifyListeners();
  }

  /// "Continuar planejando": recusa o plano com o ajuste pedido; o agente
  /// refaz e apresenta de novo.
  void refinePlan(ChatPlanItem item, String feedback) {
    if (item.decision != null) return;
    item
      ..decision = ChatPlanDecision.refined
      ..feedback = feedback.trim();
    _engine?.answerPermission(
      item.requestId,
      allow: false,
      message: item.feedback.isEmpty
          ? 'Continue planejando antes de executar.'
          : item.feedback,
    );
    notifyListeners();
  }

  Future<void> send(String text) async {
    final files = List.of(attachments);
    final msg = text.trim().isEmpty && files.isNotEmpty
        ? '(anexo)'
        : text.trim();
    if (msg.isEmpty || busy) return;
    items.add(ChatUserItem(text.trim(), attachments: files));
    attachments.clear();
    busy = true;
    sessionState = null;
    notifyListeners();
    try {
      var engine = _engine;
      if (engine == null) {
        engine = _engine = await _startEngine();
        if (permissionMode != 'default') {
          engine.setPermissionMode(permissionMode);
        }
      }
      await engine.send(msg, attachments: files);
    } on ChatAttachmentTooLarge catch (e) {
      busy = false;
      _add(ChatNoticeItem(ChatNoticeKind.attachmentTooLarge, e.name));
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
    final engine = await _factory.start(
      cwd: cwd,
      resumeSessionId: sessionId,
      showThinking: showsThinking,
    );
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

  ChatThinkingItem? get _thinking {
    final last = items.lastOrNull;
    return last is ChatThinkingItem && last.streaming ? last : null;
  }

  void _apply(ChatEvent e) {
    // Qualquer outra coisa chegando fecha o raciocínio ao vivo.
    if (e is! ChatThinkingDelta && e is! ChatThinking) {
      _thinking?.streaming = false;
    }
    switch (e) {
      // Na visualização Normal o raciocínio não aparece (nem do histórico).
      case ChatThinkingDelta() || ChatThinking() when !showsThinking:
        break;
      case ChatThinkingDelta(:final text):
        final live = _thinking;
        if (live != null) {
          live.text += text;
        } else {
          items.add(ChatThinkingItem(text, streaming: true));
        }
      case ChatThinking(:final text):
        final live = _thinking;
        if (live != null) {
          live
            ..text = text
            ..streaming = false;
        } else {
          items.add(ChatThinkingItem(text));
        }
      case ChatSessionClassified(:final state, :final detail):
        sessionState = state;
        sessionStateDetail = detail;
      case ChatReady(:final sessionId, :final model, :final permissionMode):
        this.sessionId = sessionId;
        this.model = model;
        if (permissionMode != null) this.permissionMode = permissionMode;
      case ChatModeChanged(:final mode):
        permissionMode = mode;
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
        toolName: 'AskUserQuestion',
        :final input,
      ):
        items.add(
          ChatQuestionItem(
            requestId: requestId,
            questions: ChatQuestion.parse(input),
            input: input,
          ),
        );
      case ChatPermissionAsk(
        :final requestId,
        toolName: 'ExitPlanMode',
        :final input,
      ):
        items.add(
          ChatPlanItem(
            requestId: requestId,
            plan: input['plan'] as String? ?? '',
          ),
        );
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

  /// Sessão pronta para sair do chat: tem id e não está no meio de um turno.
  bool get canHandOff => sessionId != null && !busy;

  /// Encerra o motor desta aba para a mesma sessão continuar em outro
  /// processo (terminal com Remote Control): dois processos na mesma sessão
  /// gravariam o transcript em paralelo. Devolve o id, ou `null` se não dá.
  Future<String?> handOff() async {
    final sid = sessionId;
    if (sid == null || busy) return null;
    await _sub?.cancel();
    _sub = null;
    await _engine?.close();
    _engine = null;
    _add(ChatNoticeItem(ChatNoticeKind.handedOff, sid));
    return sid;
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

  /// [view] só vale ao criar: a conversa já aberta mantém a dela.
  ChatController chatFor(
    String tabId, {
    required String cwd,
    String? resumeSessionId,
    TranscriptView view = TranscriptView.normal,
  }) => _chats[tabId] ??= ChatController(
    _factory,
    cwd: cwd,
    resumeSessionId: resumeSessionId,
    view: view,
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
