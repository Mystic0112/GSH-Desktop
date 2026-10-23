/// Um item da árvore de arquivos (pasta ou arquivo).
class FileNode {
  const FileNode({
    required this.name,
    required this.path,
    required this.isDirectory,
  });

  final String name;
  final String path;
  final bool isDirectory;
}
