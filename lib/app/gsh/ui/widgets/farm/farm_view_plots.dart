part of 'farm_view.dart';

/// Escolher o canteiro de cada projeto: arrastar a terra (ou a etiqueta) de
/// um canteiro para outra vaga troca os dois de lugar, e a vaga fica
/// lembrada por pasta nas preferências (`farm.plots`). Vale nos dois
/// cenários (o escritório usa o mesmo layout).
extension _PlotDrag on _FarmViewState {
  /// Preferências mudaram (outra janela, "redefinir"): a cena acompanha.
  void _watchPins(BuildContext context) {
    final pins = context.select<SettingsController, Map<String, int>>(
      (c) => c.settings.farmPlots,
    );
    if (identical(pins, _scene.pins)) return;
    if (pins.isEmpty && _scene.pins.isNotEmpty) {
      _scene.resetPlots();
    } else {
      _scene.pins = pins;
    }
  }

  /// Um dedo (ou o mouse) apertou na terra de um canteiro meu: começa a
  /// arrastá-lo em vez de mover a câmera.
  void _startPlotDrag(ScaleStartDetails d) {
    _dragPlot = d.pointerCount == 1 && _world != null
        ? _scene.plotAt(_cam.toWorld(d.localFocalPoint))
        : null;
    _scene
      ..dragFrom = _dragPlot
      ..dragTo = _dragPlot;
  }

  /// Arrastando um canteiro: marca a vaga sob o ponteiro. Devolve se o
  /// gesto era dele (então a câmera fica parada).
  bool _dragPlotTo(ScaleUpdateDetails d) {
    if (_dragPlot == null) return false;
    _scene.dragTo = _scene.plotAt(_cam.toWorld(d.localFocalPoint), any: true);
    _frame.tick();
    return true;
  }

  void _endPlotDrag() {
    final from = _dragPlot, to = _scene.dragTo;
    _dragPlot = null;
    _scene
      ..dragFrom = null
      ..dragTo = null;
    if (from != null && to != null && to != from) {
      final moved = _scene.movePlot(from, to);
      if (moved.isNotEmpty) {
        final settings = context.read<SettingsController>();
        settings.setFarmPlots({...settings.settings.farmPlots, ...moved});
        _scene.pins = settings.settings.farmPlots;
      }
    }
    _frame.tick();
  }

  /// "Redefinir posições" do HUD: volta tudo ao automático.
  void _resetPlots() {
    _scene.resetPlots();
    context.read<SettingsController>().setFarmPlots(const {});
    _frame.tick();
  }
}
