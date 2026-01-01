import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' show immutable;
import 'package:music_player/core/domain/entities/song.dart';
import 'package:music_player/features/songs/domain/entities/entities.dart';
import 'package:music_player/features/songs/domain/enums/enums.dart';
import 'package:music_player/features/songs/domain/usecases/usecases.dart';

part 'query_songs_event.dart';
part 'query_songs_state.dart';

class QuerySongsBloc extends Bloc<QuerySongsEvent, QuerySongsState> {
  QuerySongsBloc(
    this.querySongsFrom,
    this.saveSongsSortConfig,
    this.getSongsSortConfig,
  ) : super(
        QuerySongsState(
          sortConfig: getSongsSortConfig().value ?? const SortConfig(),
        ),
      ) {
    on<LoadQuerySongsEvent>(onQuerySongs);
  }

  final QuerySongsFrom querySongsFrom;
  final SaveSongsSortConfig saveSongsSortConfig;
  final GetSongsSortConfig getSongsSortConfig;

  Future<void> onQuerySongs(
    LoadQuerySongsEvent event,
    Emitter<QuerySongsState> emit,
  ) async {
    emit(state.copyWith(status: QuerySongsStatus.loading));
    if (event.sortConfig != state.sortConfig && event.sortConfig != null) {
      await saveSongsSortConfig(sortConfig: event.sortConfig!);
    }
    final queryResult = await querySongsFrom(
      fromType: event.songsFromType,
      where: event.where,
      sortConfig: event.sortConfig ?? state.sortConfig,
    );
    if (queryResult.isSuccess) {
      emit(
        QuerySongsState(
          songs: queryResult.value!,
          status: QuerySongsStatus.loaded,
          sortConfig: event.sortConfig ?? state.sortConfig,
        ),
      );
    } else {
      emit(
        state.copyWith(
          errorMessage: queryResult.error,
          sortConfig: event.sortConfig ?? state.sortConfig,
          status: QuerySongsStatus.error,
        ),
      );
    }
  }
}
