import 'package:music_player/features/songs/domain/entities/entities.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';

sealed class AlbumModelMapper {
  static AlbumModel fromDomain(Album album) {
    final result = AlbumModel({
      '_id': album.id,
      'album': album.album,
      'artist': album.artist,
      'artist_id': album.artistId,
      'numsongs': album.numOfSongs,
    });

    return result;
  }

  static Album toDomain(AlbumModel albumModel) {
    return Album(
      id: albumModel.id,
      album: albumModel.album,
      artist: albumModel.artist,
      artistId: albumModel.artistId,
      numOfSongs: albumModel.numOfSongs,
    );
  }
}
