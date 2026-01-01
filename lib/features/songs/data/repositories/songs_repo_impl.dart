import 'package:music_player/core/data/mappers/song_model_mapper.dart';
import 'package:music_player/core/domain/entities/song.dart';
import 'package:music_player/core/result.dart';
import 'package:music_player/features/songs/data/datasources/datasources.dart';
import 'package:music_player/features/songs/data/mappers/mappers.dart';
import 'package:music_player/features/songs/domain/domain.dart';
import 'package:music_player/features/songs/domain/enums/enums.dart';

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
    SortConfig sortConfig = const SortConfig(),
  }) async {
    try {
      final queriedSongs = await _songsDatasource.querySongs(
        sortType: sortConfig.sortType.toSongSortType(),
        orderType: sortConfig.orderType.toOrderType(),
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
    SortOrderType orderType = SortOrderType.descOrGreater,
  }) async {
    try {
      final queriedAlbums = await _songsDatasource.queryAlbums(
        sortType: sortType.toAlbumSortType(),
        orderType: orderType.toOrderType(),
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
    SortOrderType orderType = SortOrderType.descOrGreater,
  }) async {
    try {
      final queriedArtists = await _songsDatasource.queryArtists(
        sortType: sortType.toArtistSortType(),
        orderType: orderType.toOrderType(),
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
    SortConfig sortConfig = const SortConfig(),
  }) async {
    try {
      final queriedSongs = await _songsDatasource.querySongsFrom(
        audiosFromType: fromType.toAudioFromType(),
        where: where,
        sortType: sortConfig.sortType.toSongSortType(),
        orderType: sortConfig.orderType.toOrderType(),
      );
      return Result.success(
        queriedSongs.map(SongModelMapper.toDomain).toList(),
      );
    } on Exception catch (e) {
      return Result.failure('Failed to load songs from $fromType: $e');
    }
  }

  @override
  Result<SortConfig> getSongsSortConfig() {
    try {
      final sortType = _songsDatasource.getSongSortType();
      final orderType = _songsDatasource.getSongOrderType();
      return Result.success(
        SortConfig(
          sortType: SongSortTypeMapper.toSongsSortType(sortType),
          orderType: OrderTypeMapper.toSortOrderType(orderType),
        ),
      );
    } on Exception catch (e) {
      return Result.failure('Failed to get songs sort config: $e');
    }
  }

  @override
  Future<Result<bool>> saveSortConfig({
    required SortConfig sortConfig,
  }) async {
    try {
      final sortTypeSaved = await _songsDatasource.saveSongSortType(
        sortType: sortConfig.sortType.toSongSortType(),
      );
      final orderTypeSaved = await _songsDatasource.saveSongOrderType(
        orderType: sortConfig.orderType.toOrderType(),
      );
      return Result.success(sortTypeSaved && orderTypeSaved);
    } on Exception catch (e) {
      return Result.failure('Failed to save songs sort config: $e');
    }
  }
}
