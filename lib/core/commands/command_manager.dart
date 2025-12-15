import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:music_player/core/commands/base_command.dart';
import 'package:music_player/core/result.dart';

/// Manages command execution and history for undo/redo functionality.
///
/// This class implements the Command pattern with history management,
/// allowing commands to be executed and undone. It maintains a queue
/// of executed commands and notifies listeners when the undo state changes.
///
/// **Features:**
/// - Executes commands and tracks them in history
/// - Supports undo operations
/// - Limits history size to prevent memory issues
/// - Notifies listeners when undo availability changes
///
/// **Example:**
/// ```dart
/// final commandManager = CommandManager(maxHistorySize: 20);
///
/// // Execute a command
/// final command = DeleteSongCommand(song: mySong, repository: repo);
/// final result = await commandManager.execute(command);
///
/// // Undo the last command
/// if (commandManager.canUndo) {
///   await commandManager.undo();
/// }
///
/// // Listen to undo state changes
/// commandManager.canUndoNotifier.addListener(() {
///   print('Can undo: ${commandManager.canUndo}');
/// });
/// ```
class CommandManager {
  /// Creates a [CommandManager] with the specified history size limit.
  ///
  /// Parameters:
  /// - [maxHistorySize]: Maximum number of commands to keep in history.
  ///   Older commands are removed when this limit is exceeded.
  ///   Defaults to 10.
  CommandManager({this.maxHistorySize = 10});

  /// Maximum number of commands to keep in history.
  final int maxHistorySize;

  /// Queue of executed commands, maintained for undo operations.
  final _history = Queue<BaseCommand<dynamic>>();

  /// Notifier for undo availability state changes.
  final ValueNotifier<bool> _canUndoNotifier = ValueNotifier<bool>(false);

  /// Listenable for observing changes to undo availability.
  ///
  /// Listeners will be notified whenever commands are executed, undone,
  /// or the history is cleared.
  ValueListenable<bool> get canUndoNotifier => _canUndoNotifier;

  /// Whether there are any commands available to undo.
  ///
  /// Returns `true` if the history is not empty, `false` otherwise.
  bool get canUndo => _history.isNotEmpty;

  /// Executes a command and adds it to the history if successful.
  ///
  /// The command is only added to history if execution succeeds. If the
  /// history exceeds [maxHistorySize], the oldest command is removed.
  ///
  /// Parameters:
  /// - [command]: The command to execute
  ///
  /// Returns a [Result] containing the command's execution result.
  Future<Result<T>> execute<T>(BaseCommand<T> command) async {
    final result = await command.execute();

    if (result.isSuccess) {
      _history.addLast(command);

      // Limit history size
      while (_history.length > maxHistorySize) {
        _history.removeFirst();
      }

      _updateCanUndoState();
    }

    return result;
  }

  /// Undoes the most recently executed command.
  ///
  /// Removes the last command from history and calls its [undo] method.
  ///
  /// Returns a [Result] indicating success or failure. Returns a failure
  /// if there are no commands to undo.
  Future<Result<void>> undo() async {
    if (_history.isEmpty) {
      return Result.failure('No commands to undo');
    }

    final command = _history.removeLast();
    final result = await command.undo();

    _updateCanUndoState();
    return result;
  }

  /// Clears all commands from the history.
  ///
  /// This makes it impossible to undo any previous commands.
  /// Useful when starting a new session or after major state changes.
  void clearHistory() {
    _history.clear();
    _updateCanUndoState();
  }

  /// Updates the undo state notifier based on current history.
  void _updateCanUndoState() {
    _canUndoNotifier.value = _history.isNotEmpty;
  }

  /// Disposes of resources used by this manager.
  ///
  /// Should be called when the manager is no longer needed to prevent
  /// memory leaks from the notifier.
  void dispose() {
    _canUndoNotifier.dispose();
  }
}
