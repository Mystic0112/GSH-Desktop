import 'dart:convert';

import 'package:gsh_desktop/app/gsh/domain/entities/agent_message.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/desktop_agent_app.dart';
import 'package:gsh_desktop/app/gsh/domain/services/mcp_config_merge.dart';
import 'package:gsh_desktop/app/gsh/ui/session/external_agent.dart';
import 'package:gsh_desktop/app/gsh/ui/session/pane_item.dart';
import 'package:gsh_desktop/app/gsh/ui/viewmodels/agent_graph_store.dart';
import 'package:gsh_desktop/app/gsh/ui/viewmodels/agent_message_delivery.dart';
import 'package:gsh_desktop/app/gsh/ui/viewmodels/agent_message_log.dart';
import 'package:gsh_desktop/app/gsh/ui/viewmodels/gsh_cli_handler.dart';
import 'package:gsh_desktop/app/core/domain/result.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';

class _Tab extends PaneItem {
  _Tab(this.id, [String? label]) {
    restoreManualLabel(label);
  }
  @override
  final String id;
  @override
  String get projectId => 'ws';
  @override
  String get title => 'zsh';
  @override
  String get workingDirectory => '/tmp';
}

const _cmd = '/home/u/.gsh/bin/gsh';
final _args = mcpServerArgs('cursor');

