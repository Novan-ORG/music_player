part of 'songs_bloc.dart';

@immutable
final class SongsState extends Equatable {
  const SongsState({
    this.songs = const [],
    this.status = SongsStatus.initial,
    this.sortType = SortType.recentlyAdded,
  });

  final List<SongModel> songs;
  final SongsStatus status;
  final SortType sortType;

  SongsState copyWith({
    List<SongModel>? songs,
    SongsStatus? status,
    SortType? sortType,
  }) {
    return SongsState(
      songs: songs ?? this.songs,
      status: status ?? this.status,
      sortType: sortType ?? this.sortType,
    );
  }

  @override
  List<Object> get props => [songs, status, sortType];
}

enum SongsStatus { initial, loading, loaded, error }
