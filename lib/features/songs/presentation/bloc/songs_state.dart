part of 'songs_bloc.dart';

@immutable
final class SongsState extends Equatable {
  const SongsState({
    required this.sortType,
    this.allSongs = const [],
    this.allAlbums = const [],
    this.allArtists = const [],
    this.status = SongsStatus.initial,
    this.canUndo = false,
    this.lastDeletedSong,
    this.errorMessage,
  });

  final List<Song> allSongs;
  final List<Album> allAlbums;
  final List<Artist> allArtists;
  final SongsStatus status;
  final SongsSortType sortType;
  final bool canUndo;
  final Song? lastDeletedSong;
  final String? errorMessage;

  SongsState copyWith({
    List<Song>? allSongs,
    List<Album>? allAlbums,
    List<Artist>? allArtists,
    SongsStatus? status,
    SongsSortType? sortType,
    bool? canUndo,
    Song? lastDeletedSong,
    String? errorMessage,
  }) {
    return SongsState(
      allSongs: allSongs ?? this.allSongs,
      allAlbums: allAlbums ?? this.allAlbums,
      allArtists: allArtists ?? this.allArtists,
      status: status ?? this.status,
      sortType: sortType ?? this.sortType,
      canUndo: canUndo ?? this.canUndo,
      lastDeletedSong: lastDeletedSong,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    allSongs,
    allAlbums,
    allArtists,
    status,
    sortType,
    canUndo,
    lastDeletedSong,
    if (errorMessage != null) errorMessage!,
  ];
}

enum SongsStatus { initial, loading, loaded, error }
