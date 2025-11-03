import 'package:music_player/core/domain/entities/song.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';

sealed class SongModelMapper {
  static SongModel fromDomain(Song song) {
    final result = SongModel({
      '_id': song.id,
      '_display_name_wo_ext': song.displayNameWOExt,
      'title': song.title,
      '_display_name': song.displayName,
      'artist': song.artist,
      'album': song.album,
      '_data': song.data,
      '_uri': song.uri,
      'duration': song.duration.inMilliseconds,
      'album_id': song.albumId,
      'date_added': song.dateAdded.millisecondsSinceEpoch,
      '_size': song.size,
    });

    return result;
  }

  static Song toDomain(SongModel songModel) {
    return Song(
      id: songModel.id,
      title: songModel.title,
      displayNameWOExt: songModel.displayNameWOExt,
      displayName: songModel.displayName,
      data: songModel.data,
      artist: songModel.artist ?? 'Unknown Artist',
      album: songModel.album ?? 'Unknown Album',
      uri: songModel.uri,
      duration: Duration(milliseconds: songModel.duration ?? 0),
      albumId: songModel.albumId,
      size: songModel.size,
      dateAdded: DateTime.fromMillisecondsSinceEpoch(songModel.dateAdded ?? 0),
    );
  }
}
