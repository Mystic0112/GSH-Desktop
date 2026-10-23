import 'dart:async';

import 'package:cockpit/app/cockpit/domain/contracts/dismissed_update_store.dart';
import 'package:cockpit/app/cockpit/domain/contracts/self_updater.dart';
import 'package:cockpit/app/cockpit/domain/contracts/update_checker.dart';
import 'package:cockpit/app/cockpit/domain/contracts/url_opener.dart';
import 'package:cockpit/app/cockpit/domain/entities/update_info.dart';
import 'package:cockpit/app/cockpit/domain/value_objects/semver.dart';
import 'package:cockpit/app/cockpit/domain/value_objects/update_target.dart';
import 'package:cockpit/app/core/domain/entities/app_settings.dart';
import 'package:cockpit/app/core/ui/settings_controller.dart';
import 'package:flutter/foundation.dart';

/// Dono do mini card de atualização do rail. Tem **dois modos**, decididos pela
/// plataforma:
///
/// - **macOS (self-update, plano 47):** [check] liga o [SelfUpdater] nativo
///   (Sparkle) — checa/baixa em background; o card reflete o [SelfUpdateState]
///   (baixando → pronto) e o toque instala+relança o já baixado.
/// - **Windows (self-update):** o WinSparkle não baixa sozinho — o card para em
///   "Update available" e o toque é que dispara download+install. Ver
///   [SelfUpdatePhase].
/// - **Linux (notify, plano 43):** [check] lê o `latest.json` via [UpdateChecker];
///   se houver versão **maior** e **não dispensada**, o card aparece e o toque
///   abre a URL do artefato no navegador (download manual).
///
/// Tudo best-effort: falhas são silenciosas, nunca derrubam o boot.
class UpdateViewModel extends ChangeNotifier {
  UpdateViewModel(
    this._checker,
    this._dismissed,
    this._opener,
    this._target,
    this._selfUpdater, {
    this.fallbackUrl = _kFallbackUrl,
  });

  final UpdateChecker _checker;
  final DismissedUpdateStore _dismissed;
  final UrlOpener _opener;
  final UpdateTarget _target;
  final SelfUpdater _selfUpdater;
  SettingsController? _settingsController;

  void attachSettings(SettingsController controller) {
    _settingsController = controller;
  }

  /// Versão do app rodando (de package_info, resolvida no boot).
  String get currentVersion => _target.version;

  /// Plataforma/arch correntes pra escolher o artefato (caminho Linux/notify).
  String get platform => _target.platform;
  String get format => _target.format;
  String get arch => _target.arch;

  /// Página de download do site — fallback quando não há artefato da plataforma.
  final String fallbackUrl;

  static const String _kFallbackUrl =
      'https://remote-pi.jacobmoura.work/download';

  UpdateInfo? _available; // caminho Linux/notify
  StreamSubscription<SelfUpdateState>? _selfSub;
  bool _selfDismissed = false; // dispensa transiente no modo self-update
  bool _selfInitialized = false; // o motor de self-update só inicializa uma vez
  bool _disposed = false;

  /// Versão vinda do `latest.json`, usada só quando o motor nativo não informa a
  /// dele — o caso do Windows, onde o plugin não repassa o `AppcastItem` (ver
  /// [SelfUpdateState.version]). Appcast e `latest.json` saem do mesmo job de CI,
  /// então a versão é a mesma. Sem isso o card mostraria "v" vazio.
  String? _fallbackVersion;

  /// Re-checa de tempos em tempos enquanto o app está aberto (além do boot).
  Timer? _periodic;
  static const Duration _checkInterval = Duration(hours: 6);

  /// `true` em macOS/Windows (há motor de self-update); `false` no Linux.
  bool get isSelfUpdate => _selfUpdater.isSupported;

  // ---- Estado unificado consumido pelo card ----

  /// O card deve aparecer?
  bool get hasUpdate {
    if (isSelfUpdate) {
      return !_selfDismissed && _selfUpdater.state.hasPendingUpdate;
    }
    return _available != null;
  }

  /// Artefato baixado e pronto pra instalar — **só macOS** (o WinSparkle nunca
  /// reporta "baixou"). Governa o texto "restart to install" e o ícone, não o
  /// clique: quem habilita o clique é o card sempre chamar [primaryAction].
  bool get isReadyToInstall =>
      isSelfUpdate && _selfUpdater.state.isReadyToInstall;

  /// Versão a anunciar no card (`null` se ainda desconhecida). No self-update cai
  /// pro [_fallbackVersion] quando o motor não informa a versão (Windows).
  String? get updateVersion => isSelfUpdate
      ? (_selfUpdater.state.version ?? _fallbackVersion)
      : _available?.version;

  /// Título do card.
  String get cardTitle =>
      isReadyToInstall ? 'Update ready' : 'Update available';

  /// Subtítulo do card (varia por modo/fase). Tolera versão desconhecida.
  String get cardSubtitle {
    final v = updateVersion;
    final prefix = v == null ? '' : 'v$v — ';
    if (!isSelfUpdate) return '${prefix}click to download';
    return switch (_selfUpdater.state.phase) {
      // macOS: baixado em background, só falta reiniciar.
      SelfUpdatePhase.downloaded => '${prefix}restart to install',
      // macOS: download em curso (o Windows nunca passa por aqui).
      SelfUpdatePhase.downloading =>
        v == null ? 'Downloading…' : 'Downloading v$v…',
      // Windows: disponível, o clique é que baixa+instala.
      _ => '${prefix}click to install',
    };
  }

