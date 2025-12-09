import 'package:music_player/core/result.dart';
import 'package:music_player/features/playlist/domain/entities/pin_playlist.dart';
import 'package:music_player/features/playlist/domain/repositories/playlist_repository.dart';

class PinPlaylistById {
  const PinPlaylistById(this.repository);

  final PlaylistRepository repository;

  Future<Result<List<PinPlaylist>>> call(
    List<PinPlaylist> currentPinned,
    int playlistId,
  ) async {
    final pinned = [...currentPinned];

    final existingIndex = pinned.indexWhere((p) => p.playlistId == playlistId);

    if (existingIndex >= 0) {
      // unpin
      pinned.removeAt(existingIndex);
    } else {
      final nextOrder = pinned.isEmpty
          ? 0
          : pinned.map((e) => e.order).reduce((a, b) => a > b ? a : b) + 1;

      pinned.add(
        PinPlaylist(
          playlistId: playlistId,
          order: nextOrder,
        ),
      );
    }

    final saveResult = await repository.savePinnedPlaylists(pinned);

    if (!saveResult.isSuccess) {
      return Result.failure(saveResult.error);
    }

    final reloadResult = await repository.getPinnedPlaylists();

    if (reloadResult.isSuccess) {
      return Result.success(reloadResult.value);
    } else {
      return Result.failure(reloadResult.error);
    }
  }
}
