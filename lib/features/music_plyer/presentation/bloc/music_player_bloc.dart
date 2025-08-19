import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/core/services/audio_handler/m_audio_handler.dart';
import 'package:music_player/core/services/logger/logger.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';

part 'music_player_event.dart';
part 'music_player_state.dart';

class MusicPlayerBloc extends Bloc<MusicPlayerEvent, MusicPlayerState> {
  final MAudioHandler audioHandler;

  MusicPlayerBloc(this.audioHandler) : super(MusicPlayerState()) {
    on<PlayMusicEvent>(_handlePlayMusic);
    on<StopMusicEvent>(_handleStopMusic);
    on<TogglePlayPauseEvent>(_handleTogglePlayPause);
    on<NextMusicEvent>(_handleSkipToNext);
    on<PreviousMusicEvent>(_handleSkipToPrevious);
    on<ShuffleMusicEvent>(_handleShuffleMusics);
    on<SkipToMusicIndexEvent>(_handleSkipToIndex);
  }

  Stream<int?> get currentIndexStream => audioHandler.currentIndexStream;

  Stream<Duration?> get durationStream => audioHandler.durationStream;

  Stream<Duration> get positionStream => audioHandler.positionStream;

  Stream<PlayerState> get palyerStateStream => audioHandler.palyerStateStream;

  Stream<LoopMode> get loopModeStream => audioHandler.loopModeStream;

  Future<void> seek(Duration duration) => audioHandler.seek(duration);

  bool get hasNext => audioHandler.hasNext;
  bool get hasPrevious => audioHandler.hasPrevious;

  LoopMode get loopMode => audioHandler.loopMode;

  bool get shuffleModeEnabled => audioHandler.shuffleModeEnabled;

  void setNextLoopMode(LoopMode loopMode) {
    LoopMode newMode = LoopMode.off;
    if (loopMode == LoopMode.off) {
      newMode = LoopMode.all;
    } else if (loopMode == LoopMode.all) {
      newMode = LoopMode.one;
    } else {
      newMode = LoopMode.off;
    }
    audioHandler.setLoopMode(newMode);
  }

  void setShuffleModeEnabled(bool enabled) =>
      audioHandler.setShuffleModeEnabled(enabled);

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
      if (audioHandler.playing) await audioHandler.stop();
      await audioHandler.addAudioSources(songs);
      await audioHandler.setShuffleModeEnabled(shuffle);
      await audioHandler.seek(Duration.zero, index: index);
      await audioHandler.play();
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
    if (audioHandler.playing) await audioHandler.stop();
    emit(state.copyWith(status: MusicPlayerStatus.stopped));
  }

  Future<void> _handleTogglePlayPause(
    TogglePlayPauseEvent event,
    Emitter<MusicPlayerState> emit,
  ) async {
    if (audioHandler.playing) {
      await audioHandler.pause();
      emit(state.copyWith(status: MusicPlayerStatus.paused));
    } else {
      await audioHandler.play();
      emit(state.copyWith(status: MusicPlayerStatus.playing));
    }
  }

  Future<void> _handleSkipToNext(
    NextMusicEvent event,
    Emitter<MusicPlayerState> emit,
  ) async {
    await _handleSeek(
      emit: emit,
      seekAction: () => audioHandler.skipToNext(),
      errorContext: 'skipping to next track',
    );
  }

  Future<void> _handleSkipToIndex(
    SkipToMusicIndexEvent event,
    Emitter<MusicPlayerState> emit,
  ) async {
    await _handleSeek(
      emit: emit,
      seekAction: () => audioHandler.seek(Duration.zero, index: event.index),
      errorContext: 'Skipping to trak index ${event.index}',
    );
  }

  Future<void> _handleSkipToPrevious(
    PreviousMusicEvent event,
    Emitter<MusicPlayerState> emit,
  ) async {
    await _handleSeek(
      emit: emit,
      seekAction: () => audioHandler.skipToPrevious(),
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
