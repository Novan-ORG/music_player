import 'package:music_player/core/result.dart';
import 'package:music_player/features/favorite/domain/repositories/repositories.dart';

class ClearAllFavorites {
  const ClearAllFavorites(this._repository);

  final FavoriteSongsRepository _repository;

  Result<void> call() {
    return _repository.clearAllFavorites();
  }
}
