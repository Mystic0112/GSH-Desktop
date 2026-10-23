import 'dart:async';

/// Fase corrente do self-update nativo (Sparkle/WinSparkle). Best-effort: toda
/// falha vira [error] e o card cai pro caminho de notify (nunca derruba o boot).
///
/// **Os dois motores não percorrem as mesmas fases.** O Sparkle (macOS) baixa em
/// background sozinho, então anda `checking → downloading → downloaded`. O
/// WinSparkle **não baixa nada por conta própria** e não tem sequer callback de
/// "baixou" (a `WinSparkle.dll` 0.8.1 só emite checking/available/not-available/
/// error/before-quit), então ele **para em [available]** e o download+install só
/// acontece quando o usuário aciona o card. Ou seja: [downloading]/[downloaded]
/// são fases exclusivas do macOS, e [available] é o estado terminal do Windows.
enum SelfUpdatePhase {
  /// Sem update pendente (nunca checou, ou já está na última versão).
  idle,

  /// Checando o appcast.
  checking,

  /// Há versão nova, **ainda não baixada**. Estado terminal no Windows: o clique
  /// no card é que conduz download+install pela UI nativa do WinSparkle.
  available,

  /// Há versão nova; download em curso. **Só macOS** (auto-download do Sparkle).
  downloading,

  /// Artefato baixado e verificado — pronto pra instalar no próximo restart.
  /// **Só macOS**: o WinSparkle não expõe esse evento.
  downloaded,

  /// Falha (rede, assinatura, parsing). Silenciosa pra UI; só loga.
  error,
}

/// Estado observável do [SelfUpdater]. [version] preenchido quando há update
/// disponível/baixado; [message] no erro.
///
/// > [version] é `null` no Windows: o plugin `auto_updater` não repassa o
/// > `AppcastItem` do WinSparkle (o evento nativo só carrega o campo `type`).
/// > Quem consome deve tolerar isso — o `UpdateViewModel` completa a versão pelo
/// > `latest.json`.
class SelfUpdateState {
  const SelfUpdateState(this.phase, {this.version, this.message});

  const SelfUpdateState.idle() : this(SelfUpdatePhase.idle);

  final SelfUpdatePhase phase;
  final String? version;
  final String? message;

  /// `true` quando o artefato já está baixado e só falta reiniciar pra aplicar.
  /// **Nunca é `true` no Windows** — use [isActionable] pra habilitar o clique.
  bool get isReadyToInstall => phase == SelfUpdatePhase.downloaded;

  /// `true` quando acionar o card faz algo útil: instalar o já baixado (macOS)
  /// ou iniciar download+install (Windows).
  bool get isActionable =>
      phase == SelfUpdatePhase.downloaded || phase == SelfUpdatePhase.available;

  /// `true` enquanto há um update em andamento ou pronto (a UI mostra o card).
  bool get hasPendingUpdate =>
      phase == SelfUpdatePhase.available ||
      phase == SelfUpdatePhase.downloading ||
      phase == SelfUpdatePhase.downloaded;
}

/// Self-update nativo: **Sparkle no macOS, WinSparkle no Windows** (via o plugin
/// `auto_updater`). Em plataformas sem suporte (Linux) [isSupported] é `false` e
/// os métodos são no-op — aí o caminho de notify + download manual
/// (`UpdateChecker`/`UpdateCard`) assume.
///
/// UX híbrida (decisão B do plano 47): a checagem roda **em background**; a UI
/// visível é só o nosso card, que reflete [state]/[changes]. Reinício
/// **silencioso** (decisão C): ao aplicar o update o app é encerrado e relançado
/// pelo motor nativo; os agentes `pi` filhos são reapeados no próximo boot por
/// `PiProcessRegistry.cleanOrphans` e respawnados pelo estado no Hive.
///
/// > **A decisão B só vale integralmente no macOS.** No Windows o WinSparkle não
/// > tem modo headless: `win_sparkle_check_update_without_ui()` é documentado
/// > como "*not completely UI-less*" — ele abre o diálogo nativo assim que acha
/// > uma versão. Não dá pra suprimir pela fachada; o card e o diálogo coexistem.
abstract class SelfUpdater {
  /// `true` só onde há motor nativo (macOS/Windows).
  bool get isSupported;

  /// Estado corrente (snapshot síncrono pra primeira pintura do card).
  SelfUpdateState get state;

  /// Stream de transições de [state] — a UI escuta pra re-renderizar.
  Stream<SelfUpdateState> get changes;

  /// Liga o motor nativo: feed URL + listener + agenda a checagem periódica.
  /// Idempotente; no-op se [isSupported] é `false`.
  Future<void> initialize();

  /// Dispara uma checagem. [inBackground] pede a versão silenciosa (respeitada
  /// no macOS; no Windows o motor ainda abre o diálogo se achar update).
  Future<void> checkForUpdates({bool inBackground = true});

  /// Aciona o update: instala+relança o já baixado (macOS) ou inicia
  /// download+install pela UI nativa (Windows). No-op se não há nada acionável
  /// ([SelfUpdateState.isActionable] `false`).
  Future<void> applyUpdate();

  /// Libera o listener nativo e a stream.
  void dispose();
}
