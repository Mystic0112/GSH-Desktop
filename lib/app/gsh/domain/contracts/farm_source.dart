import 'package:gsh_desktop/app/gsh/domain/entities/farm_loop.dart';

/// De onde a fazenda tira os loops de agente da máquina. Polling: quem chama
/// decide a cadência e para de chamar quando nada está olhando.
abstract interface class FarmSource {
  /// Loops ativos na janela recente, vistos a partir de [now].
  Future<List<FarmLoop>> scan(DateTime now);
}
