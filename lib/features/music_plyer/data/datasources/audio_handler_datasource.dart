import 'package:music_player/core/constants/preferences_keys.dart';
import 'package:music_player/core/services/services.dart';
import 'package:music_player/features/music_plyer/data/mapppers/mappers.dart';
import 'package:music_player/features/music_plyer/domain/entities/entities.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Datasource interface for audio playback operations.
///
/// Defines the contract for interacting with the audio handler service
/// to control music playback.
abstract interface class AudioHandlerDatasource {
  /// Plays a playlist starting at the specified index.
  Future<void> play(List<SongModel> songs, int index);

  /// Pauses the currently playing song.
  Future<void> pause();

  /// Resumes playback of the paused song.
  Future<void> resume();

  /// Stops playback and clears the playlist.
  Future<void> stop();

  /// Seeks to a specific position in the current or different song.
  Future<void> seek(Duration position, {int? index});

  /// Skips to the next song in the playlist.
  Future<void> skipToNext();

  /// Skips to the previous song in the playlist.
  Future<void> skipToPrevious();

  /// Enables or disables shuffle mode.
  Future<void> setShuffleMode({required bool isEnabled});

  /// Checks if there is a next song available.
  bool hasNext();

  /// Checks if there is a previous song available.
  bool hasPrevious();

  /// Stream of the current song index.
  Stream<int?> currentIndexStream();

  /// Stream of the current song's duration.
  Stream<Duration?> durationStream();

  /// Stream of the current playback position.
  Stream<Duration> positionStream();

  /// Sets the loop/repeat mode.
  PlayerLoopMode setPlayerLoopMode(PlayerLoopMode loopMode);

  /// Adds a song to the recently played list.
  /// Parameters:
  /// - [songId]: ID of the song to add
  /// Returns a [bool] indicating success or failure.
  Future<bool> addToRecentlyPlayed(int songId);
}

/// Implementation of [AudioHandlerDatasource] using MAudioHandler.
///
/// Delegates all audio operations to the audio handler service which
/// manages the actual audio playback and system integration.
class AudioHandlerDatasourceImpl implements AudioHandlerDatasource {
  /// Creates an [AudioHandlerDatasourceImpl].
  AudioHandlerDatasourceImpl({
    required MAudioHandler audioHandler,
    required SharedPreferences preferences,
  }) : _audioHandler = audioHandler,
       _preferences = preferences;

  final MAudioHandler _audioHandler;
  final SharedPreferences _preferences;

  @override
  Future<void> pause() {
    return _audioHandler.pause();
  }

  @override
  Future<void> play(List<SongModel> songs, int index) async {
    // Add songs to the audio handler's queue
    await _audioHandler.addAudioSources(songs);
    // Seek to the specified song index
    await _audioHandler.seek(Duration.zero, index: index);
    // Start playback
    await _audioHandler.play();
  }

  @override
  Future<void> resume() {
    return _audioHandler.play();
  }

  @override
  Future<void> seek(Duration position, {int? index}) {
    return _audioHandler.seek(position, index: index);
  }

  @override
  Future<void> stop() {
    return _audioHandler.stop();
  }

  @override
  Future<void> setShuffleMode({required bool isEnabled}) {
    return _audioHandler.setShuffleModeEnabled(enabled: isEnabled);
  }

  @override
  bool hasNext() {
    return _audioHandler.hasNext;
  }

  @override
  bool hasPrevious() {
    return _audioHandler.hasPrevious;
  }

  @override
  Stream<int?> currentIndexStream() {
    return _audioHandler.currentIndexStream;
  }

  @override
  Stream<Duration?> durationStream() {
    return _audioHandler.durationStream;
  }

  @override
  Stream<Duration> positionStream() {
    return _audioHandler.positionStream;
  }

  @override
  PlayerLoopMode setPlayerLoopMode(PlayerLoopMode loopMode) {
    _audioHandler.setLoopMode(PlayerLoopModeMapper.mapToLoopMode(loopMode));
    return loopMode;
  }

  @override
  Future<bool> addToRecentlyPlayed(int songId) {
    final recentList =
        _preferences.getStringList(PreferencesKeys.recentlyPlayedSongIds) ?? [];

    final songIdStr = songId.toString();

    // Remove if already exists to avoid duplicates
    recentList
      ..remove(songIdStr)
      // Add to the start of the list
      ..insert(0, songIdStr);

    // Keep only the latest 50 entries
    if (recentList.length > 50) {
      recentList.removeRange(50, recentList.length);
    }

    return _preferences.setStringList(
      PreferencesKeys.recentlyPlayedSongIds,
      recentList,
    );
  }

  @override
  Future<void> skipToNext() {
    return _audioHandler.skipToNext();
  }

  @override
  Future<void> skipToPrevious() {
    return _audioHandler.skipToPrevious();
  }
}
