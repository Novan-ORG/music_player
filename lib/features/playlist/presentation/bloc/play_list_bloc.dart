import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:music_player/core/commands/commands.dart';
import 'package:music_player/core/domain/entities/song.dart';
import 'package:music_player/core/services/services.dart';
import 'package:music_player/features/playlist/domain/domain.dart';

part 'play_list_event.dart';
part 'play_list_state.dart';

class PlayListBloc extends Bloc<PlayListEvent, PlayListState> {
  PlayListBloc(
    this._renamePlaylist,
    this._getAllPlaylists,
    this._createPlaylist,
    this._deletePlaylistWithUndo,
    this._addSongsToPlaylist,
    this._removeSongsFromPlaylist,
    this._getPlaylistById,
    this._getPlaylistSongs,
    this._commandManager,
  ) : super(const PlayListState()) {
    on<LoadPlayListsEvent>(_loadPlayLists);
    on<CreatePlayListEvent>(_addPlayList);
    on<AddSongsToPlaylistsEvent>(_addSongToPlaylists);
    on<RemoveSongsFromPlaylistEvent>(_removeSongFromPlaylist);
    on<DeletePlayListEvent>(_deletePlayList);
    on<RenamePlayListEvent>(_renamePlayList);
    on<UndoDeletePlayListEvent>(_undoDeletePlayList);
    on<CanUndoChangedEvent>(_canUndoChanged);
    on<GetPlaylistSongsEvent>(_getThePlaylistSongs);
    _commandManager.canUndoNotifier.addListener(_onCanUndoChanged);
  }

  final RenamePlaylist _renamePlaylist;
  final GetAllPlaylists _getAllPlaylists;
  final CreatePlaylist _createPlaylist;
  final DeletePlaylistWithUndo _deletePlaylistWithUndo;
  final AddSongsToPlaylist _addSongsToPlaylist;
  final RemoveSongsFromPlaylist _removeSongsFromPlaylist;
  final GetPlaylistById _getPlaylistById;
  final GetPlaylistSongs _getPlaylistSongs;
  final CommandManager _commandManager;

  void _onCanUndoChanged() {
    add(CanUndoChangedEvent(canUndo: _commandManager.canUndo));
  }

  void _canUndoChanged(CanUndoChangedEvent event, Emitter<PlayListState> emit) {
    emit(state.copyWith(canUndo: event.canUndo));
  }

  Future<void> _undoDeletePlayList(
    UndoDeletePlayListEvent event,
    Emitter<PlayListState> emit,
  ) async {
    final undoResult = await _deletePlaylistWithUndo.undo();
    if (undoResult.isSuccess) {
      final playListsResult = await _getAllPlaylists();
      if (playListsResult.isSuccess) {
        emit(
          state.copyWith(
            playLists: playListsResult.value ?? [],
            status: PlayListStatus.loaded,
            canUndo: _commandManager.canUndo,
          ),
        );
      } else {
        emit(
          state.copyWith(
            errorMessage: playListsResult.error,
            status: PlayListStatus.error,
          ),
        );
      }
    } else {
      emit(
        state.copyWith(
          errorMessage: undoResult.error,
          status: PlayListStatus.error,
        ),
      );
    }
  }

  Future<void> _renamePlayList(
    RenamePlayListEvent event,
    Emitter<PlayListState> emit,
  ) async {
    final renameResult = await _renamePlaylist(
      event.playlistId,
      event.newName,
    );

    if (renameResult.isSuccess) {
      final playListsResult = await _getAllPlaylists();
      if (playListsResult.isSuccess) {
        emit(
          state.copyWith(
            playLists: playListsResult.value ?? [],
            status: PlayListStatus.loaded,
          ),
        );
      } else {
        emit(
          state.copyWith(
            errorMessage: playListsResult.error,
            status: PlayListStatus.error,
          ),
        );
      }
    } else {
      emit(
        state.copyWith(
          errorMessage: renameResult.error,
          status: PlayListStatus.error,
        ),
      );
    }
  }

  Future<void> _deletePlayList(
    DeletePlayListEvent event,
    Emitter<PlayListState> emit,
  ) async {
    // Get the playlist info before deleting for the snackbar
    final playlistResult = await _getPlaylistById(event.playlistId);
    final playlistToDelete = playlistResult.value;

    final deleteResult = await _deletePlaylistWithUndo(
      playlistId: event.playlistId,
    );

    if (deleteResult.isSuccess && (deleteResult.value ?? false)) {
      final playListsResult = await _getAllPlaylists();
      if (playListsResult.isSuccess) {
        emit(
          state.copyWith(
            playLists: playListsResult.value ?? [],
            status: PlayListStatus.loaded,
            canUndo: _commandManager.canUndo,
            lastDeletedPlaylist: playlistToDelete,
          ),
        );
      } else {
        emit(
          state.copyWith(
            errorMessage: playListsResult.error,
            status: PlayListStatus.error,
          ),
        );
      }
    } else {
      emit(
        state.copyWith(
          errorMessage: deleteResult.error,
          status: PlayListStatus.error,
        ),
      );
    }
  }

