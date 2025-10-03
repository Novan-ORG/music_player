import 'package:music_player/core/result.dart';
import 'package:music_player/features/music_plyer/domain/domain.dart';

class ToggleSongLike {
  const ToggleSongLike(this.repository);

  final MusicPlayerRepository repository;

  Future<Result<Set<int>>> call(int songId) {
    return repository.toggleLike(songId);
  }
}
