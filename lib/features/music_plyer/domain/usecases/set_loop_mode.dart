import 'package:music_player/core/result.dart';
import 'package:music_player/features/music_plyer/domain/domain.dart';

class SetLoopMode {
  const SetLoopMode(this.repository);

  final MusicPlayerRepository repository;

  Result<PlayerLoopMode> call({required PlayerLoopMode loopMode}) {
    return repository.setLoopMode(loopMode);
  }
}
