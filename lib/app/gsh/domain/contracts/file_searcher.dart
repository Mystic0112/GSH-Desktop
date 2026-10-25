/// Busca arquivos de uma pasta para o autocomplete do `@` no input do agente.
/// Contrato no domínio; a impl (walk + cache do filesystem) mora em `data/`.
abstract class FileSearcher {
  /// Caminhos de **arquivo relativos a [root]** que casam com [query] (vazio =
  /// os primeiros), ordenados por relevância e limitados a [limit].
  Future<List<String>> search(String root, String query, {int limit});
}
