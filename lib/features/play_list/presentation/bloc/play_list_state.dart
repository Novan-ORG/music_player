part of 'play_list_bloc.dart';

final class PlayListState extends Equatable {
  const PlayListState({
    this.playLists = const [],
    this.errorMessage = '',
    this.status = PlayListStatus.initial,
    this.canUndo = false,
    this.lastDeletedPlaylist,
  });

  final List<PlaylistModel> playLists;
  final String errorMessage;
  final PlayListStatus status;
  final bool canUndo;
  final PlaylistModel? lastDeletedPlaylist;

  PlayListState copyWith({
    List<PlaylistModel>? playLists,
    String? errorMessage,
    PlayListStatus? status,
    bool? canUndo,
    PlaylistModel? lastDeletedPlaylist,
  }) {
    return PlayListState(
      playLists: playLists ?? this.playLists,
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,
      canUndo: canUndo ?? this.canUndo,
      lastDeletedPlaylist: lastDeletedPlaylist,
    );
  }

  @override
  List<Object?> get props => [
    playLists,
    errorMessage,
    status,
    canUndo,
    if (lastDeletedPlaylist != null) lastDeletedPlaylist!,
  ];
}

enum PlayListStatus { initial, loading, loaded, error }
