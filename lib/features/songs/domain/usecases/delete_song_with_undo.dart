import 'package:music_player/core/commands/commands.dart';
import 'package:music_player/core/domain/entities/song.dart';
import 'package:music_player/core/result.dart';
import 'package:music_player/features/songs/domain/repositories/repositories.dart';

class DeleteSongWithUndo {
  const DeleteSongWithUndo(this._repository, this._commandManager);

  final SongsRepository _repository;
  final CommandManager _commandManager;

  Future<Result<bool>> call({required Song song}) {
    final command = DeleteSongCommand(
      song: song,
      repository: _repository,
    );
    return _commandManager.execute(command);
  }

  Future<Result<void>> undo() {
    return _commandManager.undo();
  }

  bool get canUndo => _commandManager.canUndo;
}
