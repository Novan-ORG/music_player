import 'package:music_player/core/result.dart';
import 'package:music_player/features/playlist/domain/domain.dart';

class CreatePlaylist {
  const CreatePlaylist(this._repository);

  final PlaylistRepository _repository;

  Future<Result<bool>> call(String name) {
    return _repository.createPlaylist(name);
  }
}
