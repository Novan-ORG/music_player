import 'package:music_player/core/data/mappers/song_model_mapper.dart';
import 'package:music_player/core/domain/entities/song.dart';
import 'package:music_player/core/result.dart';
import 'package:music_player/features/songs/data/datasources/datasources.dart';
import 'package:music_player/features/songs/data/mappers/mappers.dart';
import 'package:music_player/features/songs/domain/domain.dart';
import 'package:music_player/features/songs/domain/enums/enums.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';
import 'package:path/path.dart' as p;

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
  Future<Result<List<Folder>>> queryFolders() async {
    try {
      final queriedSongs = await _songsDatasource.querySongs(
        sortType: SongSortType.TITLE,
        orderType: OrderType.ASC_OR_SMALLER,
      );
      final foldersByPath = <String, Folder>{};

      for (final songModel in queriedSongs) {
        final song = SongModelMapper.toDomain(songModel);
        final folderPath = _extractFolderPath(song.data);
        if (folderPath == null) {
          continue;
        }

        final existingFolder = foldersByPath[folderPath];
        foldersByPath[folderPath] = Folder(
          name: _extractFolderName(folderPath),
          path: folderPath,
          songCount: (existingFolder?.songCount ?? 0) + 1,
        );
      }

      final folders = foldersByPath.values.toList()
        ..sort(
          (left, right) {
            final nameCompare = left.name.toLowerCase().compareTo(
              right.name.toLowerCase(),
            );
            if (nameCompare != 0) {
              return nameCompare;
            }
            return left.path.toLowerCase().compareTo(right.path.toLowerCase());
          },
        );
      return Result.success(folders);
    } on Exception catch (e) {
      return Result.failure('Failed to load folders: $e');
    }
  }

  @override
  Future<Result<List<Song>>> querySongsFrom({
    required SongsFromType fromType,
    required Object where,
    SortConfig sortConfig = const SortConfig(),
  }) async {
    try {
      if (fromType == SongsFromType.folderPath) {
        final queriedSongs = await _songsDatasource.querySongs(
          sortType: sortConfig.sortType.toSongSortType(),
          orderType: sortConfig.orderType.toOrderType(),
        );
        final normalizedFolderPath = p.normalize(where as String);
        final songs = queriedSongs
            .map(SongModelMapper.toDomain)
            .where(
              (song) => _extractFolderPath(song.data) == normalizedFolderPath,
            )
            .toList();
        return Result.success(songs);
      }

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

  String? _extractFolderPath(String songPath) {
    if (songPath.trim().isEmpty) {
      return null;
    }

    final normalizedSongPath = p.normalize(songPath);
    final folderPath = p.dirname(normalizedSongPath);
    if (folderPath.isEmpty ||
        folderPath == '.' ||
        folderPath == normalizedSongPath) {
      return null;
    }
    return folderPath;
  }

  String _extractFolderName(String folderPath) {
    final normalizedFolderPath = p.normalize(folderPath);
    final folderName = p.basename(normalizedFolderPath);
    return folderName.isEmpty ? normalizedFolderPath : folderName;
  }
}
