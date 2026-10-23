/// Resultado tipado de uma operação que pode falhar.
///
/// Sealed para forçar o consumidor a tratar os dois casos (`Success` /
/// `Failure`) — sem `null` ambíguo nem `catch (e)` genérico. Mora em `domain/`
/// porque os Use Cases o retornam e o domínio não importa nada de fora de si.
sealed class Result<S, F> {
  const Result();

  /// Casa os dois ramos e devolve um valor comum.
  T fold<T>(T Function(S value) onSuccess, T Function(F error) onFailure);

  bool get isSuccess => this is Success<S, F>;
  bool get isFailure => this is Failure<S, F>;

  /// Transforma o valor de sucesso, preservando a falha.
  Result<T, F> map<T>(T Function(S value) transform) =>
      fold((s) => Success(transform(s)), (f) => Failure(f));
}

final class Success<S, F> extends Result<S, F> {
  const Success(this.value);
  final S value;

  @override
  T fold<T>(T Function(S value) onSuccess, T Function(F error) onFailure) =>
      onSuccess(value);
}

final class Failure<S, F> extends Result<S, F> {
  const Failure(this.error);
  final F error;

  @override
  T fold<T>(T Function(S value) onSuccess, T Function(F error) onFailure) =>
      onFailure(error);
}
