import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' show immutable;
import 'package:music_player/core/services/services.dart';
import 'package:music_player/features/songs/presentation/widgets/widgets.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

part 'songs_event.dart';
part 'songs_state.dart';

class SongsBloc extends Bloc<SongsEvent, SongsState> {
  SongsBloc() : super(const SongsState()) {
    on<LoadSongsEvent>(onLoadSongs);
    on<SortSongsEvent>(onSortSongs);
    on<DeleteSongEvent>(onDeleteSong);
  }

  final audioQuery = OnAudioQuery();

  Future<void> onDeleteSong(
    DeleteSongEvent event,
    Emitter<SongsState> emit,
  ) async {
    try {
      final file = File(event.song.data);
      if (file.existsSync()) {
        if (await Permission.manageExternalStorage.isGranted) {
          file.deleteSync();
          final updatedSongs = List<SongModel>.from(state.allSongs)
            ..removeWhere((song) => song.id == event.song.id);
          emit(state.copyWith(allSongs: updatedSongs));
        } else {
          final isGranted = await Permission.manageExternalStorage.request();
          if (isGranted == PermissionStatus.granted ||
              isGranted == PermissionStatus.limited) {
            file.deleteSync();
            final updatedSongs = List<SongModel>.from(state.allSongs)
              ..removeWhere((song) => song.id == event.song.id);
            emit(state.copyWith(allSongs: updatedSongs));
          }
        }
      }
    } on Exception catch (e, s) {
      Logger.error('Error deleting song: $e', e, s);
    }
  }

  void onSortSongs(SortSongsEvent event, Emitter<SongsState> emit) {
    final sortedSongs = List<SongModel>.from(state.allSongs);
    _sortSongs(sortedSongs, event.sortType);
    emit(state.copyWith(allSongs: sortedSongs, sortType: event.sortType));
  }

  Future<void> onLoadSongs(SongsEvent event, Emitter<SongsState> emit) async {
    try {
      emit(const SongsState(status: SongsStatus.loading));
      final permissionsGranted = await audioQuery.permissionsStatus();
      if (!permissionsGranted) {
        final permissions = await audioQuery.permissionsRequest();
        if (!permissions) {
          emit(const SongsState(status: SongsStatus.error));
          return;
        }
      }
      final songs = await audioQuery.querySongs();
      _sortSongs(songs, state.sortType);
      emit(SongsState(allSongs: songs, status: SongsStatus.loaded));
    } on Exception catch (e, s) {
      Logger.error('Error fetching songs: $e', e, s);
      emit(const SongsState(status: SongsStatus.error));
    }
  }

  void _sortSongs(List<SongModel> songs, SortType sortType) {
    switch (sortType) {
      case SortType.recentlyAdded:
        songs.sort((a, b) => (b.dateAdded ?? 0).compareTo(a.dateAdded ?? 0));
      case SortType.dateAdded:
        songs.sort((a, b) => (a.dateAdded ?? 0).compareTo(b.dateAdded ?? 0));
      case SortType.duration:
        songs.sort((a, b) => (a.duration ?? 0).compareTo(b.duration ?? 0));
      case SortType.size:
        songs.sort((a, b) => a.size.compareTo(b.size));
      case SortType.ascendingOrder:
        songs.sort((a, b) => a.title.compareTo(b.title));
      case SortType.descendingOrder:
        songs.sort((a, b) => b.title.compareTo(a.title));
    }
  }
}
