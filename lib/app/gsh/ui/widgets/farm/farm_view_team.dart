part of 'farm_view.dart';

/// As fazendas dos colegas do time ao lado da minha: um [FarmLot] por
/// colega, com cena, fundo e posição próprios. O fundo de um colega só é
/// repintado quando a estrutura dele muda (canteiros/vagas que não cabem
/// mais, o tamanho do meu mundo ou o cenário), nunca a cada pacote.
extension _TeamLots on _FarmViewState {
  /// O que pinta o fundo de um colega: o tamanho do meu mundo e o cenário.
  Object? get _peerKey {
    final l = _world?.layout;
    return l == null ? null : (l.w, l.h, _scenery ?? FarmScenery.farm);
  }

  /// Põe os lotes de acordo com [FarmViewModel.peers]: cria, atualiza a cena,
  /// repinta o que mudou de estrutura e tira quem saiu da rede.
  void _syncPeers() {
    final peers = _vm.peers;
    final ids = {for (final p in peers) p.id};
    final gone = _team.where((l) => !ids.contains(l.id)).toList();
    for (final lot in gone) {
      lot.gen++;
      _team.remove(lot);
      final w = lot.world;
      if (w != null) {
        SchedulerBinding.instance.addPostFrameCallback((_) => w.dispose());
      }
      if (identical(_hoverLot, lot)) {
        _hoverLot = null;
        _hover.value = null;
      }
    }
    final byId = {for (final l in _team) l.id: l};
    _team
      ..clear()
      ..addAll([
        for (final p in peers)
          (byId[p.id] ?? FarmLot(p.id, p.name))..name = p.name,
      ]);
    for (final (i, p) in peers.indexed) {
      final lot = _team[i]..scene.sync(p.plots);
      final key = _peerKey;
      if (key != null &&
          !lot.pending &&
          (lot.world == null || lot.scene.outgrown || lot.builtFor != key)) {
        unawaited(_rebuildPeer(lot));
      }
    }
    if (gone.isNotEmpty) _arrange();
  }

  Future<void> _rebuildPeer(FarmLot lot) async {
    final mine = _world?.layout, key = _peerKey;
    if (mine == null) return;
    final gen = ++lot.gen;
    lot.pending = true;
    final layout = layoutLot(mine, lot.scene.need);
    final world = await buildWorld(
      layout,
      seed: lot.seed,
      scenery: _scenery ?? FarmScenery.farm,
    );
    if (!mounted || gen != lot.gen || !_team.contains(lot)) {
      world.dispose();
      return;
    }
    final old = lot.world;
    lot
      ..pending = false
      ..world = world
      ..builtFor = key;
    lot.scene.relayout(layout);
    _arrange();
    SchedulerBinding.instance.addPostFrameCallback((_) => old?.dispose());
  }

  /// Recalcula onde fica cada lote e os limites da câmera (o zoom mínimo
  /// passa a mostrar o conjunto). Sem colegas, a câmera volta ao de sempre.
  void _arrange() {
    final l = _world?.layout;
    if (l == null) return;
    if (_team.every((p) => p.world == null)) {
      _cam
        ..team = null
        ..teamZ = null;
    } else {
      final b = arrangeLots(
        l,
        _team,
        joined: _world!.scenery == FarmScenery.office,
      );
      _cam
        ..team = b
        ..teamZ = math.min(_size.width / b.width, _size.height / b.height);
    }
    _cam
      ..z = math.max(_cam.z, _cam.minZ(l))
      ..clampTo(l, _size);
    _frame.tick();
  }

  /// O retângulo do mundo à vista agora (com folga para quem entra).
  Rect get _onScreen => Rect.fromLTWH(
    _cam.x,
    _cam.y,
    _size.width / _cam.z,
    _size.height / _cam.z,
  ).inflate(40);

  /// Anima só os colegas à vista; devolve se algum quadro mudou.
  bool _updatePeers(double dt) {
    final view = _onScreen;
    var dirty = false;
    for (final lot in _team) {
      if (lot.world != null && lot.rect.overlaps(view)) {
        dirty = lot.scene.update(dt) || dirty;
      }
    }
    return dirty;
  }

  /// Algum colega à vista trabalhando (a animação vai no ritmo cheio).
  bool get _peersBusy {
    final view = _onScreen;
    return _team.any(
      (l) => l.world != null && l.scene.busy && l.rect.overlaps(view),
    );
  }

  /// O bicho sob o ponto da tela: os meus primeiro, depois os dos colegas
  /// (com o lote, para o tooltip dizer de quem é).
  (Critter?, FarmLot?) _hitAt(Offset local) {
    if (_world == null) return (null, null);
    final pt = _cam.toWorld(local);
    final mine = _scene.hit(pt);
    if (mine != null) return (mine, null);
    for (final lot in _team) {
      if (lot.world == null || !lot.rect.contains(pt)) continue;
      final c = lot.scene.hit(pt - lot.at);
      if (c != null) return (c, lot);
    }
    return (null, null);
  }

  /// Resolve os mensageiros do `TeamPost` para este quadro: pontos de
  /// partida e chegada (gorila ou porta de cada lote), só os à vista e só
  /// com o lote do colega no mundo. Devolve se algum ficou.
  bool _syncCouriers() {
    _runs.clear();
    final mine = _world;
    if (_team.isEmpty || mine == null) return false;
    final post = _post ??= context.read<GshViewModel>().teamPost;
    final now = DateTime.now(), view = _onScreen;
    for (final c in post.couriers) {
      final lot = _team
          .where((l) => l.id == c.peerId && l.world != null)
          .firstOrNull;
      if (lot == null) continue;
      final (a, ca) = courierEndpoint(
        _scene,
        mine,
        Offset.zero,
        c.localSessionId,
      );
      final (b, cb) = courierEndpoint(
        lot.scene,
        lot.world!,
        lot.at,
        c.remoteSessionId,
      );
      final run = CourierRun(
        from: c.outgoing ? a : b,
        to: c.outgoing ? b : a,
        age: now.difference(c.startedAt).inMicroseconds / 1e6,
        kind: c.kind,
        target: c.outgoing ? cb : ca,
        targetAt: c.outgoing ? lot.at : Offset.zero,
      );
      if (run.pose.stage != CourierStage.done && run.seen(view)) {
        _runs.add(run);
      }
    }
    return _runs.isNotEmpty;
  }

  void _disposeTeam() {
    for (final lot in _team) {
      lot.gen++;
      lot.dispose();
    }
    _team.clear();
  }
}
