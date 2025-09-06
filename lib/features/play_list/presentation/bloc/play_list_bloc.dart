import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:music_player/core/services/database/models/playlist_model.dart';
import 'package:music_player/core/services/database/objectbox.dart';

part 'play_list_event.dart';
part 'play_list_state.dart';

class PlayListBloc extends Bloc<PlayListEvent, PlayListState> {
  PlayListBloc(this.objectBox) : super(const PlayListState()) {
    on<LoadPlayListsEvent>(_loadPlayLists);
    on<AddPlayListEvent>(_addPlayList);
    on<AddSongToPlaylistsEvent>(_addSongToPlaylists);
  }

  final ObjectBox objectBox;

  Future<void> _addSongToPlaylists(
    AddSongToPlaylistsEvent event,
    Emitter<PlayListState> emit,
  ) async {
    try {
      final playlistBox = objectBox.store.box<PlaylistModel>();

      for (final playlistId in event.playlistIds) {
        final playlist = playlistBox.get(playlistId);
        if (playlist != null &&
            playlist.songs.contains(event.songId) == false) {
          playlist.songs.add(event.songId);
          playlistBox.put(playlist);
        }
      }
      final playLists = playlistBox.getAll();
      emit(state.copyWith(playLists: playLists, status: PlayListStatus.loaded));
    } catch (e) {
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
    } catch (e) {
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
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.toString(),
          status: PlayListStatus.error,
        ),
      );
    }
  }
}
