import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cockpit/app/cockpit/domain/contracts/update_checker.dart';
import 'package:cockpit/app/cockpit/domain/entities/update_info.dart';

/// Busca o `latest.json` via HTTP (dart:io, sem dep extra). Timeout curto;
/// qualquer falha → `null` (nunca lança), pra que o aviso seja totalmente
/// silencioso quando offline/indisponível.
class UpdateCheckerImpl implements UpdateChecker {
  const UpdateCheckerImpl({
    this.manifestUrl = defaultManifestUrl,
    this.timeout = const Duration(seconds: 5),
  });

  static const String defaultManifestUrl =
      'https://rp-s3.jacobmoura.work/downloads/cockpit/latest.json';

  final String manifestUrl;
  final Duration timeout;

  @override
  Future<UpdateInfo?> fetchLatest() async {
    final client = HttpClient()..connectionTimeout = timeout;
    try {
      final request = await client
          .getUrl(Uri.parse(manifestUrl))
          .timeout(timeout);
      final response = await request.close().timeout(timeout);
      if (response.statusCode != 200) {
        await response.drain<void>();
        return null;
      }
      final body = await response
          .transform(utf8.decoder)
          .join()
          .timeout(timeout);
      return UpdateInfo.fromJson(jsonDecode(body));
    } catch (_) {
      // sem rede / 404 / JSON inválido / schema errado → silencioso.
      return null;
    } finally {
      client.close(force: true);
    }
  }
}
