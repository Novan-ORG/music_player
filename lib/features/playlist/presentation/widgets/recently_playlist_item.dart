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
              child: SongImageWidget(
                songId: artworkId,
                size: size,
                borderRadius: borderRadius,
                defaultCover: ImageAssets.playlistCover,
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
