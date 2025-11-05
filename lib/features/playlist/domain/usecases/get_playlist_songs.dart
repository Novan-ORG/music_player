import 'package:music_player/core/domain/entities/song.dart';
import 'package:music_player/core/result.dart';
import 'package:music_player/features/playlist/domain/repositories/playlist_repository.dart';

class GetPlaylistSongs {
  const GetPlaylistSongs(this._repository);

  final PlaylistRepository _repository;

  Future<Result<List<Song>>> call(int playlistId) {
    return _repository.getPlaylistSongs(playlistId);
  }
}
