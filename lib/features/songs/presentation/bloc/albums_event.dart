part of 'albums_bloc.dart';

@immutable
sealed class AlbumsEvent {
  const AlbumsEvent();
}

final class LoadAlbumsEvent extends AlbumsEvent {
  const LoadAlbumsEvent({this.sortType = AlbumsSortType.numOfSongs});
  final AlbumsSortType sortType;
}
