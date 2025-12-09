class Artist {
  const Artist({
    required this.id,
    required this.artist,
    this.numberOfAlbums,
    this.numberOfTracks,
  });

  final int id;
  final String artist;
  final int? numberOfAlbums;
  final int? numberOfTracks;
}
