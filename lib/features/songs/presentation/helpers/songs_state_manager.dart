import 'package:music_player/core/domain/entities/song.dart';

/// Helper class to manage playlist song IDs state
class PlaylistSongsManager {
  PlaylistSongsManager(Set<int>? initialSongIds) : _songIds = initialSongIds;
  final Set<int>? _songIds;

  Set<int>? get songIds => _songIds;

  /// Add song IDs to the playlist
  void addSongs(Set<int> songIds) {
    _songIds?.addAll(songIds);
  }

  /// Remove song IDs from the playlist
  void removeSongs(Set<int> songIds) {
    for (final id in songIds) {
      _songIds?.remove(id);
    }
  }

  /// Remove a single song from the playlist
  void removeSong(int songId) {
    _songIds?.remove(songId);
  }

  /// Check if a song is in the playlist
  bool containsSong(int songId) {
    return _songIds?.contains(songId) ?? false;
  }

  /// Filter songs based on playlist membership
  List<Song> filterSongs(List<Song> allSongs) {
    if (_songIds == null) return allSongs;
    return allSongs.where((song) => _songIds.contains(song.id)).toList();
  }
}

/// Helper class to manage song filtering logic
class SongFilterManager {
  const SongFilterManager._();

  /// Filter songs based on playlist, favorites, and liked songs
  static List<Song> filterSongs({
    required List<Song> allSongs,
    required Set<int> likedSongIds,
    Set<int>? playlistSongIds,
    bool isFavorites = false,
  }) {
    final songs = List<Song>.from(allSongs);

    // Filter by playlist if provided
    if (playlistSongIds != null) {
      songs.retainWhere((song) => playlistSongIds.contains(song.id));
    }

    // Filter by favorites if needed
    if (isFavorites) {
      songs.retainWhere((song) => likedSongIds.contains(song.id));
    }

    return songs;
  }

  /// Get selected songs from a list based on selected IDs
  static List<Song> getSelectedSongs({
    required List<Song> allSongs,
    required Set<int> selectedIds,
  }) {
    return allSongs.where((song) => selectedIds.contains(song.id)).toList();
  }
}
