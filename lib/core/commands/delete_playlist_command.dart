import 'package:music_player/core/commands/base_command.dart';
import 'package:music_player/core/result.dart';
import 'package:music_player/features/playlist/domain/domain.dart';

/// Command to delete a playlist with undo functionality.
///
/// This command creates a backup of the playlist and its songs before deletion,
/// allowing for restoration if the undo operation is called.
class DeletePlaylistCommand implements BaseCommand<bool> {
  DeletePlaylistCommand({
    required this.playlistId,
    required this.playlistRepository,
  });

  final int playlistId;
  final PlaylistRepository playlistRepository;

  // Backup data for undo functionality
  Playlist? _playlistBackup;
  late List<int> _songIdsBackup;
  bool _wasExecuted = false;

  @override
  String get description =>
      'Delete playlist: ${_playlistBackup?.name ?? playlistId.toString()}';

  @override
  Future<Result<bool>> execute() async {
    try {
      // First, create backup of the playlist
      final backupResult = await _createBackup();
      if (backupResult.isFailure) {
        return Result.failure(backupResult.error);
      }

      // Proceed with deletion
      final deleteResult = await playlistRepository.deletePlaylist(playlistId);
      if (deleteResult.isFailure) {
        return Result.failure(deleteResult.error);
      }

      if (deleteResult.value ?? false) {
        _wasExecuted = true;
        return Result.success(true);
      } else {
        return Result.failure('Failed to delete playlist');
      }
    } on Exception catch (e) {
      return Result.failure('Failed to execute delete playlist command: $e');
    }
  }

  @override
  Future<Result<void>> undo() async {
    try {
      if (!_canUndo()) {
        return Result.failure(
          'Cannot undo: playlist was not deleted or backup not found',
        );
      }

      // Restore playlist from backup
      final restoreResult = await _restoreFromBackup();
      if (restoreResult.isFailure) {
        return Result.failure(restoreResult.error);
      }

      // Reset command state
      _resetState();

      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure('Failed to undo delete playlist command: $e');
    }
  }

  /// Creates backup of playlist and its songs before deletion.
  Future<Result<void>> _createBackup() async {
    // Backup playlist metadata
    final playlistResult = await playlistRepository.getPlaylistById(playlistId);
    if (playlistResult.isFailure) {
      return Result.failure(playlistResult.error);
    }

    _playlistBackup = playlistResult.value;
    if (_playlistBackup == null) {
      return Result.failure('Playlist not found');
    }

    // Backup playlist songs
    final songsResult = await playlistRepository.getPlaylistSongs(playlistId);
    if (songsResult.isFailure) {
      return Result.failure(songsResult.error);
    }

    _songIdsBackup = songsResult.value?.map((song) => song.id).toList() ?? [];

    return Result.success(null);
  }

  /// Restores playlist from backup data.
  Future<Result<void>> _restoreFromBackup() async {
    final createResult = await playlistRepository.createPlaylist(
      _playlistBackup!.name,
    );
    if (createResult.isFailure) {
      return Result.failure(createResult.error);
    }

    if (_songIdsBackup.isNotEmpty) {
      // get the new playlist id
      var newPlaylistId = playlistId;
      final allPlaylists = await playlistRepository.getAllPlaylists();
      if (allPlaylists.isSuccess) {
        // Notice that this is temporary and may not work correctly if multiple
        // playlists with the same name exist. A more robust solution would
        // require the repository to return the created playlist's ID directly.
        final newPlaylist = allPlaylists.value!.firstWhere(
          (playlist) => playlist.name == _playlistBackup!.name,
        );
        newPlaylistId = newPlaylist.id;
      }
      final addSongsResult = await playlistRepository.addSongsToPlaylist(
        newPlaylistId,
        _songIdsBackup,
      );
      if (addSongsResult.isFailure) {
        return Result.failure(addSongsResult.error);
      }
    }

    return Result.success(null);
  }

  /// Checks if the command can be undone.
  bool _canUndo() {
    return _wasExecuted && _playlistBackup != null;
  }

  /// Resets the command state after undo.
  void _resetState() {
    _playlistBackup = null;
    _songIdsBackup = [];
    _wasExecuted = false;
  }
}
