import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' show immutable;
import 'package:music_player/core/domain/entities/song.dart';
import 'package:music_player/features/songs/domain/usecases/usecases.dart';
import 'package:music_player/features/songs/presentation/widgets/widgets.dart';

part 'songs_event.dart';
part 'songs_state.dart';

class SongsBloc extends Bloc<SongsEvent, SongsState> {
  SongsBloc(this.deleteSong, this.querySongs) : super(const SongsState()) {
    on<LoadSongsEvent>(onLoadSongs);
    on<SortSongsEvent>(onSortSongs);
    on<DeleteSongEvent>(onDeleteSong);
  }

  final DeleteSong deleteSong;
  final QuerySongs querySongs;

  Future<void> onDeleteSong(
    DeleteSongEvent event,
    Emitter<SongsState> emit,
  ) async {
    final songDeleteResult = await deleteSong(songUri: event.song.uri);
    if (songDeleteResult.isSuccess && (songDeleteResult.value ?? false)) {
      final updatedSongList = List<Song>.from(state.allSongs)
        ..removeWhere((e) => e.id == event.song.id);
      emit(state.copyWith(allSongs: updatedSongList));
    } else {
      emit(state.copyWith(errorMessage: songDeleteResult.error));
    }
  }

  void onSortSongs(SortSongsEvent event, Emitter<SongsState> emit) {
    final sortedSongs = List<Song>.from(state.allSongs);
    _sortSongs(sortedSongs, event.sortType);
    emit(state.copyWith(allSongs: sortedSongs, sortType: event.sortType));
  }

  Future<void> onLoadSongs(SongsEvent event, Emitter<SongsState> emit) async {
    emit(const SongsState(status: SongsStatus.loading));
    final queryResult = await querySongs();
    if (queryResult.isSuccess) {
      _sortSongs(queryResult.value!, state.sortType);
      emit(
        SongsState(allSongs: queryResult.value!, status: SongsStatus.loaded),
      );
    } else {
      emit(
        state.copyWith(
          errorMessage: queryResult.error,
          status: SongsStatus.error,
        ),
      );
    }
  }

  void _sortSongs(List<Song> songs, SortType sortType) {
    switch (sortType) {
      case SortType.recentlyAdded:
        songs.sort((a, b) => b.dateAdded.compareTo(a.dateAdded));
      case SortType.dateAdded:
        songs.sort((a, b) => a.dateAdded.compareTo(b.dateAdded));
      case SortType.duration:
        songs.sort((a, b) => a.duration.compareTo(b.duration));
      case SortType.size:
        songs.sort((a, b) => a.size.compareTo(b.size));
      case SortType.ascendingOrder:
        songs.sort((a, b) => a.title.compareTo(b.title));
      case SortType.descendingOrder:
        songs.sort((a, b) => b.title.compareTo(a.title));
    }
  }
}
