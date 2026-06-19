import 'package:equatable/equatable.dart';

/// Persistent snapshot of the last active playback queue.
final class PlaybackSession extends Equatable {
  const PlaybackSession({
    required this.playlistSongIds,
    required this.currentSongIndex,
    required this.wasPlaying,
  });

  final List<int> playlistSongIds;
  final int currentSongIndex;
  final bool wasPlaying;

  int get currentSongId => playlistSongIds[currentSongIndex];

  @override
  List<Object> get props => [playlistSongIds, currentSongIndex, wasPlaying];
}
