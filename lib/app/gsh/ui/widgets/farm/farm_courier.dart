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
CourierPose courierPose(
  ui.Offset from,
  ui.Offset to,
  double age, [
  List<ui.Offset>? path,
]) {
  final d = to - from;
  final pts = path != null && path.length > 2 ? path : null;
  final dist = pts == null ? d.distance : _length(pts);
  final walk = (dist / courierSpeed).clamp(0.6, courierWalkMax);
  var dir = d.dx >= 0 ? 1 : -1;
  if (age < walk) {
    final s = math.max(0.0, age) / walk;
    final ui.Offset at;
    if (pts != null) {
      // pelo caminho de verdade (portas, portão, corredor), na mesma
      // velocidade de ponta a ponta
      final (p, seg) = _along(pts, s * dist);
      at = p;
      if (seg.dx.abs() > 0.3) dir = seg.dx >= 0 ? 1 : -1;
    } else {
      // controle da curva: o meio, puxado para cima um pouco
      final bend = math.min(24.0, dist * 0.15);
      final c = from + d / 2 + ui.Offset(0, -bend);
      at = from * ((1 - s) * (1 - s)) + c * (2 * s * (1 - s)) + to * (s * s);
    }
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

double _length(List<ui.Offset> pts) {
  var n = 0.0;
  for (var i = 1; i < pts.length; i++) {
    n += (pts[i] - pts[i - 1]).distance;
  }
  return n;
}

/// O ponto a [len] do começo do caminho e o trecho em que ele está.
(ui.Offset, ui.Offset) _along(List<ui.Offset> pts, double len) {
  for (var i = 1; i < pts.length; i++) {
    final seg = pts[i] - pts[i - 1], n = seg.distance;
    if (len <= n || i == pts.length - 1) {
      return (pts[i - 1] + seg * (n == 0 ? 0 : math.min(1, len / n)), seg);
    }
    len -= n;
  }
  return (pts.last, ui.Offset.zero);
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
    this.path,
  });

  final ui.Offset from, to;

  /// O caminho pelas aberturas (ver [courierRoute]); `null` = a curva reta.
  final List<ui.Offset>? path;
  final double age;
  final TeamKnockKind kind;

  /// O gorila de destino e o canto do lote dele (`null` = a porta).
  final Critter? target;
  final ui.Offset targetAt;

  CourierPose get pose => courierPose(from, to, age, path);

  /// Fica à vista em [view] (pixels de mundo), com folga do sprite.
  bool seen(ui.Rect view) {
    var r = ui.Rect.fromPoints(from, to);
    for (final p in path ?? const <ui.Offset>[]) {
      r = r.expandToInclude(ui.Rect.fromLTWH(p.dx, p.dy, 0, 0));
    }
    return r.inflate(40).overlaps(view);
  }
}

/// A porta de um lote (coordenadas do lote): a do celeiro na fazenda, a de
/// vidro do prédio no escritório.
ui.Offset _door(FarmWorld w) {
  final l = w.layout;
  return w.scenery == FarmScenery.office
      ? ui.Offset(l.pondCx, l.play.bottom - 4)
      : l.door + const ui.Offset(0, 5);
}

/// Por onde se sai de um lote para a rua (coordenadas do lote): o ponto de
/// dentro, junto da borda de baixo (a porta de vidro no escritório; na
/// fazenda, embaixo da porta do celeiro), e o de fora, já na calçada/mato.
(ui.Offset, ui.Offset) _exit(FarmWorld w) {
  final l = w.layout;
  final x = w.scenery == FarmScenery.office ? l.pondCx : l.door.dx;
  return (ui.Offset(x, l.play.bottom - 4), ui.Offset(x, l.play.bottom + 8));
}

final _routes = <Object, List<ui.Offset>>{};

/// O caminho do mensageiro de [from] (no lote [wa], canto [atA]) até [to]
/// (lote [wb], canto [atB]), pixels de mundo: sai pela borda de baixo do
/// lote dele (a porta de vidro no escritório) contornando cerca, parede e
/// mesa, anda pela rua e entra do mesmo jeito no outro. Trecho sem caminho
/// na grade vai reto. Guardado por pontas (a cena pede a cada quadro; a
/// busca só roda quando uma ponta muda de lugar). ponytail: na rua anda
/// reto, mesmo entre fileiras de lotes.
List<ui.Offset> courierRoute(
  FarmWorld wa,
  ui.Offset atA,
  ui.Offset from,
  FarmWorld wb,
  ui.Offset atB,
  ui.Offset to,
) {
  ui.Offset q(ui.Offset p) =>
      ui.Offset(p.dx.roundToDouble(), p.dy.roundToDouble());
  final key = (identityHashCode(wa), identityHashCode(wb), q(from), q(to));
  final hit = _routes[key];
  if (hit != null) return hit;
  List<ui.Offset> leg(FarmWorld w, ui.Offset at, ui.Offset a, ui.Offset b) {
    final r = w.layout.nav?.route(a - at, b - at);
    return r == null ? [b] : [for (final p in r) p + at];
  }

  final List<ui.Offset> pts;
  if (identical(wa, wb)) {
    pts = [from, ...leg(wa, atA, from, to)];
  } else {
    final (ia, oa) = _exit(wa);
    final (ib, ob) = _exit(wb);
    pts = [
      from,
      ...leg(wa, atA, from, ia + atA),
      oa + atA,
      ob + atB,
      ib + atB,
      ...leg(wb, atB, ib + atB, to),
    ];
  }
  if (_routes.length > 32) _routes.remove(_routes.keys.first);
  return _routes[key] = pts;
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
  return (_door(w) + at, null);
}
