import 'package:music_player/core/result.dart';
import 'package:music_player/features/music_plyer/domain/domain.dart';

class AddToRecentlyPlayed {
  /// Creates an [AddToRecentlyPlayed] use case.
  const AddToRecentlyPlayed(this._repository);

  final MusicPlayerRepository _repository;

  /// Adds a song to the recently played list.
  ////
  /// Parameters:
  /// - [songId]: ID of the song to add
  /// Returns a [Result] indicating success or failure.
  Future<Result<bool>> call(int songId) {
    return _repository.addToRecentlyPlayed(songId);
  }
}
