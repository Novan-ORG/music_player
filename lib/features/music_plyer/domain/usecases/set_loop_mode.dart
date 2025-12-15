import 'package:music_player/core/result.dart';
import 'package:music_player/features/music_plyer/domain/domain.dart';

/// Use case for setting the loop/repeat mode.
///
/// Controls whether playback loops the current song, entire playlist, or stops.
class SetLoopMode {
  /// Creates a [SetLoopMode] use case.
  const SetLoopMode(this._repository);

  final MusicPlayerRepository _repository;

  /// Sets the loop mode for playback.
  ///
  /// Parameters:
  /// - [loopMode]: The desired loop mode (off, one, or all)
  ///
  /// Returns a [Result] containing the set loop mode or an error.
  Result<PlayerLoopMode> call({required PlayerLoopMode loopMode}) {
    return _repository.setLoopMode(loopMode);
  }
}
