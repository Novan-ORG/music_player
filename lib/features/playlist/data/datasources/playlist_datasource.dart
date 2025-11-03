import 'package:music_player/core/services/logger/logger.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';

abstract class PlaylistDatasource {
  Future<List<PlaylistModel>> getAllPlaylists();
  Future<PlaylistModel?> getPlaylistById(int id);
  Future<bool> createPlaylist(String name);
  Future<bool> deletePlaylist(int id);
  Future<List<SongModel>> getPlaylistSongs(int playlistId);
  Future<void> addSongsToPlaylist(int playlistId, List<int> songIds);
  Future<void> removeSongsFromPlaylist(int playlistId, List<int> songIds);
  Future<bool> renamePlaylist(int id, String newName);
}

class PlaylistDatasourceImpl implements PlaylistDatasource {
  const PlaylistDatasourceImpl(this.audioQuery);

  final OnAudioQuery audioQuery;

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
      await audioQuery.removeFromPlaylist(playlistId, songIds[i]);
    }
  }

  @override
  Future<bool> renamePlaylist(int id, String newName) {
    return audioQuery.renamePlaylist(id, newName);
  }
}
