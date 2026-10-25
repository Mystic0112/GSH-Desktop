// Roda o `claude` de verdade (gasta tokens, liga Remote Control na conta):
//   GSH_CLI_E2E=1 flutter test test/e2e/claude_cli_engine_e2e_test.dart
import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:gsh_desktop/app/gsh/data/chat/claude_cli_engine.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/chat_event.dart';

void main() {
  final enabled = Platform.environment['GSH_CLI_E2E'] == '1';

  test(
    'conversa, permissão, modo e interrupção pelo CLI',
    () async {
      final dir = await Directory.systemTemp.createTemp('gsh-cli-e2e');
      final engine = await const ClaudeCliEngineFactory().start(cwd: dir.path);
      final seen = <ChatEvent>[];
      final turns = StreamController<void>.broadcast();
      engine.events.listen((e) {
        seen.add(e);
        // ignore: avoid_print
        print('EVENT ${e.runtimeType} ${_desc(e)}');
        if (e is ChatPermissionAsk) {
          engine.answerPermission(e.requestId, allow: true);
        }
        if (e is ChatTurnEnd) turns.add(null);
      });

      // O modo padrão do usuário pode ser `auto` (não pergunta): força o
      // `default`, o que também exercita o Shift+Tab.
      engine.setPermissionMode('default');
      await Future<void>.delayed(const Duration(seconds: 8));
      expect(
        seen.whereType<ChatModeChanged>().map((e) => e.mode).last,
        'default',
      );
      await engine.send(
        'Rode no Bash: echo ok > e2e.txt. Depois responda: pronto',
      );
      await turns.stream.first.timeout(const Duration(seconds: 90));
      expect(seen.whereType<ChatPermissionAsk>(), isNotEmpty);
      expect(File('${dir.path}/e2e.txt').existsSync(), isTrue);
      expect(
        seen.whereType<ChatText>().map((e) => e.text.toLowerCase()).join(),
        contains('pronto'),
      );
      expect(seen.whereType<ChatInfo>(), isNotEmpty); // link do Remote Control
      expect(seen.whereType<ChatUserText>(), isEmpty); // a nossa não volta

      engine.setPermissionMode('plan');
      await Future<void>.delayed(const Duration(seconds: 4));
      expect(
        seen.whereType<ChatModeChanged>().map((e) => e.mode),
        contains('plan'),
      );
      engine.setPermissionMode('default');
      await Future<void>.delayed(const Duration(seconds: 4));

      await engine.send(
        'Escreva um ensaio de 3000 palavras sobre gorilas, sem usar ferramentas.',
      );
      await Future<void>.delayed(const Duration(seconds: 4));
      engine.interrupt();
      await turns.stream.first.timeout(const Duration(seconds: 20));

      await engine.close();
      await dir.delete(recursive: true);
    },
    skip: enabled ? false : 'e2e: GSH_CLI_E2E=1',
    timeout: const Timeout(Duration(minutes: 3)),
  );
}

String _desc(ChatEvent e) => switch (e) {
  ChatText(:final text) => text,
  ChatToolCall(:final name) => name,
  ChatPermissionAsk(:final toolName, :final alwaysRule) =>
    '$toolName $alwaysRule',
  ChatInfo(:final text) => text,
  ChatModeChanged(:final mode) => mode,
  ChatReady(:final model) => model,
  ChatEngineFailed(:final exitCode, :final stderr) => '$exitCode $stderr',
  _ => '',
};
