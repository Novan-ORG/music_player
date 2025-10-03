import 'package:music_player/core/result.dart';
import 'package:music_player/features/music_plyer/domain/domain.dart';

class PauseSong {
  const PauseSong(this.repository);

  final MusicPlayerRepository repository;

  Future<Result<void>> call() {
    return repository.pause();
  }
}
