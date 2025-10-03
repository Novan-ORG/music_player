class Result<T> {
  Result.success(this.value) : error = null;
  Result.failure(this.error) : value = null;

  final T? value;
  final String? error;

  bool get isSuccess => error == null;
  bool get isFailure => error != null;
}
