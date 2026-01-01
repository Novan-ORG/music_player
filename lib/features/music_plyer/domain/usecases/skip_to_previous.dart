import 'package:music_player/core/result.dart';
import 'package:music_player/features/music_plyer/domain/domain.dart';

/// Use case for skipping to the previous song in the playlist.
class SkipToPrevious {
  const SkipToPrevious(this.repository);

  final MusicPlayerRepository repository;

  Future<Result<void>> call() {
    return repository.skipToPrevious();
  }
}
