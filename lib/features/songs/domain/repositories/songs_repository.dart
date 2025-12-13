import 'package:music_player/core/domain/entities/entities.dart';
import 'package:music_player/core/result.dart';
import 'package:music_player/features/songs/domain/entities/entities.dart';
import 'package:music_player/features/songs/domain/enums/enums.dart';

abstract interface class SongsRepository {
  Future<Result<List<Song>>> querySongsFrom({
    required SongsFromType fromType,
    required Object where,
    SongsSortType sortType = SongsSortType.dateAdded,
  });
  Future<Result<List<Song>>> querySongs({
    SongsSortType sortType = SongsSortType.dateAdded,
  });
  Future<Result<List<Album>>> queryAlbums({
    AlbumsSortType sortType = AlbumsSortType.album,
  });
  Future<Result<List<Artist>>> queryArtists({
    ArtistsSortType sortType = ArtistsSortType.artist,
  });
  Future<Result<bool>> deleteSong({required String songUri});
  Future<Result<bool>> saveSongsSortType({required SongsSortType sortType});
  Result<SongsSortType> getSongsSortType();
}
