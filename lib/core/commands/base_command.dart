import 'package:music_player/core/result.dart';

/// Base interface for implementing the Command pattern with undo support.
///
/// This interface defines the contract for commands that can be executed
/// and undone, enabling undo/redo functionality throughout the application.
///
/// Commands are used for operations that modify state and need to be
/// reversible, such as deleting songs or playlists.
///
/// **Example Implementation:**
/// ```dart
/// class DeleteSongCommand implements BaseCommand<bool> {
///   DeleteSongCommand({required this.song, required this.repository});
///
///   final Song song;
///   final SongsRepository repository;
///
///   @override
///   String get description => 'Delete song: ${song.title}';
///
///   @override
///   Future<Result<bool>> execute() async {
///     // Perform deletion and backup for undo
///     return repository.deleteSong(songUri: song.data);
///   }
///
///   @override
///   Future<Result<void>> undo() async {
///     // Restore from backup
///     return repository.restoreSong(song);
///   }
/// }
/// ```
abstract interface class BaseCommand<T> {
  /// Executes the command and returns the result.
  ///
  /// This method performs the main action of the command. If successful,
  /// the command will be added to the history for potential undo.
  ///
  /// Returns a [Result] containing the operation result or an error.
  Future<Result<T>> execute();

  /// Undoes the command, reverting its effects.
  ///
  /// This method should restore the state to what it was before [execute]
  /// was called. It should only be called after a successful execution.
  ///
  /// Returns a [Result] indicating success or failure of the undo operation.
  Future<Result<void>> undo();

  /// A human-readable description of what this command does.
  ///
  /// This description is useful for debugging and logging purposes.
  /// Example: "Delete song: My Favorite Song"
  String get description;
}
