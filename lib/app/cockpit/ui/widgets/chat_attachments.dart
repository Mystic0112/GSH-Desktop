import 'dart:io';

import 'package:cockpit/app/cockpit/domain/entities/chat_attachment.dart';
import 'package:cockpit/app/cockpit/ui/viewmodels/chat_viewmodel.dart';
import 'package:cockpit/app/core/ui/themes/themes.dart';
import 'package:cockpit/app/core/ui/widgets/hover_tap.dart';
import 'package:cockpit/app/core/utils/path_utils.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:pasteboard/pasteboard.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

/// Escolhe arquivos no seletor do SO e anexa.
Future<void> pickChatAttachments(ChatController chat) async {
  final result = await FilePicker.platform.pickFiles(allowMultiple: true);
  final paths = [
    for (final f in result?.files ?? const <PlatformFile>[])
      if (f.path != null) normalizePath(f.path!),
  ];
  if (paths.isNotEmpty) chat.attachFiles(paths);
}

/// Ctrl+V no composer: imagem na área de transferência vira anexo; senão cola
/// o texto no campo, no lugar da seleção.
Future<void> pasteIntoChat(
  ChatController chat,
  TextEditingController input,
) async {
  final image = await Pasteboard.image;
  if (image != null && image.isNotEmpty) {
    chat.attachPastedImage(image);
    return;
  }
  final text = (await Clipboard.getData(Clipboard.kTextPlain))?.text;
  if (text == null || text.isEmpty) return;
  final sel = input.selection;
  final value = input.text;
  final start = sel.isValid ? sel.start : value.length;
  final end = sel.isValid ? sel.end : value.length;
  input.value = TextEditingValue(
    text: value.replaceRange(start, end, text),
    selection: TextSelection.collapsed(offset: start + text.length),
  );
}

/// Soltar arquivos do SO em cima do chat anexa (pastas são ignoradas).
class ChatDropZone extends StatefulWidget {
  const ChatDropZone({super.key, required this.chat, required this.child});
  final ChatController chat;
  final Widget child;

  @override
  State<ChatDropZone> createState() => _ChatDropZoneState();
}

class _ChatDropZoneState extends State<ChatDropZone> {
  bool _over = false;

  void _setOver(bool v) {
    if (_over != v) setState(() => _over = v);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return DropTarget(
      onDragEntered: (_) => _setOver(true),
      onDragUpdated: (_) => _setOver(true),
      onDragExited: (_) => _setOver(false),
      onDragDone: (d) {
        _setOver(false);
        widget.chat.attachFiles([
          for (final f in d.files)
            if (!Directory(f.path).existsSync()) normalizePath(f.path),
        ]);
      },
      child: Stack(
        children: [
          widget.child,
          if (_over)
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: colors.accentSoft,
                    border: Border.all(color: colors.accent, width: 2),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Os anexos como fichas. [onRemove] `null` = só leitura (mensagem enviada).
class ChatAttachmentChips extends StatelessWidget {
  const ChatAttachmentChips({
    super.key,
    required this.attachments,
    this.onRemove,
  });
  final List<ChatAttachment> attachments;
  final void Function(ChatAttachment)? onRemove;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        for (final a in attachments)
          Container(
            padding: const EdgeInsets.fromLTRB(4, 4, 8, 4),
            decoration: BoxDecoration(
              color: colors.panel2,
              border: Border.all(color: colors.border),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _Thumb(a),
                const SizedBox(width: 6),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 200),
                  child: Text(
                    a.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.typo.label.copyWith(color: colors.text),
                  ),
                ),
                if (onRemove case final remove?) ...[
                  const SizedBox(width: 4),
                  HoverTap(
                    onTap: () => remove(a),
                    hoverColor: colors.panel3,
                    borderRadius: BorderRadius.circular(4),
                    child: Icon(Icons.close, size: 14, color: colors.text3),
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

class _Thumb extends StatelessWidget {
  const _Thumb(this.a);
  final ChatAttachment a;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    if (a.kind == ChatAttachmentKind.image) {
      final image = a.bytes != null
          ? Image.memory(a.bytes!, width: 24, height: 24, fit: BoxFit.cover)
          : Image.file(File(a.path!), width: 24, height: 24, fit: BoxFit.cover);
      return ClipRRect(borderRadius: BorderRadius.circular(3), child: image);
    }
    return SizedBox.square(
      dimension: 24,
      child: Icon(
        a.kind == ChatAttachmentKind.pdf
            ? Icons.picture_as_pdf_outlined
            : Icons.description_outlined,
        size: 16,
        color: colors.text3,
      ),
    );
  }
}
