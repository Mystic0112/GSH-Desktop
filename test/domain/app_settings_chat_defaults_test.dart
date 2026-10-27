import 'package:gsh_desktop/app/core/domain/entities/app_settings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('chat: modo e esforço padrão, e lembrados entre aberturas', () {
    final fresh = AppSettings.fromJson(const <String, dynamic>{});
    expect((fresh.chatPermissionMode, fresh.chatEffort), ('default', 'high'));
    final chosen = AppSettings.fromJson(
      const AppSettings(
        chatPermissionMode: 'bypassPermissions',
        chatEffort: 'max',
      ).toJson(),
    );
    expect(
      (chosen.chatPermissionMode, chosen.chatEffort),
      ('bypassPermissions', 'max'),
    );
  });
}
