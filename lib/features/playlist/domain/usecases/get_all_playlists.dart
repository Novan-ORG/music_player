import 'package:music_player/core/result.dart';
import 'package:music_player/features/playlist/domain/domain.dart';

/// Use case for retrieving all playlists.
///
/// Returns all user-created playlists from storage.
class GetAllPlaylists {
  /// Creates a [GetAllPlaylists] use case.
  const GetAllPlaylists(this._repository);

  final PlaylistRepository _repository;

  /// Retrieves all playlists.
  ///
  /// Returns a [Result] containing the list of playlists or an error.
  Future<Result<List<Playlist>>> call() {
    return _repository.getAllPlaylists();
  }
}
