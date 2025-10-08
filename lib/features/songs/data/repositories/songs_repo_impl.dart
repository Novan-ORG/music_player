import 'package:music_player/core/domain/entities/song.dart';
import 'package:music_player/core/result.dart';
import 'package:music_player/features/songs/data/datasources/datasources.dart';
import 'package:music_player/features/songs/domain/repositories/repositories.dart';

class SongsRepoImpl implements SongsRepository {
  SongsRepoImpl({required SongsDatasource songsDatasource})
    : _songsDatasource = songsDatasource;

  final SongsDatasource _songsDatasource;

  @override
  Future<Result<bool>> deleteSong(String songUri) async {
    try {
      final deleteResult = await _songsDatasource.deleteSong(songUri);
      return Result.success(deleteResult);
    } on Exception catch (e) {
      return Result.failure('Error in deleting the song, $e');
    }
  }

  @override
  Future<Result<List<Song>>> querySongs() async {
    try {
      final quriedSongs = await _songsDatasource.querySongs();
      return Result.success(quriedSongs);
    } on Exception catch (e) {
      return Result.failure('Error in loading songs, $e');
    }
  }
}
