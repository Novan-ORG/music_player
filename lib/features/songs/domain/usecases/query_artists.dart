import 'package:music_player/core/result.dart';
import 'package:music_player/features/songs/domain/entities/entities.dart';
import 'package:music_player/features/songs/domain/enums/enums.dart';
import 'package:music_player/features/songs/domain/repositories/repositories.dart';

/// Use case for querying all artists from the device.
///
/// Retrieves all music artists from the device storage and returns them
/// as a list of [Artist] entities, sorted according to the specified type.
class QueryArtists {
  /// Creates a [QueryArtists] use case.
  const QueryArtists(this._repository);

  final SongsRepository _repository;

  /// Queries all artists from the device.
  ///
  /// Parameters:
  /// - [sortType]: How to sort the results (defaults to number of tracks)
  ///
  /// Returns a [Result] containing the list of artists or an error message.
  Future<Result<List<Artist>>> call({
    ArtistsSortType sortType = ArtistsSortType.numOfTracks,
  }) {
    return _repository.queryArtists(sortType: sortType);
  }
}
