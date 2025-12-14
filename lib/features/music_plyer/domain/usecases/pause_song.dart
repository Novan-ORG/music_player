import 'package:music_player/core/result.dart';
import 'package:music_player/features/music_plyer/domain/repositories/repositories.dart';

/// Use case for pausing the currently playing song.
class PauseSong {
  /// Creates a [PauseSong] use case.
  const PauseSong(this._repository);

  final MusicPlayerRepository _repository;

  /// Pauses the currently playing song.
  ///
  /// Returns a [Result] indicating success or failure.
  Future<Result<void>> call() {
    return _repository.pause();
  }
}