void main() {
  group('mergeJsonMcpServer', () {
    const raw =
        '{\n'
        '    "preferences": {"theme": "dark"},\n'
        '    "mcpServers": {\n'
        '        "other": {"command": "x", "env": {"TOKEN": "secret"}}\n'
        '    }\n'
        '}\n';

    test('só mcpServers.gsh muda; o resto e a indentação ficam', () {
      final out = mergeJsonMcpServer(raw, command: _cmd, args: _args);
      final json = jsonDecode(out) as Map<String, dynamic>;
      expect(json['preferences'], {'theme': 'dark'});
      expect((json['mcpServers'] as Map).keys, ['other', 'gsh']);
      expect(json['mcpServers']['other']['env'], {'TOKEN': 'secret'});
      expect(json['mcpServers']['gsh'], {
        'command': _cmd,
        'args': ['mcp', '--agent', 'cursor'],
      });
      expect(out, startsWith('{\n    "preferences"'));
      expect(out.endsWith('\n'), isTrue);
    });

    test('idempotente, cria do zero e adiciona mcpServers ausente', () {
      final once = mergeJsonMcpServer(raw, command: _cmd, args: _args);
      expect(mergeJsonMcpServer(once, command: _cmd, args: _args), once);
      for (final blank in [null, '', '  \n']) {
        expect(
          jsonDecode(mergeJsonMcpServer(blank, command: _cmd, args: _args)),
          {
            'mcpServers': {
              'gsh': {'command': _cmd, 'args': _args},
            },
          },
        );
      }
      final noServers = mergeJsonMcpServer(
        '{"a": 1}',
        command: _cmd,
        args: _args,
      );
      expect((jsonDecode(noServers) as Map).keys, ['a', 'mcpServers']);
    });

    test('JSONC/lixo é recusado (nada é reescrito)', () {
      for (final bad in ['// c\n{}', '[1]', '{"mcpServers": 3}']) {
        expect(
          () => mergeJsonMcpServer(bad, command: _cmd, args: _args),
          throwsFormatException,
        );
      }
    });
  });

  group('mergeTomlMcpServer', () {
    const head =
        'model = "gpt"\n'
        '\n'
        '[mcp_servers.node_repl]\n'
        'command = "node"\n'
        '\n'
        '[mcp_servers.node_repl.env]\n'
        'KEY = "v"\n';
    final table = tomlMcpEntry(command: _cmd, args: _args);

    test('acrescenta no fim sem tocar um byte do resto; idempotente', () {
      final out = mergeTomlMcpServer(head, command: _cmd, args: _args);
      expect(out, '$head\n$table');
      expect(mergeTomlMcpServer(out, command: _cmd, args: _args), out);
      expect(mergeTomlMcpServer(null, command: _cmd, args: _args), table);
      expect(table, contains('args = ["mcp", "--agent", "cursor"]'));
    });

    test('troca só a tabela gsh; vizinhos e subtabela ficam', () {
      const tail =
          '[mcp_servers.gsh.env]\n'
          'X = "1"\n'
          '\n'
          '[tui]\n'
          'theme = "x"\n';
      const old =
          '$head\n[mcp_servers.gsh]  # mine\ncommand = "old"\nargs = []\n\n$tail';
      final out = mergeTomlMcpServer(old, command: _cmd, args: _args);
      expect(out, '$head\n$table\n$tail');
      expect(mergeTomlMcpServer(out, command: _cmd, args: _args), out);
    });

    test('entrada do Codex repassa as envs da aba (env_vars)', () {
      expect(
        table,
        contains(
          'env_vars = ["GSH_TAB_ID", "GSH_STATUS_SOCK", '
          '"GSH_STATUS_PORT", "GSH_STATUS_TOKEN"]',
        ),
      );
    });

    test('comentários depois da tabela ficam (bloco de hooks)', () {
      const block =
          '# >>> gsh hooks (auto-gerado)\n'
          '# Regerado a cada boot.\n'
          '\n'
          '[hooks.state."x"]\n'
          'enabled = true\n'
          '# <<< gsh hooks\n';
      const old =
          '$head\n[mcp_servers.gsh]\ncommand = "old"\nargs = []\n\n$block';
      final out = mergeTomlMcpServer(old, command: _cmd, args: _args);
      expect(out, '$head\n$table\n$block');
      expect(mergeTomlMcpServer(out, command: _cmd, args: _args), out);
    });

    test('gsh definido de outro jeito é recusado', () {
      for (final bad in [
        'mcp_servers.gsh.command = "x"\n',
        '[mcp_servers]\ngsh = { command = "x" }\n',
      ]) {
        expect(
          () => mergeTomlMcpServer(bad, command: _cmd, args: _args),
          throwsFormatException,
        );
      }
    });
  });

  group('wait_messages de uma aba (AgentMessageLog.takeFor)', () {
    void send(AgentMessageLog log, String to, String text) => log.record(
      fromTabId: 't1',
      fromWorkspaceId: 'ws',
      toTabId: to,
      toWorkspaceId: 'ws',
      text: text,
      signedBy: 'Builder · Claude Code',
    );

    test('só o que chegou pra aba desde a última chamada', () async {
      final log = AgentMessageLog();
      send(log, 't2', 'antes do MCP subir');
      log.markRead('t2');
      await Future<void>.delayed(const Duration(milliseconds: 2));
      send(log, 't2', 'a');
      send(log, 't3', 'pra outra aba');
      send(log, 't2', 'b');
      final got = await log.takeFor('t2', 'ws', Duration.zero);
      expect(got.map((m) => m.preview), ['a', 'b']);
      expect(got.first.signedBy, 'Builder · Claude Code');
      expect(await log.takeFor('t2', 'ws', Duration.zero), isEmpty);
      log.dispose();
    });

    test(
      'um MCP servindo duas abas: cursor de cada uma é independente',
      () async {
        final log = AgentMessageLog();
        send(log, 't50', 'pra 50');
        send(log, 't51', 'pra 51');
        expect(
          (await log.takeFor('t50', 'ws', Duration.zero)).single.preview,
          'pra 50',
        );
        // t50 ler não consome o de t51.
        expect(
          (await log.takeFor('t51', 'ws', Duration.zero)).single.preview,
          'pra 51',
        );
        // Cursor por horário: folga pra não cair no mesmo microssegundo.
        await Future<void>.delayed(const Duration(milliseconds: 2));
        send(log, 't50', 'de novo');
        expect(await log.takeFor('t51', 'ws', Duration.zero), isEmpty);
        expect(
          (await log.takeFor('t50', 'ws', Duration.zero)).single.preview,
          'de novo',
        );
        log.dispose();
      },
    );

    test('long-poll acorda na chegada e volta vazio no timeout', () {
      fakeAsync((fa) {
        final log = AgentMessageLog();
        List<AgentMessage>? got;
        log.takeFor('t2', 'ws', const Duration(seconds: 45)).then((v) {
          got = v;
        });
        fa.elapse(const Duration(seconds: 1));
        send(log, 't3', 'outra aba não acorda');
        fa.flushMicrotasks();
        expect(got, isNull);
        fa.elapse(const Duration(seconds: 1));
        send(log, 't2', 'pronto');
        fa.flushMicrotasks();
        expect(got!.single.preview, 'pronto');

        log.takeFor('t2', 'ws', const Duration(seconds: 5)).then((v) {
          got = v;
        });
        fa.elapse(const Duration(seconds: 6));
        expect(got, isEmpty);
        log.dispose();
      });
    });
  });

  group('ExternalAgent inbox', () {
    ExternalAgent ext() => ExternalAgent(
      app: DesktopAgentApp.cursor,
      projectId: 'ws',
      workingDirectory: '/w',
      label: 'Cursor',
    );

    test('teto: a mais antiga sai; drena tudo de uma vez', () async {
      final e = ext();
      for (var i = 0; i <= ExternalAgent.inboxCap; i++) {
        e.enqueue('gsh', 'm$i');
      }
      expect(e.pending, ExternalAgent.inboxCap);
      final got = await e.waitMessages(Duration.zero);
      expect(got.length, ExternalAgent.inboxCap);
      expect(got.first.text, 'm1');
      expect(e.pending, 0);
      e.dispose();
    });

    test('long-poll acorda na chegada e volta vazio no timeout', () {
      fakeAsync((fa) {
        final e = ext();
        List<InboxMessage>? got;
        e.waitMessages(const Duration(seconds: 50)).then((v) => got = v);
        fa.elapse(const Duration(seconds: 1));
        expect(got, isNull);
        expect(e.online, isTrue, reason: 'esperando = online');
        e.enqueue('Builder · Claude Code', 'pronto');
        fa.flushMicrotasks();
        expect(got!.single.from, 'Builder · Claude Code');

        e.waitMessages(const Duration(seconds: 5)).then((v) => got = v);
        fa.elapse(const Duration(seconds: 6));
        expect(got, isEmpty);
        expect(e.online, isFalse);
        e.dispose();
      });
    });

    test('presença e working decaem', () {
      fakeAsync((fa) {
        final e = ext()..markActive();
        expect((e.online, e.isWorking), (true, true));
        fa.elapse(ExternalAgent.workingWindow);
        expect((e.online, e.isWorking), (true, false));
        fa.elapse(ExternalAgent.onlineWindow);
        expect(e.online, isFalse);
        e.dispose();
      });
    });

    test('msg pra nó externo vai pra fila (assinada) e pro log', () async {
      final e = ext();
      final log = AgentMessageLog();
      deliverAgentMessage(
        log: log,
        from: _Tab('t1', 'Builder'),
        target: e,
        senderName: 'Builder',
        senderHarness: 'Claude Code',
        text: 'oi',
        targetAlive: () => true,
      );
      expect(log.forWorkspace('ws').single.toTabId, 'ext:cursor');
      final got = await e.waitMessages(Duration.zero);
      expect(
        (got.single.from, got.single.text),
        ('Builder · Claude Code', 'oi'),
      );
      e.dispose();
      log.dispose();
    });
  });

  group('nó externo no grafo', () {
    test('label do externo resolve no --to e colide com aba', () {
      final g = AgentGraphStore();
      final e = g.addExternal(
        'ws',
        DesktopAgentApp.claudeDesktop,
        label: 'Desk',
        workingDirectory: '',
      );
      final reach = [_Tab('t1', 'Reviewer'), ...g.externals];
      final r = resolveTabTarget('desk', reach);
      expect(r is Success<PaneItem, String> ? r.value : null, same(e));
      expect(
        resolveTabTarget('desk', [...reach, _Tab('t2', 'DESK')]),
        isA<Failure<PaneItem, String>>(),
      );
      g.dispose();
    });

    test(
      'maestro externo liga a todos; persiste e restaura; remover limpa',
      () {
        final g = AgentGraphStore();
        final e = g.addExternal(
          'ws',
          DesktopAgentApp.codexDesktop,
          label: 'Codex (ChatGPT)',
          workingDirectory: '/w',
        );
        expect(g.setMaestro('ws', e.id, ['t1', 't2', e.id]), ['t1', 't2']);
        final json = jsonDecode(jsonEncode(g.toJson('ws', {'t1', 't2'})));
        expect(json['maestro'], 'ext:codex-desktop');
        expect(json['externals'], [
          {'app': 'codex-desktop', 'label': 'Codex (ChatGPT)', 'cwd': '/w'},
        ]);

        final r = AgentGraphStore()..restore('ws', json);
        expect(
          r.externalById('ext:codex-desktop')!.displayTitle,
          'Codex (ChatGPT)',
        );
        expect(r.maestroOf('ws'), 'ext:codex-desktop');
        expect(
          r.peersOf('ws', 'ext:codex-desktop'),
          unorderedEquals(['t1', 't2']),
        );
        final peers = agentPeers(r, _Tab('t1'), [_Tab('t1'), _Tab('t2')]);
        expect(peers.single['app'], 'codex-desktop');
        expect(peers.single['maestro'], isTrue);

        r.removeExternal('ws', 'ext:codex-desktop');
        expect(r.maestroOf('ws'), isNull);
        expect(r.linksOf('ws'), isEmpty);
        g.dispose();
        r.dispose();
      },
    );

    test('um nó por app: adicionar em outro workspace tira do anterior', () {
      final g = AgentGraphStore();
      g.addExternal(
        'a',
        DesktopAgentApp.cursor,
        label: 'C',
        workingDirectory: '',
      );
      g.addExternal(
        'b',
        DesktopAgentApp.cursor,
        label: 'C',
        workingDirectory: '',
      );
      expect(g.externalsOf('a'), isEmpty);
      expect(g.externalById('ext:cursor')!.projectId, 'b');
      g.dispose();
    });

    test('apresentações via MCP falam das ferramentas, com label citado', () {
      final peer = _Tab('t2', 'Claude Code 2');
      expect(
        linkIntroText(peer),
        contains('gsh msg --to "Claude Code 2" "..."'),
      );
      final mcp = linkIntroText(peer, via: AgentChannel.mcpQueue);
      expect(mcp, contains('send tool'));
      expect(mcp, contains('wait_messages'));
      final maestro = maestroIntroText([peer], via: AgentChannel.mcpQueue);
      for (final tool in ['send', 'wait_messages', 'list_agents', 'peers']) {
        expect(maestro, contains(tool));
      }
      expect(agentChannel(peer), AgentChannel.shell);
    });

    test('Codex numa aba: ferramentas do MCP gsh, não a CLI de shell', () {
      final peer = _Tab('t2', 'Reviewer');
      final link = linkIntroText(peer, via: AgentChannel.mcpTab);
      expect(link, contains('`gsh` MCP server'));
      expect(link, contains('blocked by your sandbox'));
      expect(link, contains('send tool (to: Reviewer)'));
      expect(link, isNot(contains('gsh msg --to')));
      final maestro = maestroIntroText([peer], via: AgentChannel.mcpTab);
      for (final tool in ['send', 'wait_messages', 'list_agents', 'peers']) {
        expect(maestro, contains(tool));
      }
      expect(maestro, isNot(contains('gsh msg')));
    });

    test(
      'Codex numa aba: a apresentação diz o id dela e manda passar from',
      () {
        final peer = _Tab('t2', 'Reviewer');
        for (final text in [
          linkIntroText(peer, via: AgentChannel.mcpTab, selfId: 't50'),
          maestroIntroText([peer], via: AgentChannel.mcpTab, selfId: 't50'),
        ]) {
          expect(text, contains('You are GSH tab t50.'));
          expect(text, contains('always pass from: "t50"'));
        }
        expect(linkIntroText(peer, selfId: 't50'), isNot(contains('t50')));
      },
    );
  });
}
