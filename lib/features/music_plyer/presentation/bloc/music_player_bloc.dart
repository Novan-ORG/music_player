import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/core/services/logger/logger.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';

part 'music_player_event.dart';
part 'music_player_state.dart';

class MusicPlayerBloc extends Bloc<MusicPlayerEvent, MusicPlayerState> {
  final AudioPlayer audioPlayer = AudioPlayer();

  MusicPlayerBloc() : super(MusicPlayerState()) {
    on<PlayMusicEvent>(_handlePlayMusic);
    on<StopMusicEvent>(_handleStopMusic);
    on<TogglePlayPauseEvent>(_handleTogglePlayPause);
    on<NextMusicEvent>(_handleSkipToNext);
    on<PreviousMusicEvent>(_handleSkipToPrevious);
    on<ShuffleMusicEvent>(_handleShuffleMusics);
    on<SkipToMusicIndexEvent>(_handleSkipToIndex);
  }

  Future<void> _handleShuffleMusics(
    ShuffleMusicEvent event,
    Emitter<MusicPlayerState> emit,
  ) async {
    await _playList(
      emit: emit,
      songs: event.songs,
      shuffle: true,
      errorContext: 'shuffling music',
    );
  }

  Future<void> _handlePlayMusic(
    PlayMusicEvent event,
    Emitter<MusicPlayerState> emit,
  ) async {
    await _playList(
      emit: emit,
      songs: event.playList,
      index: event.index,
      shuffle: false,
      errorContext: 'playing music',
    );
  }

  Future<void> _playList({
    required Emitter<MusicPlayerState> emit,
    required List<SongModel> songs,
    int index = 0,
    required bool shuffle,
    required String errorContext,
  }) async {
    try {
      emit(
        state.copyWith(
          status: MusicPlayerStatus.playing,
          playList: songs,
          errorMessage: null,
        ),
      );
      if (audioPlayer.playing) await audioPlayer.stop();
      await audioPlayer.addAudioSources(
        songs
            .map((song) => AudioSource.uri(Uri.parse(song.uri ?? '')))
            .toList(),
      );
      await audioPlayer.setShuffleModeEnabled(shuffle);
      await audioPlayer.seek(Duration.zero, index: index);
      await audioPlayer.play();
    } catch (e, s) {
      Logger.error('Error $errorContext: $e', e, s);
      emit(
        state.copyWith(
          status: MusicPlayerStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _handleStopMusic(
    StopMusicEvent event,
    Emitter<MusicPlayerState> emit,
  ) async {
    if (audioPlayer.playing) await audioPlayer.stop();
    emit(state.copyWith(status: MusicPlayerStatus.stopped));
  }

  Future<void> _handleTogglePlayPause(
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

  Future<void> _handleSkipToNext(
    NextMusicEvent event,
    Emitter<MusicPlayerState> emit,
  ) async {
    await _handleSeek(
      emit: emit,
      seekAction: audioPlayer.seekToNext,
      errorContext: 'skipping to next track',
    );
  }

  Future<void> _handleSkipToIndex(
    SkipToMusicIndexEvent event,
    Emitter<MusicPlayerState> emit,
  ) async {
    await _handleSeek(
      emit: emit,
      seekAction: () => audioPlayer.seek(Duration.zero, index: event.index),
      errorContext: 'Skipping to trak index ${event.index}',
    );
  }

  Future<void> _handleSkipToPrevious(
    PreviousMusicEvent event,
    Emitter<MusicPlayerState> emit,
  ) async {
    await _handleSeek(
      emit: emit,
      seekAction: audioPlayer.seekToPrevious,
      errorContext: 'skipping to previous track',
    );
  }

  Future<void> _handleSeek({
    required Emitter<MusicPlayerState> emit,
    required Future<void> Function() seekAction,
    required String errorContext,
  }) async {
    try {
      await seekAction();
    } catch (e, s) {
      Logger.error('Error $errorContext: $e', e, s);
      emit(
        state.copyWith(
          status: MusicPlayerStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
