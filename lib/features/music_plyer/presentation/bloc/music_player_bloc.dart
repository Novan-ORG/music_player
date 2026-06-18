import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:music_player/core/domain/entities/entities.dart';
import 'package:music_player/features/music_plyer/domain/entities/entities.dart';
import 'package:music_player/features/music_plyer/domain/usecases/usecases.dart';

part 'music_player_event.dart';
part 'music_player_state.dart';

/// BLoC for managing music player state and playback operations.
///
/// Handles all music playback events including play, pause, seek, shuffle,
/// and loop mode. Listens to the current song index and updates state
/// accordingly.
class MusicPlayerBloc extends Bloc<MusicPlayerEvent, MusicPlayerState> {
  /// Creates a [MusicPlayerBloc] with all required use cases.
  MusicPlayerBloc(
    this.playSong,
    this.savePlaybackSession,
    this.getSavedPlaybackSession,
    this.clearSavedPlaybackSession,
    this.pauseSong,
    this.seekSong,
    this.stopSong,
    this.resumeSong,
    this.setShuffleEnabled,
    this.hasNextSong,
    this.hasPreviousSong,
    this.watchPlayerIndex,
    this.watchSongDuration,
    this.watchSongPosition,
    this.setLoopMode,
    this.addToRecentlyPlayed,
    this.skipToNext,
    this.skipToPrevious,
  ) : super(const MusicPlayerState()) {
    // Listen to player index changes
    _playerIndexSubscription = watchPlayerIndex().distinct().listen(
      _watchPlayerIndex,
    );

    // Register event handlers
    on<PlayerIndexChangedEvent>(_handlePlayerIndexChanged);
    on<PlayMusicEvent>(_handlePlayMusic);
    on<StopMusicEvent>(_handleStopMusic);
    on<TogglePlayPauseEvent>(_handleTogglePlayPause);
    on<ShuffleMusicEvent>(_handleShuffleMusics);
    on<SetShuffleEnabledEvent>(_handleSetShuffleEnabled);
    on<SeekMusicEvent>(_handleSeekMusic);
    on<SkipToNextEvent>(_handleNextMusic);
    on<SkipToPreviousEvent>(_handlePreviousMusic);
    on<SetPlayerLoopModeEvent>(_handleSetPlayerLoopMode);
    on<RestoreSavedPlaybackEvent>(_handleRestoreSavedPlayback);
  }

  // Use cases
  final PlaySong playSong;
  final SavePlaybackSession savePlaybackSession;
  final GetSavedPlaybackSession getSavedPlaybackSession;
  final ClearSavedPlaybackSession clearSavedPlaybackSession;
  final PauseSong pauseSong;
  final SeekSong seekSong;
  final SkipToNext skipToNext;
  final SkipToPrevious skipToPrevious;
  final StopSong stopSong;
  final ResumeSong resumeSong;
  final SetShuffleEnabled setShuffleEnabled;
  final HasNextSong hasNextSong;
  final HasPreviousSong hasPreviousSong;
  final SetLoopMode setLoopMode;
  final WatchPlayerIndex watchPlayerIndex;
  final WatchSongDuration watchSongDuration;
  final WatchSongPosition watchSongPosition;
  final AddToRecentlyPlayed addToRecentlyPlayed;

  late final StreamSubscription<int?> _playerIndexSubscription;

  /// Stream of the current song's duration.
  Stream<Duration?> get durationStream => watchSongDuration();

  /// Stream of the current playback position.
  Stream<Duration> get positionStream => watchSongPosition();

  @override
  Future<void> close() async {
    await _playerIndexSubscription.cancel();
    return super.close();
  }

  // ==================== Private Helper Methods ====================

  /// Handles player index changes from the audio handler.
  void _watchPlayerIndex(int? index) {
    if (index == null || index < 0 || index >= state.playList.length) {
      return;
    }

    unawaited(_persistPlaybackSession(currentSongIndex: index));
    unawaited(addToRecentlyPlayed(state.playList[index].id));

    final hasNext = hasNextSong();
    final hasPrevious = hasPreviousSong();
    add(
      PlayerIndexChangedEvent(
        index: index,
        hasNext: hasNext.value ?? state.hasNext,
        hasPrevious: hasPrevious.value ?? state.hasPrevious,
      ),
    );
  }

