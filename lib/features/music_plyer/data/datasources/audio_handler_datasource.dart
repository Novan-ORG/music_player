import 'package:music_player/core/services/services.dart';
import 'package:music_player/features/music_plyer/data/mapppers/mappers.dart';
import 'package:music_player/features/music_plyer/domain/entities/entities.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';

abstract interface class AudioHandlerDatasource {
  Future<void> play(List<SongModel> songs, int index);
  Future<void> pause();
  Future<void> resume();
  Future<void> stop();
  Future<void> seek(Duration position, {int? index});
  Future<void> setShuffleMode({required bool isEnabled});
  bool hasNext();
  bool hasPrevious();
  Stream<int?> currentIndexStream();
  Stream<Duration?> durationStream();
  Stream<Duration> positionStream();
  PlayerLoopMode setPlayerLoopMode(PlayerLoopMode loopMode);
}

class AudioHandlerDatasourceImpl implements AudioHandlerDatasource {
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
    await _audioHandler.addAudioSources(songs);
    await _audioHandler.seek(Duration.zero, index: index);
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
