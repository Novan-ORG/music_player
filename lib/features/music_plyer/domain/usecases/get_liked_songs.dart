import 'package:music_player/core/result.dart';
import 'package:music_player/features/music_plyer/domain/domain.dart';

class GetLikedSongs {
  const GetLikedSongs(this.repository);

  final MusicPlayerRepository repository;

  Result<Set<int>> call() {
    return repository.getLikedSongIds();
  }
}
