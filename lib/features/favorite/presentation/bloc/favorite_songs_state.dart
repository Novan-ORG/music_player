part of 'favorite_songs_bloc.dart';

@immutable
final class FavoriteSongsState extends Equatable {
  const FavoriteSongsState({
    this.favoriteSongs = const [],
    this.status = FavoriteSongsStatus.initial,
    this.errorMessage,
  });

  final List<Song> favoriteSongs;
  final FavoriteSongsStatus status;
  final String? errorMessage;

  Set<int> get favoriteSongIds => favoriteSongs.map((fav) => fav.id).toSet();

  FavoriteSongsState copyWith({
    List<Song>? favoriteSongs,
    FavoriteSongsStatus? status,
    String? errorMessage,
  }) {
    return FavoriteSongsState(
      favoriteSongs: favoriteSongs ?? this.favoriteSongs,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    favoriteSongs,
    status,
    if (errorMessage != null) errorMessage!,
  ];
}

enum FavoriteSongsStatus { initial, loading, loaded, error }
