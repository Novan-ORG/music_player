import 'package:music_player/features/music_plyer/domain/domain.dart';

class WatchSongDuration {
  const WatchSongDuration(this._repository);

  final MusicPlayerRepository _repository;

  Stream<Duration?> call() {
    return _repository.durationStream();
  }
}
