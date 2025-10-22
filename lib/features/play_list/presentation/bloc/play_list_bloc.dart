import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:music_player/core/commands/commands.dart';
import 'package:music_player/core/services/services.dart';
import 'package:music_player/features/play_list/domain/usecases/usecases.dart';

part 'play_list_event.dart';
part 'play_list_state.dart';

class PlayListBloc extends Bloc<PlayListEvent, PlayListState> {
  PlayListBloc(this.objectBox, this.deletePlaylist, this.commandManager)
    : super(const PlayListState()) {
    on<LoadPlayListsEvent>(_loadPlayLists);
    on<AddPlayListEvent>(_addPlayList);
    on<AddSongToPlaylistsEvent>(_addSongToPlaylists);
    on<RemoveSongFromPlaylistEvent>(_removeSongFromPlaylist);
    on<DeletePlayListEvent>(_deletePlayList);
    on<RenamePlayListEvent>(_renamePlayList);
    on<UndoDeletePlayListEvent>(_undoDeletePlayList);
    on<CanUndoChangedEvent>(_canUndoChanged);
    commandManager.canUndoNotifier.addListener(_onCanUndoChanged);
  }

  final ObjectBox objectBox;
  final DeletePlaylistWithUndo deletePlaylist;
  final CommandManager commandManager;

  void _onCanUndoChanged() {
    add(CanUndoChangedEvent(canUndo: commandManager.canUndo));
  }

  void _canUndoChanged(CanUndoChangedEvent event, Emitter<PlayListState> emit) {
    emit(state.copyWith(canUndo: event.canUndo));
  }

  Future<void> _undoDeletePlayList(
    UndoDeletePlayListEvent event,
    Emitter<PlayListState> emit,
  ) async {
    final undoResult = await deletePlaylist.undo();
    if (undoResult.isSuccess) {
      final playLists = objectBox.store.box<PlaylistModel>().getAll();
      emit(
        state.copyWith(
          playLists: playLists,
          status: PlayListStatus.loaded,
          canUndo: commandManager.canUndo,
        ),
      );
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
    try {
      final playlistBox = objectBox.store.box<PlaylistModel>();
      final playlist = playlistBox.get(event.playlistId);
      if (playlist != null) {
        final updatedPlayList = playlist.copyWith(name: event.newName);
        playlistBox.put(updatedPlayList);
      }
      final playLists = playlistBox.getAll();
      emit(state.copyWith(playLists: playLists, status: PlayListStatus.loaded));
    } on Exception catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.toString(),
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
    final playlistBox = objectBox.store.box<PlaylistModel>();
    final playlistToDelete = playlistBox.get(event.playlistId);

    final playlistDeleteResult = await deletePlaylist(
      playlistId: event.playlistId,
    );
    if (playlistDeleteResult.isSuccess &&
        (playlistDeleteResult.value ?? false)) {
      final playLists = playlistBox.getAll();
      emit(
        state.copyWith(
          playLists: playLists,
          status: PlayListStatus.loaded,
          canUndo: commandManager.canUndo,
          lastDeletedPlaylist: playlistToDelete,
        ),
      );
    } else {
      emit(
        state.copyWith(
          errorMessage: playlistDeleteResult.error,
          status: PlayListStatus.error,
        ),
      );
    }
  }

  Future<void> _addSongToPlaylists(
    AddSongToPlaylistsEvent event,
    Emitter<PlayListState> emit,
  ) async {
    try {
      final playlistBox = objectBox.store.box<PlaylistModel>();

      for (final playlistId in event.playlistIds) {
        final playlist = playlistBox.get(playlistId);
        if (playlist != null && !playlist.songs.contains(event.songId)) {
          playlist.songs.add(event.songId);
          playlistBox.put(playlist);
        }
      }
      final playLists = playlistBox.getAll();
      emit(state.copyWith(playLists: playLists, status: PlayListStatus.loaded));
    } on Exception catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.toString(),
          status: PlayListStatus.error,
        ),
      );
    }
  }

  Future<void> _removeSongFromPlaylist(
    RemoveSongFromPlaylistEvent event,
    Emitter<PlayListState> emit,
  ) async {
    try {
      final playlistBox = objectBox.store.box<PlaylistModel>();
      final playlist = playlistBox.get(event.playlistId);

      if (playlist != null && playlist.songs.contains(event.songId)) {
        final updatedSongs = List<int>.from(playlist.songs)
          ..remove(event.songId);

        final updatedPlaylist = playlist.copyWith(songs: updatedSongs);
        playlistBox.put(updatedPlaylist);
      }

      final playLists = playlistBox.getAll();
      emit(state.copyWith(playLists: playLists, status: PlayListStatus.loaded));
    } on Exception catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.toString(),
          status: PlayListStatus.error,
        ),
      );
    }
  }

  Future<void> _addPlayList(
    AddPlayListEvent event,
    Emitter<PlayListState> emit,
  ) async {
    try {
      objectBox.store.box<PlaylistModel>().put(event.playlistModel);
      final playLists = objectBox.store.box<PlaylistModel>().getAll();
      emit(state.copyWith(playLists: playLists, status: PlayListStatus.loaded));
    } on Exception catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.toString(),
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
    try {
      final playLists = objectBox.store.box<PlaylistModel>().getAll();
      emit(state.copyWith(playLists: playLists, status: PlayListStatus.loaded));
    } on Exception catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.toString(),
          status: PlayListStatus.error,
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
