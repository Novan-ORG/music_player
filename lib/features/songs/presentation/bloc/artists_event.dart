part of 'artists_bloc.dart';

@immutable
sealed class ArtistsEvent {
  const ArtistsEvent();
}

final class LoadArtistsEvent extends ArtistsEvent {
  const LoadArtistsEvent({this.sortType = ArtistsSortType.artist});
  final ArtistsSortType sortType;
}
