import 'dart:async';

import 'package:cockpit/app/cockpit/domain/contracts/process_tree_provider.dart';
import 'package:cockpit/app/cockpit/domain/entities/process_snapshot.dart';
import 'package:cockpit/app/core/domain/entities/harness.dart';
import 'package:cockpit/app/cockpit/domain/services/terminal_harness_monitor.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeProcessTreeProvider implements ProcessTreeProvider {
  List<ProcessSnapshot> snapshotsToReturn;
  int callCount = 0;
  bool shouldThrow = false;

  FakeProcessTreeProvider({this.snapshotsToReturn = const []});

  @override
  Future<List<ProcessSnapshot>> getProcessSnapshots({
    required List<int> rootPids,
  }) async {
    callCount++;
    if (shouldThrow) {
      throw Exception('Process inspection failed');
    }
    return snapshotsToReturn;
  }
}

void main() {
  group('TerminalHarnessMonitor', () {
    test(
      'starts monitor on first registration and executes immediate poll',
      () async {
        final fakeProvider = FakeProcessTreeProvider(
          snapshotsToReturn: [
            const ProcessSnapshot(
              pid: 100,
              ppid: 1,
              executable: 'bash',
              argv: ['bash'],
            ),
            const ProcessSnapshot(
              pid: 101,
              ppid: 100,
              executable: '/bin/pi',
              argv: ['pi'],
            ),
          ],
        );

        final monitor = TerminalHarnessMonitor(
          provider: fakeProvider,
          pollInterval: const Duration(milliseconds: 500),
        );

        HarnessKind? notifiedHarness;

        monitor.registerSession(
          sessionId: 'session-1',
          rootPid: () => 100,
          onHarnessChanged: (harness) {
            notifiedHarness = harness;
          },
        );

        expect(monitor.isRunning, isTrue);
        expect(monitor.registeredCount, equals(1));

        // Wait microtask for immediate poll completion
        await pumpEventQueue();

        expect(fakeProvider.callCount, equals(1));
        expect(notifiedHarness, equals(HarnessKind.pi));

        monitor.dispose();
      },
    );

    test('shares single snapshot query across multiple sessions', () async {
      final fakeProvider = FakeProcessTreeProvider(
        snapshotsToReturn: [
          const ProcessSnapshot(
            pid: 100,
            ppid: 1,
            executable: 'bash',
            argv: ['bash'],
          ),
          const ProcessSnapshot(
            pid: 101,
            ppid: 100,
            executable: '/bin/claude',
            argv: ['claude'],
          ),
          const ProcessSnapshot(
            pid: 200,
            ppid: 1,
            executable: 'bash',
            argv: ['bash'],
          ),
          const ProcessSnapshot(
            pid: 201,
            ppid: 200,
            executable: '/bin/codex',
            argv: ['codex'],
          ),
        ],
      );

      final monitor = TerminalHarnessMonitor(
        provider: fakeProvider,
        pollInterval: const Duration(milliseconds: 500),
      );

      HarnessKind? harness1;
      HarnessKind? harness2;

      monitor.registerSession(
        sessionId: 'session-1',
        rootPid: () => 100,
        onHarnessChanged: (h) => harness1 = h,
      );

      monitor.registerSession(
        sessionId: 'session-2',
        rootPid: () => 200,
        onHarnessChanged: (h) => harness2 = h,
      );

      await pumpEventQueue();
      await monitor.poll();

      expect(harness1, equals(HarnessKind.claudeCode));
      expect(harness2, equals(HarnessKind.codex));

      monitor.dispose();
    });

    test('stops polling when all sessions are unregistered', () async {
      final fakeProvider = FakeProcessTreeProvider();
      final monitor = TerminalHarnessMonitor(
        provider: fakeProvider,
        pollInterval: const Duration(milliseconds: 100),
      );

      monitor.registerSession(
        sessionId: 'session-1',
        rootPid: () => 100,
        onHarnessChanged: (_) {},
      );

      expect(monitor.isRunning, isTrue);

      monitor.unregisterSession('session-1');

      expect(monitor.isRunning, isFalse);
      expect(monitor.registeredCount, equals(0));

      monitor.dispose();
    });

    test('handles inspection error gracefully without throwing', () async {
      final fakeProvider = FakeProcessTreeProvider()..shouldThrow = true;
      final monitor = TerminalHarnessMonitor(
        provider: fakeProvider,
        pollInterval: const Duration(milliseconds: 100),
      );

      HarnessKind? harness;

      monitor.registerSession(
        sessionId: 'session-1',
        rootPid: () => 100,
        onHarnessChanged: (h) => harness = h,
      );

      await pumpEventQueue();

      expect(harness, isNull);

      monitor.dispose();
    });

    test('requestPoll coalesces without an immediate pending scan', () async {
      final gate = Completer<void>();
      final fakeProvider = _GatedProcessTreeProvider(gate);
      final monitor = TerminalHarnessMonitor(
        provider: fakeProvider,
        pollInterval: const Duration(days: 1),
      );

      monitor.registerSession(
        sessionId: 'session-1',
        rootPid: () => 100,
        onHarnessChanged: (_) {},
      );

      await pumpEventQueue();
      expect(fakeProvider.callCount, equals(1));

      monitor.requestPoll();
      monitor.requestPoll();
      expect(fakeProvider.callCount, equals(1));

      gate.complete();
      await pumpEventQueue();
      expect(fakeProvider.callCount, 1);

      await Future<void>.delayed(const Duration(milliseconds: 1050));
      expect(fakeProvider.callCount, 2);

      monitor.dispose();
    });

    test(
      'activity from many terminals does not start scans continuously',
      () async {
        final fakeProvider = FakeProcessTreeProvider();
        final monitor = TerminalHarnessMonitor(
          provider: fakeProvider,
          pollInterval: const Duration(days: 1),
          activityPollCooldown: const Duration(milliseconds: 500),
        );
        for (var i = 0; i < 8; i++) {
          monitor.registerSession(
            sessionId: 'session-$i',
            rootPid: () => 100 + i,
            onHarnessChanged: (_) {},
          );
        }
        // Let urgent registration requests coalesce before measuring output.
        await Future<void>.delayed(const Duration(milliseconds: 300));
        final beforeActivity = fakeProvider.callCount;
        for (var i = 0; i < 80; i++) {
          monitor.requestPoll(sessionId: 'session-${i % 8}');
        }
        await Future<void>.delayed(const Duration(milliseconds: 50));
        expect(fakeProvider.callCount, beforeActivity);
        await Future<void>.delayed(const Duration(milliseconds: 510));
        expect(fakeProvider.callCount, beforeActivity + 1);
        monitor.dispose();
      },
    );

    test(
      'output requests from all sessions share a one-second scan budget',
      () async {
        final fakeProvider = FakeProcessTreeProvider();
        final monitor = TerminalHarnessMonitor(
          provider: fakeProvider,
          pollInterval: const Duration(days: 1),
          idlePollInterval: const Duration(days: 1),
        );
        monitor.registerSession(
          sessionId: 'session-1',
          rootPid: () => 100,
          onHarnessChanged: (_) {},
        );
        monitor.registerSession(
          sessionId: 'session-2',
          rootPid: () => 200,
          onHarnessChanged: (_) {},
        );
        await Future<void>.delayed(const Duration(milliseconds: 200));
        await pumpEventQueue();
        final initialCount = fakeProvider.callCount;

        for (var i = 0; i < 10; i++) {
          monitor.requestPoll(sessionId: 'session-1');
          monitor.requestPoll(sessionId: 'session-2');
        }
        await Future<void>.delayed(const Duration(milliseconds: 150));
        expect(fakeProvider.callCount, initialCount);
        await Future<void>.delayed(const Duration(milliseconds: 950));
        expect(fakeProvider.callCount, initialCount + 1);

        monitor.dispose();
      },
    );

    test(
      'urgent submitted command scans promptly and coalesces retries',
      () async {
        final fakeProvider = FakeProcessTreeProvider();
        final monitor = TerminalHarnessMonitor(
          provider: fakeProvider,
          pollInterval: const Duration(days: 1),
        );
        monitor.registerSession(
          sessionId: 'session-1',
          rootPid: () => 100,
          onHarnessChanged: (_) {},
        );
        await pumpEventQueue();
        expect(fakeProvider.callCount, 1);

        monitor.requestPoll(sessionId: 'session-1', urgent: true);
        monitor.requestPoll(sessionId: 'session-1', urgent: true);
        await pumpEventQueue();
        expect(fakeProvider.callCount, 1);
        await Future<void>.delayed(const Duration(milliseconds: 200));
        expect(fakeProvider.callCount, 2);

        monitor.dispose();
      },
    );

    test('hidden stable sessions use the idle safety interval', () async {
      final fakeProvider = FakeProcessTreeProvider();
      final monitor = TerminalHarnessMonitor(
        provider: fakeProvider,
        pollInterval: const Duration(milliseconds: 20),
        idlePollInterval: const Duration(milliseconds: 80),
      );

      monitor.registerSession(
        sessionId: 'session-1',
        rootPid: () => 100,
        onHarnessChanged: (_) {},
      );
      await pumpEventQueue();
      final afterRegistration = fakeProvider.callCount;

      await Future<void>.delayed(const Duration(milliseconds: 110));
      expect(fakeProvider.callCount, greaterThan(afterRegistration));
      expect(
        fakeProvider.callCount,
        lessThan(5),
        reason: 'hidden sessions must not retain the old high-rate poll',
      );
      monitor.dispose();
    });

    test('visibility changes do not trigger a process scan', () async {
      final fakeProvider = FakeProcessTreeProvider();
      final monitor = TerminalHarnessMonitor(
        provider: fakeProvider,
        pollInterval: const Duration(days: 1),
        idlePollInterval: const Duration(days: 1),
      );
      monitor.registerSession(
        sessionId: 'session-1',
        rootPid: () => 100,
        onHarnessChanged: (_) {},
      );
      await pumpEventQueue();
      final beforeVisible = fakeProvider.callCount;

      monitor.setSessionVisible('session-1', true);
      await pumpEventQueue();
      expect(fakeProvider.callCount, beforeVisible);
      monitor.setSessionVisible('session-1', false);
      await pumpEventQueue();
      expect(fakeProvider.callCount, beforeVisible);
      monitor.dispose();
    });
  });

  group('sessionOwningProcess (cockpit mcp do Codex de uma aba)', () {
    ProcessSnapshot p(int pid, int ppid, String exe) =>
        ProcessSnapshot(pid: pid, ppid: ppid, executable: exe, argv: [exe]);
    // t1: zsh(100) → codex(110) → cockpit mcp(120). t2: bash(200).
    final table = [
      p(100, 1, 'zsh'),
      p(110, 100, 'codex'),
      p(120, 110, 'cockpit'),
      p(200, 1, 'bash'),
    ];

    test('sobe pelos ppid até a raiz de uma aba', () {
      final roots = {100: 't1', 200: 't2'};
      expect(TerminalHarnessMonitor.ownerOfProcess(120, roots, table), 't1');
      expect(TerminalHarnessMonitor.ownerOfProcess(200, roots, table), 't2');
      // Fora de qualquer aba (app desktop spawnou o MCP).
      expect(TerminalHarnessMonitor.ownerOfProcess(999, roots, table), isNull);
      // Ciclo na tabela não trava.
      expect(
        TerminalHarnessMonitor.ownerOfProcess(5, roots, [
          p(5, 6, 'a'),
          p(6, 5, 'b'),
        ]),
        isNull,
      );
    });

    test('hint de env só vale onde a árvore da aba não é visível', () async {
      final monitor = TerminalHarnessMonitor(
        provider: FakeProcessTreeProvider(snapshotsToReturn: table),
        pollInterval: const Duration(hours: 1),
      );
      for (final (id, root) in [('t1', 100), ('t2', 200)]) {
        monitor.registerSession(
          sessionId: id,
          rootPid: () => root,
          onHarnessChanged: (_) {},
        );
      }
      // Aba remota: sem pid local.
      monitor.registerSession(
        sessionId: 'r1',
        rootPid: () => null,
        onHarnessChanged: (_) {},
      );
      // Cadeia que a CLI manda (Linux/macOS): sobe até a raiz de t1.
      expect(await monitor.sessionOwningProcess([120, 110, 100, 1]), 't1');
      // Só o pid (Windows): sobe pela tabela do provider.
      expect(await monitor.sessionOwningProcess([120]), 't1');
      // Pid acha a aba: vence o hint.
      expect(
        await monitor.sessionOwningProcess([120, 110, 100], hint: 't2'),
        't1',
      );
      // Env herdado de t2 por um processo fora da árvore dela (Cursor aberto
      // do terminal): recusado.
      expect(await monitor.sessionOwningProcess([999, 1], hint: 't2'), isNull);
      // Aba remota: o hint é tudo que há.
      expect(await monitor.sessionOwningProcess([999, 1], hint: 'r1'), 'r1');
      expect(await monitor.sessionOwningProcess([999, 1]), isNull);
      expect(await monitor.sessionOwningProcess(const []), isNull);
      monitor.dispose();
    });
  });
}

class _GatedProcessTreeProvider implements ProcessTreeProvider {
  _GatedProcessTreeProvider(this.gate);

  final Completer<void> gate;
  int callCount = 0;

  @override
  Future<List<ProcessSnapshot>> getProcessSnapshots({
    required List<int> rootPids,
  }) async {
    callCount++;
    await gate.future;
    return const [
      ProcessSnapshot(pid: 100, ppid: 1, executable: 'bash', argv: ['bash']),
    ];
  }
}
