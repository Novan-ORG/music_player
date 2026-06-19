import 'package:flutter/material.dart';
import 'package:music_player/extensions/extensions.dart';

/// Widget displaying artist information with optional indicator.
///
/// Shows artist name with icon and indicates if it's the current track.
class ArtistWidget extends StatelessWidget {
  const ArtistWidget({
    required this.artist,
    this.isCurrentTrack = false,
    super.key,
  });

  final bool isCurrentTrack;
  final String artist;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final inactiveColor = theme.textTheme.bodyMedium?.color?.withValues(
      alpha: 0.76,
    );
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 4,
      children: [
        Icon(
          Icons.person,
          size: 14,
          color: isCurrentTrack ? theme.colorScheme.primary : inactiveColor,
        ),
        Flexible(
          child: Text(
            artist,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: isCurrentTrack ? theme.colorScheme.primary : inactiveColor,
            ),
          ),
        ),
      ],
    );
  }
}
