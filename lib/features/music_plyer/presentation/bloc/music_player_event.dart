part of 'music_player_bloc.dart';

sealed class MusicPlayerEvent extends Equatable {
  const MusicPlayerEvent();

  @override
  List<Object> get props => [];
}

final class PlayMusicEvent extends MusicPlayerEvent {
  const PlayMusicEvent(this.index, this.playList);

  final int index;
  final List<Song> playList;

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

final class ShuffleMusicEvent extends MusicPlayerEvent {
  const ShuffleMusicEvent({required this.songs});
  final List<Song> songs;

  @override
  List<Object> get props => [...super.props, ...songs];
}

final class ToggleLikeMusicEvent extends MusicPlayerEvent {
  const ToggleLikeMusicEvent(this.songId);

  final int songId;

  @override
  List<Object> get props => [...super.props, songId];
}

final class SetShuffleEnabledEvent extends MusicPlayerEvent {
  const SetShuffleEnabledEvent({required this.isEnabled});

  final bool isEnabled;

  @override
  List<Object> get props => [...super.props, isEnabled];
}

final class SeekMusicEvent extends MusicPlayerEvent {
  const SeekMusicEvent({this.position = Duration.zero, this.index});
  final Duration position;
  final int? index;

  @override
  List<Object> get props => [
    ...super.props,
    position,
    if (index != null) index!,
  ];
}

final class SetPlayerLoopModeEvent extends MusicPlayerEvent {
  const SetPlayerLoopModeEvent(this.loopMode);

  final PlayerLoopMode loopMode;

  @override
  List<Object> get props => [...super.props, loopMode];
}

final class UpdateStateEvent extends MusicPlayerEvent {
  const UpdateStateEvent(this.state);

  final MusicPlayerState state;

  @override
  List<Object> get props => [...super.props, state];
}
