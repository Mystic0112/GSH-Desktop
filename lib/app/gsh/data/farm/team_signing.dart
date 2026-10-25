import 'dart:convert';

import 'package:crypto/crypto.dart';

/// Assinatura HMAC-SHA256 das mensagens do time. A chave junta o nome do
/// time e a senha: mesma senha em times diferentes não se confunde.
String teamMac(String team, String secret, List<int> body) => Hmac(
  sha256,
  utf8.encode('${team.trim()}\n$secret'),
).convert(body).toString();

/// Confere [mac] em tempo constante (não vaza quantos dígitos acertou).
bool teamMacOk(String team, String secret, List<int> body, String? mac) {
  if (mac == null) return false;
  final want = teamMac(team, secret, body);
  if (want.length != mac.length) return false;
  var diff = 0;
  for (var i = 0; i < want.length; i++) {
    diff |= want.codeUnitAt(i) ^ mac.codeUnitAt(i);
  }
  return diff == 0;
}
