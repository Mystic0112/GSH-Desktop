import 'package:gsh_desktop/app/core/domain/entities/app_settings.dart';

/// Visibilidade das opções que controlam o editor integrado. O tamanho de
/// código continua exposto quando ainda é a fonte do tamanho do terminal.
abstract final class EditorAppearancePolicy {
  static bool showCodeFont(AppSettings settings) =>
      settings.fileEditorEngine == FileEditorEngine.gsh;

  static bool showCodeSize(AppSettings settings) =>
      settings.fileEditorEngine == FileEditorEngine.gsh ||
      settings.terminalSize == null;
}
