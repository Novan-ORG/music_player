import 'package:music_player/core/result.dart';
import 'package:music_player/features/playlist/domain/domain.dart';

class GetAllPlaylists {
  const GetAllPlaylists(this._repository);

  final PlaylistRepository _repository;

  Future<Result<List<Playlist>>> call() {
    return _repository.getAllPlaylists();
  }
}