  /// Calculates the next loop mode in the cycle: off → all → one → off.
  PlayerLoopMode _getNextLoopMode(PlayerLoopMode loopMode) {
    return switch (loopMode) {
      PlayerLoopMode.off => PlayerLoopMode.all,
      PlayerLoopMode.all => PlayerLoopMode.one,
      PlayerLoopMode.one => PlayerLoopMode.off,
    };
  }

  Future<void> _persistPlaybackSession({
    int? currentSongIndex,
    bool? wasPlaying,
  }) async {
    final playlist = state.playList;
    final index = currentSongIndex ?? state.currentSongIndex;

    if (playlist.isEmpty || index < 0 || index >= playlist.length) {
      return;
    }

    await savePlaybackSession(
      playlist,
      index,
      wasPlaying: wasPlaying ?? state.status == MusicPlayerStatus.playing,
    );
  }

  // ==================== Event Handlers ====================

  void _handlePlayerIndexChanged(
    PlayerIndexChangedEvent event,
    Emitter<MusicPlayerState> emit,
  ) {
    emit(
      state.copyWith(
        currentSongIndex: event.index,
        hasNext: event.hasNext,
        hasPrevious: event.hasPrevious,
      ),
    );
  }

  /// Handles setting the loop mode.
  Future<void> _handleSetPlayerLoopMode(
    SetPlayerLoopModeEvent event,
    Emitter<MusicPlayerState> emit,
  ) async {
    final newLoopMode = _getNextLoopMode(event.loopMode);
    final result = setLoopMode(loopMode: newLoopMode);

    if (result.isFailure) {
      emit(
        state.copyWith(
          status: MusicPlayerStatus.error,
          errorMessage: result.error,
        ),
      );
    } else {
      emit(state.copyWith(loopMode: newLoopMode));
    }
  }

  /// Handles skipping to the next song.
  Future<void> _handleNextMusic(
    SkipToNextEvent event,
    Emitter<MusicPlayerState> emit,
  ) async {
    final result = await skipToNext();
    if (result.isFailure) {
      emit(
        state.copyWith(
          status: MusicPlayerStatus.error,
          errorMessage: result.error,
        ),
      );
    }
  }

  /// Handles skipping to the previous song.
  Future<void> _handlePreviousMusic(
    SkipToPreviousEvent event,
    Emitter<MusicPlayerState> emit,
  ) async {
    final result = await skipToPrevious();
    if (result.isFailure) {
      emit(
        state.copyWith(
          status: MusicPlayerStatus.error,
          errorMessage: result.error,
        ),
      );
    }
  }

  /// Handles seeking to a position or different song.
  Future<void> _handleSeekMusic(
    SeekMusicEvent event,
    Emitter<MusicPlayerState> emit,
  ) async {
    // Perform seek operation
    final seekResult = await seekSong(event.position, index: event.index);
    if (seekResult.isFailure) {
      emit(
        state.copyWith(
          status: MusicPlayerStatus.error,
          errorMessage: seekResult.error,
        ),
      );
      return;
    }

    // Update navigation availability
    final hasNext = hasNextSong();
    final hasPrevious = hasPreviousSong();

    // Check for errors in navigation queries
    if (hasNext.isFailure) {
      emit(
        state.copyWith(
          status: MusicPlayerStatus.error,
          errorMessage: hasNext.error,
        ),
      );
      return;
    }

    if (hasPrevious.isFailure) {
      emit(
        state.copyWith(
          status: MusicPlayerStatus.error,
          errorMessage: hasPrevious.error,
        ),
      );
      return;
    }

    // Update state with new navigation info
    emit(
      state.copyWith(
        hasNext: hasNext.value ?? state.hasNext,
        hasPrevious: hasPrevious.value ?? state.hasPrevious,
      ),
    );
  }

