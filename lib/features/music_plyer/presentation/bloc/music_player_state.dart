part of 'music_player_bloc.dart';

/// Represents the state of the music player.
///
/// Contains all information about the current playback state including
/// the playlist, current song, playback status, and player settings.
final class MusicPlayerState extends Equatable {
  /// Creates a [MusicPlayerState].
  const MusicPlayerState({
    this.status = MusicPlayerStatus.initial,
    this.shuffleEnabled = false,
    this.loopMode = PlayerLoopMode.off,
    this.hasNext = false,
    this.hasPrevious = false,
    this.playList = const [],
    this.currentSongIndex = -1,
    this.errorMessage,
  });

  /// Current playback status.
  final MusicPlayerStatus status;

  /// Whether shuffle mode is enabled.
  final bool shuffleEnabled;

  /// Current playlist of songs.
  final List<Song> playList;

  /// Current loop/repeat mode.
  final PlayerLoopMode loopMode;

  /// Whether there is a next song available.
  final bool hasNext;

  /// Whether there is a previous song available.
  final bool hasPrevious;

  /// Error message if status is error.
  final String? errorMessage;

  /// Index of the currently playing song in the playlist.
  final int currentSongIndex;

  /// Creates a copy of this state with the given fields replaced.
  MusicPlayerState copyWith({
    MusicPlayerStatus? status,
    int? currentSongIndex,
    List<Song>? playList,
    String? errorMessage,
    bool? shuffleEnabled,
    bool? hasNext,
    bool? hasPrevious,
    PlayerLoopMode? loopMode,
  }) {
    return MusicPlayerState(
      status: status ?? this.status,
      shuffleEnabled: shuffleEnabled ?? this.shuffleEnabled,
      errorMessage: errorMessage ?? this.errorMessage,
      playList: playList ?? this.playList,
      hasNext: hasNext ?? this.hasNext,
      hasPrevious: hasPrevious ?? this.hasPrevious,
      loopMode: loopMode ?? this.loopMode,
      currentSongIndex: currentSongIndex ?? this.currentSongIndex,
    );
  }

  /// Gets the currently playing song, or null if playlist is empty.
  Song? get currentSong {
    if (playList.isEmpty) {
      return null;
    }
    return playList[currentSongIndex];
  }

  @override
  List<Object> get props => [
    status,
    playList,
    loopMode,
    hasNext,
    hasPrevious,
    shuffleEnabled,
    currentSongIndex,
    errorMessage ?? '',
  ];
}

/// Enum representing the different playback states.
enum MusicPlayerStatus {
  /// Initial state, no music loaded.
  initial,

  /// Music is currently playing.
  playing,

  /// Music is paused.
  paused,

  /// Playback has been stopped.
  stopped,

  /// An error occurred.
  error,
}
