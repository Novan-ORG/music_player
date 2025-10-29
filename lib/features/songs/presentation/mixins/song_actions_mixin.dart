import 'package:flutter/material.dart';
import 'package:music_player/core/domain/entities/song.dart';
import 'package:music_player/core/services/services.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

/// Mixin that provides song sharing functionality
mixin SongSharingMixin<T extends StatefulWidget> on State<T> {
  /// Share a single song
  Future<void> shareSong(Song song) async {
    await SharePlus.instance.share(
      ShareParams(
        text: song.title,
        subject: song.artist,
        files: [XFile(song.uri)],
      ),
    );
  }

  /// Share multiple songs
  Future<void> shareSongs(List<Song> songs, {VoidCallback? onSuccess}) async {
    if (songs.isEmpty) return;

    if (songs.length == 1) {
      await shareSong(songs.first);
      onSuccess?.call();
      return;
    }

    final songList = songs
        .map((song) => '${song.title} - ${song.artist}')
        .join('\n');

    final result = await SharePlus.instance.share(
      ShareParams(
        text: context.localization.shareSongsSubject(songs.length, songList),
        files: songs.map((song) => XFile(song.uri)).toList(),
      ),
    );

    if (result.status == ShareResultStatus.success) {
      onSuccess?.call();
    }
  }
}

/// Mixin that provides ringtone setting functionality
mixin RingtoneMixin<T extends StatefulWidget> on State<T> {
  Future<void> setAsRingtone(String songPath) async {
    final hasPermission = await Permission.systemAlertWindow
        .request()
        .isGranted;

    if (hasPermission) {
      await RingtoneSet.setRingtone(songPath);
    } else {
      if (!mounted) return;
      _showPermissionDeniedMessage();
    }
  }

  void _showPermissionDeniedMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.localization.permissionDeniedForRingtone),
      ),
    );
  }
}
