import 'package:music_player/core/result.dart';
import 'package:music_player/features/music_plyer/domain/domain.dart';

/// Use case for resuming playback of a paused song.
class ResumeSong {
  /// Creates a [ResumeSong] use case.
  const ResumeSong(this._repository);

  final MusicPlayerRepository _repository;

  /// Resumes playback of the currently paused song.
  ///
  /// Returns a [Result] indicating success or failure.
  Future<Result<void>> call() {
    return _repository.resume();
  }
}
