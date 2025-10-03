import 'package:music_player/core/domain/entities/entities.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart' as aq;

class SongModel extends Song {
  SongModel({
    required super.id,
    required super.title,
    required super.artist,
    required super.album,
    required super.uri,
    required super.duration,
    required super.albumId,
  });

  factory SongModel.fromAudioQueryModel(aq.SongModel song) {
    return SongModel(
      id: song.id,
      title: song.title,
      artist: song.artist ?? 'Unknown Artist',
      album: song.album ?? 'Unknown Album',
      uri: song.data,
      duration: Duration(milliseconds: song.duration ?? 0),
      albumId: song.albumId,
    );
  }

  factory SongModel.fromDomain(Song song) {
    return SongModel(
      id: song.id,
      title: song.title,
      artist: song.artist,
      album: song.album,
      uri: song.uri,
      duration: song.duration,
      albumId: song.albumId,
    );
  }

  Song toDomain() {
    return Song(
      id: id,
      title: title,
      artist: artist,
      album: album,
      uri: uri,
      duration: duration,
      albumId: albumId,
    );
  }
}
