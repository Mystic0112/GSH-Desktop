import 'package:gsh_desktop/app/gsh/domain/entities/desktop_agent_app.dart';
import 'package:gsh_desktop/app/core/domain/result.dart';

/// Apps desktop de agente (Claude Desktop, Cursor, Antigravity, Codex/ChatGPT)
/// como nós externos do grafo: detecção, a entrada MCP no config de cada um e
/// abrir/trazer o app pra frente.
abstract class DesktopAgentApps {
  /// Apps instalados nesta máquina, com o config e a entrada que a integração
  /// grava (o dialog mostra antes de gravar).
  Future<List<DesktopAppIntegration>> detect();

  /// Backup do config (`<arquivo>.gsh-bak-<timestamp>`) e merge só da
  /// entrada `gsh`. Idempotente; nunca toca os outros servidores.
  Future<Result<void, DesktopAppError>> install(DesktopAppIntegration app);

  /// Abre o app (ou traz pra frente, se já aberto). IDEs recebem [folder].
  Future<void> launch(DesktopAgentApp app, String folder);
}
