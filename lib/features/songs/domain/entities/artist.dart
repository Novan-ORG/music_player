/// Represents a music artist from the device storage.
///
/// Contains metadata about an artist including their name and
/// the number of songs/albums they have.
class Artist {
  /// Creates an [Artist] with the specified metadata.
  const Artist({
    required this.id,
    required this.artist,
    required this.numberOfAlbums,
    required this.numberOfTracks,
  });

  /// Unique identifier for this artist in the media store.
  final int id;

  /// Name of the artist.
  final String artist;

  /// Number of albums by this artist.
  final int numberOfAlbums;

  /// Number of tracks/songs by this artist.
  final int numberOfTracks;
}
