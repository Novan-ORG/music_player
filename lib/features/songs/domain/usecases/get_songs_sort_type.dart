import 'package:music_player/core/result.dart';
import 'package:music_player/features/songs/domain/enums/enums.dart';
import 'package:music_player/features/songs/domain/repositories/repositories.dart';

class GetSongsSortType {
  const GetSongsSortType(this._repository);

  final SongsRepository _repository;

  Result<SongsSortType> call() {
    return _repository.getSongsSortType();
  }
}
