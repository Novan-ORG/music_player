class Song {
  const Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.uri,
    required this.duration,
    required this.albumId,
  });

  final int id;
  final String title;
  final String artist;
  final String album;
  final String uri;
  final Duration duration;
  final int? albumId;
}
