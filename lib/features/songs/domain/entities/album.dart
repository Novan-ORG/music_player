class Album {
  const Album({
    required this.id,
    required this.album,
    required this.numOfSongs,
    this.artist,
    this.artistId,
  });

  final int id;
  final String album;
  final String? artist;
  final int? artistId;
  final int numOfSongs;
}
