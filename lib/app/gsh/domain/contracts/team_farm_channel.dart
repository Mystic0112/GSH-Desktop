import 'package:gsh_desktop/app/gsh/domain/entities/team_farm.dart';

/// Canal da fazenda do time: anuncia a fazenda local e recebe a dos colegas.
/// Sem servidor — quem implementa decide o transporte (hoje, multicast na
/// rede local).
abstract interface class TeamFarmChannel {
  /// Pacotes de outros GSHs (o eco do próprio já vem filtrado).
  Stream<TeamFarmPacket> get packets;

  /// Identificador desta instância, para os pacotes que ela manda.
  String get machineId;

  /// Liga o canal na [config]. Chamar de novo troca a config.
  Future<void> open(TeamFarmConfig config);

  Future<void> publish(TeamFarmPacket packet);

  Future<void> close();
}
