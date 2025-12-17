import 'package:music_player/features/songs/domain/enums/enums.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';

class SongSortTypeMapper {
  static SongSortType fromIndex(int index) {
    switch (index) {
      case 0:
        return SongSortType.TITLE;
      case 1:
        return SongSortType.ARTIST;
      case 2:
        return SongSortType.ALBUM;
      case 3:
        return SongSortType.DURATION;
      case 4:
        return SongSortType.DATE_ADDED;
      case 5:
        return SongSortType.SIZE;
      case 6:
        return SongSortType.DISPLAY_NAME;
      default:
        return SongSortType.DATE_ADDED;
    }
  }

  // we used the `SongsSortType` in domain layer
  // but the `SongSortType` in data layer
  static SongsSortType toSongsSortType(SongSortType sortType) {
    switch (sortType) {
      case SongSortType.DATE_ADDED:
        return SongsSortType.dateAdded;
      case SongSortType.TITLE:
        return SongsSortType.title;
      case SongSortType.ARTIST:
        return SongsSortType.artist;
      case SongSortType.ALBUM:
        return SongsSortType.album;
      case SongSortType.DURATION:
        return SongsSortType.duration;
      case SongSortType.SIZE:
        return SongsSortType.size;
      case SongSortType.DISPLAY_NAME:
        return SongsSortType.title;
    }
  }
}
