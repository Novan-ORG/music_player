import 'package:music_player/core/result.dart';
import 'package:music_player/features/music_plyer/domain/domain.dart';

/// Use case for stopping music playback.
///
/// Stops playback and clears the current playlist.
class StopSong {
  /// Creates a [StopSong] use case.
  const StopSong(this._repository);

  final MusicPlayerRepository _repository;

  /// Stops playback and clears the playlist.
  ///
  /// Returns a [Result] indicating success or failure.
  Future<Result<void>> call() {
    return _repository.stop();
  }
}
