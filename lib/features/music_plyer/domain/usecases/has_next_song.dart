import 'package:music_player/core/result.dart';
import 'package:music_player/features/music_plyer/domain/domain.dart';

class HasNextSong {
  const HasNextSong(this.repository);

  final MusicPlayerRepository repository;

  Result<bool> call() {
    return repository.hasNext();
  }
}
