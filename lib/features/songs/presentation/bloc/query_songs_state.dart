part of 'query_songs_bloc.dart';

@immutable
final class QuerySongsState extends Equatable {
  const QuerySongsState({
    this.songs = const [],
    this.status = QuerySongsStatus.initial,
    this.sortType = SongsSortType.dateAdded,
    this.errorMessage,
  });

  final List<Song> songs;
  final QuerySongsStatus status;
  final SongsSortType sortType;
  final String? errorMessage;

  QuerySongsState copyWith({
    List<Song>? songs,
    QuerySongsStatus? status,
    SongsSortType? sortType,
    String? errorMessage,
  }) {
    return QuerySongsState(
      songs: songs ?? this.songs,
      status: status ?? this.status,
      sortType: sortType ?? this.sortType,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    songs,
    status,
    sortType,
    if (errorMessage != null) errorMessage!,
  ];
}

enum QuerySongsStatus { initial, loading, loaded, error }
