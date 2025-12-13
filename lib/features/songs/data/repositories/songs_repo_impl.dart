import 'package:music_player/core/data/mappers/song_model_mapper.dart';
import 'package:music_player/core/domain/entities/song.dart';
import 'package:music_player/core/result.dart';
import 'package:music_player/features/songs/data/datasources/datasources.dart';
import 'package:music_player/features/songs/data/mappers/mappers.dart';
import 'package:music_player/features/songs/domain/entities/album.dart';
import 'package:music_player/features/songs/domain/entities/artist.dart';
import 'package:music_player/features/songs/domain/enums/enums.dart';
import 'package:music_player/features/songs/domain/repositories/repositories.dart';

class SongsRepoImpl implements SongsRepository {
  SongsRepoImpl({required SongsDatasource songsDatasource})
    : _songsDatasource = songsDatasource;

  final SongsDatasource _songsDatasource;

  @override
  Future<Result<bool>> deleteSong({required String songUri}) async {
    try {
      final deleteResult = await _songsDatasource.deleteSong(songUri);
      return Result.success(deleteResult);
    } on Exception catch (e) {
      return Result.failure('Error in deleting the song, $e');
    }
  }

  @override
  Future<Result<List<Song>>> querySongs({
    SongsSortType sortType = SongsSortType.dateAdded,
  }) async {
    try {
      final quriedSongs = await _songsDatasource.querySongs(
        sortType: sortType.toSongSortType(),
      );
      return Result.success(
        quriedSongs.map(SongModelMapper.toDomain).toList(),
      );
    } on Exception catch (e) {
      return Result.failure('Error in loading songs, $e');
    }
  }

  @override
  Future<Result<List<Album>>> queryAlbums({
    AlbumsSortType sortType = AlbumsSortType.album,
  }) async {
    try {
      final queriedAlbums = await _songsDatasource.queryAlbums(
        sortType: sortType.toAlbumSortType(),
      );
      return Result.success(
        queriedAlbums.map(AlbumModelMapper.toDomain).toList(),
      );
    } on Exception catch (e) {
      return Result.failure('Error in loading albums, $e');
    }
  }

  @override
  Future<Result<List<Artist>>> queryArtists({
    ArtistsSortType sortType = ArtistsSortType.artist,
  }) async {
    try {
      final queriedArtists = await _songsDatasource.queryArtists(
        sortType: sortType.toArtistSortType(),
      );
      return Result.success(
        queriedArtists.map(ArtistModelMapper.toDomain).toList(),
      );
    } on Exception catch (e) {
      return Result.failure('Error in loading artists, $e');
    }
  }

  @override
  Future<Result<List<Song>>> querySongsFrom({
    required SongsFromType fromType,
    required Object where,
    SongsSortType sortType = SongsSortType.dateAdded,
  }) async {
    try {
      final queredSongs = await _songsDatasource.querySongsFrom(
        audiosFromTye: fromType.toAudioFromType(),
        where: where,
        sortType: sortType.toSongSortType(),
      );
      return Result.success(queredSongs.map(SongModelMapper.toDomain).toList());
    } on Exception catch (e) {
      return Result.failure('Error in loading songs, $e');
    }
  }
}
