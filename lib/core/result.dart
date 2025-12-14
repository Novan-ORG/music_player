/// A generic result type for handling success and failure cases.
///
/// This class follows the Result pattern (also known as Either pattern)
/// to represent operations that can either succeed with a value or fail
/// with an error.
///
/// **Usage:**
/// ```dart
/// Future<Result<User>> getUser(int id) async {
///   try {
///     final user = await api.fetchUser(id);
///     return Result.success(user);
///   } on Exception catch (e) {
///     return Result.failure('Failed to fetch user: $e');
///   }
/// }
///
/// // Consuming the result
/// final result = await getUser(123);
/// if (result.isSuccess) {
///   print('User: ${result.value}');
/// } else {
///   print('Error: ${result.error}');
/// }
/// ```
class Result<T> {
  /// Creates a successful result with the given [value].
  ///
  /// The [error] will be null for successful results.
  Result.success(this.value) : error = null;

  /// Creates a failed result with the given [error] message.
  ///
  /// The [value] will be null for failed results.
  Result.failure(this.error) : value = null;

  /// The value returned by a successful operation.
  ///
  /// This will be null if the operation failed.
  final T? value;

  /// The error message describing why the operation failed.
  ///
  /// This will be null if the operation succeeded.
  final String? error;

  /// Returns true if the operation succeeded (error is null).
  bool get isSuccess => error == null;

  /// Returns true if the operation failed (error is not null).
  bool get isFailure => error != null;
}
