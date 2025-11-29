import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:music_player/core/commands/commands.dart';
import 'package:music_player/core/constants/constants.dart';
import 'package:music_player/core/services/services.dart';
import 'package:music_player/features/playlist/domain/domain.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'playlist_event.dart';
part 'playlist_state.dart';

class PlayListBloc extends Bloc<PlayListEvent, PlayListState> {
  PlayListBloc(
    this._renamePlaylist,
    this._getAllPlaylists,
    this._createPlaylist,
    this._deletePlaylistWithUndo,
    this._addSongsToPlaylist,
    this._removeSongsFromPlaylist,
    this._getPlaylistById,
    this._commandManager,
    this._preferences,
  ) : super(const PlayListState()) {
    on<LoadPlayListsEvent>(_loadPlayLists);
    on<CreatePlayListEvent>(_addPlayList);
    on<AddSongsToPlaylistsEvent>(_addSongToPlaylists);
    on<RemoveSongsFromPlaylistEvent>(_removeSongFromPlaylist);
    on<DeletePlayListEvent>(_deletePlayList);
    on<RenamePlayListEvent>(_renamePlayList);
    on<UndoDeletePlayListEvent>(_undoDeletePlayList);
    on<CanUndoChangedEvent>(_canUndoChanged);
    on<LoadPinnedPlaylistsEvent>(_loadPinnedPlaylists);
    on<PinnedPlaylistEvent>(_pinnedPlaylist);
    _commandManager.canUndoNotifier.addListener(_onCanUndoChanged);
    add(const LoadPinnedPlaylistsEvent());
  }

  final RenamePlaylist _renamePlaylist;
  final GetAllPlaylists _getAllPlaylists;
  final CreatePlaylist _createPlaylist;
  final DeletePlaylistWithUndo _deletePlaylistWithUndo;
  final AddSongsToPlaylist _addSongsToPlaylist;
  final RemoveSongsFromPlaylist _removeSongsFromPlaylist;
  final GetPlaylistById _getPlaylistById;
  final CommandManager _commandManager;
  final SharedPreferences _preferences;

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

  Future<void> _loadPinnedPlaylists(
    LoadPinnedPlaylistsEvent event,
    Emitter<PlayListState> emit,
  ) async {
    final pinnedIds =
        _preferences.getStringList(
          PreferencesKeys.pinnedPlaylists,
        ) ??
        [];
    final pinnedSet = pinnedIds.map(int.parse).toSet();
    emit(state.copyWith(pinnedPlaylistIds: pinnedSet));
  }

  Future<void> _pinnedPlaylist(
    PinnedPlaylistEvent event,
    Emitter<PlayListState> emit,
  ) async {
    final currentPinned = Set<int>.from(state.pinnedPlaylistIds);

    if (currentPinned.contains(event.playlistId)) {
      currentPinned.remove(event.playlistId);
    } else {
      currentPinned.add(event.playlistId);
    }

    await _preferences.setStringList(
      PreferencesKeys.pinnedPlaylists,
      currentPinned.map((id) => id.toString()).toList(),
    );

    emit(state.copyWith(pinnedPlaylistIds: currentPinned));
  }

  @override
  Future<void> close() {
    _commandManager.canUndoNotifier.removeListener(_onCanUndoChanged);
    return super.close();
  }
}
