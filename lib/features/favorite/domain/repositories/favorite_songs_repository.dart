import 'package:music_player/core/domain/entities/song.dart';
import 'package:music_player/core/result.dart';

/// Repository interface for managing favorite songs.
///
/// Provides methods for adding, removing, and querying favorite songs.
abstract interface class FavoriteSongsRepository {
  /// Retrieves all favorite songs.
  ///
  /// Returns a [Result] containing the list of favorite songs or an error.
  Future<Result<List<Song>>> getFavoriteSongs();

  /// Adds a song to favorites by song ID.
  ///
  /// Parameters:
  /// - [songId]: ID of the song to add to favorites
  ///
  /// Returns a [Result] indicating success or failure.
  Future<Result<void>> addFavoriteSong(int songId);

  /// Removes a song from favorites.
  ///
  /// Parameters:
  /// - [songId]: ID of the song to remove from favorites
  ///
  /// Returns a [Result] indicating success or failure.
  Future<Result<void>> removeFavoriteSong(int songId);

  /// Checks if a song is in favorites.
  ///
  /// Parameters:
  /// - [songId]: ID of the song to check
  ///
  /// Returns a [Result] containing `true` if the song is favorited.
  Result<bool> isFavorite(int songId);

  /// Removes all songs from favorites.
  ///
  /// Returns a [Result] indicating success or failure.
  ///
  /// **Warning**: This permanently clears all favorites.
  Result<void> clearAllFavorites();
}
