import 'package:flutter/material.dart';
import 'package:music_player/core/theme/app_themes.dart';
import 'package:music_player/extensions/extensions.dart';

/// Widget displaying the count of songs in a list or playlist.
///
/// Shows a music note icon followed by formatted text:
/// "Songs: {count}"
class SongsCount extends StatelessWidget {
  const SongsCount({
    required this.songCount,
    super.key,
    this.isPlaylistItem = false,
  });
  final int songCount;
  final bool isPlaylistItem;

  @override
  Widget build(BuildContext context) {
    final songText = songCount == 1
        ? context.localization.songs.substring(0, 4)
        : context.localization.songs;

    final color = Theme.of(context).brightness == Brightness.dark
        ? AppDarkColors.textSecondary
        : AppLightColors.textSecondary;

    return Text(
      '$songCount $songText',
      style: isPlaylistItem
          ? context.theme.textTheme.bodySmall?.copyWith(color: color)
          : context.theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
    );
  }
}
