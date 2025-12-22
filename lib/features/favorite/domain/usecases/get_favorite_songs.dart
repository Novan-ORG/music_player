import 'package:music_player/core/domain/entities/song.dart';
import 'package:music_player/core/result.dart';
import 'package:music_player/features/favorite/domain/repositories/repositories.dart';

/// Use case to fetch all favorite songs.
class GetFavoriteSongs {
  const GetFavoriteSongs(this._repository);

  final FavoriteSongsRepository _repository;

  Future<Result<List<Song>>> call() {
    return _repository.getFavoriteSongs();
  }
}
