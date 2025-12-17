/// Represents a music song/audio file from the device storage.
///
/// This entity contains all metadata about a song including its title,
/// artist, album information, file location, and playback duration.
///
/// All [Song] instances are immutable and created from audio file metadata
/// retrieved from the device's media store.
class Song {
  /// Creates a [Song] with the specified metadata.
  const Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.displayNameWOExt,
    required this.displayName,
    required this.data,
    required this.album,
    required this.uri,
    required this.duration,
    required this.albumId,
    required this.dateAdded,
    required this.size,
  });

  /// Unique identifier for this song in the media store.
  final int id;

  /// The title/name of the song.
  final String title;

  /// Display name without file extension.
  final String? displayNameWOExt;

  /// Full display name including file extension.
  final String displayName;

  /// Name of the artist who performed this song.
  final String artist;

  /// Name of the album this song belongs to.
  final String album;

  /// Content URI for accessing the song file.
  final String? uri;

  /// Absolute file path to the song file on device storage.
  final String data;

  /// Duration/length of the song.
  final Duration duration;

  /// ID of the album this song belongs to.
  final int? albumId;

  /// Size of the song file in bytes.
  final int size;

  /// Date and time when this song was added to the device.
  final DateTime dateAdded;
}
