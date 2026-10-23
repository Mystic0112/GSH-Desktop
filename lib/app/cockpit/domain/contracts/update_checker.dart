import 'package:cockpit/app/cockpit/domain/entities/update_info.dart';

/// Busca o manifest de release (`latest.json`). Contrato no domínio; impl
/// (HTTP) em `data/`. **Best-effort**: qualquer falha (sem rede, 404, JSON
/// inválido, schema errado) devolve `null` — nunca lança.
abstract class UpdateChecker {
  Future<UpdateInfo?> fetchLatest();
}
