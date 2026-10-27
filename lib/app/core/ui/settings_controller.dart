import 'dart:io';

import 'package:gsh_desktop/app/core/data/setup/launch_at_startup_service.dart';
import 'package:gsh_desktop/app/core/data/setup/sound_library.dart';
import 'package:gsh_desktop/app/core/data/theme_store.dart';
import 'package:gsh_desktop/app/core/domain/contracts/settings_store.dart';
import 'package:gsh_desktop/app/core/domain/result.dart';
import 'package:gsh_desktop/app/core/domain/entities/app_settings.dart';
import 'package:gsh_desktop/app/core/domain/entities/automation.dart';
import 'package:gsh_desktop/app/core/domain/entities/sound_event.dart';
import 'package:gsh_desktop/app/core/ui/themes/theme_registry.dart';
import 'package:gsh_desktop/app/core/ui/themes/theme_spec.dart';
import 'package:gsh_desktop/i18n/strings.g.dart';
import 'package:flutter/foundation.dart';

/// Estado global das preferências do app. Vive **acima do `ShadcnApp`** pra
/// trocar tema/fonte em runtime, e é lido pela tela de Configurações. Cada
/// mudança aplica na hora (notify) e persiste (Hive).
class SettingsController extends ChangeNotifier {
  SettingsController(this._store, [this._themeStore = const ThemeStore()]);

  final SettingsStore _store;
  final ThemeStore _themeStore;
  final LaunchAtStartupService _launchAtStartup = LaunchAtStartupService();
  AppSettings _settings = const AppSettings();

  AppSettings get settings => _settings;

  /// Carrega o que está salvo (chamado no boot, antes do primeiro frame).
  Future<void> load() async {
    _settings = await _store.load();
    // `main.dart` já chamou `useDeviceLocale()` como fallback; só agimos aqui
    // se há preferência explícita salva. Evita depender do
    // `WidgetsBinding` (via `useDeviceLocale`) em testes que chamam `load()`
    // sem `runApp`/`testWidgets` — `setLocaleRaw` não precisa dele.
    final locale = _settings.locale;
    if (locale != null) await LocaleSettings.setLocaleRaw(locale);
    _customThemes = await _themeStore.loadAll();
    notifyListeners();
  }

  void setThemeMode(AppThemeMode mode) =>
      _apply(_settings.copyWith(themeMode: mode));

  void setInterfaceFont(String? font) {
    final empty = font == null || font.trim().isEmpty;
    _apply(_settings.copyWith(interfaceFont: font, clearInterfaceFont: empty));
  }

  void setInterfaceSize(double size) =>
      _apply(_settings.copyWith(interfaceSize: size));

  void setCodeFont(String? font) {
    final empty = font == null || font.trim().isEmpty;
    _apply(_settings.copyWith(codeFont: font, clearCodeFont: empty));
  }

  void setCodeSize(double size) => _apply(_settings.copyWith(codeSize: size));

  void setTerminalFont(String? font) {
    final empty = font == null || font.trim().isEmpty;
    _apply(_settings.copyWith(terminalFont: font, clearTerminalFont: empty));
  }

  /// `null` volta a herdar o tamanho do código.
  void setTerminalSize(double? size) => _apply(
    _settings.copyWith(terminalSize: size, clearTerminalSize: size == null),
  );

  void setTerminalFontWeight(TerminalFontWeight weight) =>
      _apply(_settings.copyWith(terminalFontWeight: weight));

  void setTerminalEngine(TerminalEngine engine) =>
      _apply(_settings.copyWith(terminalEngine: engine));

  void setSourceControlViewMode(SourceControlViewMode mode) =>
      _apply(_settings.copyWith(sourceControlViewMode: mode));

