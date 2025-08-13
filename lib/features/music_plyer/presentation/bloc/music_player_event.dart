part of 'music_player_bloc.dart';

sealed class MusicPlayerEvent extends Equatable {
  const MusicPlayerEvent();

  @override
  List<Object> get props => [];
}

final class PlayMusicEvent extends MusicPlayerEvent {
  const PlayMusicEvent(this.index, this.playList);

  final int index;
  final List<SongModel> playList;

  @override
  List<Object> get props => [index, playList];
}

final class StopMusicEvent extends MusicPlayerEvent {
  const StopMusicEvent();

  @override
  List<Object> get props => [];
}

final class TogglePlayPauseEvent extends MusicPlayerEvent {
  const TogglePlayPauseEvent();

  @override
  List<Object> get props => [];
}

final class NextMusicEvent extends MusicPlayerEvent {
  const NextMusicEvent();

  @override
  List<Object> get props => [];
}

final class PreviousMusicEvent extends MusicPlayerEvent {
  const PreviousMusicEvent();

  @override
  List<Object> get props => [];
}

final class ShuffleMusicEvent extends MusicPlayerEvent {
  const ShuffleMusicEvent({required this.songs});
  final List<SongModel> songs;

  @override
  List<Object> get props => [...super.props, ...songs];
}
