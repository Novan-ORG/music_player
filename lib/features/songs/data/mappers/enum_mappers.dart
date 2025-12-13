import 'package:music_player/features/songs/domain/enums/enums.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';

extension SortSongMapper on SongsSortType {
  SongSortType toSongSortType() {
    switch (this) {
      case SongsSortType.dateAdded:
        return SongSortType.DATE_ADDED;
      case SongsSortType.title:
        return SongSortType.TITLE;
      case SongsSortType.artist:
        return SongSortType.ARTIST;
      case SongsSortType.album:
        return SongSortType.ALBUM;
      case SongsSortType.duration:
        return SongSortType.DURATION;
      case SongsSortType.size:
        return SongSortType.SIZE;
    }
  }
}

extension SortAlbumMapper on AlbumsSortType {
  AlbumSortType toAlbumSortType() {
    switch (this) {
      case AlbumsSortType.album:
        return AlbumSortType.ALBUM;
      case AlbumsSortType.artist:
        return AlbumSortType.ARTIST;
      case AlbumsSortType.numOfSongs:
        return AlbumSortType.NUM_OF_SONGS;
    }
  }
}

extension SortArtistMapper on ArtistsSortType {
  ArtistSortType toArtistSortType() {
    switch (this) {
      case ArtistsSortType.artist:
        return ArtistSortType.ARTIST;
      case ArtistsSortType.numOfAlbums:
        return ArtistSortType.NUM_OF_ALBUMS;
      case ArtistsSortType.numOfTracks:
        return ArtistSortType.NUM_OF_TRACKS;
    }
  }
}
