part of 'play_list_bloc.dart';

final class PlayListState extends Equatable {
  const PlayListState({
    this.playLists = const [],
    this.errorMessage = '',
    this.status = PlayListStatus.initial,
  });

  final List<PlaylistModel> playLists;
  final String errorMessage;
  final PlayListStatus status;

  PlayListState copyWith({
    List<PlaylistModel>? playLists,
    String? errorMessage,
    PlayListStatus? status,
  }) {
    return PlayListState(
      playLists: playLists ?? this.playLists,
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [playLists, errorMessage, status];
}

enum PlayListStatus { initial, loading, loaded, error }
