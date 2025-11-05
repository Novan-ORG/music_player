import 'package:music_player/core/result.dart';
import 'package:music_player/features/playlist/domain/domain.dart';

class RenamePlaylist {
  const RenamePlaylist(this._repository);

  final PlaylistRepository _repository;

  Future<Result<bool>> call(int id, String name) {
    return _repository.renamePlaylist(id, name);
  }
}
