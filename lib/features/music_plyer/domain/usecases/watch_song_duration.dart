import 'package:music_player/features/music_plyer/domain/domain.dart';

/// Use case for watching the current song's duration.
///
/// Provides a stream that emits the duration when a new song starts playing.
class WatchSongDuration {
  /// Creates a [WatchSongDuration] use case.
  const WatchSongDuration(this._repository);

  final MusicPlayerRepository _repository;

  /// Returns a stream of the current song's duration.
  ///
  /// Emits the duration when a new song starts playing.
  /// Emits `null` when no song is loaded.
  Stream<Duration?> call() {
    return _repository.durationStream();
  }
}
