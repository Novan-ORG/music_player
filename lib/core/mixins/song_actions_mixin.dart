import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/domain/entities/song.dart';
import 'package:music_player/core/services/services.dart';
import 'package:music_player/core/widgets/widgets.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/favorite/favorite.dart';
import 'package:share_plus/share_plus.dart';

/// Mixin that provides song sharing functionality
mixin SongSharingMixin {
  /// Share a single song
  Future<void> shareSong(Song song) async {
    await SharePlus.instance.share(
      ShareParams(
        text: song.title,
        subject: song.artist,
        files: [XFile(song.data)],
      ),
    );
  }

  /// Share multiple songs
  Future<void> shareSongs(
    BuildContext context,
    List<Song> songs, {
    VoidCallback? onSuccess,
  }) async {
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
        files: songs.map((song) => XFile(song.data)).toList(),
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
    final hasPermission = await RingtoneSet.canWriteSettings();

    if (hasPermission) {
      await _applyRingtone(songPath);
      return;
    }

    final didOpenSettings = await RingtoneSet.openWriteSettings();
    if (!didOpenSettings && mounted) {
      _showPermissionDeniedMessage();
    }
  }

  Future<void> _applyRingtone(String songPath) async {
    final didSetRingtone = await RingtoneSet.setRingtone(songPath);
    if (!didSetRingtone && mounted) {
      _showRingtoneFailedMessage();
    }
  }

  void _showPermissionDeniedMessage() {
    AppSnackBar.showError(
      context,
      title: context.localization.error,
      message: context.localization.permissionDeniedForRingtone,
      icon: Icons.settings_rounded,
    );
  }

  void _showRingtoneFailedMessage() {
    AppSnackBar.showError(
      context,
      title: context.localization.error,
      message: context.localization.error,
      icon: Icons.music_off_rounded,
    );
  }
}

mixin ToggleLikeMixin<T extends StatefulWidget> on State<T> {
  void onToggleLike(int songId) {
    context.read<FavoriteSongsBloc>().add(ToggleFavoriteSongEvent(songId));
  }
}
