import 'dart:typed_data';

enum ChatAttachmentKind {
  /// Vai como bloco `image` (o modelo vê a imagem).
  image,

  /// Vai como bloco `document` (PDF).
  pdf,

  /// Vai como menção `@"caminho"` no texto: o Claude Code lê o arquivo.
  file,
}

/// Um anexo da mensagem: arquivo do disco ([path]) ou imagem colada
/// ([bytes], sem caminho).
class ChatAttachment {
  const ChatAttachment._({
    required this.kind,
    required this.name,
    this.path,
    this.bytes,
    this.mediaType,
  });

  /// Arquivo do disco; o tipo sai da extensão.
  factory ChatAttachment.file(String path) {
    final name = path.split(RegExp(r'[/\\]')).last;
    final ext = name.contains('.') ? name.split('.').last.toLowerCase() : '';
    final image = _imageTypes[ext];
    if (image != null) {
      return ChatAttachment._(
        kind: ChatAttachmentKind.image,
        name: name,
        path: path,
        mediaType: image,
      );
    }
    if (ext == 'pdf') {
      return ChatAttachment._(
        kind: ChatAttachmentKind.pdf,
        name: name,
        path: path,
        mediaType: 'application/pdf',
      );
    }
    return ChatAttachment._(
      kind: ChatAttachmentKind.file,
      name: name,
      path: path,
    );
  }

  /// Imagem colada da área de transferência (o `Pasteboard` entrega PNG).
  factory ChatAttachment.pastedImage(Uint8List png, {required String name}) =>
      ChatAttachment._(
        kind: ChatAttachmentKind.image,
        name: name,
        bytes: png,
        mediaType: 'image/png',
      );

  static const _imageTypes = {
    'png': 'image/png',
    'jpg': 'image/jpeg',
    'jpeg': 'image/jpeg',
    'gif': 'image/gif',
    'webp': 'image/webp',
  };

  /// Tetos da API: imagem acima disso é recusada; PDF idem.
  static const maxImageBytes = 5 * 1024 * 1024;
  static const maxPdfBytes = 32 * 1024 * 1024;

  final ChatAttachmentKind kind;
  final String name;
  final String? path;
  final Uint8List? bytes;
  final String? mediaType;
}

/// Anexo que passa do tamanho que a API aceita.
class ChatAttachmentTooLarge implements Exception {
  const ChatAttachmentTooLarge(this.name);
  final String name;
}
