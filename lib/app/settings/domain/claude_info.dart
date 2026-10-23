import 'package:cockpit/app/core/domain/result.dart';

/// Informações do Claude Code da máquina (CLI `claude` e `~/.claude`) que as
/// abas Conta, Uso, Memória, Skills, Conectores, Plugins e Desenvolvedor
/// mostram. Só leitura, exceto [logout] e [writeUserInstructions]; o que
/// instala/autentica roda num terminal (o usuário vê e responde).
///
/// ponytail: um contrato só para as abas do grupo Claude — todas falam com a
/// mesma CLI/pasta; separe por aba se uma delas ganhar escrita própria.
abstract interface class ClaudeInfoSource {
  /// `claude auth status --json`.
  Future<Result<ClaudeAccount, ClaudeInfoError>> account();

  /// `claude auth logout`.
  Future<Result<void, ClaudeInfoError>> logout();

  /// Limites do plano claude.ai (`get_usage` num processo headless).
  Future<Result<ClaudeUsage, ClaudeInfoError>> usage();

  /// `claude mcp list` (faz o health-check de cada servidor; pode demorar).
  Future<Result<List<McpServerInfo>, ClaudeInfoError>> mcpServers();

  /// `claude plugin list --json`, com nome/autor/descrição do manifesto.
  Future<Result<List<ClaudePluginInfo>, ClaudeInfoError>> plugins();

  /// Plugins oferecidos pelos marketplaces adicionados (`marketplace.json`
  /// de cada um), marcando os já instalados.
  Future<Result<List<MarketplacePlugin>, ClaudeInfoError>> directory();

  /// Skills do usuário (`~/.claude/skills`), dos plugins habilitados e do
  /// projeto ([workspace]`/.claude/skills`).
  Future<Result<List<ClaudeSkillInfo>, ClaudeInfoError>> skills(
    String? workspace,
  );

  /// Arquivos de instrução (CLAUDE.md) que uma sessão aberta em [workspace]
  /// carregaria. Só os que existem.
  Future<List<MemoryFileInfo>> memoryFiles(String? workspace);

  /// Memória automática do Claude Code para [workspace]
  /// (`~/.claude/projects/<slug>/memory/MEMORY.md` e os arquivos dela).
  Future<List<AutoMemoryEntry>> autoMemory(String? workspace);

  /// Estilos de saída disponíveis além do padrão (embutidos + os de
  /// `~/.claude/output-styles`).
  Future<List<String>> outputStyles();

  /// Plugins habilitados em [workspace]`/.claude/settings.json`.
  Future<List<String>> projectPlugins(String workspace);

  /// Conteúdo do `~/.claude/CLAUDE.md` ("" se não existe).
  Future<String> readUserInstructions();

  /// Regrava o `~/.claude/CLAUDE.md` (cria se faltar).
  Future<Result<void, ClaudeInfoError>> writeUserInstructions(String text);
}

/// O que deu errado ao consultar a CLI. Sem frase: a UI traduz.
enum ClaudeInfoErrorKind { cliMissing, failed, timeout }

class ClaudeInfoError implements Exception {
  const ClaudeInfoError(this.kind, [this.detail]);
  final ClaudeInfoErrorKind kind;

  /// Texto cru de terceiros (stderr da CLI), mostrado sem tradução.
  final String? detail;

  @override
  String toString() => 'ClaudeInfoError($kind, $detail)';
}

class ClaudeAccount {
  const ClaudeAccount({
    required this.loggedIn,
    this.authMethod,
    this.apiProvider,
    this.email,
    this.orgId,
    this.orgName,
    this.subscriptionType,
  });
  final bool loggedIn;
  final String? authMethod;
  final String? apiProvider;
  final String? email;
  final String? orgId;
  final String? orgName;
  final String? subscriptionType;
}

/// Qual janela de limite uma barra representa.
enum UsageWindowKind { session, weekly, weeklyModel }

class UsageWindow {
  const UsageWindow({
    required this.kind,
    this.label,
    this.percent,
    this.resetsAt,
  });
  final UsageWindowKind kind;

  /// Nome do modelo (só em [UsageWindowKind.weeklyModel]).
  final String? label;

  /// 0–100; `null` quando o servidor não informou.
  final double? percent;
  final DateTime? resetsAt;
}

class ClaudeUsage {
  const ClaudeUsage({
    required this.available,
    this.subscriptionType,
    this.windows = const [],
  });

  /// `false` = limites de plano não se aplicam (chave de API, Bedrock...).
  final bool available;
  final String? subscriptionType;
  final List<UsageWindow> windows;
}

