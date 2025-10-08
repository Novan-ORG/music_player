part of 'songs_bloc.dart';

@immutable
final class SongsState extends Equatable {
  const SongsState({
    this.allSongs = const [],
    this.status = SongsStatus.initial,
    this.sortType = SortType.recentlyAdded,
    this.errorMessage,
  });

  final List<Song> allSongs;
  final SongsStatus status;
  final SortType sortType;
  final String? errorMessage;

  SongsState copyWith({
    List<Song>? allSongs,
    List<Song>? currentPlaylist,
    SongsStatus? status,
    SortType? sortType,
    String? errorMessage,
  }) {
    return SongsState(
      allSongs: allSongs ?? this.allSongs,
      status: status ?? this.status,
      sortType: sortType ?? this.sortType,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object> get props => [
    allSongs,
    status,
    sortType,
    if (errorMessage != null) errorMessage!,
  ];
}

enum SongsStatus { initial, loading, loaded, error }
