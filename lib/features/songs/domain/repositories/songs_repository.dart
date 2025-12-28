import 'package:music_player/core/domain/entities/entities.dart';
import 'package:music_player/core/result.dart';
import 'package:music_player/features/songs/domain/entities/entities.dart';
import 'package:music_player/features/songs/domain/enums/enums.dart';

/// Repository interface for managing songs, albums, and artists data.
///
/// This repository provides methods to query songs from various sources,
/// manage song deletion, and handle user preferences for sorting.
///
/// **Note**: This repository currently handles multiple responsibilities
/// (songs, albums, artists, preferences). Consider splitting into focused
/// repositories for better adherence to Interface Segregation Principle.
abstract interface class SongsRepository {
  /// Queries songs from a specific source (album, artist, playlist, etc.).
  ///
  /// Parameters:
  /// - [fromType]: The type of source to query from (album, artist, etc.)
  /// - [where]: The identifier for the source (album ID, artist ID, etc.)
  /// - [sortConfig]: The sort configuration for the results
  ///
  /// Returns a [Result] containing the list of songs or an error message.
  Future<Result<List<Song>>> querySongsFrom({
    required SongsFromType fromType,
    required Object where,
    SortConfig sortConfig = const SortConfig(),
  });

  /// Queries all songs from the device.
  ///
  /// Parameters:
  /// - [sortConfig]: The sort configuration for the results
  ///
  /// Returns a [Result] containing the list of all songs or an error message.
  Future<Result<List<Song>>> querySongs({
    SortConfig sortConfig = const SortConfig(),
  });

  /// Queries all albums from the device.
  ///
  /// Parameters:
  /// - [sortType]: How to sort the results (defaults to number of songs)
  ///
  /// Returns a [Result] containing the list of albums or an error message.
  Future<Result<List<Album>>> queryAlbums({
    AlbumsSortType sortType = AlbumsSortType.numOfSongs,
  });

  /// Queries all artists from the device.
  ///
  /// Parameters:
  /// - [sortType]: How to sort the results (defaults to number of tracks)
  ///
  /// Returns a [Result] containing the list of artists or an error message.
  Future<Result<List<Artist>>> queryArtists({
    ArtistsSortType sortType = ArtistsSortType.numOfTracks,
  });

  /// Deletes a song from the device storage.
  ///
  /// Parameters:
  /// - [songUri]: The file URI of the song to delete
  ///
  /// Returns a [Result] containing true if successful, or an error message.
  ///
  /// **Warning**: This permanently deletes the file from storage.
  Future<Result<bool>> deleteSong({required String songUri});

  /// Saves the user's sort configuration preference.
  ///
  /// Parameters:
  /// - [sortConfig]: The sort configuration to save
  ///
  /// Returns a [Result] containing true if successful, or an error message.
  Future<Result<bool>> saveSortConfig({required SortConfig sortConfig});

  /// Retrieves the user's saved sort type for songs.
  ///
  /// Returns a [Result] containing the saved sort type or an error message.
  /// If no preference is saved, returns the default sort type.
  Result<SortConfig> getSongsSortConfig();
}
