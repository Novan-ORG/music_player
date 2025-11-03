import 'package:music_player/core/domain/entities/song.dart';
import 'package:music_player/core/result.dart';

abstract interface class FavoriteSongsRepository {
  Future<Result<List<Song>>> getFavoriteSongs();
  Future<Result<void>> addFavoriteSong(int songId);
  Future<Result<void>> removeFavoriteSong(int songId);
  Result<bool> isFavorite(int songId);
  Result<void> clearAllFavorites();
}
