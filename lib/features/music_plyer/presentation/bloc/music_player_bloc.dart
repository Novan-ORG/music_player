import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/core/services/logger/logger.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';

part 'music_player_event.dart';
part 'music_player_state.dart';

class MusicPlayerBloc extends Bloc<MusicPlayerEvent, MusicPlayerState> {
  MusicPlayerBloc() : super(MusicPlayerState()) {
    on<PlayMusicEvent>(_onPlayMusic);
    on<StopMusicEvent>(_onStopMusic);
    on<TogglePlayPauseEvent>(_onTogglePlayPause);
    on<NextMusicEvent>(_onSkipToNext);
    on<PreviousMusicEvent>(_onSkipToPrevious);
    on<ShuffleMusicEvent>(_onShuffleMusics);
  }

  final audioPlayer = AudioPlayer();

  Future<void> _onShuffleMusics(
    ShuffleMusicEvent event,
    Emitter<MusicPlayerState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          status: MusicPlayerStatus.playing,
          playList: event.songs,
          errorMessage: null,
        ),
      );
      if (audioPlayer.playing) {
        await audioPlayer.stop();
      }
      await audioPlayer.addAudioSources(
        event.songs
            .map((song) => AudioSource.uri(Uri.parse(song.uri ?? '')))
            .toList(),
      );
      await audioPlayer.setShuffleModeEnabled(true);
      await audioPlayer.play();
    } catch (e, s) {
      Logger.error('Error shuffling music: $e', e, s);
      emit(
        state.copyWith(
          status: MusicPlayerStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onPlayMusic(
    PlayMusicEvent event,
    Emitter<MusicPlayerState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          status: MusicPlayerStatus.playing,
          playList: event.playList,
          errorMessage: null,
        ),
      );
      if (audioPlayer.playing) {
        await audioPlayer.stop();
      }
      await audioPlayer.addAudioSources(
        event.playList
            .map((song) => AudioSource.uri(Uri.parse(song.uri ?? '')))
            .toList(),
      );
      await audioPlayer.seek(Duration.zero, index: event.index);
      await audioPlayer.play();
    } catch (e, s) {
      Logger.error('Error playing music: $e', e, s);
      emit(
        state.copyWith(
          status: MusicPlayerStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onStopMusic(
    StopMusicEvent event,
    Emitter<MusicPlayerState> emit,
  ) async {
    if (audioPlayer.playing) {
      await audioPlayer.stop();
      emit(state.copyWith(status: MusicPlayerStatus.stopped));
    } else {
      emit(state.copyWith(status: MusicPlayerStatus.stopped));
    }
  }

  Future<void> _onTogglePlayPause(
    TogglePlayPauseEvent event,
    Emitter<MusicPlayerState> emit,
  ) async {
    if (audioPlayer.playing) {
      await audioPlayer.pause();
      emit(state.copyWith(status: MusicPlayerStatus.paused));
    } else {
      await audioPlayer.play();
      emit(state.copyWith(status: MusicPlayerStatus.playing));
    }
  }

  Future<void> _onSkipToNext(
    NextMusicEvent event,
    Emitter<MusicPlayerState> emit,
  ) async {
    try {
      await audioPlayer.seekToNext();
    } catch (e, s) {
      Logger.error('Error skipping to next track: $e', e, s);
      emit(
        state.copyWith(
          status: MusicPlayerStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onSkipToPrevious(
    PreviousMusicEvent event,
    Emitter<MusicPlayerState> emit,
  ) async {
    try {
      await audioPlayer.seekToPrevious();
    } catch (e, s) {
      Logger.error('Error skipping to previous track: $e', e, s);
      emit(
        state.copyWith(
          status: MusicPlayerStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
