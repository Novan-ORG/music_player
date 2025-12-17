part of 'artists_bloc.dart';

@immutable
final class ArtistsState extends Equatable {
  const ArtistsState({
    this.allArtists = const [],
    this.status = ArtistsStatus.initial,
    this.sortType = ArtistsSortType.artist,
    this.errorMessage,
  });

  final List<Artist> allArtists;
  final ArtistsStatus status;
  final ArtistsSortType sortType;
  final String? errorMessage;

  ArtistsState copyWith({
    List<Artist>? allArtists,
    ArtistsStatus? status,
    ArtistsSortType? sortType,
    String? errorMessage,
  }) {
    return ArtistsState(
      allArtists: allArtists ?? this.allArtists,
      status: status ?? this.status,
      sortType: sortType ?? this.sortType,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    allArtists,
    status,
    sortType,
    if (errorMessage != null) errorMessage!,
  ];
}

enum ArtistsStatus { initial, loading, loaded, error }
