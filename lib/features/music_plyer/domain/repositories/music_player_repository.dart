import 'package:music_player/core/domain/entities/song.dart';
import 'package:music_player/core/result.dart';
import 'package:music_player/features/music_plyer/domain/entities/entities.dart';

abstract interface class MusicPlayerRepository {
  Future<Result<void>> play(List<Song> playlist, int index);

  Future<Result<void>> pause();

  Future<Result<void>> resume();

  Future<Result<void>> stop();

  Future<Result<void>> seek(Duration position, {int? index});

  Future<Result<void>> setShuffleModeEnabled({required bool isEnabled});

  Result<bool> hasNext();

  Result<bool> hasPrevious();

  Stream<int?> currentIndexStream();

  Stream<Duration?> durationStream();

  Stream<Duration> positionStream();

  Result<PlayerLoopMode> setLoopMode(PlayerLoopMode loopMode);
}
