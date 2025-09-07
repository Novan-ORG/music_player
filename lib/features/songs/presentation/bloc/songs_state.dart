part of 'songs_bloc.dart';

@immutable
final class SongsState extends Equatable {
  const SongsState({
    this.allSongs = const [],
    this.status = SongsStatus.initial,
    this.sortType = SortType.recentlyAdded,
  });

  final List<SongModel> allSongs;
  final SongsStatus status;
  final SortType sortType;

  SongsState copyWith({
    List<SongModel>? allSongs,
    List<SongModel>? currentPlaylist,
    SongsStatus? status,
    SortType? sortType,
  }) {
    return SongsState(
      allSongs: allSongs ?? this.allSongs,
      status: status ?? this.status,
      sortType: sortType ?? this.sortType,
    );
  }

  @override
  List<Object> get props => [allSongs, status, sortType];
}

enum SongsStatus { initial, loading, loaded, error }
