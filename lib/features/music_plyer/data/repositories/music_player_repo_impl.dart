import 'package:music_player/core/data/mappers/song_model_mapper.dart';
import 'package:music_player/core/domain/entities/song.dart';
import 'package:music_player/core/result.dart';
import 'package:music_player/features/music_plyer/data/datasources/datasources.dart';
import 'package:music_player/features/music_plyer/domain/entities/entities.dart';
import 'package:music_player/features/music_plyer/domain/repositories/repositories.dart';

/// Implementation of [MusicPlayerRepository] using audio handler datasource.
///
/// Manages music playback operations including play, pause, seek, shuffle,
/// and loop functionality. Delegates actual audio operations to the
/// audio handler datasource.
class MusicPlayerRepoImpl implements MusicPlayerRepository {
  /// Creates a [MusicPlayerRepoImpl] with the given audio handler datasource.
  MusicPlayerRepoImpl({required AudioHandlerDatasource audioHandlerDatasource})
    : _audioHandlerDatasource = audioHandlerDatasource;

  final AudioHandlerDatasource _audioHandlerDatasource;

  @override
  Future<Result<void>> pause() async {
    try {
      await _audioHandlerDatasource.pause();
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure('failed to pause: $e');
    }
  }

  @override
  Future<Result<void>> play(List<Song> playlist, int index) async {
    try {
      await _audioHandlerDatasource.play(
        playlist.map(SongModelMapper.fromDomain).toList(),
        index,
      );
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure('failed to play: $e');
    }
  }

  @override
  Future<Result<void>> resume() async {
    try {
      await _audioHandlerDatasource.resume();
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure('failed to resume: $e');
    }
  }

  @override
  Future<Result<void>> seek(Duration position, {int? index}) async {
    try {
      await _audioHandlerDatasource.seek(position, index: index);
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure('failed to seek: $e');
    }
  }

  @override
  Future<Result<void>> stop() async {
    try {
      await _audioHandlerDatasource.stop();
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure('failed to stop: $e');
    }
  }

  @override
  Future<Result<void>> setShuffleModeEnabled({required bool isEnabled}) async {
    try {
      await _audioHandlerDatasource.setShuffleMode(
        isEnabled: isEnabled,
      );
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure('failed to set shuffle mode: $e');
    }
  }

  @override
  Result<bool> hasNext() {
    try {
      final result = _audioHandlerDatasource.hasNext();
      return Result.success(result);
    } on Exception catch (e) {
      return Result.failure('failed to check has next: $e');
    }
  }

  @override
  Result<bool> hasPrevious() {
    try {
      final result = _audioHandlerDatasource.hasPrevious();
      return Result.success(result);
    } on Exception catch (e) {
      return Result.failure('failed to check has previous: $e');
    }
  }

  @override
  Stream<int?> currentIndexStream() {
    return _audioHandlerDatasource.currentIndexStream();
  }

  @override
  Stream<Duration?> durationStream() {
    return _audioHandlerDatasource.durationStream();
  }

  @override
  Stream<Duration> positionStream() {
    return _audioHandlerDatasource.positionStream();
  }

  @override
  Result<PlayerLoopMode> setLoopMode(PlayerLoopMode loopMode) {
    try {
      final result = _audioHandlerDatasource.setPlayerLoopMode(
        loopMode,
      );
      return Result.success(
        result,
      );
    } on Exception catch (e) {
      return Result.failure('failed to set loop mode: $e');
    }
  }

  @override
  Future<Result<bool>> addToRecentlyPlayed(int songId) async {
    try {
      final result = await _audioHandlerDatasource.addToRecentlyPlayed(songId);
      return Result.success(result);
    } on Exception catch (e) {
      return Result.failure('failed to add to recently played: $e');
    }
  }
}
