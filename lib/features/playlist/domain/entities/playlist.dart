/// Represents a user-created playlist.
///
/// Contains metadata about a playlist including its name, song count,
/// and creation/modification timestamps.
class Playlist {
  /// Creates a [Playlist] with the specified metadata.
  Playlist({
    required this.id,
    required this.name,
    required this.numOfSongs,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Unique identifier for this playlist.
  final int id;

  /// Name of the playlist.
  final String name;

  /// Number of songs in this playlist.
  final int numOfSongs;

  /// Date and time when this playlist was created.
  final DateTime createdAt;

  /// Date and time when this playlist was last updated.
  final DateTime updatedAt;
}
