import 'package:gsh_desktop/app/gsh/domain/entities/farm_loop.dart';

/// O que um GSH anuncia para o time na rede local: quem é e os loops de
/// agente dele, já filtrados pela privacidade de quem mandou.
class TeamFarmPacket {
  const TeamFarmPacket({
    required this.machineId,
    required this.name,
    required this.team,
    required this.loops,
  });

  /// Identifica a instância (descarta o eco do próprio pacote).
  final String machineId;

  /// Nome que aparece em cima da fazenda dele.
  final String name;

  /// Só GSHs com o mesmo time se enxergam.
  final String team;
  final List<FarmLoop> loops;
}

/// Preferências da fazenda do time (Configurações > Recursos).
class TeamFarmConfig {
  const TeamFarmConfig({
    this.enabled = false,
    this.team = '',
    this.name = '',
    this.showTitles = false,
    this.network = '',
  });

  final bool enabled;
  final String team;
  final String name;

  /// Manda os títulos das sessões (podem ter trecho de prompt). Desligado:
  /// vai só projeto, status e tokens.
  final bool showTitles;

  /// Faixa da rede do trabalho (`192.168.10.0/24`). Vazio = qualquer rede
  /// local; preenchido = fora dela o GSH nem anuncia nem escuta.
  final String network;

  bool get active => enabled && team.trim().isNotEmpty;
}
