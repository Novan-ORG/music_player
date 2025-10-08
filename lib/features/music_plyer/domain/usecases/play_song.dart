import 'package:music_player/core/domain/entities/entities.dart';
import 'package:music_player/core/result.dart';
import 'package:music_player/features/music_plyer/domain/domain.dart';

class PlaySong {
  const PlaySong(this._repository);

  final MusicPlayerRepository _repository;

  Future<Result<void>> call(List<Song> playlist, int index) {
    return _repository.play(playlist, index);
  }
}
