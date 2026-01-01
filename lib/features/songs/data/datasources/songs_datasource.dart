import 'dart:io';
import 'package:music_player/core/constants/constants.dart';
import 'package:music_player/features/songs/data/mappers/mappers.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Abstract datasource for song queries from the device media store.
///
/// Implements:
/// - Device audio file queries
/// - File deletion
/// - Permission handling
/// - Sort preference persistence
abstract interface class SongsDatasource {
  Future<List<SongModel>> querySongs({
    SongSortType sortType = SongSortType.DATE_ADDED,
    OrderType orderType = OrderType.DESC_OR_GREATER,
  });
  Future<List<AlbumModel>> queryAlbums({
    AlbumSortType sortType = AlbumSortType.NUM_OF_SONGS,
    OrderType orderType = OrderType.DESC_OR_GREATER,
  });
  Future<List<ArtistModel>> queryArtists({
    ArtistSortType sortType = ArtistSortType.NUM_OF_TRACKS,
    OrderType orderType = OrderType.DESC_OR_GREATER,
  });
  Future<List<SongModel>> querySongsFrom({
    required AudiosFromType audiosFromType,
    required Object where,
    SongSortType sortType = SongSortType.DATE_ADDED,
    OrderType orderType = OrderType.DESC_OR_GREATER,
  });
  Future<bool> deleteSong(String songUri);
  Future<bool> saveSongSortType({required SongSortType sortType});
  Future<bool> saveSongOrderType({required OrderType orderType});
  SongSortType getSongSortType();
  OrderType getSongOrderType();
}

class SongsDatasourceImpl implements SongsDatasource {
  const SongsDatasourceImpl({
    required OnAudioQuery onAudioQuery,
    required SharedPreferences preferences,
  }) : _onAudioQuery = onAudioQuery,
       _preferences = preferences;

  final OnAudioQuery _onAudioQuery;
  final SharedPreferences _preferences;

  @override
  Future<bool> deleteSong(String songUri) async {
    final file = File(songUri);
    if (file.existsSync()) {
      if (await Permission.manageExternalStorage.isGranted) {
        await file.delete();
        return true;
      } else {
        final isGranted = await Permission.manageExternalStorage.request();
        if (isGranted == PermissionStatus.granted ||
            isGranted == PermissionStatus.limited) {
          await file.delete();
          return true;
        } else {
          return false;
        }
      }
    } else {
      throw FileSystemException('File not exist in the system', file.path);
    }
  }

  @override
  Future<List<SongModel>> querySongs({
    SongSortType sortType = SongSortType.DATE_ADDED,
    OrderType orderType = OrderType.DESC_OR_GREATER,
  }) => _onAudioQuery.querySongs(
    sortType: sortType,
    orderType: orderType,
  );

  @override
  Future<List<AlbumModel>> queryAlbums({
    AlbumSortType sortType = AlbumSortType.NUM_OF_SONGS,
    OrderType orderType = OrderType.DESC_OR_GREATER,
  }) => _onAudioQuery.queryAlbums(
    sortType: sortType,
    orderType: orderType,
  );

  @override
  Future<List<ArtistModel>> queryArtists({
    ArtistSortType sortType = ArtistSortType.NUM_OF_TRACKS,
    OrderType orderType = OrderType.DESC_OR_GREATER,
  }) => _onAudioQuery.queryArtists(
    sortType: sortType,
    orderType: orderType,
  );

  @override
  Future<List<SongModel>> querySongsFrom({
    required AudiosFromType audiosFromType,
    required Object where,
    SongSortType sortType = SongSortType.DATE_ADDED,
    OrderType orderType = OrderType.DESC_OR_GREATER,
  }) {
    return _onAudioQuery.queryAudiosFrom(
      audiosFromType,
      where,
      sortType: sortType,
      orderType: orderType,
    );
  }

  @override
  SongSortType getSongSortType() {
    // the index 4 is for the DATE_ADDED
    final index = _preferences.getInt(PreferencesKeys.songSortType) ?? 4;
    return SongSortTypeMapper.fromIndex(index);
  }

  @override
  OrderType getSongOrderType() {
    // the index 1 is for the DESC_OR_GREATER
    final index = _preferences.getInt(PreferencesKeys.songOrderType) ?? 1;
    return OrderTypeMapper.fromIndex(index);
  }

  @override
  Future<bool> saveSongSortType({required SongSortType sortType}) {
    return _preferences.setInt(PreferencesKeys.songSortType, sortType.index);
  }

  @override
  Future<bool> saveSongOrderType({required OrderType orderType}) {
    return _preferences.setInt(PreferencesKeys.songOrderType, orderType.index);
  }
}
