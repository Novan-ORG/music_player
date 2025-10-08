import 'package:music_player/core/domain/entities/entities.dart';
import 'package:music_player/core/result.dart';

abstract interface class SongsRepository {
  Future<Result<List<Song>>> querySongs();
  Future<Result<bool>> deleteSong(String songUri);
}
