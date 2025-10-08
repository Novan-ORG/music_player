import 'package:music_player/core/result.dart';
import 'package:music_player/features/music_plyer/domain/domain.dart';

class SetLoopMode {
  const SetLoopMode(this._repository);

  final MusicPlayerRepository _repository;

  Result<PlayerLoopMode> call({required PlayerLoopMode loopMode}) {
    return _repository.setLoopMode(loopMode);
  }
}
