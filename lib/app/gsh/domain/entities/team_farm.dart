import 'dart:typed_data';

import 'package:gsh_desktop/app/gsh/domain/entities/farm_loop.dart';

/// O que um GSH anuncia para o time na rede local: quem é, os loops de
/// agente dele (já filtrados pela privacidade de quem mandou) e os agentes
/// que aceitam mensagem, com a porta do correio.
class TeamFarmPacket {
  const TeamFarmPacket({
    required this.machineId,
    required this.name,
    required this.team,
    required this.loops,
    this.agents = const [],
    this.mailPort,
    this.address,
  });

  /// Identifica a instância (descarta o eco do próprio pacote).
  final String machineId;

  /// Nome que aparece em cima da fazenda dele.
  final String name;

  /// Só GSHs com o mesmo time se enxergam.
  final String team;
  final List<FarmLoop> loops;

  /// Abas de terminal com agente que podem receber mensagem/entrega.
  final List<TeamAgent> agents;

  /// Porta TCP do correio dele. `null` = não recebe (sem senha do time).
  final int? mailPort;

  /// IP de onde o pacote veio (preenchido por quem recebe).
  final String? address;
}

/// Um agente de um GSH que aceita mensagem: uma aba de terminal com
/// Claude Code/Codex/... rodando.
class TeamAgent {
  const TeamAgent({
    required this.tabId,
    required this.label,
    required this.harness,
    required this.project,
    this.sessionId,
  });

  final String tabId;

  /// Nome da aba (o que se usa no `--to`).
  final String label;
  final String harness;

  /// Só o nome da pasta, nunca o caminho.
  final String project;

  /// Sessão do agente (liga o gorila da fazenda à aba).
  final String? sessionId;
}

enum TeamKnockKind { message, file }

/// Algo batendo na porta de um agente: mensagem de um agente de colega, ou
/// um arquivo entregue por ele.
class TeamKnock {
  const TeamKnock({
    required this.id,
    required this.kind,
    required this.fromMachine,
    required this.fromName,
    required this.fromAgent,
    required this.toTabId,
    required this.text,
    this.fileName,
    this.fileBytes,
    this.fromSessionId,
  });

  /// Único por batida (também é o nonce contra reenvio).
  final String id;
  final TeamKnockKind kind;
  final String fromMachine;
  final String fromName;

  /// Nome da aba do agente que mandou (para responder).
  final String fromAgent;
  final String? fromSessionId;
  final String toTabId;

  /// Mensagem, ou nota que acompanha o arquivo.
  final String text;
  final String? fileName;
  final Uint8List? fileBytes;
}

/// Preferências da fazenda do time (Configurações > Recursos).
class TeamFarmConfig {
  const TeamFarmConfig({
    this.enabled = false,
    this.team = '',
    this.name = '',
    this.showTitles = false,
    this.network = '',
    this.secret = '',
    this.askBeforeOpening = false,
    this.allowedKnockers = '',
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

  /// Senha do time: assina pacotes e mensagens. Sem ela o correio fica
  /// desligado (ninguém bate na porta).
  final String secret;

  /// A porta pergunta ao humano antes de entregar ao agente.
  final bool askBeforeOpening;

  /// Quem pode bater (nomes separados por vírgula). Vazio = todo o time.
  final String allowedKnockers;

  bool get active => enabled && team.trim().isNotEmpty;

  bool get mailActive => active && secret.isNotEmpty;

  /// [name] (de quem bateu) está liberado?
  bool allows(String name) {
    final list = allowedKnockers
        .split(',')
        .map((s) => s.trim().toLowerCase())
        .where((s) => s.isNotEmpty);
    return list.isEmpty || list.contains(name.trim().toLowerCase());
  }
}
