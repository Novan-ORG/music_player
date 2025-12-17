import 'package:music_player/features/playlist/domain/entities/pin_playlist.dart';

extension PinnedPlaylistOrdering on List<PinPlaylist> {
  List<PinPlaylist> ordered() {
    final out = [...this]..sort((a, b) => b.order.compareTo(a.order));
    return out;
  }
}
