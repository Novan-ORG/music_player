import 'package:music_player/core/services/services.dart';
import 'package:music_player/features/music_plyer/data/mapppers/mappers.dart';
import 'package:music_player/features/music_plyer/domain/entities/entities.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';

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
}

/// Implementation of [AudioHandlerDatasource] using MAudioHandler.
///
/// Delegates all audio operations to the audio handler service which
/// manages the actual audio playback and system integration.
class AudioHandlerDatasourceImpl implements AudioHandlerDatasource {
  /// Creates an [AudioHandlerDatasourceImpl].
  AudioHandlerDatasourceImpl({
    required MAudioHandler audioHandler,
  }) : _audioHandler = audioHandler;

  final MAudioHandler _audioHandler;

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
}
