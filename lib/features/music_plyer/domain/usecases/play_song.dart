import 'package:music_player/core/domain/entities/song.dart';
import 'package:music_player/core/result.dart';
import 'package:music_player/features/music_plyer/domain/repositories/repositories.dart';

/// Use case for playing a playlist of songs.
///
/// Starts playback of a playlist at the specified index.
class PlaySong {
  /// Creates a [PlaySong] use case.
  const PlaySong(this._repository);

  final MusicPlayerRepository _repository;

  /// Plays a playlist starting at the specified song index.
  ///
  /// Parameters:
  /// - [playlist]: List of songs to play
  /// - [index]: Index of the song to start playing
  ///
  /// Returns a [Result] indicating success or failure.
  Future<Result<void>> call(List<Song> playlist, int index) {
    return _repository.play(playlist, index);
  }
}
