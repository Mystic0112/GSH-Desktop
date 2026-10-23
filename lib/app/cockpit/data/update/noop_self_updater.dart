import 'package:cockpit/app/cockpit/domain/contracts/self_updater.dart';

/// Sem self-update nativo (Linux): [isSupported] é `false` e tudo é no-op. O
/// `UpdateViewModel` detecta isso e cai no caminho de notify + download manual
/// (`UpdateChecker` lendo `latest.json` + abrir a URL do artefato).
class NoopSelfUpdater implements SelfUpdater {
  const NoopSelfUpdater();

  @override
  bool get isSupported => false;

  @override
  SelfUpdateState get state => const SelfUpdateState.idle();

  @override
  Stream<SelfUpdateState> get changes => const Stream<SelfUpdateState>.empty();

  @override
  Future<void> initialize() async {}

  @override
  Future<void> checkForUpdates({bool inBackground = true}) async {}

  @override
  Future<void> applyUpdate() async {}

  @override
  void dispose() {}
}
