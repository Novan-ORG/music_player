import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/constants/image_assets.dart';
import 'package:music_player/features/playlist/domain/entities/playlist.dart';
import 'package:music_player/features/playlist/presentation/bloc/bloc.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';

class PinnedPlaylistItem extends StatelessWidget {
  const PinnedPlaylistItem({
    required this.playlist,
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

  final Playlist playlist;
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
        BlocBuilder<PlayListBloc, PlayListState>(
          builder: (context, state) {
            // Get cover song ID from bloc state
            final coverSongId = state.playlistCoverSongIds[playlist.id];
            final artworkId = coverSongId ?? playlist.id;

            return GestureDetector(
              onTap: onTap,
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
                  child: ColoredBox(
                    color: Colors.white,
                    child: Image.asset(
                      ImageAssets.playlistCover,
                      fit: BoxFit.cover,
                      width: size,
                      height: size,
                    ),
                  ),
                ),
              ),
            );
          },
        ),

        const SizedBox(
          height: 6,
        ),
        Text(
          playlist.name.length > 8
              ? '${playlist.name.substring(0, 6)}...'
              : playlist.name,
          style: theme.textTheme.labelLarge?.copyWith(
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
