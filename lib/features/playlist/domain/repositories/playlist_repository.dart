import 'package:music_player/core/domain/entities/song.dart';
import 'package:music_player/core/result.dart';
import 'package:music_player/features/playlist/domain/entities/entities.dart';

/// Repository interface for managing playlists.
///
/// Provides methods for CRUD operations on playlists, managing songs
/// within playlists, and handling playlist covers and pinning.
abstract class PlaylistRepository {
  /// Retrieves all playlists.
  ///
  /// Returns a [Result] containing the list of playlists or an error.
  Future<Result<List<Playlist>>> getAllPlaylists();

  /// Retrieves a specific playlist by its ID.
  ///
  /// Parameters:
  /// - [id]: The playlist ID
  ///
  /// Returns a [Result] containing the playlist or an error.
  Future<Result<Playlist>> getPlaylistById(int id);

  /// Creates a new playlist with the given name.
  ///
  /// Parameters:
  /// - [name]: Name for the new playlist
  ///
  /// Returns a [Result] containing `true` if successful, or an error.
  Future<Result<bool>> createPlaylist(String name);

  /// Renames an existing playlist.
  ///
  /// Parameters:
  /// - [id]: The playlist ID
  /// - [newName]: New name for the playlist
  ///
  /// Returns a [Result] containing `true` if successful, or an error.
  Future<Result<bool>> renamePlaylist(int id, String newName);

  /// Deletes a playlist.
  ///
  /// Parameters:
  /// - [id]: The playlist ID to delete
  ///
  /// Returns a [Result] containing `true` if successful, or an error.
  ///
  /// **Warning**: This permanently deletes the playlist and cannot be undone.
  Future<Result<bool>> deletePlaylist(int id);

  /// Retrieves all songs in a playlist.
  ///
  /// Parameters:
  /// - [playlistId]: The playlist ID
  ///
  /// Returns a [Result] containing the list of songs or an error.
  Future<Result<List<Song>>> getPlaylistSongs(int playlistId);

  /// Retrieves the list of recently played songs.
  ////
  /// Returns a [Result] containing the list of songs or an error.
  Future<Result<List<Song>>> getRecentlyPlayedSongs();

  /// Adds songs to a playlist.
  ///
  /// Parameters:
  /// - [playlistId]: The playlist ID
  /// - [songIds]: List of song IDs to add
  ///
  /// Returns a [Result] indicating success or failure.
  Future<Result<void>> addSongsToPlaylist(int playlistId, List<int> songIds);

  /// Removes songs from a playlist.
  ///
  /// Parameters:
  /// - [playlistId]: The playlist ID
  /// - [songIds]: List of song IDs to remove
  ///
  /// Returns a [Result] indicating success or failure.
  Future<Result<void>> removeSongsFromPlaylist(
    int playlistId,
    List<int> songIds,
  );

  /// Gets the song ID used for the playlist cover image.
  ///
  /// Parameters:
  /// - [playlistId]: The playlist ID
  ///
  /// Returns a [Result] containing the cover song ID or null.
  Future<Result<int?>> getPlaylistCoverSongId(int playlistId);

  /// Initializes cover images for existing playlists.
  ///
  /// Should be called once at app startup to ensure all playlists
  /// have cover images assigned.
  ///
  /// Returns a [Result] indicating success or failure.
  Future<Result<void>> initializePlaylistCoversForExistingPlaylists();

  /// Saves the list of pinned playlists.
  ///
  /// Parameters:
  /// - [pinnedPlaylists]: List of playlists to pin
  ///
  /// Returns a [Result] indicating success or failure.
  Future<Result<void>> savePinnedPlaylists(List<PinPlaylist> pinnedPlaylists);

  /// Retrieves the list of pinned playlists.
  ///
  /// Returns a [Result] containing the pinned playlists or an error.
  Future<Result<List<PinPlaylist>>> getPinnedPlaylists();
}
