import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/domain/entities/song.dart';
import 'package:music_player/features/playlist/playlist.dart';

part 'playlist_details_event.dart';
part 'playlist_details_state.dart';

class PlaylistDetailsBloc
    extends Bloc<PlayListDetailsEvent, PlaylistDetailsState> {
  PlaylistDetailsBloc({
    required Playlist playlist,
    required this.getPlaylistSongs,
  }) : super(PlaylistDetailsState(playlist: playlist)) {
    on<GetPlaylistSongsEvent>(_onGetPlaylistSongs);
  }

  final GetPlaylistSongs getPlaylistSongs;

  Future<void> _onGetPlaylistSongs(
    GetPlaylistSongsEvent event,
    Emitter<PlaylistDetailsState> emit,
  ) async {
    emit(state.copyWith(status: PlaylistDetailsStatus.loading));

    final result = await getPlaylistSongs(state.playlist.id);

    if (result.isFailure) {
      emit(
        state.copyWith(
          status: PlaylistDetailsStatus.failure,
          errorMessage: result.error,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: PlaylistDetailsStatus.success,
          songs: result.value,
        ),
      );
    }
  }
}
