import 'package:music_player/core/result.dart';
import 'package:music_player/features/music_plyer/domain/domain.dart';

/// Use case for seeking to a specific position in a song.
///
/// Can seek within the current song or jump to a
/// different song in the playlist.
class SeekSong {
  /// Creates a [SeekSong] use case.
  const SeekSong(this._repository);

  final MusicPlayerRepository _repository;

  /// Seeks to a specific position.
  ///
  /// Parameters:
  /// - [position]: The position to seek to
  /// - [index]: Optional song index to jump to a different song
  ///
  /// Returns a [Result] indicating success or failure.
  Future<Result<void>> call(Duration position, {int? index}) {
    return _repository.seek(position, index: index);
  }
}
