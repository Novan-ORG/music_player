part of 'songs_bloc.dart';

@immutable
sealed class SongsEvent {
  const SongsEvent();
}

final class LoadSongsEvent extends SongsEvent {
  const LoadSongsEvent({this.sortType});
  final SongsSortType? sortType;
}

final class DeleteSongEvent extends SongsEvent {
  const DeleteSongEvent(this.song);

  final Song song;
}

final class DeleteSongsEvent extends SongsEvent {
  const DeleteSongsEvent(this.songs);

  final List<Song> songs;
}

final class UndoDeleteSongEvent extends SongsEvent {
  const UndoDeleteSongEvent();
}

final class CanUndoChangedEvent extends SongsEvent {
  const CanUndoChangedEvent({required this.canUndo});

  final bool canUndo;
}

final class DeselectSongEvent extends SongsEvent {
  const DeselectSongEvent(this.songId);

  final int songId;
}
