import 'package:music_player/core/domain/entities/song.dart';
import 'package:music_player/core/result.dart';
import 'package:music_player/features/playlist/domain/entities/entities.dart';

abstract class PlaylistRepository {
  Future<Result<List<Playlist>>> getAllPlaylists();
  Future<Result<Playlist>> getPlaylistById(int id);
  Future<Result<bool>> createPlaylist(String name);
  Future<Result<bool>> renamePlaylist(int id, String newName);
  Future<Result<bool>> deletePlaylist(int id);
  Future<Result<List<Song>>> getPlaylistSongs(int playlistId);
  Future<Result<void>> addSongsToPlaylist(int playlistId, List<int> songIds);
  Future<Result<void>> removeSongsFromPlaylist(
    int playlistId,
    List<int> songIds,
  );

  Future<Result<int?>> getPlaylistCoverSongId(int playlistId);
  Future<Result<void>> initializePlaylistCoversForExistingPlaylists();

  Future<Result<void>> savePinnedPlaylists(List<PinPlaylist> pinnedPlaylists);
  Future<Result<List<PinPlaylist>>> getPinnedPlaylists();
}
