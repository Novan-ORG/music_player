import 'package:music_player/features/playlist/domain/entities/pin_playlist.dart';

class PinPlaylistModel extends PinPlaylist {
  const PinPlaylistModel({
    required super.playlistId,
    required super.order,
  });

  factory PinPlaylistModel.fromEntity(PinPlaylist entity) {
    return PinPlaylistModel(
      playlistId: entity.playlistId,
      order: entity.order,
    );
  }

  factory PinPlaylistModel.fromJson(Map<String, dynamic> json) {
    return PinPlaylistModel(
      playlistId: json['playlistId'] as int,
      order: json['order'] as int,
    );
  }

  PinPlaylist toEntity() {
    return PinPlaylist(
      playlistId: playlistId,
      order: order,
    );
  }

  Map<String, dynamic> toJson() => {
    'playlistId': playlistId,
    'order': order,
  };
}