  void setAutomationHarness(HarnessKind? id) {
    _apply(
      _settings.copyWith(
        automationHarnessId: id,
        clearAutomationHarnessId: id == null,
        clearAutomationModelId: id == null,
        // Trocar de harness volta para o padrão dele (`auto` quando existe,
        // senão o modelo que o CLI já traz): id de modelo não atravessa
        // harness, e congelar um aqui envelheceria junto com o catálogo.
        useDefaultAutomationModel: id != null,
      ),
    );
  }

  void setAutomationModel(String? id) {
    final value = id?.trim();
    _apply(
      _settings.copyWith(
        automationModelId: value,
        useDefaultAutomationModel: value == null || value.isEmpty,
      ),
    );
  }

  /// Define (ou limpa, se `null`/vazio) o perfil de terminal padrão do `+`
  /// (plano 50). Limpar = voltar ao fallback de plataforma.
  void setDefaultTerminalProfileId(String? id) {
    final empty = id == null || id.trim().isEmpty;
    _apply(
      _settings.copyWith(
        defaultTerminalProfileId: id,
        clearDefaultTerminalProfileId: empty,
      ),
    );
  }

  /// Temas importados pelo usuário. Somam-se aos built-in no [availableThemes]
  /// e são preenchidos no [load] a partir do disco.
  List<GshThemeSpec> _customThemes = const [];

  /// Catálogo completo: built-in primeiro, importados depois.
  List<GshThemeSpec> get availableThemes => [
    ...builtInThemes,
    ..._customThemes,
  ];

  /// O tema ativo. Id desconhecido (tema importado que foi removido do disco,
  /// ou arquivo de preferências vindo de outra máquina) cai no default em vez
  /// de deixar o app sem paleta.
  GshThemeSpec get activeTheme {
    for (final theme in availableThemes) {
      if (theme.id == _settings.themeId) return theme;
    }
    return gshTheme;
  }

  void setThemeId(String id) => _apply(_settings.copyWith(themeId: id));

  /// Importa um tema de [file] e já o **ativa** — quem acabou de escolher um
  /// arquivo quer ver o resultado, não ir procurar no dropdown depois.
  Future<Result<GshThemeSpec, ThemeStoreError>> importTheme(File file) async {
    final result = await _themeStore.import(file);
    if (result case Success(:final value)) {
      _customThemes = await _themeStore.loadAll();
      _apply(_settings.copyWith(themeId: value.id));
    }
    return result;
  }

  /// Exporta o tema ativo para [path]. Sempre gera arquivo completo (sem
  /// `extends`), então serve de ponto de partida para editar à mão.
  Future<Result<void, ThemeStoreError>> exportActiveTheme(String path) =>
      _themeStore.export(activeTheme, path);

  /// Remove um tema importado. Se era o ativo, volta pro default — o app nunca
  /// fica apontando para um tema que não existe mais.
  Future<Result<void, ThemeStoreError>> deleteTheme(String id) async {
    final result = await _themeStore.delete(id);
    if (result.isSuccess) {
      _customThemes = await _themeStore.loadAll();
      if (_settings.themeId == id) {
        _apply(_settings.copyWith(themeId: kDefaultThemeId));
      } else {
        notifyListeners();
      }
    }
    return result;
  }

  /// `true` quando [id] é de um tema importado (built-in não é removível).
  bool isCustomTheme(String id) => _customThemes.any((t) => t.id == id);

  /// Define (ou limpa, se `null` = "System") o idioma da interface.
  void setLocale(String? code) {
    _apply(_settings.copyWith(locale: code, clearLocale: code == null));
    _applyLocale(code);
  }

  Future<void> _applyLocale(String? code) => code == null
      ? LocaleSettings.useDeviceLocale()
      : LocaleSettings.setLocaleRaw(code);

  void setPinUserMessage(bool value) =>
      _apply(_settings.copyWith(pinUserMessage: value));

  void setLastOpenApp(String id) =>
      _apply(_settings.copyWith(lastOpenAppId: id));

