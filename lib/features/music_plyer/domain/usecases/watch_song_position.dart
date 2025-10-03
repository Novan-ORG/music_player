import 'package:music_player/features/music_plyer/domain/domain.dart';

class WatchSongPosition {
  const WatchSongPosition(this.repository);

  final MusicPlayerRepository repository;

  Stream<Duration> call() {
    return repository.positionStream();
  }
}
