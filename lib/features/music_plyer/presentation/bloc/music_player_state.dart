part of 'music_player_bloc.dart';

final class MusicPlayerState extends Equatable {
  const MusicPlayerState({
    this.status = MusicPlayerStatus.initial,
    this.playList = const [],
    this.likedSongIds = const [],
    this.errorMessage,
  });

  final MusicPlayerStatus status;
  final List<SongModel> playList;
  final List<int> likedSongIds;
  final String? errorMessage;

  MusicPlayerState copyWith({
    MusicPlayerStatus? status,
    int? currentSongIndex,
    List<SongModel>? playList,
    List<int>? likedSongIds,
    String? errorMessage,
  }) {
    return MusicPlayerState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      playList: playList ?? this.playList,
      likedSongIds: likedSongIds ?? this.likedSongIds,
    );
  }

  @override
  List<Object> get props => [
    status,
    playList,
    errorMessage ?? '',
    likedSongIds,
  ];
}

enum MusicPlayerStatus { initial, playing, paused, stopped, error }
