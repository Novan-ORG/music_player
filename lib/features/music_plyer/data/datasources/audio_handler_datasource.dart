import 'package:music_player/core/constants/preferences_keys.dart';
import 'package:music_player/core/services/services.dart';
import 'package:music_player/features/music_plyer/data/data.dart';
import 'package:music_player/features/music_plyer/data/mapppers/mappers.dart';
import 'package:music_player/features/music_plyer/domain/entities/entities.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class AudioHandlerDatasource {
  Future<void> play(List<SongModel> songs, int index);
  Future<void> pause();
  Future<void> resume();
  Future<void> stop();
  Future<void> seek(Duration position, {int? index});
  Future<Set<int>> toggleLike(int songId);
  Set<int> getLikedSongIds();
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
    required SharedPreferences preferences,
  }) : _audioHandler = audioHandler,
       _preferences = preferences;

  final MAudioHandler _audioHandler;
  final SharedPreferences _preferences;

  @override
  Set<int> getLikedSongIds() {
    final likedSongIds = _preferences
        .getStringList(PreferencesKeys.favoriteSongs)
        ?.map(int.tryParse)
        .whereType<int>()
        .toSet();
    return likedSongIds ?? {};
  }

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
  Future<Set<int>> toggleLike(int songId) async {
    final likedSongIds = getLikedSongIds();
    if (likedSongIds.contains(songId)) {
      likedSongIds.remove(songId);
    } else {
      likedSongIds.add(songId);
    }
    final likedSongIdsList = likedSongIds.map((id) => id.toString()).toList();
    await _preferences.setStringList(
      PreferencesKeys.favoriteSongs,
      likedSongIdsList,
    );

    return likedSongIds;
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
