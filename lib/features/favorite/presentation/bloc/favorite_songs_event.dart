part of 'favorite_songs_bloc.dart';

@immutable
sealed class FavoriteSongsEvent extends Equatable {
  const FavoriteSongsEvent();

  @override
  List<Object> get props => [];
}

final class LoadFavoriteSongsEvent extends FavoriteSongsEvent {
  const LoadFavoriteSongsEvent();
}

final class AddFavoriteSongEvent extends FavoriteSongsEvent {
  const AddFavoriteSongEvent(this.songId);

  final int songId;

  @override
  List<Object> get props => [songId];
}

final class RemoveFavoriteSongEvent extends FavoriteSongsEvent {
  const RemoveFavoriteSongEvent(this.songId);

  final int songId;

  @override
  List<Object> get props => [songId];
}

final class ToggleFavoriteSongEvent extends FavoriteSongsEvent {
  const ToggleFavoriteSongEvent(this.songId);

  final int songId;

  @override
  List<Object> get props => [songId];
}

final class ClearAllFavoritesEvent extends FavoriteSongsEvent {
  const ClearAllFavoritesEvent();
}
