import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/constants/image_assets.dart';
import 'package:music_player/core/widgets/song_image_widget.dart';
import 'package:music_player/features/playlist/domain/entities/playlist.dart';
import 'package:music_player/features/playlist/presentation/bloc/bloc.dart';

class PinnedPlaylistItem extends StatelessWidget {
  const PinnedPlaylistItem({
    required this.playlist,
    super.key,
    this.size = 74,
    this.borderRadius = 16,
    this.margin = 6,
    this.onTap,
  });

  final Playlist playlist;
  final double size;
  final double borderRadius;
  final double margin;
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
              child: ArtImageWidget(
                id: artworkId,
                size: size,
                borderRadius: borderRadius,
                defaultCoverBg: Colors.white,
                defaultCover: ImageAssets.playlistCover,
              ),
            );
          },
        ),

        const SizedBox(
          height: 6,
        ),
        SizedBox(
          width: 74,
          child: Text(
            playlist.name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelLarge?.copyWith(
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
