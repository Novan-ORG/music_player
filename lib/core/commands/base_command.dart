import 'package:music_player/core/result.dart';

abstract interface class BaseCommand<T> {
  Future<Result<T>> execute();
  Future<Result<void>> undo();
  String get description;
}
