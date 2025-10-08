import 'package:music_player/core/result.dart';
import 'package:music_player/features/music_plyer/domain/domain.dart';

class ToggleSongLike {
  const ToggleSongLike(this._repository);

  final MusicPlayerRepository _repository;

  Future<Result<Set<int>>> call(int songId) {
    return _repository.toggleLike(songId);
  }
}
