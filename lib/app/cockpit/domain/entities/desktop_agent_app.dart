import 'package:cockpit/app/core/domain/entities/harness.dart';

/// App desktop de agente que entra no grafo como nó **externo**, falando com o
/// Cockpit pelo servidor MCP da CLI (`cockpit mcp --agent <id>`). [id] é o
/// mesmo do `--agent` (ver `cli/src/mcp.rs`).
enum DesktopAgentApp {
  claudeDesktop('claude-desktop', 'Claude Desktop', HarnessKind.claudeCode),
  cursor('cursor', 'Cursor', HarnessKind.cursor),
  antigravityIde('antigravity-ide', 'Antigravity', HarnessKind.antigravity),
  // O Codex desktop é o app do ChatGPT.
  codexDesktop('codex-desktop', 'Codex (ChatGPT)', HarnessKind.codex);

  const DesktopAgentApp(this.id, this.label, this.icon);

  final String id;

  /// Nome próprio (não se traduz).
  final String label;

  /// Harness cujo logo o nó usa.
  final HarnessKind icon;

  /// Abre com a pasta do workspace como argumento (IDEs).
  bool get opensFolder => this == cursor || this == antigravityIde;

  /// Config MCP em TOML (`[mcp_servers.<nome>]`); os demais são JSON
  /// (`{"mcpServers": {...}}`).
  bool get tomlConfig => this == codexDesktop;

  static DesktopAgentApp? fromId(String? id) {
    for (final a in values) {
      if (a.id == id) return a;
    }
    return null;
  }
}

/// App detectado + onde e o que a integração grava (o dialog mostra antes).
class DesktopAppIntegration {
  const DesktopAppIntegration({
    required this.app,
    required this.configPath,
    required this.entry,
  });
  final DesktopAgentApp app;
  final String configPath;

  /// Trecho exato que entra no config (`"cockpit": {...}` ou a tabela TOML).
  final String entry;
}

enum DesktopAppErrorKind {
  /// O config existe mas não é JSON/TOML que dê pra editar com segurança.
  invalidConfig,

  /// A CLI `cockpit` ainda não foi instalada em `~/.cockpit/bin`.
  cliMissing,

  /// Erro de IO ao fazer backup/gravar.
  writeFailed,
}

/// Falha da integração; a UI traduz ([detail] = caminho ou mensagem do SO).
class DesktopAppError implements Exception {
  const DesktopAppError(this.kind, {this.detail});
  final DesktopAppErrorKind kind;
  final String? detail;
}