  Future<void> _addSongToPlaylists(
    AddSongsToPlaylistsEvent event,
    Emitter<PlayListState> emit,
  ) async {
    Logger.info(
      'Adding songs to playlists: ${event.playlistIds}:songs: ${event.songIds}',
    );
    for (final playlistId in event.playlistIds) {
      Logger.info('Adding songs to playlist $playlistId');
      final result = await _addSongsToPlaylist(
        playlistId,
        event.songIds.toList(),
      );

      if (result.isFailure) {
        emit(
          state.copyWith(
            errorMessage: result.error,
            status: PlayListStatus.error,
          ),
        );
        return;
      }
    }

    final playListsResult = await _getAllPlaylists();
    if (playListsResult.isSuccess) {
      emit(
        state.copyWith(
          playLists: playListsResult.value ?? [],
          status: PlayListStatus.loaded,
        ),
      );
    } else {
      emit(
        state.copyWith(
          errorMessage: playListsResult.error,
          status: PlayListStatus.error,
        ),
      );
    }

    if (state.currentPlaylistId != null) {
      add(
        GetPlaylistSongsEvent(playlistId: state.currentPlaylistId!),
      );
    }
  }

  Future<void> _removeSongFromPlaylist(
    RemoveSongsFromPlaylistEvent event,
    Emitter<PlayListState> emit,
  ) async {
    final result = await _removeSongsFromPlaylist(
      event.playlistId,
      event.songIds.toList(),
    );

    if (result.isSuccess) {
      final playListsResult = await _getAllPlaylists();
      if (playListsResult.isSuccess) {
        emit(
          state.copyWith(
            playLists: playListsResult.value ?? [],
            status: PlayListStatus.loaded,
          ),
        );
      } else {
        emit(
          state.copyWith(
            errorMessage: playListsResult.error,
            status: PlayListStatus.error,
          ),
        );
      }
    } else {
      emit(
        state.copyWith(
          errorMessage: result.error,
          status: PlayListStatus.error,
        ),
      );
    }

    if (state.currentPlaylistId != null) {
      add(
        GetPlaylistSongsEvent(playlistId: state.currentPlaylistId!),
      );
    }
  }

  Future<void> _addPlayList(
    CreatePlayListEvent event,
    Emitter<PlayListState> emit,
  ) async {
    final saveResult = await _createPlaylist(event.name);

    if (saveResult.isSuccess) {
      final playListsResult = await _getAllPlaylists();
      if (playListsResult.isSuccess) {
        emit(
          state.copyWith(
            playLists: playListsResult.value ?? [],
            status: PlayListStatus.loaded,
          ),
        );
      } else {
        emit(
          state.copyWith(
            errorMessage: playListsResult.error,
            status: PlayListStatus.error,
          ),
        );
      }
    } else {
      emit(
        state.copyWith(
          errorMessage: saveResult.error,
          status: PlayListStatus.error,
        ),
      );
    }
  }

  Future<void> _loadPlayLists(
    LoadPlayListsEvent event,
    Emitter<PlayListState> emit,
  ) async {
    emit(state.copyWith(status: PlayListStatus.loading));

    final result = await _getAllPlaylists();
    if (result.isSuccess) {
      emit(
        state.copyWith(
          playLists: result.value ?? [],
          status: PlayListStatus.loaded,
        ),
      );
    } else {
      emit(
        state.copyWith(
          errorMessage: result.error,
          status: PlayListStatus.error,
        ),
      );
    }
  }

  Future<void> _getThePlaylistSongs(
    GetPlaylistSongsEvent event,
    Emitter<PlayListState> emit,
  ) async {
    emit(state.copyWith(status: PlayListStatus.loading));

    final result = await _getPlaylistSongs(event.playlistId);

    if (result.isSuccess) {
      emit(
        state.copyWith(
          currentPlaylistSongs: result.value ?? [],
          currentPlaylistId: event.playlistId,
          status: PlayListStatus.loaded,
        ),
      );
    } else {
      emit(
        state.copyWith(
          errorMessage: result.error,
          status: PlayListStatus.error,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _commandManager.canUndoNotifier.removeListener(_onCanUndoChanged);
    return super.close();
  }
}