  // ---- Boot ----

  /// Checa updates no boot e arma uma re-checagem periódica (a cada
  /// [_checkInterval]) enquanto o app está aberto. Silencioso em falha.
  Future<void> check() async {
    await _runCheck();
    _periodic ??= Timer.periodic(_checkInterval, (_) => _runCheck());
  }

  /// Checagem **pedida pelo usuário** (menu "Check for Updates…"). Diferente da
  /// de boot: roda em foreground, porque no Windows só a variante com UI
  /// (`win_sparkle_check_update_with_ui`) — segundo o header, *"intended for
  /// manual, user-initiated checks […] it ignores 'Skip this version'"* — mostra
  /// resposta e destrava quem já dispensou a versão no diálogo nativo. Com a
  /// checagem de background aqui, quem clicou "Skip" ficava sem saída pelo app.
  /// Também limpa a dispensa local, já que pedir explicitamente é o oposto de
  /// dispensar.
  Future<void> checkNow() async {
    if (_disposed) return;
    _selfDismissed = false;
    if (isSelfUpdate) {
      _selfSub ??= _selfUpdater.changes.listen(_onSelfUpdateChange);
      if (!_selfInitialized) {
        await _selfUpdater.initialize();
        _selfInitialized = true;
      }
      await _selfUpdater.checkForUpdates(inBackground: false);
      return;
    }
    await _runCheck(force: true);
  }

  /// Uma passada de checagem (boot ou periódica).
  Future<void> _runCheck({bool force = false}) async {
    if (_disposed) return;

    final freq =
        _settingsController?.settings.updateCheckFrequency ??
        UpdateCheckFrequency.never;
    if (!force) {
      if (freq == UpdateCheckFrequency.never) return;

      final lastCheck = _settingsController?.settings.lastUpdateCheckTime;
      if (lastCheck != null) {
        final now = DateTime.now();
        final diff = now.difference(lastCheck);
        if (freq == UpdateCheckFrequency.daily && diff.inDays < 1) return;
        if (freq == UpdateCheckFrequency.weekly && diff.inDays < 7) return;
        if (freq == UpdateCheckFrequency.monthly && diff.inDays < 30) return;
      }
    }

    _settingsController?.setLastUpdateCheckTime(DateTime.now());

    if (isSelfUpdate) {
      _selfSub ??= _selfUpdater.changes.listen(_onSelfUpdateChange);
      if (!_selfInitialized) {
        await _selfUpdater.initialize();
        _selfInitialized = true;
      }
      await _selfUpdater.checkForUpdates(inBackground: true);
      return;
    }
    // Linux: notify + download manual.
    final latest = await _checker.fetchLatest();
    if (latest == null) return; // sem rede/manifest/inválido → nada.
    if (!isNewerVersion(latest.version, currentVersion)) return; // igual/menor.
    if (_dismissed.dismissedVersion() == latest.version) return; // dispensada.
    _available = latest;
    _safeNotify();
  }

  /// Reage a uma transição do motor nativo. Além de repintar, completa a versão
  /// pelo `latest.json` quando o motor não a informa (Windows) — só quando há
  /// update pendente, pra não gastar rede à toa no caminho feliz.
  void _onSelfUpdateChange(SelfUpdateState state) {
    if (state.hasPendingUpdate &&
        state.version == null &&
        _fallbackVersion == null) {
      unawaited(_fetchFallbackVersion());
    }
    _safeNotify();
  }

  Future<void> _fetchFallbackVersion() async {
    final latest = await _checker.fetchLatest(); // nunca lança; `null` em falha
    if (_disposed || latest == null) return;
    _fallbackVersion = latest.version;
    _safeNotify();
  }

  // ---- Ações do card ----

  /// Toque no card: self-update → aciona o update (macOS instala+relança o já
  /// baixado; Windows inicia download+install); Linux → baixa o artefato (abre a
  /// URL no navegador).
  Future<void> primaryAction() async {
    if (isSelfUpdate) {
      await _selfUpdater.applyUpdate();
      return;
    }
    await _download();
  }

  /// Fecha o card. Self-update → dispensa só pela sessão (reaparece se baixar
  /// outra versão). Linux → persiste a versão como dispensada (não reaparece).
  Future<void> dismiss() async {
    if (isSelfUpdate) {
      _selfDismissed = true;
      _safeNotify();
      return;
    }
    final v = _available?.version;
    _available = null;
    _safeNotify();
    if (v != null) await _dismissed.dismiss(v);
  }

  /// Abre a URL do artefato da plataforma corrente; sem artefato compatível →
  /// abre a página de download do site (caminho Linux/notify).
  Future<void> _download() async {
    final info = _available;
    if (info == null) return;
    final artifact = info.artifactFor(
      platform: platform,
      format: format,
      arch: arch,
    );
    await _opener.open(artifact?.url ?? fallbackUrl);
  }

  void _safeNotify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _periodic?.cancel();
    _selfSub?.cancel();
    super.dispose();
  }
}
