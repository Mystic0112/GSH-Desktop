import 'package:cockpit/app/core/domain/result.dart';
import 'package:cockpit/app/settings/domain/claude_info.dart';
import 'package:flutter/foundation.dart';

/// Estado de uma consulta à CLI: ainda não pedida, carregando, ou o último
/// resultado (valor ou erro tipado).
class InfoLoad<T> {
  const InfoLoad._(this.loading, this.result, [this.at]);
  const InfoLoad.idle() : this._(false, null);

  final bool loading;
  final Result<T, ClaudeInfoError>? result;

  /// Quando o [result] chegou.
  final DateTime? at;

  T? get value => switch (result) {
    Success(:final value) => value,
    _ => null,
  };
  ClaudeInfoError? get error => switch (result) {
    Failure(:final error) => error,
    _ => null,
  };
}

/// Dados do Claude Code das abas do grupo Claude (Conta, Uso, Memória,
/// Skills, Conectores, Plugins, Desenvolvedor). Page-scoped: cada aba pede o
/// seu ao montar e o botão "Atualizar" força a releitura; trocar de aba e
/// voltar não roda a CLI de novo.
class ClaudeInfoViewModel extends ChangeNotifier {
  ClaudeInfoViewModel(this._source);

  final ClaudeInfoSource _source;
  bool _disposed = false;

  InfoLoad<ClaudeAccount> account = const InfoLoad.idle();
  InfoLoad<ClaudeUsage> usage = const InfoLoad.idle();
  InfoLoad<List<McpServerInfo>> mcp = const InfoLoad.idle();
  InfoLoad<List<ClaudePluginInfo>> plugins = const InfoLoad.idle();
  InfoLoad<List<MarketplacePlugin>> directory = const InfoLoad.idle();
  InfoLoad<List<ClaudeSkillInfo>> skills = const InfoLoad.idle();
  List<MemoryFileInfo>? memory;
  List<AutoMemoryEntry>? autoMemory;
  List<String>? outputStyles;
  List<String>? projectPlugins;

  /// `~/.claude/CLAUDE.md` como está no disco (`null` = ainda lendo).
  String? instructions;

  /// Falha do último "Sair" / da última gravação das instruções.
  ClaudeInfoError? logoutError;
  ClaudeInfoError? instructionsError;

  Future<void> loadAccount({bool force = false}) =>
      _load(account, force, _source.account, (v) => account = v);
  Future<void> loadUsage({bool force = false}) =>
      _load(usage, force, _source.usage, (v) => usage = v);
  Future<void> loadMcp({bool force = false}) =>
      _load(mcp, force, _source.mcpServers, (v) => mcp = v);
  Future<void> loadPlugins({bool force = false}) =>
      _load(plugins, force, _source.plugins, (v) => plugins = v);
  Future<void> loadDirectory({bool force = false}) =>
      _load(directory, force, _source.directory, (v) => directory = v);
  Future<void> loadSkills(String? workspace, {bool force = false}) =>
      _load(skills, force, () => _source.skills(workspace), (v) => skills = v);

  /// Instruções + memória automática do workspace ativo (aba Memória).
  Future<void> loadMemory(String? workspace) async {
    final files = await _source.memoryFiles(workspace);
    final auto = await _source.autoMemory(workspace);
    if (_disposed) return;
    memory = files;
    autoMemory = auto;
    notifyListeners();
  }

  Future<void> loadOutputStyles() async {
    final styles = await _source.outputStyles();
    if (_disposed) return;
    outputStyles = styles;
    notifyListeners();
  }

  Future<void> loadProjectPlugins(String? workspace) async {
    final ids = workspace == null
        ? const <String>[]
        : await _source.projectPlugins(workspace);
    if (_disposed) return;
    projectPlugins = ids;
    notifyListeners();
  }

  Future<void> loadInstructions() async {
    final text = await _source.readUserInstructions();
    if (_disposed) return;
    instructions = text;
    notifyListeners();
  }

  Future<void> saveInstructions(String text) async {
    if (text == instructions) return;
    final r = await _source.writeUserInstructions(text);
    if (_disposed) return;
    instructionsError = switch (r) {
      Failure(:final error) => error,
      _ => null,
    };
    if (r.isSuccess) instructions = text;
    notifyListeners();
  }

  Future<void> logout() async {
    final r = await _source.logout();
    if (_disposed) return;
    logoutError = switch (r) {
      Failure(:final error) => error,
      _ => null,
    };
    await loadAccount(force: true);
  }

  Future<void> _load<T>(
    InfoLoad<T> current,
    bool force,
    Future<Result<T, ClaudeInfoError>> Function() fetch,
    void Function(InfoLoad<T>) set,
  ) async {
    if (current.loading || (!force && current.result != null)) return;
    set(InfoLoad._(true, current.result, current.at));
    notifyListeners();
    final r = await fetch();
    if (_disposed) return;
    set(InfoLoad._(false, r, DateTime.now()));
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
