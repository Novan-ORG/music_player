import 'package:music_player/core/commands/commands.dart';
import 'package:music_player/core/result.dart';
import 'package:music_player/core/services/services.dart';

class DeletePlaylistWithUndo {
  const DeletePlaylistWithUndo(this._objectBox, this._commandManager);

  final ObjectBox _objectBox;
  final CommandManager _commandManager;

  Future<Result<bool>> call({required int playlistId}) {
    final command = DeletePlaylistCommand(
      playlistId: playlistId,
      objectBox: _objectBox,
    );
    return _commandManager.execute(command);
  }

  Future<Result<void>> undo() {
    return _commandManager.undo();
  }

  bool get canUndo => _commandManager.canUndo;
}
