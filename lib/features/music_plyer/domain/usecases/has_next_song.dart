import 'package:music_player/core/result.dart';
import 'package:music_player/features/music_plyer/domain/domain.dart';

/// Use case for checking if there is a next song in the playlist.
class HasNextSong {
  /// Creates a [HasNextSong] use case.
  const HasNextSong(this._repository);

  final MusicPlayerRepository _repository;

  /// Checks if there is a next song available.
  ///
  /// Returns a [Result] containing `true` if there is a next song,
  /// `false` otherwise.
  Result<bool> call() {
    return _repository.hasNext();
  }
}
