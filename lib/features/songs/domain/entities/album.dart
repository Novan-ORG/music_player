/// Represents a music album from the device storage.
///
/// Contains metadata about an album including its name, artist,
/// and the number of songs it contains.
class Album {
  /// Creates an [Album] with the specified metadata.
  const Album({
    required this.id,
    required this.album,
    required this.artist,
    required this.artistId,
    required this.numOfSongs,
  });

  /// Unique identifier for this album in the media store.
  final int id;

  /// Name of the album.
  final String album;

  /// Name of the artist who created this album.
  final String? artist;

  /// ID of the artist who created this album.
  final int? artistId;

  /// Number of songs in this album.
  final int numOfSongs;
}
