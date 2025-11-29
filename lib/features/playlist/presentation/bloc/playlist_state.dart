part of 'playlist_bloc.dart';

final class PlayListState extends Equatable {
  const PlayListState({
    this.playLists = const [],
    this.status = PlayListStatus.initial,
    this.errorMessage,
    this.canUndo = false,
    this.lastDeletedPlaylist,
    this.currentPlaylistId,
    this.pinnedPlaylistIds = const {},
  });

  final List<Playlist> playLists;
  final PlayListStatus status;
  final String? errorMessage;
  final bool canUndo;
  final Playlist? lastDeletedPlaylist;
  final int? currentPlaylistId;
  final Set<int> pinnedPlaylistIds;

  PlayListState copyWith({
    List<Playlist>? playLists,
    PlayListStatus? status,
    String? errorMessage,
    bool? canUndo,
    Playlist? lastDeletedPlaylist,
    int? currentPlaylistId,
    Set<int>? pinnedPlaylistIds,
  }) {
    return PlayListState(
      playLists: playLists ?? this.playLists,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      canUndo: canUndo ?? this.canUndo,
      lastDeletedPlaylist: lastDeletedPlaylist ?? this.lastDeletedPlaylist,
      currentPlaylistId: currentPlaylistId ?? this.currentPlaylistId,
      pinnedPlaylistIds: pinnedPlaylistIds ?? this.pinnedPlaylistIds,
    );
  }

  @override
  List<Object?> get props => [
    playLists,
    status,
    errorMessage,
    canUndo,
    lastDeletedPlaylist,
    currentPlaylistId,
    pinnedPlaylistIds,
  ];
}

enum PlayListStatus { initial, loading, loaded, error }
