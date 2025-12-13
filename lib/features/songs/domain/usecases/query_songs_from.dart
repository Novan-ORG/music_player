import 'package:music_player/core/domain/entities/entities.dart';
import 'package:music_player/core/result.dart';
import 'package:music_player/features/songs/domain/enums/enums.dart';
import 'package:music_player/features/songs/domain/repositories/repositories.dart';

class QuerySongsFrom {
  const QuerySongsFrom(this._repository);

  final SongsRepository _repository;

  Future<Result<List<Song>>> call({
    required SongsFromType fromType,
    required Object where,
    SongsSortType sortType = SongsSortType.dateAdded,
  }) {
    return _repository.querySongsFrom(
      fromType: fromType,
      where: where,
      sortType: sortType,
    );
  }
}
