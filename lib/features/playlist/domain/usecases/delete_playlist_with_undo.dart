import 'package:music_player/core/commands/commands.dart';
import 'package:music_player/core/result.dart';
import 'package:music_player/features/playlist/domain/domain.dart';

/// Use case for deleting playlists with undo support.
///
/// Wraps playlist deletion in a command that can be undone,
/// allowing users to recover accidentally deleted playlists.
class DeletePlaylistWithUndo {
  /// Creates a [DeletePlaylistWithUndo] use case.
  const DeletePlaylistWithUndo(this._repository, this._commandManager);

  final PlaylistRepository _repository;
  final CommandManager _commandManager;

  /// Deletes a playlist with undo support.
  ///
  /// Parameters:
  /// - [playlistId]: ID of the playlist to delete
  ///
  /// Returns a [Result] containing `true` if successful, or an error.
  Future<Result<bool>> call({required int playlistId}) {
    final command = DeletePlaylistCommand(
      playlistId: playlistId,
      playlistRepository: _repository,
    );
    return _commandManager.execute(command);
  }

  /// Undoes the last playlist deletion.
  ///
  /// Returns a [Result] indicating success or failure.
  Future<Result<void>> undo() {
    return _commandManager.undo();
  }

  /// Whether there are any deletions that can be undone.
  bool get canUndo => _commandManager.canUndo;
}
