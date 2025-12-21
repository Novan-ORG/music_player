import 'package:music_player/core/domain/entities/song.dart';
import 'package:music_player/core/result.dart';
import 'package:music_player/features/playlist/domain/repositories/playlist_repository.dart';

class GetRecentlyPlayedSongs {
  /// Creates a [GetRecentlyPlayedSongs] use case.
  const GetRecentlyPlayedSongs(this._repository);

  final PlaylistRepository _repository;

  /// Retrieves the list of recently played songs.
  ////  /// Returns a [Result] containing the list of songs or an error.
  Future<Result<List<Song>>> call() {
    return _repository.getRecentlyPlayedSongs();
  }
}
