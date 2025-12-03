import 'dart:convert';

import 'package:music_player/core/constants/preferences_keys.dart';
import 'package:music_player/core/services/logger/logger.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PlaylistDatasource {
  Future<List<PlaylistModel>> getAllPlaylists();
  Future<PlaylistModel?> getPlaylistById(int id);
  Future<bool> createPlaylist(String name);
  Future<bool> deletePlaylist(int id);
  Future<List<SongModel>> getPlaylistSongs(int playlistId);
  Future<void> addSongsToPlaylist(int playlistId, List<int> songIds);
  Future<void> removeSongsFromPlaylist(int playlistId, List<int> songIds);
  Future<bool> renamePlaylist(int id, String newName);

  Future<int?> getLatestSongIdFromPlaylist(int playlistId);
  Future<int?> getPlaylistCoverSongId(int playlistId);
  Future<void> setPlaylistCoverSongId(int playlistId, int songId);
  Future<void> updatePlaylistCoverFromLatestSong(int playlistId);

  Future<void> savePinnedPlaylists(List<String> pinnedPlaylistIds);
  Future<List<String>> getPinnedPlaylists();
}

class PlaylistDatasourceImpl implements PlaylistDatasource {
  const PlaylistDatasourceImpl(
    this.audioQuery,
    this.preferences,
  );

  final OnAudioQuery audioQuery;
  final SharedPreferences preferences;

  @override
  Future<List<PlaylistModel>> getAllPlaylists() {
    return audioQuery.queryPlaylists();
  }

  @override
  Future<PlaylistModel?> getPlaylistById(int id) async {
    final playlists = await audioQuery.queryPlaylists();
    return playlists.firstWhere(
      (playlist) => playlist.id == id,
    );
  }

  @override
  Future<bool> createPlaylist(String name) {
    return audioQuery.createPlaylist(name);
  }

  @override
  Future<bool> deletePlaylist(int id) {
    return audioQuery.removePlaylist(id);
  }

  @override
  Future<List<SongModel>> getPlaylistSongs(int playlistId) =>
      audioQuery.queryAudiosFrom(
        AudiosFromType.PLAYLIST,
        playlistId,
      );

  @override
  Future<void> addSongsToPlaylist(int playlistId, List<int> songIds) async {
    for (var i = 0; i < songIds.length; i++) {
      final result = await audioQuery.addToPlaylist(playlistId, songIds[i]);
      Logger.info(
        'Adding song with ID ${songIds[i]} to playlist $playlistId: $result',
      );
    }
  }

  @override
  Future<void> removeSongsFromPlaylist(
    int playlistId,
    List<int> songIds,
  ) async {
    for (var i = 0; i < songIds.length; i++) {
      final result = await audioQuery.removeFromPlaylist(
        playlistId,
        songIds[i],
      );
      Logger.info(
        'Removed song with ID ${songIds[i]} from playlist $playlistId: $result',
      );
    }
  }

  @override
  Future<bool> renamePlaylist(int id, String newName) {
    return audioQuery.renamePlaylist(id, newName);
  }

  @override
  Future<int?> getLatestSongIdFromPlaylist(int playlistId) async {
    final songs = await getPlaylistSongs(playlistId);
    if (songs.isEmpty) {
      return null;
    }
    // get latest song id
    final latestSong = songs.last;
    return latestSong.id;
  }

  @override
  Future<int?> getPlaylistCoverSongId(int playlistId) async {
    final coverMapJson = preferences.getString(
      PreferencesKeys.playlistCoverSongsId,
    );
    if (coverMapJson == null) {
      return null;
    }

    final coverMap = Map<String, dynamic>.from(jsonDecode(coverMapJson) as Map);
    final songId = coverMap[playlistId.toString()];
    return songId != null ? (songId as num).toInt() : null;
  }

  @override
  Future<void> setPlaylistCoverSongId(int playlistId, int songId) async {
    final coverMapJson = preferences.getString(
      PreferencesKeys.playlistCoverSongsId,
    );
    final coverMap = coverMapJson != null
        ? Map<String, dynamic>.from(jsonDecode(coverMapJson) as Map)
        : <String, dynamic>{};

    coverMap[playlistId.toString()] = songId;

    await preferences.setString(
      PreferencesKeys.playlistCoverSongsId,
      jsonEncode(coverMap),
    );
  }

  @override
  Future<void> updatePlaylistCoverFromLatestSong(int playlistId) async {
    final latestSongId = await getLatestSongIdFromPlaylist(playlistId);
    if (latestSongId != null) {
      await setPlaylistCoverSongId(playlistId, latestSongId);
    }
  }

  @override
  Future<List<String>> getPinnedPlaylists() async {
    final prefs = await SharedPreferences.getInstance();

    final list = prefs.getStringList(PreferencesKeys.pinnedPlaylists) ?? [];

    return list;
  }

  @override
  Future<void> savePinnedPlaylists(List<String> pinnedPlaylistIds) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setStringList(
      PreferencesKeys.pinnedPlaylists,
      pinnedPlaylistIds,
    );
  }
}
