import 'package:music_player/core/commands/commands.dart';
import 'package:music_player/core/result.dart';
import 'package:music_player/features/playlist/domain/domain.dart';

class DeletePlaylistWithUndo {
  const DeletePlaylistWithUndo(this._repository, this._commandManager);

  final PlaylistRepository _repository;
  final CommandManager _commandManager;

  Future<Result<bool>> call({required int playlistId}) {
    final command = DeletePlaylistCommand(
      playlistId: playlistId,
      playlistRepository: _repository,
    );
    return _commandManager.execute(command);
  }

  Future<Result<void>> undo() {
    return _commandManager.undo();
  }

  bool get canUndo => _commandManager.canUndo;
}
