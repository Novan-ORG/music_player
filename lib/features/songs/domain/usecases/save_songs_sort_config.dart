import 'package:music_player/core/result.dart';
import 'package:music_player/features/songs/domain/entities/entities.dart';
import 'package:music_player/features/songs/domain/repositories/repositories.dart';

class SaveSongsSortConfig {
  const SaveSongsSortConfig(this._repository);

  final SongsRepository _repository;

  /// Use case to save the user's preferred sort configuration for songs.
  //// Parameters:
  /// - [sortConfig]: The sort configuration to save
  Future<Result<bool>> call({required SortConfig sortConfig}) {
    return _repository.saveSortConfig(sortConfig: sortConfig);
  }
}
