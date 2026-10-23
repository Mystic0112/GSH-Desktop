import 'package:cockpit/app/cockpit/domain/entities/git_info.dart';

/// Lê o estado git de uma pasta. Contrato no domínio; a impl (roda `git`) mora
/// em `data/`.
abstract class GitStatusReader {
  /// [GitInfo] do repo em [path], ou `null` se a pasta **não** é repositório git
  /// (ou o git não está disponível).
  Future<GitInfo?> read(String path);
}
