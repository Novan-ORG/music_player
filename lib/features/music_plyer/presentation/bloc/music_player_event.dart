part of 'music_player_bloc.dart';

/// Base class for all music player events.
sealed class MusicPlayerEvent extends Equatable {
  const MusicPlayerEvent();

  @override
  List<Object> get props => [];
}

/// Event to play a playlist starting at a specific index.
final class PlayMusicEvent extends MusicPlayerEvent {
  /// Creates a [PlayMusicEvent].
  ///
  /// Parameters:
  /// - [index]:The index of the song to start playing
  /// - [playList]: The list of songs to play
  const PlayMusicEvent(this.index, this.playList);

  final int index;
  final List<Song> playList;

  @override
  List<Object> get props => [index, playList];
}

/// Event to stop music playback.
final class StopMusicEvent extends MusicPlayerEvent {
  const StopMusicEvent();

  @override
  List<Object> get props => [];
}

/// Event to toggle between play and pause states.
final class TogglePlayPauseEvent extends MusicPlayerEvent {
  const TogglePlayPauseEvent();

  @override
  List<Object> get props => [];
}

/// Event to shuffle and play a list of songs.
final class ShuffleMusicEvent extends MusicPlayerEvent {
  /// Creates a [ShuffleMusicEvent].
  const ShuffleMusicEvent({required this.songs});

  final List<Song> songs;

  @override
  List<Object> get props => [...super.props, ...songs];
}

/// Event to enable or disable shuffle mode.
final class SetShuffleEnabledEvent extends MusicPlayerEvent {
  /// Creates a [SetShuffleEnabledEvent].
  const SetShuffleEnabledEvent({required this.isEnabled});

  final bool isEnabled;

  @override
  List<Object> get props => [...super.props, isEnabled];
}

/// Event to seek to a specific position in the current or different song.
final class SeekMusicEvent extends MusicPlayerEvent {
  /// Creates a [SeekMusicEvent].
  ///
  /// Parameters:
  /// - [position]: The position to seek to (defaults to start)
  /// - [index]: Optional song index to jump to a different song
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

/// Event to change the loop/repeat mode.
final class SetPlayerLoopModeEvent extends MusicPlayerEvent {
  /// Creates a [SetPlayerLoopModeEvent].
  const SetPlayerLoopModeEvent(this.loopMode);

  final PlayerLoopMode loopMode;

  @override
  List<Object> get props => [...super.props, loopMode];
}

/// Internal event to update the state.
final class UpdateStateEvent extends MusicPlayerEvent {
  /// Creates an [UpdateStateEvent].
  const UpdateStateEvent(this.state);

  final MusicPlayerState state;

  @override
  List<Object> get props => [...super.props, state];
}

/// Event to skip to the next song in the playlist.
final class SkipToNextEvent extends MusicPlayerEvent {
  /// Creates a [SkipToNextEvent].
  const SkipToNextEvent();

  @override
  List<Object> get props => [];
}

/// Event to skip to the previous song in the playlist.
final class SkipToPreviousEvent extends MusicPlayerEvent {
  /// Creates a [SkipToPreviousEvent].
  const SkipToPreviousEvent();

  @override
  List<Object> get props => [];
}
