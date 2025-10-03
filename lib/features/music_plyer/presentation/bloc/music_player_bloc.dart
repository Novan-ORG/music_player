import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:music_player/core/domain/entities/entities.dart';
import 'package:music_player/features/music_plyer/domain/entities/entities.dart';
import 'package:music_player/features/music_plyer/domain/usecases/usecases.dart';

part 'music_player_event.dart';
part 'music_player_state.dart';

class MusicPlayerBloc extends Bloc<MusicPlayerEvent, MusicPlayerState> {
  MusicPlayerBloc(
    this.playSong,
    this.getLikedSongs,
    this.pauseSong,
    this.seekSong,
    this.stopSong,
    this.toggleSongLike,
    this.resumeSong,
    this.setShuffleEnabled,
    this.hasNextSong,
    this.hasPreviousSong,
    this.watchPlayerIndex,
    this.watchSongDuration,
    this.watchSongPosition,
    this.setLoopMode,
  ) : super(
        MusicPlayerState(
          likedSongIds: getLikedSongs().value?.toSet() ?? <int>{},
        ),
      ) {
    _playerIndexSubscription = watchPlayerIndex().distinct().listen(
      _watchPlayerIndex,
    );
    on<UpdateStateEvent>(
      (event, emit) => emit(event.state),
    );
    on<PlayMusicEvent>(_handlePlayMusic);
    on<StopMusicEvent>(_handleStopMusic);
    on<TogglePlayPauseEvent>(_handleTogglePlayPause);
    on<ShuffleMusicEvent>(_handleShuffleMusics);
    on<ToggleLikeMusicEvent>(_handleToggleLike);
    on<SetShuffleEnabledEvent>(_handleSetShuffleEnabled);
    on<SeekMusicEvent>(_handleSeekMusic);
    on<SetPlayerLoopModeEvent>(_handleSetPlayerLoopMode);
  }

  final PlaySong playSong;
  final GetLikedSongs getLikedSongs;
  final PauseSong pauseSong;
  final SeekSong seekSong;
  final StopSong stopSong;
  final ToggleSongLike toggleSongLike;
  final ResumeSong resumeSong;
  final SetShuffleEnabled setShuffleEnabled;
  final HasNextSong hasNextSong;
  final HasPreviousSong hasPreviousSong;
  final SetLoopMode setLoopMode;
  final WatchPlayerIndex watchPlayerIndex;
  final WatchSongDuration watchSongDuration;
  final WatchSongPosition watchSongPosition;
  late final StreamSubscription<int?> _playerIndexSubscription;

  Stream<Duration?> get durationStream => watchSongDuration();

  Stream<Duration> get positionStream => watchSongPosition();

  @override
  Future<void> close() async {
    await _playerIndexSubscription.cancel();
    return super.close();
  }

  void _watchPlayerIndex(int? index) {
    if (index == null ||
        index == state.currentSongIndex ||
        index < 0 ||
        index >= state.playList.length) {
      return;
    }
    final hasNext = hasNextSong();
    final hasPrevious = hasPreviousSong();
    add(
      UpdateStateEvent(
        state.copyWith(
          currentSongIndex: index,
          hasNext: hasNext.value ?? state.hasNext,
          hasPrevious: hasPrevious.value ?? state.hasPrevious,
        ),
      ),
    );
  }

  PlayerLoopMode _getNextLoopMode(PlayerLoopMode loopMode) {
    var newMode = PlayerLoopMode.off;
    if (loopMode == PlayerLoopMode.off) {
      newMode = PlayerLoopMode.all;
    } else if (loopMode == PlayerLoopMode.all) {
      newMode = PlayerLoopMode.one;
    } else {
      newMode = PlayerLoopMode.off;
    }
    return newMode;
  }

