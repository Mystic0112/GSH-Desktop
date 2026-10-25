import 'package:flutter_test/flutter_test.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/farm/farm_courier.dart';

void main() {
  const a = Offset(10, 20), b = Offset(240, 60);
  final walk = (b - a).distance / courierSpeed;

  test('anda de a até b no tempo da caminhada, numa curva leve', () {
    expect(courierPose(a, b, 0).at, a);
    expect(courierPose(a, b, 0).fade, 0);
    final mid = courierPose(a, b, walk / 2);
    expect(mid.stage, CourierStage.walk);
    expect(mid.dir, 1);
    // no meio: entre os dois em x, um pouco acima da reta em y
    expect(mid.at.dx, closeTo((a.dx + b.dx) / 2, 1));
    expect(mid.at.dy, lessThan((a.dy + b.dy) / 2));
    expect((courierPose(a, b, walk - 1e-6).at - b).distance, lessThan(0.1));
  });

  test('entrega em b, some e acaba dentro do TTL de 14 s', () {
    expect(courierPose(a, b, walk + 0.1).stage, CourierStage.deliver);
    expect(courierPose(a, b, walk + 0.1).at, b);
    expect(
      courierPose(a, b, walk + courierDeliver + 0.1).stage,
      CourierStage.vanish,
    );
    expect(
      courierPose(a, b, walk + courierDeliver + courierVanish).stage,
      CourierStage.done,
    );
    // o mais longe possível ainda cabe
    const far = Offset(100000, 0);
    expect(
      courierPose(
        Offset.zero,
        far,
        courierWalkMax + courierDeliver + courierVanish,
      ).stage,
      CourierStage.done,
    );
    expect(courierWalkMax + courierDeliver + courierVanish, lessThan(14));
  });

  test('perto demais ainda leva o mínimo de caminhada, para a esquerda', () {
    final p = courierPose(b, a, 0.3);
    expect(p.stage, CourierStage.walk);
    expect(p.dir, -1);
  });
}
