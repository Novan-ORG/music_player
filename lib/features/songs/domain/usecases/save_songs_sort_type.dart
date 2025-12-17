import 'package:music_player/core/result.dart';
import 'package:music_player/features/songs/domain/enums/enums.dart';
import 'package:music_player/features/songs/domain/repositories/repositories.dart';

class SaveSongsSortType {
  const SaveSongsSortType(this._repository);

  final SongsRepository _repository;

  Future<Result<bool>> call({required SongsSortType sortType}) {
    return _repository.saveSongsSortType(sortType: sortType);
  }
}
