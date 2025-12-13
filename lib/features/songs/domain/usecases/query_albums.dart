import 'package:music_player/core/result.dart';
import 'package:music_player/features/songs/domain/entities/entities.dart';
import 'package:music_player/features/songs/domain/enums/enums.dart';
import 'package:music_player/features/songs/domain/repositories/repositories.dart';

class QueryAlbums {
  const QueryAlbums(this._repository);

  final SongsRepository _repository;

  Future<Result<List<Album>>> call({
    AlbumsSortType sortType = AlbumsSortType.album,
  }) {
    return _repository.queryAlbums(sortType: sortType);
  }
}
