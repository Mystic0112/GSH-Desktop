import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:gsh_desktop/app/core/data/diagnostics/diagnostics_log.dart';
import 'package:gsh_desktop/app/core/domain/result.dart';
import 'package:gsh_desktop/app/gsh/domain/contracts/team_farm_channel.dart';
import 'package:gsh_desktop/app/gsh/domain/contracts/team_mail.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/team_farm.dart';
import 'package:path/path.dart' as p;

/// Um agente de colega que se pode chamar: `Fulano/aba`.
class TeamContact {
  const TeamContact({required this.peer, required this.agent});
  final TeamFarmPacket peer;
  final TeamAgent agent;

  String get address => '${peer.name}/${agent.label}';
}

/// Um mensageiro andando na fazenda: de um agente meu para o de um colega
/// ([outgoing]) ou o contrário. Some sozinho depois de [TeamPost.courierTtl].
class FarmCourier {
  const FarmCourier({
    required this.id,
    required this.outgoing,
    required this.peerId,
    required this.kind,
    required this.startedAt,
    this.localSessionId,
    this.remoteSessionId,
  });

  final String id;
  final bool outgoing;

  /// `machineId` do colega (identifica a fazenda dele no mundo).
  final String peerId;
  final TeamKnockKind kind;
  final DateTime startedAt;

  /// Sessão do meu agente (o gorila de onde sai / onde chega).
  final String? localSessionId;

  /// Sessão do agente do colega (gorila de lá).
  final String? remoteSessionId;
}

/// Quem manda, do lado de cá: a aba com agente que pediu o envio.
class TeamSender {
  const TeamSender({required this.tabId, required this.label, this.sessionId});
  final String tabId;
  final String label;
  final String? sessionId;
}

/// O correio do time no app: resolve o destino (`Fulano/aba`), manda pelo
/// [TeamMail], recebe as batidas e decide a **porta** — quem pode bater,
/// perguntar ao humano antes ([pending]) ou entregar direto ao agente pelo
/// [deliver] que o shell pluga. Também guarda os [couriers] que a fazenda
/// desenha andando entre os lotes.
///
/// Singleton da feature: a fazenda (presença) e o shell (abas, CLI) usam a
/// mesma instância.
class TeamPost extends ChangeNotifier {
  TeamPost(this._channel, this._mail) {
    _subs = [_channel.packets.listen(_onPacket), _mail.knocks.listen(_onKnock)];
  }

  final TeamFarmChannel _channel;
  final TeamMail _mail;
  late final List<StreamSubscription<Object?>> _subs;

  static const courierTtl = Duration(seconds: 14);
  static const _peerTimeout = Duration(seconds: 10);

  TeamFarmConfig _config = const TeamFarmConfig();
  final _peers = <String, (TeamFarmPacket, DateTime)>{};
  final _couriers = <FarmCourier>[];
  final _pending = <TeamKnock>[];

  /// Agentes desta máquina que aceitam mensagem (o shell pluga).
  List<TeamAgent> Function() localAgents = () => const [];

  /// Entrega uma batida aceita ao agente da aba. Devolve o que deu errado
  /// (aba fechada...) ou `null`. O shell pluga.
  Future<String?> Function(TeamKnock knock) deliver = (_) async =>
      'no shell attached';

  TeamFarmConfig get config => _config;
  int? get mailPort => _mail.port;

  /// Batidas esperando o humano abrir a porta (com "perguntar antes").
  List<TeamKnock> get pending => List.unmodifiable(_pending);

  List<FarmCourier> get couriers {
    final now = DateTime.now();
    return [
      for (final c in _couriers)
        if (now.difference(c.startedAt) < courierTtl) c,
    ];
  }

  /// Agentes de colegas que se pode chamar agora.
  List<TeamContact> get contacts {
    final now = DateTime.now();
    return [
      for (final (pkt, at) in _peers.values)
        if (now.difference(at) < _peerTimeout && pkt.mailPort != null)
          for (final a in pkt.agents) TeamContact(peer: pkt, agent: a),
    ];
  }

  Future<void> configure(TeamFarmConfig config) async {
    _config = config;
    try {
      await _mail.configure(config);
    } on SocketException catch (e, st) {
      DiagnosticsLog.instance.warn(
        'team',
        'correio do time indisponível',
        error: e,
        stack: st,
      );
    }
    if (!config.active) _peers.clear();
    notifyListeners();
  }

  void _onPacket(TeamFarmPacket p) {
    if (!_config.active) return;
    _peers[p.machineId] = (p, DateTime.now());
  }

