import 'package:music_player/core/result.dart';
import 'package:music_player/features/music_plyer/domain/domain.dart';

class HasNextSong {
  const HasNextSong(this._repository);

  final MusicPlayerRepository _repository;

  Result<bool> call() {
    return _repository.hasNext();
  }
}
