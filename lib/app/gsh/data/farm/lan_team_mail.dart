import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:gsh_desktop/app/core/domain/result.dart';
import 'package:gsh_desktop/app/gsh/data/farm/team_signing.dart';
import 'package:gsh_desktop/app/gsh/domain/contracts/team_mail.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/team_farm.dart';

/// [TeamMail] por TCP direto na rede local: cada GSH escuta numa porta
/// livre (anunciada no pacote da fazenda do time) e quem manda abre uma
/// conexão, escreve uma linha JSON e lê uma linha de resposta.
///
/// Linha: `{"b": <corpo JSON em texto>, "m": <HMAC do corpo>}`. O corpo leva
/// o time, a hora e o id da batida: hora fora de ±5 min ou id repetido não
/// entram (reenvio de pacote capturado na rede).
class LanTeamMail implements TeamMail {
  LanTeamMail({this.maxBytes = 25 * 1024 * 1024});

  /// Teto da linha (o arquivo vai em base64 dentro dela).
  final int maxBytes;

  static const _skew = Duration(minutes: 5);
  static const _seenCap = 2000;

  final _knocks = StreamController<TeamKnock>.broadcast();
  final _seen = <String>{};
  ServerSocket? _server;
  TeamFarmConfig _config = const TeamFarmConfig();

  @override
  Stream<TeamKnock> get knocks => _knocks.stream;

  @override
  int? get port => _server?.port;

  @override
  Future<void> configure(TeamFarmConfig config) async {
    _config = config;
    if (!config.mailActive) return close();
    if (_server != null) return;
    final s = await ServerSocket.bind(InternetAddress.anyIPv4, 0);
    s.listen(_serve);
    _server = s;
  }

  Future<void> _serve(Socket socket) async {
    String reply;
    try {
      final line = await _readLine(socket);
      reply = _accept(line);
    } on Object catch (e) {
      reply = jsonEncode({'ok': false, 'error': '$e'});
    }
    try {
      socket.write('$reply\n');
      await socket.flush();
    } on SocketException {
      // quem mandou desistiu
    } finally {
      socket.destroy();
    }
  }

  Future<String> _readLine(Socket socket) async {
    final buf = BytesBuilder(copy: false);
    await for (final chunk in socket.timeout(const Duration(seconds: 30))) {
      final nl = chunk.indexOf(0x0A);
      if (nl >= 0) {
        buf.add(chunk.sublist(0, nl));
        break;
      }
      buf.add(chunk);
      if (buf.length > maxBytes) throw const FormatException('too large');
    }
    return utf8.decode(buf.takeBytes());
  }

  String _accept(String line) {
    final o = jsonDecode(line);
    if (o is! Map || o['b'] is! String) {
      return jsonEncode({'ok': false, 'error': 'bad request'});
    }
    final body = o['b'] as String;
    if (!_config.mailActive ||
        !teamMacOk(
          _config.team,
          _config.secret,
          utf8.encode(body),
          o['m'] as String?,
        )) {
      return jsonEncode({'ok': false, 'error': 'wrong team password'});
    }
    final knock = decodeKnock(body, now: DateTime.now(), skew: _skew);
    if (knock == null) {
      return jsonEncode({'ok': false, 'error': 'stale or invalid knock'});
    }
    if (!_seen.add(knock.id)) {
      return jsonEncode({'ok': false, 'error': 'duplicate knock'});
    }
    if (_seen.length > _seenCap) _seen.remove(_seen.first);
    _knocks.add(knock);
    return jsonEncode({'ok': true});
  }

  @override
  Future<Result<void, String>> send(
    String address,
    int port,
    TeamKnock knock,
  ) async {
    if (!_config.mailActive) {
      return const Failure('team mail is off (set the team password)');
    }
    final body = encodeKnock(knock, team: _config.team, at: DateTime.now());
    final line = jsonEncode({
      'b': body,
      'm': teamMac(_config.team, _config.secret, utf8.encode(body)),
    });
    if (line.length > maxBytes) return const Failure('file too large');
    Socket? s;
    try {
      s = await Socket.connect(
        address,
        port,
        timeout: const Duration(seconds: 5),
      );
      s.write('$line\n');
      await s.flush();
      final reply = await _readLine(s);
      final r = jsonDecode(reply);
      if (r is Map && r['ok'] == true) return const Success(null);
      return Failure('refused: ${r is Map ? r['error'] : reply}');
    } on Object catch (e) {
      return Failure('could not reach $address:$port ($e)');
    } finally {
      s?.destroy();
    }
  }

  @override
  Future<void> close() async {
    await _server?.close();
    _server = null;
  }
}

// ---- formato da batida (versão 1) ----------------------------------------

String encodeKnock(TeamKnock k, {required String team, required DateTime at}) =>
    jsonEncode({
      'v': 1,
      'team': team.trim(),
      'ts': at.millisecondsSinceEpoch,
      'id': k.id,
      'kind': k.kind.name,
      'fm': k.fromMachine,
      'fn': k.fromName,
      'fa': k.fromAgent,
      if (k.fromSessionId != null) 'fs': k.fromSessionId,
      'to': k.toTabId,
      'text': k.text,
      if (k.fileName != null) 'file': k.fileName,
      if (k.fileBytes != null) 'data': base64Encode(k.fileBytes!),
    });

/// `null` = versão desconhecida, hora fora da janela ou campo faltando.
TeamKnock? decodeKnock(
  String body, {
  required DateTime now,
  required Duration skew,
}) {
  try {
    final o = jsonDecode(body) as Map;
    if (o['v'] != 1) return null;
    final at = DateTime.fromMillisecondsSinceEpoch(o['ts'] as int);
    if (now.difference(at).abs() > skew) return null;
    final kind = TeamKnockKind.values.asNameMap()[o['kind']];
    if (kind == null) return null;
    final data = o['data'] as String?;
    return TeamKnock(
      id: o['id'] as String,
      kind: kind,
      fromMachine: o['fm'] as String,
      fromName: o['fn'] as String? ?? '',
      fromAgent: o['fa'] as String? ?? '',
      fromSessionId: o['fs'] as String?,
      toTabId: o['to'] as String,
      text: o['text'] as String? ?? '',
      fileName: o['file'] as String?,
      fileBytes: data == null ? null : base64Decode(data),
    );
  } on Object {
    return null;
  }
}
