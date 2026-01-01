import 'package:music_player/core/result.dart';
import 'package:music_player/features/music_plyer/domain/domain.dart';

/// Use case for skipping to the next song in the playlist.
class SkipToNext {
  const SkipToNext(this.repository);

  final MusicPlayerRepository repository;

  Future<Result<void>> call() {
    return repository.skipToNext();
  }
}
