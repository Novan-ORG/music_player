import 'package:flutter/material.dart' show BuildContext, IconData, Icons;
import 'package:music_player/extensions/extensions.dart';

/// Enum for song sorting options (date added, title, artist, album,
///  duration, size).
enum SongsSortType {
  dateAdded,
  title,
  artist,
  album,
  duration,
  size,
}

extension SongsSortTypeExtension on SongsSortType {
  String toLocalizationString(BuildContext context) {
    switch (this) {
      case SongsSortType.dateAdded:
        return context.localization.dateAdded;
      case SongsSortType.title:
        return context.localization.title;
      case SongsSortType.artist:
        return context.localization.artist;
      case SongsSortType.album:
        return context.localization.album;
      case SongsSortType.duration:
        return context.localization.duration;
      case SongsSortType.size:
        return context.localization.size;
    }
  }

  IconData toIconData() {
    switch (this) {
      case SongsSortType.dateAdded:
        return Icons.calendar_today;
      case SongsSortType.title:
        return Icons.text_fields;
      case SongsSortType.artist:
        return Icons.person;
      case SongsSortType.album:
        return Icons.album;
      case SongsSortType.duration:
        return Icons.access_time;
      case SongsSortType.size:
        return Icons.sd_storage;
    }
  }
}
