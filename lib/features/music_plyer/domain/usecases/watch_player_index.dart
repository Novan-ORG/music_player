import 'package:music_player/features/music_plyer/domain/domain.dart';

class WatchPlayerIndex {
  const WatchPlayerIndex(this.repository);

  final MusicPlayerRepository repository;

  Stream<int?> call() {
    return repository.currentIndexStream();
  }
}
