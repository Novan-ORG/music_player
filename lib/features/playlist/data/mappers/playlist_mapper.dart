import 'package:music_player/features/playlist/domain/domain.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';

class PlaylistMapper {
  static Playlist fromModel(PlaylistModel model) {
    return Playlist(
      id: model.id,
      name: model.playlist,
      numOfSongs: model.numOfSongs,
      createdAt: DateTime.fromMillisecondsSinceEpoch(model.dateAdded ?? 0),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(model.dateModified ?? 0),
    );
  }

  static PlaylistModel toModel(Playlist playlist) {
    return PlaylistModel({
      '_id': playlist.id,
      'name': playlist.name,
      'num_of_songs': playlist.numOfSongs,
      'date_added': playlist.createdAt.millisecondsSinceEpoch,
      'date_modified': playlist.updatedAt.millisecondsSinceEpoch,
    });
  }
}
