import 'package:music_player/core/domain/entities/song.dart';
import 'package:music_player/core/result.dart';
import 'package:music_player/features/music_plyer/domain/repositories/repositories.dart';

class SavePlaybackSession {
  const SavePlaybackSession(this._repository);

  final MusicPlayerRepository _repository;

  Future<Result<bool>> call(
    List<Song> playlist,
    int currentIndex, {
    required bool wasPlaying,
  }) {
    return _repository.savePlaybackSession(
      playlist,
      currentIndex,
      wasPlaying: wasPlaying,
    );
  }
}
