import 'package:music_player/core/result.dart';
import 'package:music_player/features/playlist/domain/domain.dart';

class GetPlaylistById {
  const GetPlaylistById(this._repository);

  final PlaylistRepository _repository;

  Future<Result<Playlist>> call(int id) {
    return _repository.getPlaylistById(id);
  }
}
