import 'package:music_player/core/result.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/playlist/domain/entities/pin_playlist.dart';
import 'package:music_player/features/playlist/domain/repositories/playlist_repository.dart';

class GetPinnedPlaylists {
  const GetPinnedPlaylists(this.repository);

  final PlaylistRepository repository;

  Future<Result<List<PinPlaylist>>> call() async {
    final result = await repository.getPinnedPlaylists();

    if (result.isSuccess) {
      final updated = result.value!.ordered();

      return Result.success(updated);
    } else {
      return Result.failure(result.error);
    }
  }
}
