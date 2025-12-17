part of 'query_songs_bloc.dart';

@immutable
sealed class QuerySongsEvent {
  const QuerySongsEvent();
}

final class LoadQuerySongsEvent extends QuerySongsEvent {
  const LoadQuerySongsEvent({
    required this.songsFromType,
    required this.where,
    this.sortType,
  });
  final SongsSortType? sortType;
  final Object where;
  final SongsFromType songsFromType;
}
