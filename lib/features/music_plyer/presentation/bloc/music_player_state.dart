part of 'music_player_bloc.dart';

final class MusicPlayerState extends Equatable {
  const MusicPlayerState({
    this.status = MusicPlayerStatus.initial,
    this.shuffleEnabled = false,
    this.loopMode = PlayerLoopMode.off,
    this.hasNext = false,
    this.hasPrevious = false,
    this.playList = const [],
    this.likedSongIds = const {},
    this.currentSongIndex = 0,
    this.errorMessage,
  });

  final MusicPlayerStatus status;
  final bool shuffleEnabled;
  final List<Song> playList;
  final PlayerLoopMode loopMode;
  final bool hasNext;
  final bool hasPrevious;
  final Set<int> likedSongIds;
  final String? errorMessage;
  final int currentSongIndex;

  MusicPlayerState copyWith({
    MusicPlayerStatus? status,
    int? currentSongIndex,
    List<Song>? playList,
    Set<int>? likedSongIds,
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
      likedSongIds: likedSongIds ?? this.likedSongIds,
      hasNext: hasNext ?? this.hasNext,
      hasPrevious: hasPrevious ?? this.hasPrevious,
      loopMode: loopMode ?? this.loopMode,
      currentSongIndex: currentSongIndex ?? this.currentSongIndex,
    );
  }

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
    hasNext,
    hasPrevious,
    shuffleEnabled,
    currentSongIndex,
    likedSongIds,
    errorMessage ?? '',
  ];
}

enum MusicPlayerStatus { initial, playing, paused, stopped, error }
