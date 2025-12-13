import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' show immutable;
import 'package:music_player/core/domain/entities/song.dart';
import 'package:music_player/features/songs/domain/enums/enums.dart';
import 'package:music_player/features/songs/domain/usecases/usecases.dart';

part 'query_songs_event.dart';
part 'query_songs_state.dart';

class QuerySongsBloc extends Bloc<QuerySongsEvent, QuerySongsState> {
  QuerySongsBloc(
    this.querySongsFrom,
    this.saveSongsSortType,
    this.getSongsSortType,
  ) : super(
        QuerySongsState(
          sortType: getSongsSortType().value ?? SongsSortType.dateAdded,
        ),
      ) {
    on<LoadQuerySongsEvent>(onQuerySongs);
  }

  final QuerySongsFrom querySongsFrom;
  final SaveSongsSortType saveSongsSortType;
  final GetSongsSortType getSongsSortType;

  Future<void> onQuerySongs(
    LoadQuerySongsEvent event,
    Emitter<QuerySongsState> emit,
  ) async {
    emit(state.copyWith(status: QuerySongsStatus.loading));
    if (event.sortType != state.sortType && event.sortType != null) {
      await saveSongsSortType(sortType: event.sortType!);
    }
    final queryResult = await querySongsFrom(
      fromType: event.songsFromType,
      where: event.where,
      sortType: event.sortType ?? state.sortType,
    );
    if (queryResult.isSuccess) {
      emit(
        QuerySongsState(
          songs: queryResult.value!,
          status: QuerySongsStatus.loaded,
          sortType: event.sortType ?? state.sortType,
        ),
      );
    } else {
      emit(
        state.copyWith(
          errorMessage: queryResult.error,
          sortType: event.sortType,
          status: QuerySongsStatus.error,
        ),
      );
    }
  }
}
