import 'package:music_player/core/domain/entities/entities.dart';
import 'package:music_player/core/result.dart';
import 'package:music_player/features/music_plyer/domain/domain.dart';

class PlaySong {
  const PlaySong(this.repository);

  final MusicPlayerRepository repository;

  Future<Result<void>> call(List<Song> playlist, int index) {
    return repository.play(playlist, index);
  }
}