  /// Handles enabling/disabling shuffle mode.
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
    }

    emit(state.copyWith(shuffleEnabled: event.isEnabled));
  }

  /// Handles shuffling and playing a list of songs.
  Future<void> _handleShuffleMusics(
    ShuffleMusicEvent event,
    Emitter<MusicPlayerState> emit,
  ) async {
    emit(
      state.copyWith(
        shuffleEnabled: true,
        status: MusicPlayerStatus.playing,
        playList: event.songs,
        currentSongIndex: 0,
      ),
    );

    final shuffleResult = await setShuffleEnabled(isEnabled: true);
    if (shuffleResult.isFailure) {
      emit(
        state.copyWith(
          status: MusicPlayerStatus.error,
          errorMessage: shuffleResult.error,
        ),
      );
      return;
    }

    final result = await playSong(event.songs, 0);
    if (result.isFailure) {
      emit(
        state.copyWith(
          status: MusicPlayerStatus.error,
          errorMessage: result.error,
        ),
      );
      return;
    }

    await _persistPlaybackSession(currentSongIndex: 0, wasPlaying: true);
  }

  /// Handles playing music from a playlist.
  Future<void> _handlePlayMusic(
    PlayMusicEvent event,
    Emitter<MusicPlayerState> emit,
  ) async {
    // Update state immediately for UI responsiveness
    emit(
      state.copyWith(
        currentSongIndex: event.index,
        status: MusicPlayerStatus.playing,
        playList: event.playList,
      ),
    );

    // Start playback
    final result = await playSong(event.playList, event.index);

    if (result.isFailure) {
      emit(
        state.copyWith(
          status: MusicPlayerStatus.error,
          errorMessage: result.error,
        ),
      );
      return;
    }

    await _persistPlaybackSession(
      currentSongIndex: event.index,
      wasPlaying: true,
    );
  }

  /// Handles stopping music playback.
  Future<void> _handleStopMusic(
    StopMusicEvent event,
    Emitter<MusicPlayerState> emit,
  ) async {
    await stopSong();
    await clearSavedPlaybackSession();
    emit(
      state.copyWith(
        status: MusicPlayerStatus.stopped,
        playList: const [],
        currentSongIndex: -1,
        hasNext: false,
        hasPrevious: false,
      ),
    );
  }

  /// Handles toggling between play and pause.
  Future<void> _handleTogglePlayPause(
    TogglePlayPauseEvent event,
    Emitter<MusicPlayerState> emit,
  ) async {
    if (state.status == MusicPlayerStatus.playing) {
      // Pause playback
      emit(state.copyWith(status: MusicPlayerStatus.paused));
      await pauseSong();
      await _persistPlaybackSession(wasPlaying: false);
    } else {
      // Resume playback
      emit(state.copyWith(status: MusicPlayerStatus.playing));
      await resumeSong();
      await _persistPlaybackSession(wasPlaying: true);
    }
  }

  Future<void> _handleRestoreSavedPlayback(
    RestoreSavedPlaybackEvent event,
    Emitter<MusicPlayerState> emit,
  ) async {
    if (state.playList.isNotEmpty || event.availableSongs.isEmpty) {
      return;
    }

    final savedSessionResult = await getSavedPlaybackSession();
    if (savedSessionResult.isFailure) {
      emit(
        state.copyWith(
          status: MusicPlayerStatus.error,
          errorMessage: savedSessionResult.error,
        ),
      );
      return;
    }

    final savedSession = savedSessionResult.value;
    if (savedSession == null) {
      return;
    }

    final songsById = <int, Song>{
      for (final song in event.availableSongs) song.id: song,
    };
    final restoredPlaylist = savedSession.playlistSongIds
        .map((songId) => songsById[songId])
        .whereType<Song>()
        .toList(growable: false);

    if (restoredPlaylist.isEmpty) {
      await clearSavedPlaybackSession();
      return;
    }

    final restoredIndex = restoredPlaylist.indexWhere(
      (song) => song.id == savedSession.currentSongId,
    );
    if (restoredIndex == -1) {
      await clearSavedPlaybackSession();
      return;
    }

    emit(
      state.copyWith(
        playList: restoredPlaylist,
        currentSongIndex: restoredIndex,
        status: savedSession.wasPlaying
            ? MusicPlayerStatus.playing
            : MusicPlayerStatus.paused,
        hasNext: restoredIndex < restoredPlaylist.length - 1,
        hasPrevious: restoredIndex > 0,
      ),
    );

    final result = await playSong(
      restoredPlaylist,
      restoredIndex,
      autoPlay: savedSession.wasPlaying,
    );
    if (result.isFailure) {
      emit(
        state.copyWith(
          status: MusicPlayerStatus.error,
          errorMessage: result.error,
        ),
      );
    }
  }
}
