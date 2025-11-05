import 'package:flutter/material.dart';
import 'package:music_player/extensions/extensions.dart';

class SongsCount extends StatelessWidget {
  const SongsCount({required this.songCount, super.key});
  final int songCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(Icons.library_music, size: 18, color: theme.primaryColor),
        const SizedBox(width: 8),
        Text(
          '${context.localization.songs}: $songCount',
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
