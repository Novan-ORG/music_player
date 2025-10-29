part of 'songs_bloc.dart';

@immutable
sealed class SongsEvent {
  const SongsEvent();
}

final class LoadSongsEvent extends SongsEvent {
  const LoadSongsEvent();
}

final class SortSongsEvent extends SongsEvent {
  const SortSongsEvent(this.sortType);

  final SortType sortType;
}

final class DeleteSongEvent extends SongsEvent {
  const DeleteSongEvent(this.song);

  final Song song;
}

final class UndoDeleteSongEvent extends SongsEvent {
  const UndoDeleteSongEvent();
}

final class CanUndoChangedEvent extends SongsEvent {
  const CanUndoChangedEvent({required this.canUndo});

  final bool canUndo;
}

final class ToggleSelectionModeEvent extends SongsEvent {
  const ToggleSelectionModeEvent();
}

final class SelectSongEvent extends SongsEvent {
  const SelectSongEvent(this.songId);

  final int songId;
}

final class DeselectSongEvent extends SongsEvent {
  const DeselectSongEvent(this.songId);

  final int songId;
}

final class SelectAllSongsEvent extends SongsEvent {
  const SelectAllSongsEvent(this.songs);

  final List<Song> songs;
}

final class ClearSelectionEvent extends SongsEvent {
  const ClearSelectionEvent();
}

final class DeleteSelectedSongsEvent extends SongsEvent {
  const DeleteSelectedSongsEvent();
}
