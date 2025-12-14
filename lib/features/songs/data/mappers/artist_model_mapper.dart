import 'package:music_player/features/songs/domain/entities/entities.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';

sealed class ArtistModelMapper {
  static ArtistModel fromDomain(Artist artist) {
    final result = ArtistModel({
      '_id': artist.id,
      'artist': artist.artist,
      'number_of_albums': artist.numberOfAlbums,
      'number_of_tracks': artist.numberOfTracks,
    });

    return result;
  }

  static Artist toDomain(ArtistModel artistModel) {
    return Artist(
      id: artistModel.id,
      artist: artistModel.artist,
      numberOfAlbums: artistModel.numberOfAlbums ?? 0,
      numberOfTracks: artistModel.numberOfTracks ?? 0,
    );
  }
}
