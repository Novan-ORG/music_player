import 'package:music_player/core/result.dart';
import 'package:music_player/features/playlist/domain/repositories/playlist_repository.dart';

class GetPlaylistCoverSongId {
  const GetPlaylistCoverSongId(this._repository);

  final PlaylistRepository _repository;

  Future<Result<int?>> call(int playlistId) {
    return _repository.getPlaylistCoverSongId(playlistId);
  }
}

