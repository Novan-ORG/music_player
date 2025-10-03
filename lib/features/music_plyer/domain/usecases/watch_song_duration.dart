import 'package:music_player/features/music_plyer/domain/domain.dart';

class WatchSongDuration {
  const WatchSongDuration(this.repository);

  final MusicPlayerRepository repository;

  Stream<Duration?> call() {
    return repository.durationStream();
  }
}
