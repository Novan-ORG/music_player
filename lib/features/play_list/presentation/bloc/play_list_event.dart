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

final class AddSongToPlaylistsEvent extends PlayListEvent {
  const AddSongToPlaylistsEvent(this.songId, this.playlistIds);

  final int songId;
  final List<int> playlistIds;

  @override
  List<Object> get props => [songId, playlistIds];
}

final class DeletePlayListEvent extends PlayListEvent {
  const DeletePlayListEvent(this.playlistId);

  final int playlistId;

  @override
  List<Object> get props => [playlistId];
}

final class RenamePlayListEvent extends PlayListEvent {
  const RenamePlayListEvent(this.playlistId, this.newName);

  final int playlistId;
  final String newName;

  @override
  List<Object> get props => [playlistId, newName];
}

final class UndoDeletePlayListEvent extends PlayListEvent {}

final class CanUndoChangedEvent extends PlayListEvent {
  const CanUndoChangedEvent({required this.canUndo});

  final bool canUndo;

  @override
  List<Object> get props => [canUndo];
}

final class RemoveSongFromPlaylistEvent extends PlayListEvent {
  const RemoveSongFromPlaylistEvent(this.songId, this.playlistId);

  final int songId;
  final int playlistId;

  @override
  List<Object> get props => [songId, playlistId];
}