  Future<void> _handleSetPlayerLoopMode(
    SetPlayerLoopModeEvent event,
    Emitter<MusicPlayerState> emit,
  ) async {
    final newLoopMode = _getNextLoopMode(state.loopMode);
    final result = setLoopMode(loopMode: newLoopMode);
    if (result.isFailure) {
      emit(
        state.copyWith(
          status: MusicPlayerStatus.error,
          errorMessage: result.error,
        ),
      );
      return;
    } else {
      emit(state.copyWith(loopMode: newLoopMode));
    }
  }

  Future<void> _handleSeekMusic(
    SeekMusicEvent event,
    Emitter<MusicPlayerState> emit,
  ) async {
    final seekResult = await seekSong(event.position, index: event.index);
    if (seekResult.isFailure) {
      emit(
        state.copyWith(
          status: MusicPlayerStatus.error,
          errorMessage: seekResult.error,
        ),
      );
    }
    final hasNext = hasNextSong();
    if (hasNext.isFailure) {
      emit(
        state.copyWith(
          status: MusicPlayerStatus.error,
          errorMessage: hasNext.error,
        ),
      );
    }

    final hasPrevious = hasPreviousSong();
    if (hasPrevious.isFailure) {
      emit(
        state.copyWith(
          status: MusicPlayerStatus.error,
          errorMessage: hasPrevious.error,
        ),
      );
    }
    emit(
      state.copyWith(
        hasNext: hasNext.value ?? state.hasNext,
        hasPrevious: hasPrevious.value ?? state.hasPrevious,
      ),
    );
  }

  Future<void> _handleSetShuffleEnabled(
    SetShuffleEnabledEvent event,
    Emitter<MusicPlayerState> emit,
  ) async {
    final result = await setShuffleEnabled(isEnabled: event.isEnabled);
    if (result.isFailure) {
      emit(
        state.copyWith(
          status: MusicPlayerStatus.error,
          errorMessage: result.error,
        ),
      );
      return;
    } else {
      emit(state.copyWith(shuffleEnabled: event.isEnabled));
    }
  }

  Future<void> _handleToggleLike(
    ToggleLikeMusicEvent event,
    Emitter<MusicPlayerState> emit,
  ) async {
    final result = await toggleSongLike(event.songId);
    if (result.isFailure) {
      emit(
        state.copyWith(
          status: MusicPlayerStatus.error,
          errorMessage: result.error,
        ),
      );
      return;
    }
    final likedSongIds = result.value!;
    emit(state.copyWith(likedSongIds: likedSongIds));
  }

  Future<void> _handleShuffleMusics(
    ShuffleMusicEvent event,
    Emitter<MusicPlayerState> emit,
  ) async {
    await setShuffleEnabled(isEnabled: true);
    await playSong(event.songs, 0);
    emit(
      state.copyWith(shuffleEnabled: true, status: MusicPlayerStatus.playing),
    );
  }

  Future<void> _handlePlayMusic(
    PlayMusicEvent event,
    Emitter<MusicPlayerState> emit,
  ) async {
    final result = await playSong(event.playList, event.index);
    if (result.isSuccess) {
      emit(state.copyWith(status: MusicPlayerStatus.playing));
    } else {
      emit(
        state.copyWith(
          status: MusicPlayerStatus.error,
          errorMessage: result.error,
        ),
      );
    }
  }

  Future<void> _handleStopMusic(
    StopMusicEvent event,
    Emitter<MusicPlayerState> emit,
  ) async {
    await stopSong();
    emit(state.copyWith(status: MusicPlayerStatus.stopped));
  }

  Future<void> _handleTogglePlayPause(
    TogglePlayPauseEvent event,
    Emitter<MusicPlayerState> emit,
  ) async {
    if (state.status == MusicPlayerStatus.playing) {
      await pauseSong();
      emit(state.copyWith(status: MusicPlayerStatus.paused));
    } else {
      await resumeSong();
      emit(state.copyWith(status: MusicPlayerStatus.playing));
    }
  }
}
