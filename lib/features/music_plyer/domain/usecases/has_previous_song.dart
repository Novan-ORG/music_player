import 'package:music_player/core/result.dart';
import 'package:music_player/features/music_plyer/domain/domain.dart';

class HasPreviousSong {
  const HasPreviousSong(this._repository);

  final MusicPlayerRepository _repository;

  Result<bool> call() {
    return _repository.hasPrevious();
  }
}
