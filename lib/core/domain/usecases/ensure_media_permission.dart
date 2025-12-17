import 'package:music_player/core/result.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';

/// Use case for ensuring media/audio permissions are granted.
///
/// This use case checks if the app has permission to access audio files
/// on the device and requests permission if not already granted.
///
/// Required for accessing songs, albums, and other audio metadata from
/// the device's media store.
///
/// **Example:**
/// ```dart
/// final result = await ensureMediaPermission();
/// if (result.isSuccess) {
///   // Permission granted, can access audio files
/// } else {
///   // Permission denied, show error to user
/// }
/// ```
class EnsureMediaPermission {
  /// Creates an [EnsureMediaPermission] use case.
  EnsureMediaPermission(this._onAudioQuery);

  final OnAudioQuery _onAudioQuery;

  /// Checks and requests media permission if needed.
  ///
  /// Returns a [Result] containing `true` if permission is granted,
  /// or an error message if permission is denied.
  Future<Result<bool>> call() async {
    final granted = await _onAudioQuery.checkAndRequest();
    return granted
        ? Result.success(true)
        : Result.failure('Permission not granted');
  }
}
