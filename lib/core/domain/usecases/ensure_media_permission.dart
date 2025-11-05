import 'package:music_player/core/result.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';

class EnsureMediaPermission {
  EnsureMediaPermission(this._onAudioQuery);

  final OnAudioQuery _onAudioQuery;

  Future<Result<bool>> call() async {
    final granted = await _onAudioQuery.checkAndRequest();
    return granted
        ? Result.success(true)
        : Result.failure('Permission not granted');
  }
}
