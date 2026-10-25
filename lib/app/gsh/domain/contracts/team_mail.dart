import 'package:gsh_desktop/app/core/domain/result.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/team_farm.dart';

/// Correio entre GSHs do time: leva uma [TeamKnock] até a porta de um
/// colega e recebe as que batem na nossa. Toda batida é assinada com a senha
/// do time; sem a senha certa, não entra.
abstract interface class TeamMail {
  /// Batidas que chegaram (assinatura e reenvio já conferidos).
  Stream<TeamKnock> get knocks;

  /// Porta TCP em que este GSH recebe (`null` = correio desligado).
  int? get port;

  /// Liga (ou religa com outra senha). Sem [TeamFarmConfig.mailActive],
  /// desliga.
  Future<void> configure(TeamFarmConfig config);

  /// Entrega [knock] em `address:port`. Falha = texto para o agente que
  /// mandou (sai na CLI, não é traduzido).
  Future<Result<void, String>> send(String address, int port, TeamKnock knock);

  Future<void> close();
}
