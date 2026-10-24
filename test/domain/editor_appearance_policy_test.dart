import 'package:gsh_desktop/app/core/domain/entities/app_settings.dart';
import 'package:gsh_desktop/app/settings/domain/editor_appearance_policy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('GSH engine exposes both code appearance settings', () {
    const settings = AppSettings(fileEditorEngine: FileEditorEngine.gsh);
    expect(EditorAppearancePolicy.showCodeFont(settings), isTrue);
    expect(EditorAppearancePolicy.showCodeSize(settings), isTrue);
  });

  test('external engine hides code font and explicit code size', () {
    const settings = AppSettings(
      fileEditorEngine: FileEditorEngine.neovim,
      terminalSize: 15,
    );
    expect(EditorAppearancePolicy.showCodeFont(settings), isFalse);
    expect(EditorAppearancePolicy.showCodeSize(settings), isFalse);
  });

  test('external engine keeps code size while terminal inherits it', () {
    const settings = AppSettings(fileEditorEngine: FileEditorEngine.neovim);
    expect(EditorAppearancePolicy.showCodeFont(settings), isFalse);
    expect(EditorAppearancePolicy.showCodeSize(settings), isTrue);
  });
}
