import 'package:music_player/core/result.dart';
import 'package:music_player/features/playlist/domain/repositories/playlist_repository.dart';

class AddSongsToPlaylist {
  const AddSongsToPlaylist(this._repository);

  final PlaylistRepository _repository;

  Future<Result<void>> call(int playlistId, List<int> songIds) {
    return _repository.addSongsToPlaylist(playlistId, songIds);
  }
}
