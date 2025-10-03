import 'package:music_player/core/result.dart';
import 'package:music_player/features/music_plyer/domain/domain.dart';

class SeekSong {
  const SeekSong(this.repository);

  final MusicPlayerRepository repository;

  Future<Result<void>> call(Duration position, {int? index}) {
    return repository.seek(position, index: index);
  }
}
