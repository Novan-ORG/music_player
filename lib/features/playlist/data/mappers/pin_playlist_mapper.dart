import 'package:music_player/features/playlist/domain/entities/pin_playlist.dart';

class PinPlaylistMapper {
  static PinPlaylist fromModel(PinPlaylist model) {
    return PinPlaylist(
      playlistId: model.playlistId,
      order: model.order,
    );
  }

  static PinPlaylist toModel(PinPlaylist entity) {
    return PinPlaylist(
      playlistId: entity.playlistId,
      order: entity.order,
    );
  }
}
