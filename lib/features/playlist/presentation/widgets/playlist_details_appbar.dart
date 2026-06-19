import 'package:flutter/material.dart';
import 'package:music_player/core/widgets/songs_count.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/playlist/domain/domain.dart';
import 'package:music_player/features/playlist/presentation/widgets/playlist_image_widget.dart';

class PlaylistDetailsAppbar extends StatelessWidget {
  const PlaylistDetailsAppbar({
    required this.playlist,
    required this.songCount,
    required this.onBackPressed,
    required this.onSearchButtonPressed,
    super.key,
    this.onAddSongsPressed,
  });

  final Playlist playlist;
  final int songCount;
  final VoidCallback onBackPressed;
  final VoidCallback onSearchButtonPressed;
  final VoidCallback? onAddSongsPressed;

  bool get _isRecentlyPlayed => playlist.id == -1;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withValues(alpha: 0.94),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 640;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _HeaderAction(
                      icon: Icons.arrow_back_rounded,
                      onPressed: onBackPressed,
                      tooltip: MaterialLocalizations.of(
                        context,
                      ).backButtonTooltip,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _isRecentlyPlayed
                            ? context.localization.recentlyPlayed
                            : context.localization.playlist,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    _HeaderAction(
                      icon: Icons.search_rounded,
                      onPressed: onSearchButtonPressed,
                      tooltip: context.localization.searchSongs,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (isWide)
                  Row(
                    children: [
                      Expanded(
                        child: _PlaylistMeta(
                          playlist: playlist,
                          songCount: songCount,
                        ),
                      ),
                      const SizedBox(width: 18),
                      PlaylistImageWidget(
                        playlistId: playlist.id,
                        borderRadius: 20,
                        size: 92,
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      PlaylistImageWidget(
                        playlistId: playlist.id,
                        borderRadius: 20,
                        size: constraints.maxWidth < 380 ? 72 : 84,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: _PlaylistMeta(
                          playlist: playlist,
                          songCount: songCount,
                        ),
                      ),
                    ],
                  ),
                if (onAddSongsPressed != null) ...[
                  const SizedBox(height: 14),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: OutlinedButton.icon(
                      onPressed: onAddSongsPressed,
                      icon: const Icon(Icons.playlist_add_rounded, size: 18),
                      label: Text(context.localization.addSongs),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 42),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PlaylistMeta extends StatelessWidget {
  const _PlaylistMeta({
    required this.playlist,
    required this.songCount,
  });

  final Playlist playlist;
  final int songCount;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          playlist.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 6),
        SongsCount(songCount: songCount),
      ],
    );
  }
}

class _HeaderAction extends StatelessWidget {
  const _HeaderAction({
    required this.icon,
    required this.onPressed,
    required this.tooltip,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon),
        style: IconButton.styleFrom(
          backgroundColor: context.theme.colorScheme.surface,
          foregroundColor: context.theme.colorScheme.onSurface,
          minimumSize: const Size.square(42),
          side: BorderSide(
            color: context.theme.colorScheme.onSurface.withValues(alpha: 0.08),
          ),
        ),
      ),
    );
  }
}
