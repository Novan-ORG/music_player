import 'package:music_player/core/result.dart';
import 'package:music_player/features/music_plyer/domain/entities/entities.dart';
import 'package:music_player/features/music_plyer/domain/repositories/repositories.dart';

class GetSavedPlaybackSession {
  const GetSavedPlaybackSession(this._repository);

  final MusicPlayerRepository _repository;

  Future<Result<PlaybackSession?>> call() {
    return _repository.getSavedPlaybackSession();
  }
}