  /// `Fulano/aba` (ou só `Fulano`, se ele tiver um agente só). Nome e aba
  /// sem diferença de maiúsculas.
  Result<TeamContact, String> resolve(String target) {
    final i = target.indexOf('/');
    final who = (i < 0 ? target : target.substring(0, i)).trim().toLowerCase();
    final tab = i < 0 ? null : target.substring(i + 1).trim().toLowerCase();
    final mine = contacts
        .where((c) => c.peer.name.trim().toLowerCase() == who)
        .toList();
    if (mine.isEmpty) {
      return Failure(
        'no teammate "$who" on the network (see `gsh peers`; team mail needs '
        'the same team name and password on both sides)',
      );
    }
    if (tab == null) {
      return mine.length == 1
          ? Success(mine.single)
          : Failure(
              '$who has ${mine.length} agents; use one of: '
              '${mine.map((c) => c.address).join(', ')}',
            );
    }
    final hit = mine.where(
      (c) =>
          c.agent.label.toLowerCase() == tab ||
          c.agent.tabId.toLowerCase() == tab,
    );
    return hit.isEmpty
        ? Failure(
            '$who has no agent "$tab"; use one of: '
            '${mine.map((c) => c.address).join(', ')}',
          )
        : Success(hit.first);
  }

  /// Bate na porta do agente [target] com uma mensagem ou um arquivo.
  Future<Result<String, String>> send({
    required TeamSender from,
    required String target,
    required String text,
    String? filePath,
  }) async {
    if (!_config.mailActive) {
      return const Failure(
        'team mail is off: turn on the team farm and set the team password '
        '(Settings > Resources > Team farm)',
      );
    }
    final TeamContact to;
    switch (resolve(target)) {
      case Failure(:final error):
        return Failure(error);
      case Success(:final value):
        to = value;
    }
    Uint8List? bytes;
    if (filePath != null) {
      try {
        bytes = await File(filePath).readAsBytes();
      } on FileSystemException catch (e) {
        return Failure(
          'cannot read $filePath (${e.osError?.message ?? e.message})',
        );
      }
    }
    final knock = TeamKnock(
      id: _id(),
      kind: filePath == null ? TeamKnockKind.message : TeamKnockKind.file,
      fromMachine: _channel.machineId,
      fromName: _config.name.trim(),
      fromAgent: from.label,
      fromSessionId: from.sessionId,
      toTabId: to.agent.tabId,
      text: text,
      fileName: filePath == null ? null : p.basename(filePath),
      fileBytes: bytes,
    );
    final r = await _mail.send(to.peer.address!, to.peer.mailPort!, knock);
    if (r case Failure(:final error)) return Failure(error);
    _addCourier(
      outgoing: true,
      peerId: to.peer.machineId,
      kind: knock.kind,
      local: from.sessionId,
      remote: to.agent.sessionId,
    );
    return Success(to.address);
  }

  void _onKnock(TeamKnock k) {
    if (!_config.mailActive || !_config.allows(k.fromName)) {
      debugPrint('[team] batida de "${k.fromName}" ignorada (não liberado)');
      return;
    }
    if (_config.askBeforeOpening) {
      _pending.add(k);
      notifyListeners();
      return;
    }
    unawaited(_open(k));
  }

  /// O humano abriu a porta (ou não precisava).
  Future<void> open(TeamKnock k) async {
    _pending.remove(k);
    await _open(k);
  }

  /// O humano recusou: some sem chegar ao agente.
  void refuse(TeamKnock k) {
    _pending.remove(k);
    notifyListeners();
  }

  Future<void> _open(TeamKnock k) async {
    final err = await deliver(k);
    if (err != null) debugPrint('[team] entrega falhou: $err');
    final local = localAgents().where((a) => a.tabId == k.toTabId).firstOrNull;
    _addCourier(
      outgoing: false,
      peerId: k.fromMachine,
      kind: k.kind,
      local: local?.sessionId,
      remote: k.fromSessionId,
    );
  }

  void _addCourier({
    required bool outgoing,
    required String peerId,
    required TeamKnockKind kind,
    String? local,
    String? remote,
  }) {
    final now = DateTime.now();
    _couriers
      ..removeWhere((c) => now.difference(c.startedAt) >= courierTtl)
      ..add(
        FarmCourier(
          id: _id(),
          outgoing: outgoing,
          peerId: peerId,
          kind: kind,
          startedAt: now,
          localSessionId: local,
          remoteSessionId: remote,
        ),
      );
    notifyListeners();
  }

  @override
  void dispose() {
    for (final s in _subs) {
      unawaited(s.cancel());
    }
    unawaited(_mail.close());
    super.dispose();
  }
}

String _id() {
  final r = Random.secure();
  return List.generate(12, (_) => r.nextInt(256).toRadixString(16)).join();
}
