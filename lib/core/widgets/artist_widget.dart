import 'package:flutter/material.dart';
import 'package:music_player/extensions/extensions.dart';

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
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 4,
      children: [
        Icon(
          Icons.person,
          size: 14,
          color: isCurrentTrack
              ? context.theme.colorScheme.primary
              : Colors.grey,
        ),
        Flexible(
          child: Text(
            artist,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: isCurrentTrack
                  ? context.theme.colorScheme.primary
                  : Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }
}
