import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:gsh_desktop/app/gsh/domain/entities/chat_event.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/chat_usage.dart';

/// Modelos da resposta do `initialize` (`models: [{value, displayName,
/// description, resolvedModel}]`).
List<ChatModelOption> parseClaudeModels(Object? init) {
  final list = init is Map ? init['models'] : null;
  if (list is! List) return const [];
  return [
    for (final m in list.whereType<Map>())
      if (m['value'] case final String value when value.isNotEmpty)
        ChatModelOption(
          value: value,
          displayName: m['displayName'] as String? ?? value,
          description: m['description'] as String? ?? '',
          resolved: m['resolvedModel'] as String?,
        ),
  ];
}

/// Comandos da resposta do `initialize` (`commands: [{name, description,
/// argumentHint, aliases}]`). A descrição traz o escopo no fim ("(user)",
/// "(project)"), que fica de fora.
List<ChatCommandOption> parseClaudeCommands(Object? init) {
  final list = init is Map ? init['commands'] : null;
  if (list is! List) return const [];
  return [
    for (final c in list.whereType<Map>())
      if (c['name'] case final String name when name.isNotEmpty)
        ChatCommandOption(
          name: name,
          description: (c['description'] as String? ?? '')
              .replaceFirst(
                RegExp(r'\s*\((user|project|local|plugin[^)]*)\)$'),
                '',
              )
              .trim(),
          argumentHint: c['argumentHint'] as String? ?? '',
          aliases: [
            for (final a in (c['aliases'] as List? ?? const []))
              if (a is String) a,
          ],
        ),
  ];
}

/// Limites da resposta do `get_usage` (`limits: [{kind, percent, severity,
/// resets_at, scope}]`). Sem `limits`, cai nos `rate_limits` antigos.
ChatPlanUsage? parseClaudePlanUsage(Object? usage) {
  if (usage is! Map) return null;
  final plan = usage['subscription_type'] as String?;
  final limits = <ChatLimit>[];
  final list = usage['limits'];
  if (list is List) {
    for (final l in list.whereType<Map>()) {
      final pct = l['percent'];
      if (pct is! num) continue;
      final scope = l['scope'];
      final scopeModel = scope is Map ? scope['model'] : null;
      final model = scopeModel is Map ? scopeModel['display_name'] : null;
      limits.add(
        ChatLimit(
          kind: switch (l['kind']) {
            'session' => ChatLimitKind.session,
            'weekly_all' => ChatLimitKind.weekly,
            'weekly_scoped' when model is String => ChatLimitKind.weeklyModel,
            _ => ChatLimitKind.other,
          },
          percent: pct.round().clamp(0, 100),
          model: model is String ? model : null,
          resetsAt: DateTime.tryParse(
            l['resets_at'] as String? ?? '',
          )?.toLocal(),
          warning: l['severity'] != null && l['severity'] != 'normal',
        ),
      );
    }
  } else if (usage['rate_limits'] case final Map rl) {
    for (final (key, kind) in const [
      ('five_hour', ChatLimitKind.session),
      ('seven_day', ChatLimitKind.weekly),
    ]) {
      final w = rl[key];
      if (w is! Map || w['utilization'] is! num) continue;
      limits.add(
        ChatLimit(
          kind: kind,
          percent: (w['utilization'] as num).round().clamp(0, 100),
          resetsAt: DateTime.tryParse(
            w['resets_at'] as String? ?? '',
          )?.toLocal(),
        ),
      );
    }
  }
  if (limits.isEmpty) return null;
  return ChatPlanUsage(
    limits: limits.where((l) => l.kind != ChatLimitKind.other).toList(),
    plan: plan,
  );
}

/// Contexto ao fim do turno (`result`): tokens de entrada da última chamada
/// (input + cache) e a janela do modelo (`modelUsage[*].contextWindow`).
ChatContext? parseClaudeContext(Map<String, dynamic> result) {
  final u = result['usage'];
  if (u is! Map) return null;
  int n(Object? v) => v is num ? v.toInt() : 0;
  final tokens =
      n(u['input_tokens']) +
      n(u['cache_creation_input_tokens']) +
      n(u['cache_read_input_tokens']);
  var window = 0;
  final mu = result['modelUsage'];
  if (mu is Map) {
    for (final m in mu.values.whereType<Map>()) {
      window = window < n(m['contextWindow']) ? n(m['contextWindow']) : window;
    }
  }
  return tokens == 0 ? null : ChatContext(tokens: tokens, window: window);
}

/// Pergunta à conta, num `claude -p` de vida curta, os modelos e o uso
/// (`initialize` + `get_usage`). Não abre conversa nem gasta tokens.
Future<ChatAccountProbe?> probeClaudeAccount(
  String exe,
  Map<String, String> env,
) async {
  final Process proc;
  try {
    proc = await Process.start(exe, [
      '-p',
      '--input-format',
      'stream-json',
      '--output-format',
      'stream-json',
      '--verbose',
    ], environment: env);
  } on ProcessException {
    return null;
  }
  final init = Completer<Object?>(), usage = Completer<Object?>();
  final sub = proc.stdout
      .transform(utf8.decoder)
      .transform(const LineSplitter())
      .listen((line) {
        final Object? o;
        try {
          o = jsonDecode(line);
        } on FormatException {
          return;
        }
        if (o is! Map || o['type'] != 'control_response') return;
        final r = o['response'];
        if (r is! Map) return;
        final target = switch (r['request_id']) {
          'probe-init' => init,
          'probe-usage' => usage,
          _ => null,
        };
        if (target != null && !target.isCompleted) {
          target.complete(r['response']);
        }
      });
  unawaited(proc.stderr.drain<void>());
  void send(String id, String subtype) => proc.stdin.writeln(
    jsonEncode({
      'type': 'control_request',
      'request_id': id,
      'request': {'subtype': subtype},
    }),
  );
  try {
    send('probe-init', 'initialize');
    send('probe-usage', 'get_usage');
    const wait = Duration(seconds: 15);
    final initBody = await init.future.timeout(wait);
    final plan = parseClaudePlanUsage(
      await usage.future.timeout(wait, onTimeout: () => null),
    );
    return ChatAccountProbe(
      models: parseClaudeModels(initBody),
      usage: plan,
      commands: parseClaudeCommands(initBody),
    );
  } on TimeoutException {
    return null;
  } finally {
    await sub.cancel();
    proc.kill();
  }
}
