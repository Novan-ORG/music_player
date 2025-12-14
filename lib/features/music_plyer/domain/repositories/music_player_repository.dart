import 'package:music_player/core/domain/entities/song.dart';
import 'package:music_player/core/result.dart';
import 'package:music_player/features/music_plyer/domain/entities/entities.dart';

/// Repository interface for music player operations.
///
/// Provides methods for controlling music playback including play, pause,
/// seek, shuffle, and loop functionality. Also provides streams for
/// observing playback state.
abstract class MusicPlayerRepository {
  /// Plays a playlist starting at the specified index.
  ///
  /// Parameters:
  /// - [playlist]: List of songs to play
  /// - [index]: Index of the song to start playing
  ///
  /// Returns a [Result] indicating success or failure.
  Future<Result<void>> play(List<Song> playlist, int index);

  /// Pauses the currently playing song.
  ///
  /// Returns a [Result] indicating success or failure.
  Future<Result<void>> pause();

  /// Resumes playback of the paused song.
  ///
  /// Returns a [Result] indicating success or failure.
  Future<Result<void>> resume();

  /// Stops playback and clears the playlist.
  ///
  /// Returns a [Result] indicating success or failure.
  Future<Result<void>> stop();

  /// Seeks to a specific position in the current song.
  ///
  /// Parameters:
  /// - [position]: Position to seek to
  /// - [index]: Optional song index to seek to a different song
  ///
  /// Returns a [Result] indicating success or failure.
  Future<Result<void>> seek(Duration position, {int? index});

  /// Enables or disables shuffle mode.
  ///
  /// Parameters:
  /// - [isEnabled]: Whether shuffle should be enabled
  ///
  /// Returns a [Result] indicating success or failure.
  Future<Result<void>> setShuffleModeEnabled({required bool isEnabled});

  /// Checks if there is a next song in the playlist.
  ///
  /// Returns a [Result] containing `true` if there is a next song.
  Result<bool> hasNext();

  /// Checks if there is a previous song in the playlist.
  ///
  /// Returns a [Result] containing `true` if there is a previous song.
  Result<bool> hasPrevious();

  /// Stream of the current song index in the playlist.
  ///
  /// Emits the index whenever the current song changes.
  Stream<int?> currentIndexStream();

  /// Stream of the current song's duration.
  ///
  /// Emits the duration when a new song starts playing.
  Stream<Duration?> durationStream();

  /// Stream of the current playback position.
  ///
  /// Emits position updates as the song plays.
  Stream<Duration> positionStream();

  /// Sets the loop/repeat mode for playback.
  ///
  /// Parameters:
  /// - [loopMode]: The desired loop mode
  ///
  /// Returns a [Result] containing the set loop mode or an error.
  Result<PlayerLoopMode> setLoopMode(PlayerLoopMode loopMode);
}
