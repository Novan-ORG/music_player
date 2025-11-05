import 'package:music_player/core/result.dart';
import 'package:music_player/features/favorite/domain/repositories/repositories.dart';

class ToggleFavoriteSong {
  const ToggleFavoriteSong(this._repository);

  final FavoriteSongsRepository _repository;

  Future<Result<bool>> call(int songId) async {
    final isFavoriteResult = _repository.isFavorite(songId);
    if (isFavoriteResult.isFailure) {
      return Result.failure(isFavoriteResult.error);
    }

    if (isFavoriteResult.value!) {
      final removeResult = await _repository.removeFavoriteSong(songId);
      if (removeResult.isFailure) {
        return Result.failure(removeResult.error);
      }
      return Result.success(false);
    } else {
      final addResult = await _repository.addFavoriteSong(songId);
      if (addResult.isFailure) {
        return Result.failure(addResult.error);
      }
      return Result.success(true);
    }
  }
}
