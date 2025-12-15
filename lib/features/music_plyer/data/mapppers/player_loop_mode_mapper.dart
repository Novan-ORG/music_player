import 'package:just_audio/just_audio.dart';
import 'package:music_player/features/music_plyer/domain/entities/entities.dart';

/// Mapper for converting between domain and audio library loop modes.
///
/// Maps [PlayerLoopMode] to [LoopMode] from the just_audio package.
sealed class PlayerLoopModeMapper {
  /// Maps domain [PlayerLoopMode] to just_audio [LoopMode].
  ///
  /// Parameters:
  /// - [loopMode]: The domain loop mode to convert
  ///
  /// Returns the corresponding [LoopMode] for the audio library.
  static LoopMode mapToLoopMode(PlayerLoopMode loopMode) {
    return switch (loopMode) {
      PlayerLoopMode.off => LoopMode.off,
      PlayerLoopMode.one => LoopMode.one,
      PlayerLoopMode.all => LoopMode.all,
    };
  }
}
