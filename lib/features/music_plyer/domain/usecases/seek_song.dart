import 'package:music_player/core/result.dart';
import 'package:music_player/features/music_plyer/domain/domain.dart';

class SeekSong {
  const SeekSong(this._repository);

  final MusicPlayerRepository _repository;

  Future<Result<void>> call(Duration position, {int? index}) {
    return _repository.seek(position, index: index);
  }
}
