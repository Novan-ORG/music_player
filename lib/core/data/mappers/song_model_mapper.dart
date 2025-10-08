import 'package:music_player/core/data/models/models.dart';
import 'package:music_player/core/domain/entities/song.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart' as aq;

sealed class SongModelMapper {
  static SongModel fromAudioQueryModel(aq.SongModel song) {
    return SongModel(
      id: song.id,
      title: song.title,
      artist: song.artist ?? 'Unknown Artist',
      album: song.album ?? 'Unknown Album',
      uri: song.data,
      duration: Duration(milliseconds: song.duration ?? 0),
      albumId: song.albumId,
      size: song.size,
      dateAdded: DateTime.fromMillisecondsSinceEpoch(song.dateAdded ?? 0),
    );
  }

  static SongModel fromDomain(Song song) {
    return SongModel(
      id: song.id,
      title: song.title,
      artist: song.artist,
      album: song.album,
      uri: song.uri,
      duration: song.duration,
      albumId: song.albumId,
      dateAdded: song.dateAdded,
      size: song.size,
    );
  }

  static Song toDomain(SongModel songModel) {
    return Song(
      id: songModel.id,
      title: songModel.title,
      artist: songModel.artist,
      album: songModel.album,
      uri: songModel.uri,
      duration: songModel.duration,
      albumId: songModel.albumId,
      size: songModel.size,
      dateAdded: songModel.dateAdded,
    );
  }
}
