import 'package:music_player/core/result.dart';
import 'package:music_player/features/music_plyer/domain/repositories/repositories.dart';

class ClearSavedPlaybackSession {
  const ClearSavedPlaybackSession(this._repository);

  final MusicPlayerRepository _repository;

  Future<Result<bool>> call() {
    return _repository.clearSavedPlaybackSession();
  }
}
