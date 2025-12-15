import 'package:music_player/core/result.dart';
import 'package:music_player/features/songs/domain/entities/entities.dart';
import 'package:music_player/features/songs/domain/enums/enums.dart';
import 'package:music_player/features/songs/domain/repositories/repositories.dart';

/// Use case for querying all albums from the device.
///
/// Retrieves all music albums from the device storage and returns them
/// as a list of [Album] entities, sorted according to the specified type.
class QueryAlbums {
  /// Creates a [QueryAlbums] use case.
  const QueryAlbums(this._repository);

  final SongsRepository _repository;

  /// Queries all albums from the device.
  ///
  /// Parameters:
  /// - [sortType]: How to sort the results (defaults to album name)
  ///
  /// Returns a [Result] containing the list of albums or an error message.
  Future<Result<List<Album>>> call({
    AlbumsSortType sortType = AlbumsSortType.album,
  }) {
    return _repository.queryAlbums(sortType: sortType);
  }
}