enum McpStatus { connected, needsAuth, failed, pending, unknown }

/// De onde vem um servidor MCP (decide o selo na lista).
enum McpOrigin { local, claudeAi, plugin }

class McpServerInfo {
  const McpServerInfo({
    required this.name,
    required this.target,
    required this.status,
    required this.statusText,
  });

  /// Nome como a CLI imprime (`claude.ai Notion`, `plugin:x:y`, `iris`) — é
  /// o que `claude mcp login` espera.
  final String name;

  /// URL ou comando do servidor, como a CLI imprime.
  final String target;
  final McpStatus status;

  /// Status cru da CLI (detalhe de falha, aprovação pendente...).
  final String statusText;

  McpOrigin get origin => name.startsWith('claude.ai ')
      ? McpOrigin.claudeAi
      : name.startsWith('plugin:')
      ? McpOrigin.plugin
      : McpOrigin.local;

  /// Nome para exibir: sem o prefixo `claude.ai ` e sem o `plugin:<p>:`.
  String get displayName => switch (origin) {
    McpOrigin.claudeAi => name.substring('claude.ai '.length),
    McpOrigin.plugin => name.split(':').last,
    McpOrigin.local => name,
  };

  /// HTTP/SSE (web) em vez de um processo local (stdio).
  bool get isRemote => target.startsWith('http://') ||
      target.startsWith('https://');

  /// Comando e argumentos de um servidor stdio (o primeiro token é o
  /// executável). ponytail: split por espaço — caminho com espaço quebra;
  /// troque por `claude mcp get` se aparecer.
  (String command, String args) get commandLine {
    final i = target.indexOf(' ');
    return i < 0
        ? (target, '')
        : (target.substring(0, i), target.substring(i + 1));
  }
}

class ClaudePluginInfo {
  const ClaudePluginInfo({
    required this.id,
    required this.enabled,
    this.version,
    this.scope,
    this.installPath,
    this.updatedAt,
    this.displayName,
    this.author,
    this.description,
  });

  /// `nome@marketplace`.
  final String id;
  final bool enabled;
  final String? version;
  final String? scope;
  final String? installPath;
  final DateTime? updatedAt;

  /// Do `plugin.json` (quando existe).
  final String? displayName;
  final String? author;
  final String? description;

  String get name => displayName ?? id.split('@').first;
  String get marketplace => id.contains('@') ? id.split('@').last : '';

  ClaudePluginInfo withManifest({
    String? displayName,
    String? author,
    String? description,
  }) => ClaudePluginInfo(
    id: id,
    enabled: enabled,
    version: version,
    scope: scope,
    installPath: installPath,
    updatedAt: updatedAt,
    displayName: displayName ?? this.displayName,
    author: author ?? this.author,
    description: description ?? this.description,
  );
}

/// Plugin oferecido por um marketplace adicionado (aba Descobrir).
class MarketplacePlugin {
  const MarketplacePlugin({
    required this.name,
    required this.marketplace,
    this.description,
    this.author,
    this.category,
    this.installed = false,
  });
  final String name;
  final String marketplace;
  final String? description;
  final String? author;
  final String? category;
  final bool installed;

  /// O que `claude plugin install` espera.
  String get id => '$name@$marketplace';
}

enum SkillSource { user, plugin, project }

class ClaudeSkillInfo {
  const ClaudeSkillInfo({
    required this.name,
    required this.path,
    this.source = SkillSource.user,
    this.description,
    this.plugin,
    this.updatedAt,
  });
  final String name;
  final String? description;

  /// Caminho do `SKILL.md`.
  final String path;
  final SkillSource source;

  /// Id do plugin dono (só em [SkillSource.plugin]).
  final String? plugin;
  final DateTime? updatedAt;
}

enum MemoryScope { user, project }

class MemoryFileInfo {
  const MemoryFileInfo({required this.path, required this.scope});
  final String path;
  final MemoryScope scope;
}

/// Uma linha do `MEMORY.md` (`- [Título](arquivo.md) — gancho`), com o tipo
/// do frontmatter do arquivo e a data da última mudança.
class AutoMemoryEntry {
  const AutoMemoryEntry({
    required this.title,
    required this.path,
    this.hook,
    this.type,
    this.updatedAt,
  });
  final String title;
  final String path;
  final String? hook;

  /// `user`, `feedback`, `project`, `reference`… (frontmatter).
  final String? type;
  final DateTime? updatedAt;
}
