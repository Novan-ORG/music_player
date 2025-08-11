import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart' show immutable;
import 'package:music_player/core/services/logger/logger.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';

part 'songs_event.dart';
part 'songs_state.dart';

class SongsBloc extends Bloc<SongsEvent, SongsState> {
  SongsBloc() : super(const SongsState()) {
    on<LoadSongsEvent>(loadSongs);
  }

  final audioQuery = OnAudioQuery();

  void loadSongs(SongsEvent event, Emitter emit) async {
    try {
      emit(SongsState(status: SongsStatus.loading));
      final permissionsGranted = await audioQuery.permissionsStatus();
      if (!permissionsGranted) {
        final permissions = await audioQuery.permissionsRequest();
        if (!permissions) {
          emit(SongsState(status: SongsStatus.error));
          return;
        }
      }
      final songs = await audioQuery.querySongs(
        sortType: SongSortType.DATE_ADDED,
      );
      emit(SongsState(songs: songs, status: SongsStatus.loaded));
    } catch (e, s) {
      Logger.error('Error fetching songs: $e', e, s);
      emit(SongsState(status: SongsStatus.error));
    }
  }
}
