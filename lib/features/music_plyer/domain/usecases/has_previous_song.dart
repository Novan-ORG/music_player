import 'package:music_player/core/result.dart';
import 'package:music_player/features/music_plyer/domain/domain.dart';

/// Use case for checking if there is a previous song in the playlist.
class HasPreviousSong {
  /// Creates a [HasPreviousSong] use case.
  const HasPreviousSong(this._repository);

  final MusicPlayerRepository _repository;

  /// Checks if there is a previous song available.
  ///
  /// Returns a [Result] containing `true` if there is a previous song,
  /// `false` otherwise.
  Result<bool> call() {
    return _repository.hasPrevious();
  }
}
