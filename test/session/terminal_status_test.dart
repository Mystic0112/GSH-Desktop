import 'dart:async';
import 'dart:convert';

import 'package:gsh_desktop/app/gsh/domain/contracts/terminal_gateway.dart';
import 'package:gsh_desktop/app/gsh/domain/contracts/terminal_status_server.dart';
import 'package:gsh_desktop/app/gsh/ui/viewmodels/gsh_cli_handler.dart';
import 'package:gsh_desktop/app/core/domain/result.dart';
import 'package:gsh_desktop/app/gsh/domain/services/terminal_harness_monitor.dart';
import 'package:gsh_desktop/app/core/domain/entities/harness.dart';
import 'package:fake_async/fake_async.dart';
import 'package:gsh_desktop/app/core/utils/spawn_directory.dart';
import 'package:gsh_desktop/app/core/domain/entities/terminal_profile.dart';
import 'package:gsh_desktop/app/gsh/ui/session/terminal_session.dart';
import 'package:flutter_test/flutter_test.dart';

/// [TerminalGateway] inerte — não sobe PTY nenhum; só satisfaz o construtor da
/// [TerminalSession] pra testar a máquina de status de turno isoladamente.
class _NoopGateway implements TerminalGateway {
  // `implements` não herda o corpo default do contrato: precisa declarar.
  @override
  SpawnDirectory? get spawnDirectory => null;

  @override
  int? get rootProcessId => null;

  final _out = StreamController<List<int>>();

  @override
  Stream<List<int>> get output => _out.stream;
  @override
  void start({
    required String workingDirectory,
    required TerminalProfile profile,
    int rows = 25,
    int columns = 80,
    Map<String, String> extraEnv = const <String, String>{},
  }) {}
  @override
  void write(List<int> data) {}
  @override
  void resize(int rows, int columns) {}
  @override
  void acknowledgeOutput() {}
  @override
  Future<void> kill() async {
    await _out.close();
  }
}

/// Monitor que só guarda o callback: o teste decide qual harness "roda".
class _FakeMonitor implements TerminalHarnessMonitor {
  void Function(HarnessKind?)? onChange;

  @override
  void registerSession({
    required String sessionId,
    required int? Function() rootPid,
    String? wslDistro,
    required void Function(HarnessKind? newHarness) onHarnessChanged,
  }) => onChange = onHarnessChanged;

  @override
  void unregisterSession(String sessionId) {}

  @override
  void requestPoll({String? sessionId, bool urgent = false}) {}

