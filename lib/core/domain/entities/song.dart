class Song {
  const Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.uri,
    required this.duration,
    required this.albumId,
    required this.dateAdded,
    required this.size,
  });

  final int id;
  final String title;
  final String artist;
  final String album;
  final String uri;
  final Duration duration;
  final int? albumId;
  final int size;
  final DateTime dateAdded;
}
