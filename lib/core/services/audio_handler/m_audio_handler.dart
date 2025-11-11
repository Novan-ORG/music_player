import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/core/services/logger/logger.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';

class MAudioHandler extends BaseAudioHandler with SeekHandler {
  MAudioHandler(this._player) {
    unawaited(
      _player.playbackEventStream.map(_transformEvent).pipe(playbackState),
    );
    _player.currentIndexStream.listen((currentIndex) {
      if (currentIndex != null && queue.value.length > currentIndex) {
        if (mediaItem.value?.id != queue.value[currentIndex].id) {
          mediaItem.add(queue.value[currentIndex]);
        }
      }
    });
  }

  Timer? _timer;

  final AudioPlayer _player;

  bool get playing => _player.playing;

  Stream<int?> get currentIndexStream => _player.currentIndexStream.distinct();

  Stream<Duration?> get durationStream => _player.durationStream;

  Stream<Duration> get positionStream => _player.positionStream;

  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  Stream<LoopMode> get loopModeStream => _player.loopModeStream;

  bool get hasNext => _player.hasNext;

  bool get hasPrevious => _player.hasPrevious;

  LoopMode get loopMode => _player.loopMode;

  bool get shuffleModeEnabled => _player.shuffleModeEnabled;

  void setLoopMode(LoopMode loopMode) => _player.setLoopMode(loopMode);

  Future<void> dispose() async {
    _timer?.cancel();
    await _player.dispose();
  }

  void setSleepTimer(Duration duration) {
    _timer?.cancel();
    _timer = Timer(duration, () async {
      await stop();
      cancelSleepTimer();
    });
  }

  void cancelSleepTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  Future<void> seek(Duration position, {int? index}) async {
    await _player.seek(position, index: index);
  }

  Future<void> setShuffleModeEnabled({required bool enabled}) async {
    await _player.setShuffleModeEnabled(enabled);
  }

  Future<void> addAudioSources(List<SongModel> songs) async {
    final mediaItems = <MediaItem>[];

    try {
      await _player.setAudioSources(
        songs.map((song) {
          final mediaItem = MediaItem(
            id: song.id.toString(),
            title: song.title,
            album: song.album,
            artist: song.artist,
            duration: Duration(milliseconds: song.duration ?? 0),
            artUri: Uri.parse(
              'content://media/external/audio/albumart/${song.albumId}',
            ),
          );
          mediaItems.add(mediaItem);
          return AudioSource.uri(Uri.parse(song.data));
        }).toList(),
      );
      await addQueueItems(mediaItems);
    } on Exception catch (e) {
      Logger.error('Error setting audio sources: $e');
    }
  }

  @override
  Future<void> addQueueItem(MediaItem mediaItem) async {
    final newQueue = [...queue.value, mediaItem];
    queue.add(newQueue);
  }

  @override
  Future<void> addQueueItems(List<MediaItem> mediaItems) async {
    queue.add(mediaItems);
  }

  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        MediaControl.skipToPrevious,
        if (_player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.skipToNext,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 2],
      processingState: {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      playing: _player.playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: _player.currentIndex,
    );
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> skipToNext() => _player.seekToNext();

  @override
  Future<void> skipToPrevious() => _player.seekToPrevious();

  @override
  Future<void> stop() => _player.stop();
}
