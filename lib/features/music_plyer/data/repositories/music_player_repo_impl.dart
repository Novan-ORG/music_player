import 'package:music_player/core/data/mappers/mappers.dart';
import 'package:music_player/core/domain/entities/entities.dart';
import 'package:music_player/core/result.dart';
import 'package:music_player/features/music_plyer/data/datasources/datasources.dart';
import 'package:music_player/features/music_plyer/domain/domain.dart';

class MusicPlayerRepoImpl implements MusicPlayerRepository {
  MusicPlayerRepoImpl({required AudioHandlerDatasource audioHandlerDatasource})
    : _audioHandlerDatasource = audioHandlerDatasource;

  final AudioHandlerDatasource _audioHandlerDatasource;

  @override
  Result<Set<int>> getLikedSongIds() {
    try {
      final likedSongIds = _audioHandlerDatasource.getLikedSongIds();
      return Result.success(likedSongIds);
    } on Exception catch (e) {
      return Result.failure('failed to get liked song ids: $e');
    }
  }

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
  Future<Result<Set<int>>> toggleLike(int songId) async {
    try {
      final result = await _audioHandlerDatasource.toggleLike(songId);
      return Result.success(result);
    } on Exception catch (e) {
      return Result.failure('failed to toggle like: $e');
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
}
