/// Represents the loop/repeat mode for music playback.
///
/// Controls how the player behaves when reaching the end of the playlist.
enum PlayerLoopMode {
  /// No looping - stops when playlist ends.
  off,

  /// Loop current song - repeats the same song indefinitely.
  one,

  /// Loop entire playlist - restarts from beginning when playlist ends.
  all,
}
