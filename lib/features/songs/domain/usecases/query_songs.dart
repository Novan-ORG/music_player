import 'package:music_player/core/domain/entities/entities.dart';
import 'package:music_player/core/result.dart';
import 'package:music_player/features/songs/domain/entities/entities.dart';
import 'package:music_player/features/songs/domain/repositories/repositories.dart';

/// Use case for querying all songs from the device.
///
/// Retrieves all audio files from the device storage and returns them
/// as a list of [Song] entities, sorted according to the specified type.
///
/// **Example:**
/// ```dart
/// final result = await querySongs(sortType: SongsSortType.title);
/// if (result.isSuccess) {
///   print('Found ${result.value!.length} songs');
/// }
/// ```
class QuerySongs {
  /// Creates a [QuerySongs] use case.
  const QuerySongs(this._repository);

  final SongsRepository _repository;

  /// Queries all songs from the device.
  ///
  /// Parameters:
  /// - [sortConfig]: The sort configuration for the results
  ///
  /// Returns a [Result] containing the list of songs or an error message.
  Future<Result<List<Song>>> call({
    SortConfig sortConfig = const SortConfig(),
  }) {
    return _repository.querySongs(sortConfig: sortConfig);
  }
}
