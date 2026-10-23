/// Algo cujo recurso precisa ser liberado explicitamente (processos, streams).
abstract class Disposable {
  void dispose();
}
