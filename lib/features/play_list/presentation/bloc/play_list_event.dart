part of 'play_list_bloc.dart';

sealed class PlayListEvent extends Equatable {
  const PlayListEvent();

  @override
  List<Object> get props => [];
}

final class LoadPlayListsEvent extends PlayListEvent {}

final class AddPlayListEvent extends PlayListEvent {
  const AddPlayListEvent(this.playlistModel);

  final PlaylistModel playlistModel;

  @override
  List<Object> get props => [playlistModel];
}
