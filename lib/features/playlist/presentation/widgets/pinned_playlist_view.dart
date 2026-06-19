import 'package:flutter/material.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/playlist/domain/entities/playlist.dart';
import 'package:music_player/features/playlist/presentation/pages/playlist_details_page.dart';
import 'package:music_player/features/playlist/presentation/widgets/recently_playlist_item.dart';

class PinnedPlaylistsView extends StatelessWidget {
  const PinnedPlaylistsView({
    required this.pinnedPlaylists,
    this.compact = false,
    this.cardWidth = 150,
    this.cardHeight = 182,
    super.key,
  });

  final List<Playlist> pinnedPlaylists;
  final bool compact;
  final double cardWidth;
  final double cardHeight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalHighlights = pinnedPlaylists.length + 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                context.localization.favoritePlaylists,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withValues(alpha: 0.86),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
                ),
              ),
              child: Text(
                '$totalHighlights',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          context.localization.playlistPinnedHint,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.62),
            height: 1.35,
          ),
        ),
        SizedBox(height: compact ? 10 : 14),
        SizedBox(
          height: cardHeight,
          child: ListView.separated(
            itemCount: pinnedPlaylists.length + 1,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final recently = Playlist(
                id: -1,
                name: context.localization.recentlyPlayed,
                numOfSongs: 0,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              );

              if (index == 0) {
                return PinnedPlaylistItem(
                  playlist: recently,
                  compact: compact,
                  height: cardHeight,
                  width: cardWidth,
                  isRecent: true,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => PlaylistDetailsPage(
                        playlistModel: recently,
                      ),
                    ),
                  ),
                );
              }
              final playlist = pinnedPlaylists[index - 1];

              return PinnedPlaylistItem(
                playlist: playlist,
                compact: compact,
                height: cardHeight,
                width: cardWidth,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => PlaylistDetailsPage(
                      playlistModel: playlist,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: compact ? 2 : 6),
      ],
    );
  }
}
