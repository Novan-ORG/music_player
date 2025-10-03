import 'package:just_audio/just_audio.dart' show LoopMode;
import 'package:music_player/features/music_plyer/domain/entities/entities.dart'
    show PlayerLoopMode;

sealed class PlayerLoopModeMapper {
  static PlayerLoopMode map(LoopMode loopMode) {
    switch (loopMode) {
      case LoopMode.off:
        return PlayerLoopMode.off;
      case LoopMode.all:
        return PlayerLoopMode.all;
      case LoopMode.one:
        return PlayerLoopMode.one;
    }
  }

  static LoopMode mapToLoopMode(PlayerLoopMode loopMode) {
    switch (loopMode) {
      case PlayerLoopMode.off:
        return LoopMode.off;
      case PlayerLoopMode.all:
        return LoopMode.all;
      case PlayerLoopMode.one:
        return LoopMode.one;
    }
  }
}
