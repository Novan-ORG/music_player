import 'package:music_player/core/result.dart';
import 'package:music_player/features/music_plyer/domain/domain.dart';

class SetShuffleEnabled {
  const SetShuffleEnabled(this._repository);

  final MusicPlayerRepository _repository;

  Future<Result<void>> call({required bool isEnabled}) {
    return _repository.setShuffleModeEnabled(isEnabled: isEnabled);
  }
}
