import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:gsh_desktop/app/gsh/ui/widgets/farm/farm_scene.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/farm/farm_world.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/farm/pix.dart';

/// A fazenda de um colega do time no mundo: a cena dele (os bichos), o
/// fundo pré-pintado e onde fica, ao lado da minha. Só o [FarmView] mexe
/// aqui; o painter só lê.
class FarmLot {
  FarmLot(this.id, this.name) : scene = FarmScene();

  final String id;
  String name;
  final FarmScene scene;

  /// `null` enquanto o primeiro fundo pinta (o lote não aparece).
  FarmWorld? world;

  /// Canto do lote no mundo (a minha fazenda fica em (0, 0)).
  ui.Offset at = ui.Offset.zero;

  /// Até onde (x, nas coordenadas do lote) o fundo não é desenhado: no
  /// escritório, a calçada da esquerda some e a parede dele vira a divisória
  /// com o vizinho.
  double clip = 0;

  /// Pinturas em voo: só a última vale.
  int gen = 0;
  bool pending = false;

  /// O que pintou o fundo atual (tamanho do meu mundo e cenário): mudou,
  /// repinta.
  Object? builtFor;

  ui.Rect get rect {
    final l = world!.layout;
    return ui.Rect.fromLTWH(at.dx, at.dy, l.w.toDouble(), l.h.toDouble());
  }

  /// Semente do fundo: cada colega com a sua (árvores e móveis diferentes).
  int get seed => 7 + hashStr(id) % 997;

  void dispose() => world?.dispose();
}

/// Põe os lotes prontos ao lado da minha fazenda ([mine], em (0, 0)): em
/// fila à direita até 3 colegas; com mais, em grade quase quadrada (a minha
/// no canto de cima à esquerda). [joined] (escritório) cola os lotes de uma
/// fileira num prédio só: a parede esquerda do colega cai em cima da minha
/// parede direita e a calçada dele daquele lado é recortada ([FarmLot.clip]);
/// entre fileiras fica a rua. Devolve o retângulo do conjunto.
ui.Rect arrangeLots(
  FarmLayout mine,
  List<FarmLot> lots, {
  bool joined = false,
}) {
  final ready = lots.where((l) => l.world != null).toList();
  final n = ready.length + 1;
  final cols = n <= 4 ? n : math.sqrt(n).ceil();
  var bounds = ui.Rect.fromLTWH(0, 0, mine.w.toDouble(), mine.h.toDouble());
  var x = mine.w.toDouble(), y = 0.0, rowH = mine.h.toDouble();
  var right = mine.play.right;
  for (var i = 1; i < n; i++) {
    final first = i % cols == 0;
    if (first) {
      x = 0;
      y += rowH;
      rowH = 0;
    }
    final lot = ready[i - 1];
    final l = lot.world!.layout;
    // a parede vertical ocupa 1,5 px de mundo a partir de `play.right + 0,5`
    if (joined && !first) {
      lot
        ..at = ui.Offset(right + 2 - l.play.left, y)
        ..clip = l.play.left - 1.5;
    } else {
      lot
        ..at = ui.Offset(x, y)
        ..clip = 0;
    }
    x = lot.at.dx + l.w;
    right = lot.at.dx + l.play.right;
    rowH = math.max(rowH, l.h.toDouble());
    bounds = bounds.expandToInclude(lot.rect);
  }
  return bounds;
}

/// O layout da fazenda de um colega para caber [need]: a "janela" é o meu
/// mundo inteiro em z = 1, então o lote sai do tamanho do meu (maior só se
/// não couber), com o miolo no meio.
FarmLayout layoutLot(FarmLayout mine, ({int plots, int yard}) need) =>
    layoutFarm(
      plots: (need.plots * 1.15).ceil() + 1,
      yard: (need.yard * 1.1).ceil() + 2,
      view: FarmViewport(w: mine.w.toDouble(), h: mine.h.toDouble()),
      snap: (_) => 1,
      margin: mine.t,
    );
