import 'dart:io';
import 'package:music_player/core/commands/base_command.dart';
import 'package:music_player/core/domain/entities/song.dart';
import 'package:music_player/core/result.dart';
import 'package:music_player/features/songs/domain/repositories/repositories.dart';

/// Command to delete a song file with undo capability.
///
/// Creates a backup of the original song file before deletion,
/// allowing for restoration if the undo operation is called.
/// The backup is stored in the system temporary directory.
class DeleteSongCommand implements BaseCommand<bool> {
  DeleteSongCommand({
    required this.song,
    required this.repository,
  });

  final Song song;
  final SongsRepository repository;
  File? _backupFile;
  bool _wasDeleted = false;

  @override
  String get description => 'Delete song: ${song.title}';

  @override
  Future<Result<bool>> execute() async {
    try {
      // Create backup before deletion
      final originalFile = File(song.data);
      if (!originalFile.existsSync()) {
        return Result.failure('Original file does not exist');
      }

      // Create backup in temporary directory
      final tempDir = Directory.systemTemp;
      final backupPath =
          '${tempDir.path}/backup_${song.id}_${DateTime.now().millisecondsSinceEpoch}.mp3';
      _backupFile = File(backupPath);

      await originalFile.copy(_backupFile!.path);

      // Proceed with deletion
      final result = await repository.deleteSong(songUri: song.data);
      if (result.isSuccess && (result.value ?? false)) {
        _wasDeleted = true;
        return Result.success(true);
      } else {
        // Cleanup backup if deletion failed
        if (_backupFile?.existsSync() ?? false) {
          await _backupFile!.delete();
        }
        return result;
      }
    } on Exception catch (e) {
      return Result.failure('Failed to execute delete command: $e');
    }
  }

  @override
  Future<Result<void>> undo() async {
    try {
      if (!_wasDeleted || _backupFile == null) {
        return Result.failure(
          'Cannot undo: song was not deleted or backup not found',
        );
      }

      if (!_backupFile!.existsSync()) {
        return Result.failure('Backup file not found, cannot restore');
      }

      // Restore file from backup
      final restoredFile = File(song.data);
      await _backupFile!.copy(restoredFile.path);

      // Clean up backup
      await _backupFile!.delete();
      _backupFile = null;
      _wasDeleted = false;

      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure('Failed to undo delete command: $e');
    }
  }
}
