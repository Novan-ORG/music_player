import 'package:music_player/core/data/mappers/song_model_mapper.dart';
import 'package:music_player/core/domain/entities/song.dart';
import 'package:music_player/core/result.dart';
import 'package:music_player/features/songs/data/datasources/datasources.dart';
import 'package:music_player/features/songs/data/mappers/mappers.dart';
import 'package:music_player/features/songs/domain/entities/album.dart';
import 'package:music_player/features/songs/domain/entities/artist.dart';
import 'package:music_player/features/songs/domain/enums/enums.dart';
import 'package:music_player/features/songs/domain/repositories/repositories.dart';

/// Implementation of [SongsRepository] that handles song, album,
/// and artist queries.
///
/// This repository acts as a bridge between the domain layer and the
/// data layer, converting data models to domain entities and handling
/// errors gracefully.
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
      return Result.failure('Failed to delete song: $e');
    }
  }

  @override
  Future<Result<List<Song>>> querySongs({
    SongsSortType sortType = SongsSortType.dateAdded,
  }) async {
    try {
      final queriedSongs = await _songsDatasource.querySongs(
        sortType: sortType.toSongSortType(),
      );
      return Result.success(
        queriedSongs.map(SongModelMapper.toDomain).toList(),
      );
    } on Exception catch (e) {
      return Result.failure('Failed to load songs: $e');
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
      return Result.failure('Failed to load albums: $e');
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
      return Result.failure('Failed to load artists: $e');
    }
  }

  @override
  Future<Result<List<Song>>> querySongsFrom({
    required SongsFromType fromType,
    required Object where,
    SongsSortType sortType = SongsSortType.dateAdded,
  }) async {
    try {
      final queriedSongs = await _songsDatasource.querySongsFrom(
        audiosFromTye: fromType.toAudioFromType(),
        where: where,
        sortType: sortType.toSongSortType(),
      );
      return Result.success(
        queriedSongs.map(SongModelMapper.toDomain).toList(),
      );
    } on Exception catch (e) {
      return Result.failure('Failed to load songs from $fromType: $e');
    }
  }

  @override
  Result<SongsSortType> getSongsSortType() {
    try {
      final result = _songsDatasource.getSongSortType();
      return Result.success(
        SongSortTypeMapper.toSongsSortType(result),
      );
    } on Exception catch (e) {
      return Result.failure('Failed to get songs sort type: $e');
    }
  }

  @override
  Future<Result<bool>> saveSongsSortType({
    required SongsSortType sortType,
  }) async {
    try {
      final isSuccess = await _songsDatasource.saveSongSortType(
        sortType: sortType.toSongSortType(),
      );
      return Result.success(isSuccess);
    } on Exception catch (e) {
      return Result.failure('Failed to save songs sort type: $e');
    }
  }
}
