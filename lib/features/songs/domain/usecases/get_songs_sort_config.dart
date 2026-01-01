import 'package:music_player/core/result.dart';
import 'package:music_player/features/songs/domain/entities/entities.dart';
import 'package:music_player/features/songs/domain/repositories/repositories.dart';

class GetSongsSortConfig {
  const GetSongsSortConfig(this._repository);

  final SongsRepository _repository;

  /// Use case to retrieve the user's saved sort configuration for songs.
  //// Returns a [Result] containing the [SortConfig] or an error message.
  Result<SortConfig> call() {
    return _repository.getSongsSortConfig();
  }
}
