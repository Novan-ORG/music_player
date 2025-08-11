part of 'music_player_bloc.dart';

final class MusicPlayerState extends Equatable {
  const MusicPlayerState({
    this.status = MusicPlayerStatus.initial,
    this.playList = const [],
    this.errorMessage,
  });

  final MusicPlayerStatus status;
  final List<SongModel> playList;
  final String? errorMessage;

  MusicPlayerState copyWith({
    MusicPlayerStatus? status,
    int? currentSongIndex,
    List<SongModel>? playList,
    String? errorMessage,
  }) {
    return MusicPlayerState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      playList: playList ?? this.playList,
    );
  }

  @override
  List<Object> get props => [status, playList, errorMessage ?? ''];
}

enum MusicPlayerStatus { initial, playing, paused, stopped, error }
