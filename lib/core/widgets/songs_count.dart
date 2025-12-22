import 'package:flutter/material.dart';
import 'package:music_player/extensions/extensions.dart';

/// Widget displaying the count of songs in a list or playlist.
///
/// Shows a music note icon followed by formatted text:
/// "Songs: {count}"
class SongsCount extends StatelessWidget {
  const SongsCount({required this.songCount, super.key});
  final int songCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 4,
      children: [
        const Icon(
          Icons.music_note_rounded,
          size: 18,
        ),
        Text(
          '${context.localization.songs}: $songCount',
          style: context.theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
