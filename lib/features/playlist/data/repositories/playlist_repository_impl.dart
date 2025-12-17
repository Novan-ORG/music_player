import 'package:music_player/core/data/mappers/mappers.dart';
import 'package:music_player/core/domain/entities/song.dart';
import 'package:music_player/core/result.dart';
import 'package:music_player/features/playlist/data/data.dart';
import 'package:music_player/features/playlist/data/models/pin_playlist_model.dart';
import 'package:music_player/features/playlist/domain/domain.dart';

/// Implementation of [PlaylistRepository] using local datasource.
///
/// Handles playlist CRUD operations, song management within playlists,
/// cover image management, and playlist pinning functionality.
class PlaylistRepositoryImpl implements PlaylistRepository {
  /// Creates a [PlaylistRepositoryImpl] with the given datasource.
  const PlaylistRepositoryImpl(this.datasource);

  final PlaylistDatasource datasource;

  @override
  Future<Result<List<Playlist>>> getAllPlaylists() async {
    try {
      final playlists = await datasource.getAllPlaylists();
      return Result.success(
        playlists.map(PlaylistMapper.fromModel).toList(),
      );
    } on Exception catch (e) {
      return Result.failure('Failed to get all playlists: $e');
    }
  }

  @override
  Future<Result<Playlist>> getPlaylistById(int id) async {
    try {
      final playlist = await datasource.getPlaylistById(id);
      if (playlist == null) {
        return Result.failure('Playlist not found');
      } else {
        return Result.success(PlaylistMapper.fromModel(playlist));
      }
    } on Exception catch (e) {
      return Result.failure('Failed to get playlist by id: $e');
    }
  }

  @override
  Future<Result<bool>> createPlaylist(String name) async {
    try {
      final result = await datasource.createPlaylist(name);
      return Result.success(result);
    } on Exception catch (e) {
      return Result.failure('Failed to save playlist: $e');
    }
  }

  @override
  Future<Result<bool>> deletePlaylist(int id) async {
    try {
      final result = await datasource.deletePlaylist(id);
      return Result.success(result);
    } on Exception catch (e) {
      return Result.failure('Failed to delete playlist: $e');
    }
  }

  @override
  Future<Result<List<Song>>> getPlaylistSongs(int playlistId) async {
    try {
      final songModels = await datasource.getPlaylistSongs(playlistId);
      final songs = songModels.map(SongModelMapper.toDomain).toList();

      return Result.success(songs);
    } on Exception catch (e) {
      return Result.failure('Failed to get playlist songs: $e');
    }
  }

  @override
  Future<Result<void>> addSongsToPlaylist(
    int playlistId,
    List<int> songIds,
  ) async {
    try {
      await datasource.addSongsToPlaylist(playlistId, songIds);

      // auto-update playlist cover with the latest song
      if (songIds.isNotEmpty) {
        final latestSongId = songIds.last;
        await datasource.setPlaylistCoverSongId(playlistId, latestSongId);
      }

      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure('Failed to add songs to playlist: $e');
    }
  }

  @override
  Future<Result<void>> removeSongsFromPlaylist(
    int playlistId,
    List<int> songIds,
  ) async {
    try {
      await datasource.removeSongsFromPlaylist(playlistId, songIds);
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure('Failed to remove songs from playlist: $e');
    }
  }

  @override
  Future<Result<bool>> renamePlaylist(int id, String newName) async {
    try {
      final result = await datasource.renamePlaylist(id, newName);
      return Result.success(result);
    } on Exception catch (e) {
      return Result.failure('Failed to rename playlist: $e');
    }
  }

  @override
  Future<Result<int?>> getPlaylistCoverSongId(int playlistId) async {
    try {
      final songId = await datasource.getPlaylistCoverSongId(playlistId);
      return Result.success(songId);
    } on Exception catch (e) {
      return Result.failure('Failed to get playlist cover song ID: $e');
    }
  }

  @override
  Future<Result<void>> initializePlaylistCoversForExistingPlaylists() async {
    try {
      await datasource.initializePlaylistCoversForExistingPlaylists();
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure('Failed to initialize playlist covers: $e');
    }
  }

  @override
  Future<Result<List<PinPlaylist>>> getPinnedPlaylists() async {
    try {
      final models = await datasource.getPinnedPlaylists();

      return Result.success(models.cast<PinPlaylist>().toList());
    } on Exception catch (e) {
      return Result.failure('Failed to get pinned playlist: $e');
    }
  }

  @override
  Future<Result<void>> savePinnedPlaylists(
    List<PinPlaylist> pinnedPlaylists,
  ) async {
    try {
      final models = pinnedPlaylists.map(PinPlaylistModel.fromEntity).toList();

      await datasource.savePinnedPlaylists(models);
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure('Failed to save as pinned playlist: $e');
    }
  }
}
