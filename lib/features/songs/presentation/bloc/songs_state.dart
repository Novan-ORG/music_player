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
    this.isSelectionMode = false,
    this.selectedSongIds = const {},
  });

  final List<Song> allSongs;
  final SongsStatus status;
  final SortType sortType;
  final bool canUndo;
  final Song? lastDeletedSong;
  final String? errorMessage;
  final bool isSelectionMode;
  final Set<int> selectedSongIds;

  SongsState copyWith({
    List<Song>? allSongs,
    SongsStatus? status,
    SortType? sortType,
    bool? canUndo,
    Song? lastDeletedSong,
    String? errorMessage,
    bool? isSelectionMode,
    Set<int>? selectedSongIds,
  }) {
    return SongsState(
      allSongs: allSongs ?? this.allSongs,
      status: status ?? this.status,
      sortType: sortType ?? this.sortType,
      canUndo: canUndo ?? this.canUndo,
      lastDeletedSong: lastDeletedSong,
      errorMessage: errorMessage,
      isSelectionMode: isSelectionMode ?? this.isSelectionMode,
      selectedSongIds: selectedSongIds ?? this.selectedSongIds,
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
    isSelectionMode,
    selectedSongIds,
  ];
}

enum SongsStatus { initial, loading, loaded, error }
