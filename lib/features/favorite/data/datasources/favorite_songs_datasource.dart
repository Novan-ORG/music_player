import 'dart:convert';

import 'package:music_player/core/constants/constants.dart';
import 'package:music_player/features/favorite/data/models/models.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Abstract datasource for favorite songs management.
///
/// Stores favorite songs data in local storage and provides
/// methods to manage the favorites list.
abstract interface class FavoriteSongsDatasource {
  Future<List<SongModel>> getFavoriteSongs();
  Future<void> addFavoriteSong(int songId);
  Future<void> removeFavoriteSong(int songId);
  bool isFavorite(int songId);
  void clearAllFavorites();
}

class FavoriteSongsDatasourceImpl implements FavoriteSongsDatasource {
  FavoriteSongsDatasourceImpl({
    required this.preferences,
    required this.audioQuery,
  });

  final SharedPreferences preferences;
  final OnAudioQuery audioQuery;

  @override
  Future<List<SongModel>> getFavoriteSongs() async {
    final favorites = _getAllFavorites();
    final songIds = favorites.map((fav) => fav.songId).toList();
    final queryResult = await audioQuery.querySongs();
    queryResult.retainWhere((song) => songIds.contains(song.id));
    return queryResult;
  }

  List<FavoriteSongModel> _getAllFavorites() {
    final jsonList =
        preferences.getStringList(PreferencesKeys.favoriteSongs) ?? [];
    return jsonList.map((jsonString) {
      final json = Map<String, dynamic>.from(
        jsonDecode(jsonString) as Map,
      );
      return FavoriteSongModel.fromJson(json);
    }).toList();
  }

  @override
  Future<void> addFavoriteSong(int songId) async {
    final favorites = _getAllFavorites();
    // Check if already exists
    if (favorites.any((fav) => fav.songId == songId)) {
      return;
    }

    final newFavorite = FavoriteSongModel(
      id: DateTime.now().millisecondsSinceEpoch,
      songId: songId,
      dateAdded: DateTime.now(),
    );

    favorites.add(newFavorite);
    await _saveFavorites(favorites);
  }

  @override
  Future<void> removeFavoriteSong(int songId) async {
    final favorites = _getAllFavorites()
      ..removeWhere((fav) => fav.songId == songId);
    await _saveFavorites(favorites);
  }

  @override
  bool isFavorite(int songId) {
    final favorites = _getAllFavorites();
    return favorites.any((fav) => fav.songId == songId);
  }

  @override
  Future<void> clearAllFavorites() async {
    await preferences.remove(PreferencesKeys.favoriteSongs);
  }

  Future<void> _saveFavorites(List<FavoriteSongModel> favorites) async {
    final jsonList = favorites.map((fav) => jsonEncode(fav.toJson())).toList();
    await preferences.setStringList(PreferencesKeys.favoriteSongs, jsonList);
  }
}
