import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' show immutable;
import 'package:music_player/core/services/logger/logger.dart';
import 'package:music_player/features/songs/presentation/widgets/top_head_actions.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';

part 'songs_event.dart';
part 'songs_state.dart';

class SongsBloc extends Bloc<SongsEvent, SongsState> {
  SongsBloc() : super(const SongsState()) {
    on<LoadSongsEvent>(onLoadSongs);
    on<SortSongsEvent>(onSortSongs);
  }

  final audioQuery = OnAudioQuery();

  void onSortSongs(SortSongsEvent event, Emitter<SongsState> emit) {
    final sortedSongs = List<SongModel>.from(state.songs);
    _sortSongs(sortedSongs, event.sortType);
    emit(state.copyWith(songs: sortedSongs, sortType: event.sortType));
  }

  void onLoadSongs(SongsEvent event, Emitter emit) async {
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
      final songs = await audioQuery.querySongs();
      _sortSongs(songs, state.sortType);
      emit(SongsState(songs: songs, status: SongsStatus.loaded));
    } catch (e, s) {
      Logger.error('Error fetching songs: $e', e, s);
      emit(SongsState(status: SongsStatus.error));
    }
  }

  void _sortSongs(List<SongModel> songs, SortType sortType) {
    switch (sortType) {
      case SortType.recentlyAdded:
        songs.sort((a, b) => (b.dateAdded ?? 0).compareTo(a.dateAdded ?? 0));
        break;
      case SortType.dateAdded:
        songs.sort((a, b) => (a.dateAdded ?? 0).compareTo(b.dateAdded ?? 0));
        break;
      case SortType.duration:
        songs.sort((a, b) => (a.duration ?? 0).compareTo(b.duration ?? 0));
        break;
      case SortType.size:
        songs.sort((a, b) => a.size.compareTo(b.size));
        break;
      case SortType.ascendingOrder:
        songs.sort((a, b) => a.title.compareTo(b.title));
        break;
      case SortType.descendingOrder:
        songs.sort((a, b) => b.title.compareTo(a.title));
        break;
    }
  }
}
