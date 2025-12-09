import 'package:music_player/core/result.dart';
import 'package:music_player/features/playlist/domain/entities/pin_playlist.dart';
import 'package:music_player/features/playlist/domain/repositories/playlist_repository.dart';

class GetPinnedPlaylists {
  const GetPinnedPlaylists(this.repository);

  final PlaylistRepository repository;

  Future<Result<List<PinPlaylist>>> call() async {
    final result = await repository.getPinnedPlaylists();

    if (result.isSuccess) {
      final list = [...?result.value];

      return Result.success(list);
    } else {
      return Result.failure(result.error);
    }
  }
}
