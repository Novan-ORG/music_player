import 'package:music_player/core/result.dart';
import 'package:music_player/features/playlist/domain/domain.dart';

/// Use case for creating a new playlist.
///
/// Creates an empty playlist with the specified name.
class CreatePlaylist {
  /// Creates a [CreatePlaylist] use case.
  const CreatePlaylist(this._repository);

  final PlaylistRepository _repository;

  /// Creates a new playlist with the given name.
  ///
  /// Parameters:
  /// - [name]: Name for the new playlist
  ///
  /// Returns a [Result] containing `true` if successful, or an error.
  Future<Result<bool>> call(String name) {
    return _repository.createPlaylist(name);
  }
}
