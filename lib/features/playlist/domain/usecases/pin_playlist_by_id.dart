import 'package:music_player/core/result.dart';
import 'package:music_player/features/playlist/domain/repositories/playlist_repository.dart';

class PinPlaylistById {
  const PinPlaylistById(this.repository);

  final PlaylistRepository repository;

  Future<Result<Set<int>>> call(Set<int> currentPinned, int playlistId) async {
    if (currentPinned.contains(playlistId)) {
      currentPinned.remove(playlistId);
    } else {
      currentPinned.add(playlistId);
    }

    final result = await repository.savePinnedPlaylists(
      currentPinned.map((id) => id.toString()).toList(),
    );

    if (result.isSuccess) {
      return Result.success(currentPinned);
    } else {
      return Result.failure(result.error);
    }
  }
}
