import 'package:music_player/features/playlist/domain/entities/pin_playlist.dart';

/// Extension on `List<PinPlaylist>` for sorting by pinned order.
///
/// Method: `ordered()` - Returns a new list sorted by descending order
extension PinnedPlaylistOrdering on List<PinPlaylist> {
  List<PinPlaylist> ordered() {
    final out = [...this]..sort((a, b) => b.order.compareTo(a.order));
    return out;
  }
}
