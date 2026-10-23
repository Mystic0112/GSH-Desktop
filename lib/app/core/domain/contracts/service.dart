import 'package:cockpit/app/core/domain/contracts/disposable.dart';

/// Serviço de infraestrutura (singleton preguiçoso no injector). O `dispose`
/// é encadeado pelo `CustomInjector` no descarte — para o gateway RPC, é onde
/// o child process precisa ser morto (sem órfão).
abstract class Service implements Disposable {
  @override
  void dispose() {}
}