  /// Define (ou limpa, se vazio) o comando do language server de [languageId].
  void setLspCommand(String languageId, String? command) {
    final next = Map<String, String>.of(_settings.lspCommands);
    final trimmed = command?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      next.remove(languageId);
    } else {
      next[languageId] = trimmed;
    }
    _apply(_settings.copyWith(lspCommands: next));
  }

  /// Define (ou limpa, se vazio) o comando de formatador externo de [languageId].
  void setLspFormatter(String languageId, String? command) {
    final next = Map<String, String>.of(_settings.lspFormatters);
    final trimmed = command?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      next.remove(languageId);
    } else {
      next[languageId] = trimmed;
    }
    _apply(_settings.copyWith(lspFormatters: next));
  }

  void setFormatOnSave(bool value) =>
      _apply(_settings.copyWith(formatOnSave: value));

  void setCloseTabOnShellExit(bool value) =>
      _apply(_settings.copyWith(closeTabOnShellExit: value));

  void setFileEditorEngine(FileEditorEngine engine) =>
      _apply(_settings.copyWith(fileEditorEngine: engine));

  void setNotificationsEnabled(bool value) =>
      _apply(_settings.copyWith(notificationsEnabled: value));

  void setSoundVolume(double value) =>
      _apply(_settings.copyWith(soundVolume: value.clamp(0, 100)));

  void setSoundEventEnabled(SoundEvent event, bool value) {
    final next = Map<SoundEvent, bool>.from(_settings.soundEvents);
    next[event] = value;
    _apply(_settings.copyWith(soundEvents: next));
  }

  void setSoundOnActiveTab(SoundEvent event, bool value) {
    final next = Map<SoundEvent, bool>.from(_settings.soundOnActiveTab);
    next[event] = value;
    _apply(_settings.copyWith(soundOnActiveTab: next));
  }

  /// Importa [sourcePath] como o áudio custom de [event]: copia pro storage do
  /// app (o original pode sumir) e persiste o caminho da cópia.
  Future<void> importSoundOverride(SoundEvent event, String sourcePath) async {
    final copy = await SoundLibrary.import(event, sourcePath);
    setSoundOverride(event, copy);
  }

  /// Volta [event] ao som embarcado: apaga a cópia custom e limpa o override.
  Future<void> clearSoundOverride(SoundEvent event) async {
    await SoundLibrary.clear(event);
    setSoundOverride(event, null);
  }

  /// Define (ou limpa, com `null`) o áudio custom de um evento. O chamador é
  /// responsável por já ter copiado o arquivo pro storage do app.
  void setSoundOverride(SoundEvent event, String? path) {
    final next = Map<SoundEvent, String>.from(_settings.soundOverrides);
    if (path == null || path.trim().isEmpty) {
      next.remove(event);
    } else {
      next[event] = path;
    }
    _apply(_settings.copyWith(soundOverrides: next));
  }

  void setSearchPanelHeight(double value) =>
      _apply(_settings.copyWith(searchPanelHeight: value));

  void setTasksPanelHeight(double value) =>
      _apply(_settings.copyWith(tasksPanelHeight: value));

  void setShowGsh(bool value) => _apply(_settings.copyWith(showGsh: value));

  /// Modo desenvolvedor (plano 68): telemetria do próprio app + métricas.
  void setDeveloperMode(bool value) =>
      _apply(_settings.copyWith(developerMode: value));

  /// Inverte o lado dos painéis laterais (workspaces à direita).
  void setSwapSidePanels(bool value) =>
      _apply(_settings.copyWith(swapSidePanels: value));

  /// Liga/desliga "iniciar com o sistema": grava a preferência na hora (UI
  /// reflete imediato) e aplica no SO em background; se o SO recusar, reconcilia
  /// a preferência com o estado efetivo lido de volta.
  void setLaunchAtStartup(bool value) {
    _apply(_settings.copyWith(launchAtStartup: value));
    _launchAtStartup.apply(value).then((effective) {
      if (effective != _settings.launchAtStartup) {
        _apply(_settings.copyWith(launchAtStartup: effective));
      }
    });
  }

  void setUpdateCheckFrequency(UpdateCheckFrequency frequency) =>
      _apply(_settings.copyWith(updateCheckFrequency: frequency));

  void setLastUpdateCheckTime(DateTime time) =>
      _apply(_settings.copyWith(lastUpdateCheckTime: time));

  void setClassifySessionStates(bool value) =>
      _apply(_settings.copyWith(classifySessionStates: value));

  void setChatRemoteControl(bool value) =>
      _apply(_settings.copyWith(chatRemoteControl: value));

  void setChatPermissionMode(String mode) {
    if (mode != _settings.chatPermissionMode) {
      _apply(_settings.copyWith(chatPermissionMode: mode));
    }
  }

  void setChatEffort(String level) {
    if (level != _settings.chatEffort) {
      _apply(_settings.copyWith(chatEffort: level));
    }
  }

  void setFarmScenery(FarmScenery scenery) =>
      _apply(_settings.copyWith(farmScenery: scenery));

  /// Vagas escolhidas para os canteiros da fazenda (`{}` = automáticas).
  void setFarmPlots(Map<String, int> plots) =>
      _apply(_settings.copyWith(farmPlots: plots));

  /// Fazenda do time: qualquer campo `null` fica como está.
  void setTeamFarm({
    bool? enabled,
    String? team,
    String? name,
    bool? showTitles,
    String? network,
    String? secret,
    bool? doorAsk,
    String? doorAllow,
  }) => _apply(
    _settings.copyWith(
      teamFarmEnabled: enabled,
      teamFarmTeam: team,
      teamFarmName: name,
      teamFarmShowTitles: showTitles,
      teamFarmNetwork: network,
      teamFarmSecret: secret,
      teamDoorAsk: doorAsk,
      teamDoorAllow: doorAllow,
    ),
  );

  /// Paleta de código do modo claro; `null` = a do tema ativo.
  void setCodeThemeLight(String? id) => _apply(
    _settings.copyWith(codeThemeLight: id, clearCodeThemeLight: id == null),
  );

  /// Paleta de código do modo escuro; `null` = a do tema ativo.
  void setCodeThemeDark(String? id) => _apply(
    _settings.copyWith(codeThemeDark: id, clearCodeThemeDark: id == null),
  );

  void setTranscriptView(TranscriptView view) =>
      _apply(_settings.copyWith(transcriptView: view));

  /// Fonte do chat; `null`/vazio = a da interface.
  void setChatFont(String? font) {
    final empty = font == null || font.trim().isEmpty;
    _apply(_settings.copyWith(chatFont: font, clearChatFont: empty));
  }

  void setTranscriptWidth(TranscriptWidth width) =>
      _apply(_settings.copyWith(transcriptWidth: width));

  void setFeatureVisible(AppFeature feature, bool visible) => _apply(
    _settings.copyWith(
      hiddenFeatures: visible
          ? (_settings.hiddenFeatures.toSet()..remove(feature))
          : {..._settings.hiddenFeatures, feature},
    ),
  );

  void setOpenLinksInApp(bool value) =>
      _apply(_settings.copyWith(openLinksInApp: value));

  /// Persiste a visibilidade dos painéis do shell (rail de projetos + árvore de
  /// arquivos) para restaurar no próximo boot. Não faz `notifyListeners` porque
  /// a fonte de verdade em runtime é a `GshViewModel` — aqui só grava.
  void setPanelVisibility({required bool rail, required bool tree}) {
    final next = _settings.copyWith(railVisible: rail, treeVisible: tree);
    _settings = next;
    _store.save(next);
  }

  void _apply(AppSettings next) {
    _settings = next;
    notifyListeners();
    // Persiste em background — falha de IO não pode travar a UI.
    _store.save(next);
  }
}
