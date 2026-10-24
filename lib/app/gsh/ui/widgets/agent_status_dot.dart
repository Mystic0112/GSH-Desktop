import 'dart:async';

import 'package:gsh_desktop/app/core/ui/themes/themes.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/farm_loop.dart';
import 'package:gsh_desktop/app/gsh/ui/session/terminal_session.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

/// Cor de cada status de agente, a mesma em todo lugar (fazenda, topbar, abas,
/// rail): verde trabalhando, amarelo esperando alguém, azul parado.
Color farmStatusColor(AppColors colors, FarmStatus status) => switch (status) {
  FarmStatus.working => colors.online,
  FarmStatus.waiting => colors.warn,
  FarmStatus.idle => colors.gitUntracked,
};

/// O status do hook de uma aba de terminal, no vocabulário da fazenda.
FarmStatus terminalFarmStatus(TerminalStatus status) => switch (status) {
  TerminalStatus.working => FarmStatus.working,
  TerminalStatus.waiting => FarmStatus.waiting,
  TerminalStatus.idle => FarmStatus.idle,
};

/// Resumo de um workspace na rail: amarelo se alguma aba espera, verde se
/// alguma trabalha. Parado devolve `null` — na rail seria só ruído.
FarmStatus? workspaceAgentStatus(Iterable<TerminalSession> tabs) {
  var working = false;
  for (final t in tabs) {
    if (t.status == TerminalStatus.waiting) return FarmStatus.waiting;
    if (t.status == TerminalStatus.working) working = true;
  }
  return working ? FarmStatus.working : null;
}

/// Bolinha de status de agente. Amarelo (esperando) pisca. [hollow] desenha só
/// o contorno (aba parada já vista, para não confundir com o ponto de
/// "terminou e você não viu").
class AgentStatusDot extends StatelessWidget {
  const AgentStatusDot({
    super.key,
    required this.status,
    this.size = 7,
    this.hollow = false,
  });

  final FarmStatus status;
  final double size;
  final bool hollow;

  @override
  Widget build(BuildContext context) {
    final color = farmStatusColor(context.colors, status);
    final dot = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: hollow ? null : color,
        border: hollow ? Border.all(color: color, width: 1.4) : null,
        shape: BoxShape.circle,
      ),
    );
    return status == FarmStatus.waiting ? AgentPulse(child: dot) : dot;
  }
}

/// Ponto da rail que resume as abas de um workspace ([workspaceAgentStatus]).
/// Escuta as sessões direto: o status do hook muda sem notificar o VM.
class WorkspaceAgentDot extends StatelessWidget {
  const WorkspaceAgentDot({super.key, required this.tabs});
  final List<TerminalSession> tabs;

  @override
  Widget build(BuildContext context) {
    if (tabs.isEmpty) return const SizedBox.shrink();
    return ListenableBuilder(
      listenable: Listenable.merge(tabs),
      builder: (context, _) => switch (workspaceAgentStatus(tabs)) {
        final status? => Padding(
          padding: const EdgeInsets.only(right: 6),
          child: AgentStatusDot(status: status),
        ),
        null => const SizedBox.shrink(),
      },
    );
  }
}

/// Pisca [child] no compasso único de [_pulse]: todos os amarelos da janela
/// piscam juntos, e o relógio só corre enquanto algum está montado.
class AgentPulse extends StatelessWidget {
  const AgentPulse({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => RepaintBoundary(
    child: ListenableBuilder(
      listenable: _pulse,
      builder: (_, child) =>
          Opacity(opacity: _pulse.bright ? 1 : 0.3, child: child),
      child: child,
    ),
  );
}

// ponytail: piscar seco (2 quadros por ciclo) em vez de fade animado — um
// fade a 60 Hz enquanto alguém espera (pode ser horas) custa CPU contínua
// (~0,5%/fps medido no Linux, ver farm_view). Fade suave = AnimatedOpacity.
class _Pulse extends ChangeNotifier {
  static const _every = Duration(milliseconds: 700);

  Timer? _timer;
  int _listeners = 0;
  bool bright = true;

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    if (_listeners++ == 0) {
      _timer = Timer.periodic(_every, (_) {
        bright = !bright;
        notifyListeners();
      });
    }
  }

  @override
  void removeListener(VoidCallback listener) {
    super.removeListener(listener);
    if (--_listeners > 0) return;
    _listeners = 0;
    _timer?.cancel();
    _timer = null;
    bright = true;
  }
}

final _pulse = _Pulse();
