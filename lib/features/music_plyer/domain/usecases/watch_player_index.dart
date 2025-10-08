import 'package:music_player/features/music_plyer/domain/domain.dart';

class WatchPlayerIndex {
  const WatchPlayerIndex(this._repository);

  final MusicPlayerRepository _repository;

  Stream<int?> call() {
    return _repository.currentIndexStream();
  }
}
