import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:music_player/core/commands/base_command.dart';
import 'package:music_player/core/result.dart';

class CommandManager {
  CommandManager({this.maxHistorySize = 10});

  final int maxHistorySize;
  final _history = Queue<BaseCommand<dynamic>>();
  final ValueNotifier<bool> _canUndoNotifier = ValueNotifier<bool>(false);

  ValueListenable<bool> get canUndoNotifier => _canUndoNotifier;
  bool get canUndo => _history.isNotEmpty;

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

  Future<Result<void>> undo() async {
    if (_history.isEmpty) {
      return Result.failure('No commands to undo');
    }

    final command = _history.removeLast();
    final result = await command.undo();

    _updateCanUndoState();
    return result;
  }

  void clearHistory() {
    _history.clear();
    _updateCanUndoState();
  }

  void _updateCanUndoState() {
    _canUndoNotifier.value = _history.isNotEmpty;
  }

  void dispose() {
    _canUndoNotifier.dispose();
  }
}
