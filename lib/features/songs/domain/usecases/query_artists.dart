import 'package:music_player/core/result.dart';
import 'package:music_player/features/songs/domain/entities/entities.dart';
import 'package:music_player/features/songs/domain/enums/enums.dart';
import 'package:music_player/features/songs/domain/repositories/repositories.dart';

class QueryArtists {
  const QueryArtists(this._repository);

  final SongsRepository _repository;

  Future<Result<List<Artist>>> call({
    ArtistsSortType sortType = ArtistsSortType.artist,
  }) {
    return _repository.queryArtists(sortType: sortType);
  }
}
