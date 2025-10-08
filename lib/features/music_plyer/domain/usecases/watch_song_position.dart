import 'package:music_player/features/music_plyer/domain/domain.dart';

class WatchSongPosition {
  const WatchSongPosition(this._repository);

  final MusicPlayerRepository _repository;

  Stream<Duration> call() {
    return _repository.positionStream();
  }
}
