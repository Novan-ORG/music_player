import 'package:flutter/material.dart';
import 'package:music_player/core/constants/image_assets.dart';

class RecentlyPlaylistItem extends StatelessWidget {
  const RecentlyPlaylistItem({
    super.key,
    this.size = 74,
    this.borderRadius = 16,
    this.artworkFit = BoxFit.cover,
    this.margin = 6,
  });

  final double size;
  final double borderRadius;
  final double margin;
  final BoxFit artworkFit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          width: size,
          height: size,
          margin: EdgeInsets.all(margin),
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: Image.asset(
              ImageAssets.caroAvatar,
              fit: artworkFit,
              width: size,
              height: size,
            ),
          ),
        ),

        Text(
          'Recently',
          style: theme.textTheme.labelLarge?.copyWith(
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
