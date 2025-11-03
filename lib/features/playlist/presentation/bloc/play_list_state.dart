part of 'play_list_bloc.dart';

final class PlayListState extends Equatable {
  const PlayListState({
    this.playLists = const [],
    this.status = PlayListStatus.initial,
    this.errorMessage,
    this.canUndo = false,
    this.lastDeletedPlaylist,
    this.currentPlaylistSongs = const [],
    this.currentPlaylistId,
  });

  final List<Playlist> playLists;
  final PlayListStatus status;
  final String? errorMessage;
  final bool canUndo;
  final Playlist? lastDeletedPlaylist;
  final List<Song> currentPlaylistSongs;
  final int? currentPlaylistId;

  PlayListState copyWith({
    List<Playlist>? playLists,
    PlayListStatus? status,
    String? errorMessage,
    bool? canUndo,
    Playlist? lastDeletedPlaylist,
    List<Song>? currentPlaylistSongs,
    int? currentPlaylistId,
  }) {
    return PlayListState(
      playLists: playLists ?? this.playLists,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      canUndo: canUndo ?? this.canUndo,
      lastDeletedPlaylist: lastDeletedPlaylist ?? this.lastDeletedPlaylist,
      currentPlaylistSongs: currentPlaylistSongs ?? this.currentPlaylistSongs,
      currentPlaylistId: currentPlaylistId ?? this.currentPlaylistId,
    );
  }

  @override
  List<Object?> get props => [
    playLists,
    status,
    errorMessage,
    canUndo,
    lastDeletedPlaylist,
    currentPlaylistSongs,
    currentPlaylistId,
  ];
}

enum PlayListStatus { initial, loading, loaded, error }
