import 'package:cockpit/app/cockpit/domain/entities/content_search.dart';

/// Busca por **conteúdo** (find-in-files): varre os arquivos da pasta e emite,
/// **incrementalmente**, os resultados por arquivo conforme acha. A impl
/// (`data/`) roda o walk + grep fora da main thread (Isolate) e respeita
/// cancelamento ao cancelar a assinatura do stream.
abstract class ContentSearcher {
  /// Stream de [FileMatches] (um evento por arquivo com ≥1 match). O stream
  /// **completa** ao fim da varredura; cancelar a assinatura aborta o trabalho.
  /// Termo vazio → stream vazio. Regex inválida → o stream emite um erro.
  Stream<FileMatches> search(ContentQuery query);
}
