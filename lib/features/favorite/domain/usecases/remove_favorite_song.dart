import 'package:music_player/core/result.dart';
import 'package:music_player/features/favorite/domain/repositories/repositories.dart';

class RemoveFavoriteSong {
  const RemoveFavoriteSong(this._repository);

  final FavoriteSongsRepository _repository;

  Future<Result<void>> call(int songId) {
    return _repository.removeFavoriteSong(songId);
  }
}
