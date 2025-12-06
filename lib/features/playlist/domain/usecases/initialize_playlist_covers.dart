import 'package:music_player/core/result.dart';
import 'package:music_player/features/playlist/domain/repositories/playlist_repository.dart';

class InitializePlaylistCovers {
  const InitializePlaylistCovers(this._repository);

  final PlaylistRepository _repository;

  Future<Result<void>> call() {
    return _repository.initializePlaylistCoversForExistingPlaylists();
  }
}

