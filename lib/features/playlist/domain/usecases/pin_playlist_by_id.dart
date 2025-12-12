import 'package:music_player/core/result.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/playlist/domain/entities/pin_playlist.dart';
import 'package:music_player/features/playlist/domain/repositories/playlist_repository.dart';

class PinPlaylistById {
  const PinPlaylistById(this.repository);

  final PlaylistRepository repository;

  Future<Result<List<PinPlaylist>>> call(
    List<PinPlaylist> currentPinned,
    int playlistId,
  ) async {
    final index = currentPinned.indexWhere(
      (p) => p.playlistId == playlistId,
    );

    if (index >= 0) {
      // unpin
      currentPinned.removeAt(index);
    } else {
      // pin
      final nextOrder = currentPinned.isEmpty
          ? 0
          : currentPinned.map((e) => e.order).reduce((a, b) => a > b ? a : b) +
                1; // max order + 1

      currentPinned.add(
        PinPlaylist(
          playlistId: playlistId,
          order: nextOrder,
        ),
      );
    }
    final updated = currentPinned.ordered();

    final saveResult = await repository.savePinnedPlaylists(updated);

    if (saveResult.isFailure) {
      return Result.failure(saveResult.error);
    } else {
      return Result.success(updated);
    }
  }
}
