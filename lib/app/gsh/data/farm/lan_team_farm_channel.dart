import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:gsh_desktop/app/gsh/data/farm/team_signing.dart';
import 'package:gsh_desktop/app/gsh/domain/contracts/team_farm_channel.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/farm_loop.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/team_farm.dart';

/// Fazenda do time por **multicast UDP na rede local**: cada GSH manda o
/// próprio pacote (JSON + gzip, poucos KB) para um grupo fixo e escuta o
/// mesmo grupo. Sem servidor, sem porta aberta para a internet (multicast
/// `239.255.x.x` não passa de roteador), sem cadastro de IP.
class LanTeamFarmChannel implements TeamFarmChannel {
  LanTeamFarmChannel({InternetAddress? group, this.port = 47183})
    : group = group ?? InternetAddress('239.255.71.83');

  final InternetAddress group;
  final int port;

  @override
  final String machineId = _randomId();

  final _packets = StreamController<TeamFarmPacket>.broadcast();
  RawDatagramSocket? _socket;
  TeamFarmConfig _config = const TeamFarmConfig();

  @override
  Stream<TeamFarmPacket> get packets => _packets.stream;

  @override
  Future<void> open(TeamFarmConfig config) async {
    _config = config;
    final allowed = config.active && await _onAllowedNetwork(config.network);
    if (!allowed) return close();
    if (_socket != null) return;
    final s = await RawDatagramSocket.bind(
      InternetAddress.anyIPv4,
      port,
      reuseAddress: true,
      // Dois GSHs na mesma máquina (teste) dividem a porta.
      reusePort: !Platform.isWindows,
    );
    s
      ..multicastLoopback = true
      ..joinMulticast(group)
      ..listen((ev) {
        if (ev != RawSocketEvent.read) return;
        final d = s.receive();
        if (d == null) return;
        final p = decodeTeamPacket(
          d.data,
          team: _config.team,
          secret: _config.secret,
          address: d.address.address,
        );
        if (p == null || p.machineId == machineId) return;
        if (p.team != _config.team.trim()) return;
        _packets.add(p);
      });
    _socket = s;
  }

  @override
  Future<void> publish(TeamFarmPacket packet) async {
    final s = _socket;
    if (s == null) return;
    s.send(encodeTeamPacket(packet, secret: _config.secret), group, port);
  }

  @override
  Future<void> close() async {
    _socket?.close();
    _socket = null;
  }
}

/// Uma interface IPv4 desta máquina cai em [cidr]? Vazio = qualquer rede.
Future<bool> _onAllowedNetwork(String cidr) async {
  if (cidr.trim().isEmpty) return true;
  final List<NetworkInterface> ifaces;
  try {
    ifaces = await NetworkInterface.list(type: InternetAddressType.IPv4);
  } on SocketException {
    return false;
  }
  return ifaces
      .expand((i) => i.addresses)
      .any((a) => ipv4InCidr(a.address, cidr));
}

/// `192.168.10.37` está em `192.168.10.0/24`? CIDR inválido = não.
bool ipv4InCidr(String ip, String cidr) {
  final parts = cidr.trim().split('/');
  final net = _ipv4(parts.first);
  final bits = parts.length == 2 ? int.tryParse(parts[1]) : 32;
  final addr = _ipv4(ip);
  if (net == null || addr == null || bits == null || bits < 0 || bits > 32) {
    return false;
  }
  final mask = bits == 0 ? 0 : (0xFFFFFFFF << (32 - bits)) & 0xFFFFFFFF;
  return (net & mask) == (addr & mask);
}

int? _ipv4(String s) {
  final p = s.split('.');
  if (p.length != 4) return null;
  var v = 0;
  for (final x in p) {
    final n = int.tryParse(x);
    if (n == null || n < 0 || n > 255) return null;
    v = (v << 8) | n;
  }
  return v;
}

String _randomId() {
  final r = Random.secure();
  return List.generate(8, (_) => r.nextInt(256).toRadixString(16)).join();
}

// ---- formato do pacote (versão 1) ----------------------------------------

/// Teto do datagrama: o resto dos loops (os mais antigos) fica de fora.
const _maxLoops = 80;

