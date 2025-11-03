import 'package:music_player/features/favorite/domain/entities/entities.dart';

class FavoriteSongModel extends FavoriteSong {
  const FavoriteSongModel({
    required super.id,
    required super.songId,
    required super.dateAdded,
  });

  factory FavoriteSongModel.fromEntity(FavoriteSong entity) {
    return FavoriteSongModel(
      id: entity.id,
      songId: entity.songId,
      dateAdded: entity.dateAdded,
    );
  }

  factory FavoriteSongModel.fromJson(Map<String, dynamic> json) {
    return FavoriteSongModel(
      id: json['id'] as int,
      songId: json['songId'] as int,
      dateAdded: DateTime.fromMillisecondsSinceEpoch(json['dateAdded'] as int),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'songId': songId,
      'dateAdded': dateAdded.millisecondsSinceEpoch,
    };
  }

  FavoriteSong toEntity() {
    return FavoriteSong(
      id: id,
      songId: songId,
      dateAdded: dateAdded,
    );
  }
}
