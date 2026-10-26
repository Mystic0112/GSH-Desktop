import 'package:gsh_desktop/app/gsh/domain/entities/project_harness.dart';

/// O harness de um workspace: o que o agente carrega ao rodar ali.
abstract interface class HarnessSource {
  Future<ProjectHarness> read(String workspace);

  /// Cria o arquivo de um item novo a partir de um modelo e devolve o
  /// caminho (já existindo, só devolve). [name] vale para skill, subagente e
  /// comando; instruções, hooks, permissões e MCP abrem o arquivo da seção
  /// (criado vazio-válido se faltar).
  Future<String> create(String workspace, HarnessKind kind, {String? name});
}
