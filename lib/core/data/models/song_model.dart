import 'package:music_player/core/domain/entities/entities.dart';

class SongModel extends Song {
  const SongModel({
    required super.id,
    required super.title,
    required super.artist,
    required super.album,
    required super.uri,
    required super.duration,
    required super.albumId,
    required super.size,
    required super.dateAdded,
  });
}
