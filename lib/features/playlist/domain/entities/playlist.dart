class Playlist {
  Playlist({
    required this.id,
    required this.name,
    required this.numOfSongs,
    required this.createdAt,
    required this.updatedAt,

    this.pinnedAt,
  });

  final int id;
  final String name;
  final int numOfSongs;
  final DateTime createdAt;
  final DateTime updatedAt;

  DateTime? pinnedAt;
}
