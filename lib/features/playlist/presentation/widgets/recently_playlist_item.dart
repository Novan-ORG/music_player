import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/constants/image_assets.dart';
import 'package:music_player/core/widgets/glass_card.dart';
import 'package:music_player/core/widgets/song_image_widget.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/playlist/domain/entities/playlist.dart';
import 'package:music_player/features/playlist/presentation/bloc/bloc.dart';

class PinnedPlaylistItem extends StatelessWidget {
  const PinnedPlaylistItem({
    required this.playlist,
    super.key,
    this.size = 84,
    this.borderRadius = 22,
    this.width = 144,
    this.height = 170,
    this.isRecent = false,
    this.compact = false,
    this.onTap,
  });

  final Playlist playlist;
  final double size;
  final double borderRadius;
  final double width;
  final double height;
  final bool isRecent;
  final bool compact;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SizedBox(
      width: width,
      height: height,
      child: GlassCard(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        padding: EdgeInsets.all(compact ? 9 : 10),
        gradient: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: [
            theme.colorScheme.surface.withValues(alpha: isDark ? 0.34 : 0.88),
            theme.colorScheme.surface.withValues(alpha: isDark ? 0.22 : 0.66),
          ],
        ),
        child: BlocBuilder<PlayListBloc, PlayListState>(
          builder: (context, state) {
            final coverSongId = state.playlistCoverSongIds[playlist.id];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Center(
                    child: coverSongId == null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(
                              compact ? 14 : 16,
                            ),
                            child: ColoredBox(
                              color: Colors.white,
                              child: Image.asset(
                                ImageAssets.playlistCover,
                                width: compact ? size - 8 : size,
                                height: compact ? size - 8 : size,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : ArtImageWidget(
                            id: coverSongId,
                            size: compact ? size - 8 : size,
                            borderRadius: compact ? 14 : 16,
                            defaultCoverBg: Colors.white,
                            defaultCover: ImageAssets.playlistCover,
                          ),
                  ),
                ),
                SizedBox(height: compact ? 6 : 10),
                Text(
                  playlist.name,
                  maxLines: compact ? 1 : 2,
                  overflow: TextOverflow.ellipsis,
                  style:
                      (compact
                              ? theme.textTheme.titleSmall
                              : theme.textTheme.titleSmall)
                          ?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                ),
                const SizedBox(height: 4),
                Text(
                  isRecent
                      ? context.localization.playlistRecentHint
                      : '${playlist.numOfSongs} ${context.localization.songs}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.62),
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
