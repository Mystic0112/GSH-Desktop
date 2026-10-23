/// Erro tipado da camada de processo RPC, já traduzido do mundo de I/O
/// (`data/`) para algo que o domínio e a UI entendem. Nunca vaza `Exception`
/// cru nem `Map<String,dynamic>`.
class RpcError {
  const RpcError(this.message, {this.cause, this.stackTrace});

  final String message;
  final Object? cause;
  final StackTrace? stackTrace;

  @override
  String toString() => 'RpcError: $message';
}
