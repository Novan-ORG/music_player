import 'package:music_player/core/result.dart';
import 'package:music_player/features/music_plyer/domain/domain.dart';

class PauseSong {
  const PauseSong(this._repository);

  final MusicPlayerRepository _repository;

  Future<Result<void>> call() {
    return _repository.pause();
  }
}
