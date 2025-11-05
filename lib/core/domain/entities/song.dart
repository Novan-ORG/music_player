class Song {
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

  final int id;
  final String title;
  final String? displayNameWOExt;
  final String displayName;
  final String artist;
  final String album;
  final String? uri;
  final String data;
  final Duration duration;
  final int? albumId;
  final int size;
  final DateTime dateAdded;
}