  @override
  void setSessionVisible(String sessionId, bool visible) {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

TerminalSession _session({
  _NoopGateway? gateway,
  TerminalHarnessMonitor? monitor,
  String id = 't1',
}) => TerminalSession(
  id: id,
  projectId: 'p1',
  workingDirectory: '/tmp',
  gateway: gateway ?? _NoopGateway(),
  monitor: monitor,
  profile: const TerminalProfile(
    id: 'login-shell',
    label: 'sh (login)',
    executable: '/bin/sh',
    args: ['-l'],
  ),
);

void main() {
  group('TerminalSession — status de turno (spinner)', () {
    test('working → idle: spinner liga e desliga', () async {
      final s = _session();
      expect(s.isWorking, isFalse);

      s.applyClaudeStatus(
        status: TerminalStatus.working,
        isTurnStart: true,
      ); // UserPromptSubmit
      expect(s.isWorking, isTrue);

      s.applyClaudeStatus(status: TerminalStatus.idle); // Stop
      expect(s.isWorking, isFalse);
      await s.dispose();
    });

    test(
      'FIX: working mid-turn reordenado que chega DEPOIS do idle é descartado',
      () async {
        final s = _session();
        s.applyClaudeStatus(status: TerminalStatus.working, isTurnStart: true);
        s.applyClaudeStatus(status: TerminalStatus.idle); // Stop → idle
        expect(s.isWorking, isFalse);

        // PostToolUse('working') do MESMO turno, entregue fora de ordem depois do
        // Stop (processos/sockets separados). Sem o guard, o spinner voltaria e
        // ficaria girando pra sempre.
        s.applyClaudeStatus(status: TerminalStatus.working, isTurnStart: false);
        expect(
          s.isWorking,
          isFalse,
          reason: 'working mid-turn órfão pós-idle deve ser ignorado',
        );
        await s.dispose();
      },
    );

    test(
      'follow-up enfileirado (UserPromptSubmit) logo após idle LIGA o spinner',
      () async {
        final s = _session();
        s.applyClaudeStatus(status: TerminalStatus.working, isTurnStart: true);
        s.applyClaudeStatus(status: TerminalStatus.idle);
        expect(s.isWorking, isFalse);

        // Turno novo (não é reordenação): isTurnStart pula o guard.
        s.applyClaudeStatus(status: TerminalStatus.working, isTurnStart: true);
        expect(s.isWorking, isTrue);
        await s.dispose();
      },
    );

    test('working mid-turn DENTRO de um turno ativo é aceito', () async {
      final s = _session();
      s.applyClaudeStatus(status: TerminalStatus.working, isTurnStart: true);
      // PreToolUse volta a idle? não — segue working. Simula waiting→working:
      s.applyClaudeStatus(status: TerminalStatus.waiting); // Notification
      expect(s.isWorking, isFalse);
      // Aprovou → PreToolUse('working') com turno ainda ativo → volta a working.
      s.applyClaudeStatus(status: TerminalStatus.working, isTurnStart: false);
      expect(s.isWorking, isTrue);
      await s.dispose();
    });
  });

  group('TerminalSession — status por saída (harness sem hook)', () {
    const silence = TerminalSession.outputSilenceIdle;

    test('saída liga, silêncio desliga; turno sustentado notifica', () {
      fakeAsync((async) {
        final gw = _NoopGateway();
        final monitor = _FakeMonitor();
        final s = _session(gateway: gw, monitor: monitor);
        var finished = 0;
        s.onTurnFinished = () => finished++;
        void out() {
          gw._out.add(utf8.encode('x'));
          async.flushMicrotasks();
        }

        out(); // sem harness: shell puro não vira "working"
        expect(s.isWorking, isFalse);

        monitor.onChange!(HarnessKind.antigravity);
        out();
        expect(s.isWorking, isTrue);
        async.elapse(silence ~/ 2);
        out(); // ainda imprimindo no 1º tick → turno sustentado
        async.elapse(silence);
        expect(s.isWorking, isTrue);
        async.elapse(silence + const Duration(milliseconds: 100));
        expect(s.isWorking, isFalse);
        expect(finished, 1);
        unawaited(s.dispose());
        async.flushMicrotasks();
      });
    });

    test('redesenho isolado apaga o spinner sem notificar', () {
      fakeAsync((async) {
        final gw = _NoopGateway();
        final monitor = _FakeMonitor();
        final s = _session(gateway: gw, monitor: monitor);
        var finished = 0;
        s.onTurnFinished = () => finished++;
        monitor.onChange!(HarnessKind.openCode);
        gw._out.add(utf8.encode('x'));
        async.flushMicrotasks();
        expect(s.isWorking, isTrue);
        async.elapse(silence + const Duration(milliseconds: 100));
        expect(s.isWorking, isFalse);
        expect(finished, 0);
        unawaited(s.dispose());
        async.flushMicrotasks();
      });
    });

    test('harness com hook ignora a saída', () {
      fakeAsync((async) {
        final gw = _NoopGateway();
        final monitor = _FakeMonitor();
        final s = _session(gateway: gw, monitor: monitor);
        monitor.onChange!(HarnessKind.claudeCode);
        gw._out.add(utf8.encode('x'));
        async.flushMicrotasks();
        expect(s.isWorking, isFalse);
        unawaited(s.dispose());
        async.flushMicrotasks();
      });
    });
  });

  // Codex CLI roda as sessões num daemon compartilhado: o `gsh mcp` não
  // tem árvore de aba, então cada chamada diz `from`.
  group('from do gsh mcp (actAsMcpFrom)', () {
    test('aba Codex age como ela; outra aba, desconhecida e ausente', () async {
      final codexMon = _FakeMonitor();
      final claudeMon = _FakeMonitor();
      final codex = _session(id: 't50', monitor: codexMon)
        ..restoreManualLabel('Builder');
      final claude = _session(id: 't3', monitor: claudeMon);
      codexMon.onChange!(HarnessKind.codex);
      claudeMon.onChange!(HarnessKind.claudeCode);
      final tabs = [codex, claude];
      GshCommand cmd(String verb, Object? from) => GshCommand(
        cmd: verb,
        tabId: 'ext:codex-desktop',
        args: {'from': ?from, 'timeout': 0},
      );
      String? tabOf(Result<GshCommand, String> r) =>
          r.fold((c) => c.tabId, (e) => 'ERR $e');

      for (final verb in ['msg', 'peers', 'agents', 'ext-wait']) {
        expect(tabOf(actAsMcpFrom(cmd(verb, 't50'), tabs)), 't50');
      }
      expect(tabOf(actAsMcpFrom(cmd('peers', ' builder '), tabs)), 't50');
      expect(
        tabOf(actAsMcpFrom(cmd('peers', 't3'), tabs)),
        startsWith('ERR from: tab "t3" is not a Codex terminal tab'),
      );
      expect(
        tabOf(actAsMcpFrom(cmd('peers', 't99'), tabs)),
        startsWith('ERR from: no tab with id or label "t99"'),
      );
      // Ausente (ou vazio): identidade do startup, intacta.
      expect(
        tabOf(actAsMcpFrom(cmd('peers', null), tabs)),
        'ext:codex-desktop',
      );
      expect(tabOf(actAsMcpFrom(cmd('peers', ' '), tabs)), 'ext:codex-desktop');
      // Fora dos verbos de agente, `from` não significa nada.
      expect(
        tabOf(actAsMcpFrom(cmd('write', 't3'), tabs)),
        'ext:codex-desktop',
      );
      await codex.dispose();
      await claude.dispose();
    });
  });
}
