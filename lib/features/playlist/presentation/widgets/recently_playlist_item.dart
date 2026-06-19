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
    this.size = 92,
    this.borderRadius = 24,
    this.width = 154,
    this.height = 182,
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
        padding: EdgeInsets.all(compact ? 10 : 12),
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
            final artworkId = coverSongId ?? playlist.id;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: compact ? 8 : 10,
                    vertical: compact ? 4 : 5,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    isRecent
                        ? context.localization.recentlyPlayed
                        : context.localization.playlist,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        (compact
                                ? theme.textTheme.labelSmall
                                : theme.textTheme.labelMedium)
                            ?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w700,
                            ),
                  ),
                ),
                SizedBox(height: compact ? 8 : 12),
                Expanded(
                  child: Center(
                    child: ArtImageWidget(
                      id: artworkId,
                      size: compact ? size - 8 : size,
                      borderRadius: compact ? 16 : 18,
                      defaultCoverBg: Colors.white,
                      defaultCover: ImageAssets.playlistCover,
                    ),
                  ),
                ),
                SizedBox(height: compact ? 8 : 10),
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
                  maxLines: compact ? 1 : 2,
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
