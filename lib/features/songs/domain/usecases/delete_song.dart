import 'package:music_player/core/result.dart';
import 'package:music_player/features/songs/domain/repositories/repositories.dart';

class DeleteSong {
  const DeleteSong(this._repository);

  final SongsRepository _repository;

  Future<Result<bool>> call({required String songUri}) {
    return _repository.deleteSong(songUri);
  }
}