/// Com [secret], o corpo vai assinado (`{"b": corpo, "m": hmac}`); sem,
/// vai o corpo puro.
Uint8List encodeTeamPacket(TeamFarmPacket p, {String secret = ''}) {
  final loops = [...p.loops]..sort((a, b) => b.lastSeen.compareTo(a.lastSeen));
  final body = jsonEncode({
    'v': 1,
    'id': p.machineId,
    'n': p.name,
    't': p.team,
    'l': [for (final l in loops.take(_maxLoops)) _loopToJson(l)],
    if (p.agents.isNotEmpty) 'ag': [for (final a in p.agents) _agentToJson(a)],
    if (p.mailPort != null) 'mp': p.mailPort,
  });
  final wire = secret.isEmpty
      ? body
      : jsonEncode({
          'b': body,
          'm': teamMac(p.team, secret, utf8.encode(body)),
        });
  return Uint8List.fromList(gzip.encode(utf8.encode(wire)));
}

/// `null` para lixo, versão desconhecida, pacote de outro programa ou
/// assinatura que não bate. Com [secret], só aceita pacote assinado com ela;
/// sem, só aceita pacote sem assinatura (times com e sem senha não se
/// misturam).
TeamFarmPacket? decodeTeamPacket(
  List<int> bytes, {
  String team = '',
  String secret = '',
  String? address,
}) {
  try {
    var o = jsonDecode(utf8.decode(gzip.decode(bytes)));
    if (o is Map && o.containsKey('m')) {
      final body = o['b'] as String;
      if (secret.isEmpty ||
          !teamMacOk(team, secret, utf8.encode(body), o['m'] as String?)) {
        return null;
      }
      o = jsonDecode(body);
    } else if (secret.isNotEmpty) {
      return null;
    }
    if (o is! Map || o['v'] != 1) return null;
    return TeamFarmPacket(
      machineId: o['id'] as String,
      name: o['n'] as String? ?? '',
      team: o['t'] as String? ?? '',
      loops: [
        for (final l in (o['l'] as List? ?? const []).whereType<Map>())
          ?_loopFromJson(l),
      ],
      agents: [
        for (final a in (o['ag'] as List? ?? const []).whereType<Map>())
          ?_agentFromJson(a),
      ],
      mailPort: o['mp'] as int?,
      address: address,
    );
  } on Object {
    return null; // FormatException, gzip inválido, tipo errado
  }
}

Map<String, Object?> _agentToJson(TeamAgent a) => {
  'id': a.tabId,
  'l': a.label,
  'h': a.harness,
  'p': a.project,
  if (a.sessionId != null) 's': a.sessionId,
};

TeamAgent? _agentFromJson(Map a) {
  final id = a['id'];
  if (id is! String) return null;
  return TeamAgent(
    tabId: id,
    label: a['l'] as String? ?? id,
    harness: a['h'] as String? ?? '',
    project: a['p'] as String? ?? '',
    sessionId: a['s'] as String?,
  );
}

Map<String, Object?> _loopToJson(FarmLoop l) => {
  'id': l.id,
  if (l.parentId != null) 'p': l.parentId,
  if (l.teammate != null) 'tm': l.teammate,
  'h': l.harness,
  'pr': l.project,
  't': l.title,
  if (l.agentType != null) 'ty': l.agentType,
  'a': l.activity.name,
  if (l.tool != null) 'tl': l.tool,
  'o': l.outputTokens,
  'c': l.contextTokens,
  'i': l.inputTokens,
  'r': l.cacheReadTokens,
  if (l.contextWindow > 0) 'cw': l.contextWindow,
  'ls': l.lastSeen.millisecondsSinceEpoch,
};

FarmLoop? _loopFromJson(Map l) {
  final id = l['id'];
  final activity = FarmActivity.values.asNameMap()[l['a']];
  if (id is! String || activity == null) return null;
  int n(Object? v) => v is int ? v : 0;
  return FarmLoop(
    id: id,
    parentId: l['p'] as String?,
    teammate: l['tm'] as String?,
    harness: l['h'] as String? ?? 'claude',
    project: l['pr'] as String? ?? '',
    title: l['t'] as String? ?? '',
    agentType: l['ty'] as String?,
    activity: activity,
    tool: l['tl'] as String?,
    outputTokens: n(l['o']),
    contextTokens: n(l['c']),
    inputTokens: n(l['i']),
    cacheReadTokens: n(l['r']),
    contextWindow: n(l['cw']),
    lastSeen: DateTime.fromMillisecondsSinceEpoch(n(l['ls'])),
  );
}
