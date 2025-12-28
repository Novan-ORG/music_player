part of 'query_songs_bloc.dart';

@immutable
final class QuerySongsState extends Equatable {
  const QuerySongsState({
    required this.sortConfig,
    this.songs = const [],
    this.status = QuerySongsStatus.initial,
    this.errorMessage,
  });

  final List<Song> songs;
  final QuerySongsStatus status;
  final SortConfig sortConfig;
  final String? errorMessage;

  QuerySongsState copyWith({
    List<Song>? songs,
    QuerySongsStatus? status,
    SortConfig? sortConfig,
    String? errorMessage,
  }) {
    return QuerySongsState(
      songs: songs ?? this.songs,
      status: status ?? this.status,
      sortConfig: sortConfig ?? this.sortConfig,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    songs,
    status,
    sortConfig,
    if (errorMessage != null) errorMessage!,
  ];
}

enum QuerySongsStatus { initial, loading, loaded, error }
