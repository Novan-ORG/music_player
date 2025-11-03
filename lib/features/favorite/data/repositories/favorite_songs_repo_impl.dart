import 'package:music_player/core/data/mappers/mappers.dart';
import 'package:music_player/core/domain/entities/song.dart';
import 'package:music_player/core/result.dart';
import 'package:music_player/features/favorite/data/datasources/datasources.dart';
import 'package:music_player/features/favorite/domain/domain.dart';

class FavoriteSongsRepoImpl implements FavoriteSongsRepository {
  FavoriteSongsRepoImpl({required this.datasource});

  final FavoriteSongsDatasource datasource;

  @override
  Future<Result<List<Song>>> getFavoriteSongs() async {
    try {
      final models = await datasource.getFavoriteSongs();
      final entities = models.map(SongModelMapper.toDomain).toList();
      return Result.success(entities);
    } on Exception catch (e) {
      return Result.failure('Failed to get favorite songs: $e');
    }
  }

  @override
  Future<Result<void>> addFavoriteSong(int songId) async {
    try {
      await datasource.addFavoriteSong(songId);
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure('Failed to add favorite song: $e');
    }
  }

  @override
  Future<Result<void>> removeFavoriteSong(int songId) async {
    try {
      await datasource.removeFavoriteSong(songId);
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure('Failed to remove favorite song: $e');
    }
  }

  @override
  Result<bool> isFavorite(int songId) {
    try {
      final isFav = datasource.isFavorite(songId);
      return Result.success(isFav);
    } on Exception catch (e) {
      return Result.failure('Failed to check favorite status: $e');
    }
  }

  @override
  Result<void> clearAllFavorites() {
    try {
      datasource.clearAllFavorites();
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure('Failed to clear favorites: $e');
    }
  }
}
