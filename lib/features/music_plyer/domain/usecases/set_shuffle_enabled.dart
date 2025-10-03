import 'package:music_player/core/result.dart';
import 'package:music_player/features/music_plyer/domain/domain.dart';

class SetShuffleEnabled {
  const SetShuffleEnabled(this.repository);

  final MusicPlayerRepository repository;

  Future<Result<void>> call({required bool isEnabled}) {
    return repository.setShuffleModeEnabled(isEnabled: isEnabled);
  }
}
