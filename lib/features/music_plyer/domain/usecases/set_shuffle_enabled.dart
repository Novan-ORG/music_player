import 'package:music_player/core/result.dart';
import 'package:music_player/features/music_plyer/domain/domain.dart';

/// Use case for enabling or disabling shuffle mode.
///
/// When shuffle is enabled, songs play in random order.
class SetShuffleEnabled {
  /// Creates a [SetShuffleEnabled] use case.
  const SetShuffleEnabled(this._repository);

  final MusicPlayerRepository _repository;

  /// Enables or disables shuffle mode.
  ///
  /// Parameters:
  /// - [isEnabled]: Whether shuffle should be enabled
  ///
  /// Returns a [Result] indicating success or failure.
  Future<Result<void>> call({required bool isEnabled}) {
    return _repository.setShuffleModeEnabled(isEnabled: isEnabled);
  }
}
