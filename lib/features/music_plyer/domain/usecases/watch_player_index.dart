import 'package:music_player/features/music_plyer/domain/domain.dart';

/// Use case for watching the current song index in the playlist.
///
/// Provides a stream that emits whenever the current song changes.
class WatchPlayerIndex {
  /// Creates a [WatchPlayerIndex] use case.
  const WatchPlayerIndex(this._repository);

  final MusicPlayerRepository _repository;

  /// Returns a stream of the current song index.
  ///
  /// Emits the index whenever the current song changes.
  /// Emits `null` when no song is playing.
  Stream<int?> call() {
    return _repository.currentIndexStream();
  }
}
