import 'package:music_player/core/result.dart';
import 'package:music_player/features/songs/domain/entities/entities.dart';
import 'package:music_player/features/songs/domain/repositories/repositories.dart';

class QueryFolders {
  const QueryFolders(this._repository);

  final SongsRepository _repository;

  Future<Result<List<Folder>>> call() {
    return _repository.queryFolders();
  }
}
