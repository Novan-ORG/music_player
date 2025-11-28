import 'package:flutter/material.dart';
import 'package:music_player/core/constants/image_assets.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';

class RecentlyPlaylistItem extends StatelessWidget {
  const RecentlyPlaylistItem({
    super.key,
    this.size = 74,
    this.borderRadius = 16,
    this.artworkFit = BoxFit.cover,
    this.margin = 6,
    this.quality = 70,
    this.qualitySize = 200,
    this.artworkQuality = FilterQuality.medium,
    this.onTap,
  });

  final double size;
  final double borderRadius;
  final double margin;
  final BoxFit artworkFit;
  final int quality;
  final int qualitySize;
  final FilterQuality artworkQuality;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: QueryArtworkWidget(
            id: 0,
            quality: quality,
            type: ArtworkType.AUDIO,
            size: qualitySize,
            artworkWidth: size,
            artworkHeight: size,
            artworkQuality: artworkQuality,
            artworkFit: artworkFit,
            artworkBorder: BorderRadius.circular(borderRadius),
            nullArtworkWidget: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: Image.asset(
                ImageAssets.playlistCover,
                fit: BoxFit.cover,
                width: size,
                height: size,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 6,
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
