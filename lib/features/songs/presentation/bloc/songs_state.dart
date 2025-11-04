part of 'songs_bloc.dart';

@immutable
final class SongsState extends Equatable {
  const SongsState({
    this.allSongs = const [],
    this.status = SongsStatus.initial,
    this.sortType = SortType.recentlyAdded,
    this.canUndo = false,
    this.lastDeletedSong,
    this.errorMessage,
  });

  final List<Song> allSongs;
  final SongsStatus status;
  final SortType sortType;
  final bool canUndo;
  final Song? lastDeletedSong;
  final String? errorMessage;

  SongsState copyWith({
    List<Song>? allSongs,
    SongsStatus? status,
    SortType? sortType,
    bool? canUndo,
    Song? lastDeletedSong,
    String? errorMessage,
  }) {
    return SongsState(
      allSongs: allSongs ?? this.allSongs,
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
    status,
    sortType,
    canUndo,
    lastDeletedSong,
    if (errorMessage != null) errorMessage!,
  ];
}

enum SongsStatus { initial, loading, loaded, error }
