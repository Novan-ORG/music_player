import 'package:music_player/core/commands/commands.dart';
import 'package:music_player/core/domain/entities/song.dart';
import 'package:music_player/core/result.dart';
import 'package:music_player/features/songs/domain/repositories/repositories.dart';

/// Use case for deleting songs with undo support.
///
/// This use case wraps song deletion in a command that can be undone,
/// allowing users to recover accidentally deleted songs.
///
/// **Example:**
/// ```dart
/// // Delete a song
/// final result = await deleteSongWithUndo(song: mySong);
/// if (result.isSuccess) {
///   print('Song deleted');
///
///   // Undo the deletion
///   if (deleteSongWithUndo.canUndo) {
///     await deleteSongWithUndo.undo();
///   }
/// }
/// ```
class DeleteSongWithUndo {
  /// Creates a [DeleteSongWithUndo] use case.
  const DeleteSongWithUndo(this._repository, this._commandManager);

  final SongsRepository _repository;
  final CommandManager _commandManager;

  /// Deletes a song with undo support.
  ///
  /// The song file is backed up before deletion, allowing it to be
  /// restored via the [undo] method.
  ///
  /// Parameters:
  /// - [song]: The song to delete
  ///
  /// Returns a [Result] containing `true` if successful, or an error.
  Future<Result<bool>> call({required Song song}) {
    final command = DeleteSongCommand(
      song: song,
      repository: _repository,
    );
    return _commandManager.execute(command);
  }

  /// Undoes the last song deletion.
  ///
  /// Restores the most recently deleted song from backup.
  ///
  /// Returns a [Result] indicating success or failure.
  Future<Result<void>> undo() {
    return _commandManager.undo();
  }

  /// Whether there are any deletions that can be undone.
  bool get canUndo => _commandManager.canUndo;
}
