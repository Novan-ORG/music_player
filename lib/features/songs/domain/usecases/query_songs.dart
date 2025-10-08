import 'package:music_player/core/domain/entities/entities.dart';
import 'package:music_player/core/result.dart';
import 'package:music_player/features/songs/domain/repositories/repositories.dart';

class QuerySongs {
  const QuerySongs(this._repository);

  final SongsRepository _repository;

  Future<Result<List<Song>>> call() {
    return _repository.querySongs();
  }
}
