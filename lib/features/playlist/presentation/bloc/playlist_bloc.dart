import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:music_player/core/commands/commands.dart';
import 'package:music_player/core/services/services.dart';
import 'package:music_player/features/playlist/domain/domain.dart';
import 'package:music_player/features/playlist/domain/usecases/get_pinned_playlist.dart';
import 'package:music_player/features/playlist/domain/usecases/pin_playlist_by_id.dart';

part 'playlist_event.dart';
part 'playlist_state.dart';

/// BLoC managing playlists list and operations.
///
/// Handles:
/// - Fetching all playlists
/// - Creating new playlists
/// - Deleting playlists with undo
/// - Renaming playlists
/// - Adding/removing songs from playlists
/// - Pinning/unpinning playlists
/// - Managing playlist cover images
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
    this._pinPlaylistById,
    this._getPinnedPlaylist,
    this._initializePlaylistCovers,
    this._getPlaylistCoverSongId,
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
    on<PinnedPlaylistEvent>(_togglePinPlaylist);
    on<InitializePlaylistCoversEvent>(_initializePlaylistCoversHandler);
    on<LoadPlaylistCoverSongIdsEvent>(_loadPlaylistCoverSongIds);
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
  final PinPlaylistById _pinPlaylistById;
  final GetPinnedPlaylists _getPinnedPlaylist;
  final InitializePlaylistCovers _initializePlaylistCovers;
  final GetPlaylistCoverSongId _getPlaylistCoverSongId;

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
      final playlists = playListsResult.value ?? [];
      emit(
        state.copyWith(
          playLists: playlists,
          status: PlayListStatus.loaded,
        ),
      );

      // Reload covers after adding songs
      add(
        LoadPlaylistCoverSongIdsEvent(
          playlists.map((p) => p.id).toList(),
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
      final playlists = result.value ?? [];
      emit(
        state.copyWith(
          playLists: playlists,
          status: PlayListStatus.loaded,
        ),
      );

      // Load cover song IDs for all playlists
      add(
        LoadPlaylistCoverSongIdsEvent(
          playlists.map((p) => p.id).toList(),
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
    final result = await _getPinnedPlaylist();

    if (result.isSuccess) {
      emit(
        state.copyWith(
          pinnedPlaylists: result.value,
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

  Future<void> _togglePinPlaylist(
    PinnedPlaylistEvent event,
    Emitter<PlayListState> emit,
  ) async {
    final result = await _pinPlaylistById(
      List<PinPlaylist>.from(state.pinnedPlaylists),
      event.playlistId,
    );

    if (result.isSuccess) {
      emit(
        state.copyWith(
          pinnedPlaylists: result.value,
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

  // use this just once when app starts to initialize playlist covers
  Future<void> _initializePlaylistCoversHandler(
    InitializePlaylistCoversEvent event,
    Emitter<PlayListState> emit,
  ) async {
    final result = await _initializePlaylistCovers();

    if (result.isFailure) {
      Logger.error(
        'Failed to initialize playlist covers: ${result.error}',
        null,
        StackTrace.current,
      );
    } else {
      if (state.playLists.isNotEmpty) {
        add(
          LoadPlaylistCoverSongIdsEvent(
            state.playLists.map((p) => p.id).toList(),
          ),
        );
      }
    }
  }

  Future<void> _loadPlaylistCoverSongIds(
    LoadPlaylistCoverSongIdsEvent event,
    Emitter<PlayListState> emit,
  ) async {
    final coverMap = <int, int?>{...state.playlistCoverSongIds};

    for (final playlistId in event.playlistIds) {
      final result = await _getPlaylistCoverSongId(playlistId);
      if (result.isSuccess) {
        coverMap[playlistId] = result.value;
      }
    }

    emit(state.copyWith(playlistCoverSongIds: coverMap));
  }

  @override
  Future<void> close() {
    _commandManager.canUndoNotifier.removeListener(_onCanUndoChanged);
    return super.close();
  }
}
