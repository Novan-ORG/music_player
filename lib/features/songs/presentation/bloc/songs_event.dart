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

  final SongModel song;
}
