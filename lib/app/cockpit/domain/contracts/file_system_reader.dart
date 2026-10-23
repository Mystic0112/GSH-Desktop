import 'package:cockpit/app/cockpit/domain/entities/file_node.dart';

/// Leitura read-only da árvore de arquivos (o cockpit observa, não edita).
/// Contrato no domínio; impl (dart:io) em `data/filesystem/`.
abstract class FileSystemReader {
  /// Filhos imediatos de [dirPath] — pastas primeiro, ordenado, sem ocultos.
  Future<List<FileNode>> children(String dirPath);
}
