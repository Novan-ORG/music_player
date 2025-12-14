import 'package:music_player/features/music_plyer/domain/domain.dart';

/// Use case for watching the current playback position.
///
/// Provides a stream that continuously emits position
/// updates as the song plays.
class WatchSongPosition {
  /// Creates a [WatchSongPosition] use case.
  const WatchSongPosition(this._repository);

  final MusicPlayerRepository _repository;

  /// Returns a stream of the current playback position.
  ///
  /// Emits position updates as the song plays, typically every second.
  Stream<Duration> call() {
    return _repository.positionStream();
  }
}
