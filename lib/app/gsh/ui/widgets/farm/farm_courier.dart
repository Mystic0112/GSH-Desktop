import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:gsh_desktop/app/core/domain/entities/app_settings.dart'
    show FarmScenery;
import 'package:gsh_desktop/app/gsh/domain/entities/team_farm.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/farm/farm_scene.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/farm/farm_world.dart';

/// O mensageiro do time na fazenda: nasce ao lado do gorila de origem, anda
/// até o de destino, entrega (o destino mostra o balão por
/// [courierDeliver] s) e some num brilho. Tudo cabe nos 14 s do TTL do
/// `TeamPost`: a caminhada leva no máximo [courierWalkMax] s.
const courierSpeed = 46.0, courierWalkMax = 6.0, courierDeliver = 2.0;
const courierAppear = 0.35, courierVanish = 0.5;

enum CourierStage { walk, deliver, vanish, done }

/// Onde e como o mensageiro está num instante; [fade] vai de 0 a 1 ao
/// nascer e volta a 0 no sumiço.
typedef CourierPose = ({
  ui.Offset at,
  CourierStage stage,
  int dir,
  int legs,
  double hop,
  double fade,
});

/// Onde o mensageiro está [age] segundos depois de sair de [from] rumo a
/// [to] (pixels de mundo): uma curva leve (não atravessa reto por cima de
/// tudo) com o passo e o pulinho do andar.
CourierPose courierPose(ui.Offset from, ui.Offset to, double age) {
  final d = to - from, dist = d.distance;
  final walk = (dist / courierSpeed).clamp(0.6, courierWalkMax);
  final dir = d.dx >= 0 ? 1 : -1;
  if (age < walk) {
    final s = math.max(0.0, age) / walk;
    // controle da curva: o meio, puxado para cima um pouco
    final bend = math.min(24.0, dist * 0.15);
    final c = from + d / 2 + ui.Offset(0, -bend);
    final at =
        from * ((1 - s) * (1 - s)) + c * (2 * s * (1 - s)) + to * (s * s);
    final step = (math.max(0.0, age) / 0.11).floor() % 4;
    return (
      at: at,
      stage: CourierStage.walk,
      dir: dir,
      legs: const [1, 0, 2, 0][step],
      hop: step.isOdd ? -0.5 : 0.0,
      fade: math.min(1.0, math.max(0.0, age) / courierAppear),
    );
  }
  final after = age - walk - courierDeliver;
  final stage = after < 0
      ? CourierStage.deliver
      : after < courierVanish
      ? CourierStage.vanish
      : CourierStage.done;
  return (
    at: to,
    stage: stage,
    dir: dir,
    legs: 0,
    hop: 0.0,
    fade: after < 0 ? 1.0 : (1 - after / courierVanish).clamp(0.0, 1.0),
  );
}

/// Um mensageiro resolvido para este quadro: pontos no mundo (já com o
/// canto do lote somado), idade e o gorila que recebe (para o balão).
class CourierRun {
  const CourierRun({
    required this.from,
    required this.to,
    required this.age,
    required this.kind,
    this.target,
    this.targetAt = ui.Offset.zero,
  });

  final ui.Offset from, to;
  final double age;
  final TeamKnockKind kind;

  /// O gorila de destino e o canto do lote dele (`null` = a porta).
  final Critter? target;
  final ui.Offset targetAt;

  CourierPose get pose => courierPose(from, to, age);

  /// Fica à vista em [view] (pixels de mundo), com folga do sprite.
  bool seen(ui.Rect view) =>
      ui.Rect.fromPoints(from, to).inflate(40).overlaps(view);
}

/// De onde sai / onde chega o mensageiro num lote (pixels de mundo, com o
/// canto [at] do lote): ao lado do gorila da sessão [sid], ou na porta (a do
/// celeiro na fazenda, a de vidro no escritório) quando ele não está ali.
(ui.Offset, Critter?) courierEndpoint(
  FarmScene scene,
  FarmWorld w,
  ui.Offset at,
  String? sid,
) {
  final c = sid == null ? null : scene.critters[sid];
  if (c != null && c.gone == null) {
    return (ui.Offset(c.x - 11, c.y + 1) + at, c);
  }
  final l = w.layout;
  final door = w.scenery == FarmScenery.office
      ? ui.Offset(l.pondCx, l.play.bottom - 4)
      : l.door + const ui.Offset(0, 5);
  return (door + at, null);
}
