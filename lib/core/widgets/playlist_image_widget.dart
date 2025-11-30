import 'package:flutter/material.dart';
import 'package:music_player/core/constants/constants.dart';
import 'package:music_player/core/result.dart';
import 'package:music_player/features/playlist/domain/domain.dart';
import 'package:music_player/injection/service_locator.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';

class PlaylistImageWidget extends StatelessWidget {
  const PlaylistImageWidget({
    required this.playlistId,
    this.quality = 70,
    this.qualitySize = 200,
    this.size = 50,
    this.borderRadius = 12,
    this.artworkFit = BoxFit.cover,
    this.artworkQuality = FilterQuality.medium,
    super.key,
  });

  final int playlistId;
  final int quality;
  final int qualitySize;
  final double size;
  final double borderRadius;
  final BoxFit artworkFit;
  final FilterQuality artworkQuality;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Result<int?>>(
      future: getIt<PlaylistRepository>().getPlaylistCoverSongId(playlistId),
      builder: (context, snapshot) {
        // use latest song id
        final coverSongId = snapshot.data?.value;
        final artworkId = coverSongId ?? playlistId;

        return Center(
          child: QueryArtworkWidget(
            id: artworkId,
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
        );
      },
    );
  }
}
