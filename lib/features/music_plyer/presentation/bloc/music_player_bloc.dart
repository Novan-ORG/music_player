import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/core/constants/preferences_keys.dart';
import 'package:music_player/core/services/audio_handler/m_audio_handler.dart';
import 'package:music_player/core/services/logger/logger.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'music_player_event.dart';
part 'music_player_state.dart';

class MusicPlayerBloc extends Bloc<MusicPlayerEvent, MusicPlayerState> {
  MusicPlayerBloc(this._audioHandler, this._preferences)
    : super(
        MusicPlayerState(
          likedSongIds:
              _preferences
                  .getStringList(PreferencesKeys.favoritedSongs)
                  ?.map(int.parse)
                  .toList() ??
              [],
        ),
      ) {
    on<PlayMusicEvent>(_handlePlayMusic);
    on<StopMusicEvent>(_handleStopMusic);
    on<TogglePlayPauseEvent>(_handleTogglePlayPause);
    on<NextMusicEvent>(_handleSkipToNext);
    on<PreviousMusicEvent>(_handleSkipToPrevious);
    on<ShuffleMusicEvent>(_handleShuffleMusics);
    on<SkipToMusicIndexEvent>(_handleSkipToIndex);
    on<ToggleLikeMusicEvent>(_handleToggleLike);
  }

  final MAudioHandler _audioHandler;
  final SharedPreferences _preferences;

  Stream<int?> get currentIndexStream => _audioHandler.currentIndexStream;

  Stream<Duration?> get durationStream => _audioHandler.durationStream;

  Stream<Duration> get positionStream => _audioHandler.positionStream;

  Stream<PlayerState> get palyerStateStream => _audioHandler.palyerStateStream;

  Stream<LoopMode> get loopModeStream => _audioHandler.loopModeStream;

  Future<void> seek(Duration duration) => _audioHandler.seek(duration);

  bool get hasNext => _audioHandler.hasNext;
  bool get hasPrevious => _audioHandler.hasPrevious;

  LoopMode get loopMode => _audioHandler.loopMode;

  bool get shuffleModeEnabled => _audioHandler.shuffleModeEnabled;

  void setNextLoopMode(LoopMode loopMode) {
    LoopMode newMode = LoopMode.off;
    if (loopMode == LoopMode.off) {
      newMode = LoopMode.all;
    } else if (loopMode == LoopMode.all) {
      newMode = LoopMode.one;
    } else {
      newMode = LoopMode.off;
    }
    _audioHandler.setLoopMode(newMode);
  }

  void setShuffleModeEnabled(bool enabled) =>
      _audioHandler.setShuffleModeEnabled(enabled);

  Future<void> _handleToggleLike(
    ToggleLikeMusicEvent event,
    Emitter<MusicPlayerState> emit,
  ) async {
    final favorites =
        _preferences.getStringList(PreferencesKeys.favoritedSongs) ?? [];
    if (favorites.contains(event.songId.toString())) {
      favorites.remove(event.songId.toString());
    } else {
      favorites.add(event.songId.toString());
    }
    await _preferences.setStringList(PreferencesKeys.favoritedSongs, favorites);
    emit(state.copyWith(likedSongIds: favorites.map(int.parse).toList()));
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
      final favorites =
          _preferences.getStringList(PreferencesKeys.favoritedSongs) ?? [];
      emit(
        state.copyWith(
          status: MusicPlayerStatus.playing,
          playList: songs,
          likedSongIds: favorites.map(int.parse).toList(),
          errorMessage: null,
        ),
      );
      await _audioHandler.addAudioSources(songs);
      await _audioHandler.setShuffleModeEnabled(shuffle);
      await _audioHandler.seek(Duration.zero, index: index);
      await _audioHandler.play();
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
    if (_audioHandler.playing) await _audioHandler.stop();
    emit(state.copyWith(status: MusicPlayerStatus.stopped));
  }

  Future<void> _handleTogglePlayPause(
    TogglePlayPauseEvent event,
    Emitter<MusicPlayerState> emit,
  ) async {
    if (_audioHandler.playing) {
      await _audioHandler.pause();
      emit(state.copyWith(status: MusicPlayerStatus.paused));
    } else {
      await _audioHandler.play();
      emit(state.copyWith(status: MusicPlayerStatus.playing));
    }
  }

  Future<void> _handleSkipToNext(
    NextMusicEvent event,
    Emitter<MusicPlayerState> emit,
  ) async {
    await _handleSeek(
      emit: emit,
      seekAction: () => _audioHandler.skipToNext(),
      errorContext: 'skipping to next track',
    );
  }

  Future<void> _handleSkipToIndex(
    SkipToMusicIndexEvent event,
    Emitter<MusicPlayerState> emit,
  ) async {
    await _handleSeek(
      emit: emit,
      seekAction: () => _audioHandler.seek(Duration.zero, index: event.index),
      errorContext: 'Skipping to trak index ${event.index}',
    );
  }

  Future<void> _handleSkipToPrevious(
    PreviousMusicEvent event,
    Emitter<MusicPlayerState> emit,
  ) async {
    await _handleSeek(
      emit: emit,
      seekAction: () => _audioHandler.skipToPrevious(),
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
