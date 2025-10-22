import 'package:music_player/core/commands/base_command.dart';
import 'package:music_player/core/result.dart';
import 'package:music_player/core/services/services.dart';

class DeletePlaylistCommand implements BaseCommand<bool> {
  DeletePlaylistCommand({
    required this.playlistId,
    required this.objectBox,
  });

  final int playlistId;
  final ObjectBox objectBox;
  PlaylistModel? _backupPlaylist;
  bool _wasDeleted = false;

  @override
  String get description =>
      'Delete playlist: ${_backupPlaylist?.name ?? playlistId.toString()}';

  @override
  Future<Result<bool>> execute() async {
    try {
      final playlistBox = objectBox.store.box<PlaylistModel>();

      // Create backup before deletion
      _backupPlaylist = playlistBox.get(playlistId);
      if (_backupPlaylist == null) {
        return Result.failure('Playlist not found');
      }

      // Proceed with deletion
      final deleted = playlistBox.remove(playlistId);
      if (deleted) {
        _wasDeleted = true;
        return Result.success(true);
      } else {
        return Result.failure('Failed to delete playlist from database');
      }
    } on Exception catch (e) {
      return Result.failure('Failed to execute delete playlist command: $e');
    }
  }

  @override
  Future<Result<void>> undo() async {
    try {
      if (!_wasDeleted || _backupPlaylist == null) {
        return Result.failure(
          'Cannot undo: playlist was not deleted or backup not found',
        );
      }

      // Restore playlist from backup
      objectBox.store.box<PlaylistModel>().put(_backupPlaylist!);

      // Reset state
      _backupPlaylist = null;
      _wasDeleted = false;

      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure('Failed to undo delete playlist command: $e');
    }
  }
}
