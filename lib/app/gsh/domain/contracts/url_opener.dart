/// Abre uma URL externa (navegador/download do SO). Contrato no domínio; impl
/// (`url_launcher`) em `data/`.
abstract class UrlOpener {
  /// Abre [url]. Devolve `true` se conseguiu, `false` caso contrário.
  Future<bool> open(String url);
}
