import 'package:music_player/core/result.dart';
import 'package:music_player/features/music_plyer/domain/domain.dart';

class StopSong {
  const StopSong(this._repository);

  final MusicPlayerRepository _repository;

  Future<Result<void>> call() {
    return _repository.stop();
  }
}
