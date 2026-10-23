import 'dart:convert';

import 'package:cockpit/app/cockpit/domain/entities/agent_message.dart';
import 'package:cockpit/app/cockpit/ui/actions/agent_graph_actions.dart';
import 'package:cockpit/app/core/ui/themes/agent_colors.dart';
import 'package:cockpit/app/cockpit/ui/session/pane_item.dart';
import 'package:cockpit/app/cockpit/ui/viewmodels/agent_graph_store.dart';
import 'package:cockpit/app/cockpit/ui/viewmodels/agent_message_delivery.dart';
import 'package:cockpit/app/cockpit/ui/widgets/agent_graph_painter.dart';
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

AgentMessage _msg(String from, String to, String text) => AgentMessage(
  fromTabId: from,
  toTabId: to,
  sentAt: DateTime(2026),
  preview: text,
);

void main() {
  group('AgentGraphStore', () {
    test('link não ordenado: add/dedupe/laço/remove + aviso por workspace', () {
      final changed = <String>[];
      final g = AgentGraphStore(onWorkspaceChanged: changed.add);
      expect(g.addLink('ws', 't2', 't1'), isTrue);
      expect(g.addLink('ws', 't1', 't2'), isFalse, reason: 'mesmo par');
      expect(g.addLink('ws', 't1', 't1'), isFalse, reason: 'laço');
      expect(g.addLink('ws', 't1', 't3'), isTrue);
      expect(g.peersOf('ws', 't1'), unorderedEquals(['t2', 't3']));
      expect(g.peersOf('outro', 't1'), isEmpty);
      g.removeLink('ws', 't2', 't1');
      expect(g.isLinked('ws', 't1', 't2'), isFalse);
      expect(changed, ['ws', 'ws', 'ws']);
    });

    test('persiste e restaura (JSON real), podando abas mortas', () {
      final g = AgentGraphStore()
        ..addLink('ws', 't1', 't2')
        ..addLink('ws', 't1', 't9')
        ..setPosition('ws', 't1', const Offset(10, 20))
        ..setPosition('ws', 't9', const Offset(1, 1));
      final json = jsonDecode(jsonEncode(g.toJson('ws', {'t1', 't2'})));
      expect(json['links'], [
        ['t1', 't2'],
      ]);
      expect((json['positions'] as Map).keys, ['t1']);

      final r = AgentGraphStore()..restore('ws', json, remap: {'t2': 't7'});
      expect(r.linksOf('ws'), {('t1', 't7')});
      expect(r.positionsOf('ws'), {'t1': const Offset(10, 20)});
    });

    test('restore ignora lixo', () {
      final r = AgentGraphStore()
        ..restore('ws', {
          'positions': {
            'a': [1],
            'b': 'x',
          },
          'links': [
            ['a'],
            ['a', 'a'],
            3,
          ],
        });
      expect(r.positionsOf('ws'), isEmpty);
      expect(r.linksOf('ws'), isEmpty);
      r.restore('ws', null);
      expect(r.linksOf('ws'), isEmpty);
    });

    test('placeMissing não empilha e não move quem já tem posição', () {
      final g = AgentGraphStore()
        ..setPosition('ws', 't1', const Offset(kGraphOrigin, kGraphOrigin));
      g.placeMissing('ws', ['t1', 't2', 't3']);
      final p = g.positionsOf('ws');
      expect(p['t1'], const Offset(kGraphOrigin, kGraphOrigin));
      expect({p['t1'], p['t2'], p['t3']}.length, 3);
    });
  });

  test('observedEdges: um cabo por par, conta e guarda a última', () {
    final edges = observedEdges([
      _msg('t1', 't2', 'a'),
      _msg('t2', 't1', 'b'),
      _msg('t1', 't3', 'c'),
      _msg('t1', 't1', 'eco'),
    ]);
    expect(edges.keys, unorderedEquals([('t1', 't2'), ('t1', 't3')]));
    expect(edges[('t1', 't2')]!.count, 2);
    expect(edges[('t1', 't2')]!.last.preview, 'b');
  });

  test('buildCables funde definido + observado e esconde nó ausente', () {
    final cables = buildCables(
      defined: {('t1', 't2'), ('t1', 't9')},
      observed: observedEdges([_msg('t2', 't1', 'x'), _msg('t2', 't3', 'y')]),
      nodes: {'t1', 't2', 't3'},
    );
    final byPair = {for (final c in cables) c.pair: c};
    expect(byPair.keys, unorderedEquals([('t1', 't2'), ('t2', 't3')]));
    expect(byPair[('t1', 't2')]!.defined, isTrue);
    expect(byPair[('t1', 't2')]!.observed!.count, 1);
    expect(byPair[('t2', 't3')]!.defined, isFalse);
  });

  test('agentPeers: só links vivos do emissor', () {
    final g = AgentGraphStore()
      ..addLink('ws', 't1', 't2')
      ..addLink('ws', 't1', 'gone');
    final t1 = _Tab('t1');
    final peers = agentPeers(g, t1, [t1, _Tab('t2', 'Reviewer')]);
    expect(peers, [
      {
        'id': 't2',
        'label': 'Reviewer',
        'title': 'zsh',
        'harness': null,
        'working': false,
        'maestro': false,
      },
    ]);
  });

  test('apresentação do link: label no comando, senão o tab-id', () {
    expect(
      linkIntroText(_Tab('t2', 'Reviewer')),
      'You are now connected to Reviewer. '
      'Talk to it with: cockpit msg --to Reviewer "..."',
    );
    expect(linkIntroText(_Tab('t5')), contains('cockpit msg --to t5 "..."'));
  });

  group('maestro', () {
    test('um por workspace; liga a todos e devolve só os links novos', () {
      final g = AgentGraphStore()..addLink('ws', 't1', 't2');
      expect(g.setMaestro('ws', 't1', ['t1', 't2', 't3']), ['t3']);
      expect(g.peersOf('ws', 't1'), unorderedEquals(['t2', 't3']));
      // Novo maestro rebaixa o anterior (os links dele ficam).
      expect(g.setMaestro('ws', 't3', ['t1', 't2']), ['t2']);
      expect(g.maestroOf('ws'), 't3');
      expect(g.isLinked('ws', 't1', 't3'), isTrue);
      expect(g.maestroOf('outro'), isNull);
      g.clearMaestro('ws');
      expect(g.maestroOf('ws'), isNull);
    });

    test('persiste com remap e poda maestro/cor/monitor de aba morta', () {
      final g = AgentGraphStore()
        ..setMaestro('ws', 't1', ['t2'])
        ..setColor('ws', 't2', agentPalette[3])
        ..setColor('ws', 't9', agentPalette[1])
        ..setMonitored('ws', 't2', false)
        ..setMonitored('ws', 't9', false);
      final json = jsonDecode(jsonEncode(g.toJson('ws', {'t1', 't2'})));
      expect(json['maestro'], 't1');
      expect((json['colors'] as Map).keys, ['t2']);
      expect(json['unmonitored'], ['t2']);
      expect(g.toJson('ws', {'t2'}).containsKey('maestro'), isFalse);

      final r = AgentGraphStore()..restore('ws', json, remap: {'t2': 't7'});
      expect(r.maestroOf('ws'), 't1');
      expect(r.colorOf('t7'), agentPalette[3]);
      expect(r.isMonitored('t7'), isFalse);
      expect(r.isMonitored('t1'), isTrue);
    });

    test('apresentação do maestro lista os pares e os comandos', () {
      final text = maestroIntroText([_Tab('t2', 'Reviewer'), _Tab('t3')]);
      expect(text, contains('Agents: Reviewer, t3.'));
      expect(text, contains('cockpit msg --to <label>'));
      expect(text, contains('cockpit peers'));
    });
  });

  test('colorOf: escolhida sobrepõe o hash, senão agentColorFor', () {
    final g = AgentGraphStore()..setColor('ws', 't1', agentPalette[0]);
    expect(g.colorOf('t1'), agentPalette[0]);
    expect(g.colorOf('t2'), agentColorFor('t2'));
  });

  test(
    'nome padrão e unicidade de label (case-insensitive, sem o próprio)',
    () {
      final tabs = [
        _Tab('t1', 'Claude Code'),
        _Tab('t2', 'claude code 2'),
        _Tab('t3'),
      ];
      final taken = takenLabels(tabs);
      expect(taken, {'claude code', 'claude code 2'});
      expect(defaultAgentName('Claude Code', taken), 'Claude Code 3');
      expect(defaultAgentName('Codex', taken), 'Codex');
      expect(takenLabels(tabs, except: 't1'), {'claude code 2'});
    },
  );

  test('placeMissing devolve só os recém-posicionados', () {
    final g = AgentGraphStore()..setPosition('ws', 't1', Offset.zero);
    expect(g.placeMissing('ws', ['t1', 't2']), ['t2']);
    expect(g.placeMissing('ws', ['t1', 't2']), isEmpty);
  });

  test('agentColorFor é determinística', () {
    expect(agentColorFor('t3'), agentColorFor('t3'));
  });
}
