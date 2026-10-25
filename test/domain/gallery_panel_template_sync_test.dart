import 'dart:io';

import 'package:gsh_desktop/app/gsh/domain/entities/gallery_template.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'template "panel" da Galeria == cli/skills/gsh-design/templates/dashboard.panel',
    () {
      final file = File('cli/skills/gsh-design/templates/dashboard.panel');
      expect(
        file.existsSync(),
        isTrue,
        reason: 'rode o teste da raiz de gsh/',
      );
      expect(GalleryTemplate.panel.content, file.readAsStringSync());
    },
  );
}
