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
  ) : super(const QuerySongsState()) {
    on<LoadQuerySongsEvent>(onQuerySongs);
  }

  final QuerySongsFrom querySongsFrom;

  Future<void> onQuerySongs(
    LoadQuerySongsEvent event,
    Emitter<QuerySongsState> emit,
  ) async {
    emit(const QuerySongsState(status: QuerySongsStatus.loading));
    final queryResult = await querySongsFrom(
      fromType: event.songsFromType,
      where: event.where,
      sortType: event.sortType,
    );
    if (queryResult.isSuccess) {
      emit(
        QuerySongsState(
          songs: queryResult.value!,
          status: QuerySongsStatus.loaded,
        ),
      );
    } else {
      emit(
        state.copyWith(
          errorMessage: queryResult.error,
          status: QuerySongsStatus.error,
        ),
      );
    }
  }
}
