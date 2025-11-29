part of 'playlist_bloc.dart';

sealed class PlayListEvent extends Equatable {
  const PlayListEvent();

  @override
  List<Object> get props => [];
}

final class LoadPlayListsEvent extends PlayListEvent {}

final class CreatePlayListEvent extends PlayListEvent {
  const CreatePlayListEvent(this.name);

  final String name;

  @override
  List<Object> get props => [name];
}

final class AddSongsToPlaylistsEvent extends PlayListEvent {
  const AddSongsToPlaylistsEvent(this.songIds, this.playlistIds);

  final Set<int> songIds;
  final List<int> playlistIds;

  @override
  List<Object> get props => [songIds, playlistIds];
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

final class RemoveSongsFromPlaylistEvent extends PlayListEvent {
  const RemoveSongsFromPlaylistEvent(this.songIds, this.playlistId);

  final Set<int> songIds;
  final int playlistId;

  @override
  List<Object> get props => [songIds, playlistId];
}

final class LoadPinnedPlaylistsEvent extends PlayListEvent {
  const LoadPinnedPlaylistsEvent();
}

final class PinnedPlaylistEvent extends PlayListEvent {
  const PinnedPlaylistEvent(this.playlistId);

  final int playlistId;

  @override
  List<Object> get props => [playlistId];
}
