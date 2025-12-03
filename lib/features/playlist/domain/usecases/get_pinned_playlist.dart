import 'package:music_player/core/result.dart';
import 'package:music_player/features/playlist/domain/repositories/playlist_repository.dart';

class GetPinnedPlaylists {
  const GetPinnedPlaylists(this.repository);

  final PlaylistRepository repository;

  Future<Result<Set<int>>> call() async {
    final result = await repository.getPinnedPlaylists();

    if (result.isSuccess) {
      final pinnedIds = result.value;
      return Result.success(pinnedIds?.map(int.parse).toSet());
    } else {
      return Result.failure(result.error);
    }
  }
}
