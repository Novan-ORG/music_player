import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' show immutable;
import 'package:music_player/core/commands/commands.dart';
import 'package:music_player/core/domain/entities/song.dart';
import 'package:music_player/core/domain/usecases/usecases.dart';
import 'package:music_player/features/songs/domain/entities/entities.dart';
import 'package:music_player/features/songs/domain/enums/enums.dart';
import 'package:music_player/features/songs/domain/usecases/usecases.dart';

part 'songs_event.dart';
part 'songs_state.dart';

/// BLoC managing all songs library state and playback events.
///
/// Handles:
/// - Fetching and displaying songs
/// - Searching songs
/// - Deleting songs with undo capability
/// - Toggling favorite status
/// - Sorting songs
/// - Managing undo/redo state
class SongsBloc extends Bloc<SongsEvent, SongsState> {
  SongsBloc(
    this.ensureMediaPermission,
    this.deleteSong,
    this.querySongs,
    this.getSongsSortType,
    this.saveSongsSortType,
    this.commandManager,
  ) : super(
        SongsState(
          sortType: getSongsSortType().value ?? SongsSortType.dateAdded,
        ),
      ) {
    on<LoadSongsEvent>(onLoadSongs);
    on<DeleteSongEvent>(onDeleteSong);
    on<UndoDeleteSongEvent>(onUndoDeleteSong);
    on<CanUndoChangedEvent>(onCanUndoChanged);
    on<DeleteSongsEvent>(onDeleteSongs);
    commandManager.canUndoNotifier.addListener(_onCanUndoChanged);
  }

  final CommandManager commandManager;
  final DeleteSongWithUndo deleteSong;
  final QuerySongs querySongs;
  final SaveSongsSortType saveSongsSortType;
  final GetSongsSortType getSongsSortType;
  final EnsureMediaPermission ensureMediaPermission;

  void _onCanUndoChanged() {
    add(CanUndoChangedEvent(canUndo: commandManager.canUndo));
  }

  Future<void> onDeleteSongs(
    DeleteSongsEvent event,
    Emitter<SongsState> emit,
  ) async {
    for (final song in event.songs) {
      final result = await deleteSong(song: song);
      if (result.isFailure) {
        emit(state.copyWith(errorMessage: result.error));
      }
    }
    // Reload songs to reflect the changes
    final queryResult = await querySongs();
    if (queryResult.isSuccess) {
      emit(
        state.copyWith(
          allSongs: queryResult.value,
          canUndo: commandManager.canUndo,
        ),
      );
    } else {
      emit(state.copyWith(errorMessage: queryResult.error));
    }
  }

  Future<void> onDeleteSong(
    DeleteSongEvent event,
    Emitter<SongsState> emit,
  ) async {
    final result = await deleteSong(song: event.song);
    if (result.isFailure) {
      emit(state.copyWith(errorMessage: result.error));
      return;
    }
    // Reload songs to reflect the changes
    final queryResult = await querySongs();
    if (queryResult.isSuccess) {
      emit(
        state.copyWith(
          allSongs: queryResult.value,
          canUndo: commandManager.canUndo,
        ),
      );
    } else {
      emit(state.copyWith(errorMessage: queryResult.error));
    }
  }

  Future<void> onUndoDeleteSong(
    UndoDeleteSongEvent event,
    Emitter<SongsState> emit,
  ) async {
    final undoResult = await commandManager.undo();
    if (undoResult.isSuccess) {
      // Reload songs to reflect the restored file
      final queryResult = await querySongs();
      if (queryResult.isSuccess) {
        emit(
          state.copyWith(
            allSongs: queryResult.value,
            canUndo: commandManager.canUndo,
          ),
        );
      }
    } else {
      emit(state.copyWith(errorMessage: undoResult.error));
    }
  }

  void onCanUndoChanged(CanUndoChangedEvent event, Emitter<SongsState> emit) {
    emit(state.copyWith(canUndo: event.canUndo));
  }

  Future<void> onLoadSongs(
    LoadSongsEvent event,
    Emitter<SongsState> emit,
  ) async {
    emit(state.copyWith(status: SongsStatus.loading));
    if (event.sortType != state.sortType && event.sortType != null) {
      await saveSongsSortType(sortType: event.sortType!);
    }
    final queryResult = await querySongs(
      sortType: event.sortType ?? state.sortType,
    );
    if (queryResult.isSuccess) {
      emit(
        SongsState(
          allSongs: queryResult.value!,
          status: SongsStatus.loaded,
          sortType: event.sortType ?? state.sortType,
        ),
      );
    } else {
      emit(
        state.copyWith(
          errorMessage: queryResult.error,
          sortType: event.sortType,
          status: SongsStatus.error,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    commandManager.canUndoNotifier.removeListener(_onCanUndoChanged);
    return super.close();
  }
}
