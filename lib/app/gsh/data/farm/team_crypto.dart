import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:pointycastle/export.dart';

/// Cifra do time: AES-256-GCM (cifra + autentica) com a chave derivada da
/// senha por PBKDF2-HMAC-SHA256, salgada com o nome do time — mesma senha em
/// times diferentes dá chave diferente. Quem não tem a senha não lê nem
/// forja o anúncio da fazenda nem as mensagens do correio.
///
/// Formato: `[2][nonce de 12 bytes][cifrado + tag de 16 bytes]`.
const _version = 2;
const _nonceLength = 12;
const _iterations = 100000;
final _aad = Uint8List.fromList(utf8.encode('gsh-team-v2'));
final _random = Random.secure();

/// PBKDF2 é lento de propósito: deriva uma vez por (time, senha).
final _keys = <(String, String), Uint8List>{};

Uint8List _key(String team, String secret) => _keys[(team.trim(), secret)] ??=
    (PBKDF2KeyDerivator(HMac(SHA256Digest(), 64))..init(
          Pbkdf2Parameters(
            Uint8List.fromList(utf8.encode('gsh-team\n${team.trim()}')),
            _iterations,
            32,
          ),
        ))
        .process(Uint8List.fromList(utf8.encode(secret)));

GCMBlockCipher _gcm(bool encrypt, Uint8List key, Uint8List nonce) =>
    GCMBlockCipher(AESEngine())
      ..init(encrypt, AEADParameters(KeyParameter(key), 128, nonce, _aad));

/// Cifra [plain] para o time.
Uint8List teamSeal(String team, String secret, List<int> plain) {
  final nonce = Uint8List.fromList(
    List.generate(_nonceLength, (_) => _random.nextInt(256)),
  );
  final sealed = _gcm(
    true,
    _key(team, secret),
    nonce,
  ).process(Uint8List.fromList(plain));
  return (BytesBuilder(copy: false)
        ..addByte(_version)
        ..add(nonce)
        ..add(sealed))
      .takeBytes();
}

/// Abre o que [teamSeal] cifrou. `null` = outra senha/time, adulterado ou
/// não é deste formato.
Uint8List? teamOpen(String team, String secret, List<int> data) {
  if (data.length < 1 + _nonceLength + 16 || data[0] != _version) return null;
  final bytes = Uint8List.fromList(data);
  try {
    return _gcm(
      false,
      _key(team, secret),
      bytes.sublist(1, 1 + _nonceLength),
    ).process(bytes.sublist(1 + _nonceLength));
  } on InvalidCipherTextException {
    return null;
  } on ArgumentError {
    return null;
  }
}
