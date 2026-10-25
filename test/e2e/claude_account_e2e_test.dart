// Pergunta à conta de verdade (sem conversa, sem tokens):
//   GSH_CLI_E2E=1 flutter test test/e2e/claude_account_e2e_test.dart
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:gsh_desktop/app/core/data/claude_code_settings_file.dart';
import 'package:gsh_desktop/app/gsh/data/chat/claude_stream_engine.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/chat_event.dart';

void main() {
  final enabled = Platform.environment['GSH_CLI_E2E'] == '1';
  test(
    'modelos, uso e troca de modelo',
    () async {
      final f = ClaudeStreamEngineFactory(ClaudeCodeSettingsFile());
      final p = (await f.probe(fresh: true))!;
      // ignore: avoid_print
      print('models: ${p.models.map((m) => m.value).join(', ')}');
      // ignore: avoid_print
      print(
        'limits: ${p.usage?.limits.map((l) => '${l.kind.name}=${l.percent}%').join(' ')}',
      );
      expect(p.models, isNotEmpty);

      final dir = await Directory.systemTemp.createTemp('gsh-acct');
      final e = await f.start(cwd: dir.path, model: 'haiku');
      final changed = e.events.firstWhere((ev) => ev is ChatModelChanged);
      final models = e.events.firstWhere((ev) => ev is ChatModels);
      expect(((await models) as ChatModels).models, isNotEmpty);
      e.setModel('sonnet');
      expect(((await changed) as ChatModelChanged).model, contains('sonnet'));
      expect((await e.planUsage())?.limits, isNotEmpty);
      await e.close();
    },
    skip: enabled ? false : 'e2e: GSH_CLI_E2E=1',
    timeout: const Timeout(Duration(minutes: 1)),
  );
}
