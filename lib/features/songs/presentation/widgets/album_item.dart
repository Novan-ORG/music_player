import 'package:flutter/material.dart';
import 'package:music_player/core/widgets/widgets.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/songs/domain/entities/entities.dart';

/// Album card widget for displaying album information.
///
/// Shows album artwork, name, artist, and song count.
class AlbumItem extends StatelessWidget {
  const AlbumItem({required this.album, this.onTap, super.key});

  final Album album;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final songLocalized = album.numOfSongs > 1
        ? context.localization.songs
        : context.localization.song;
    return GlassCard(
      margin: const EdgeInsets.only(left: 16, right: 16, top: 10),
      padding: const EdgeInsets.all(10),
      borderRadius: const BorderRadius.all(Radius.circular(22)),
      onTap: onTap,
      child: Row(
        children: [
          const _LibraryIconBadge(
            icon: Icons.album_rounded,
            companionIcon: Icons.music_note_rounded,
            size: 64,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 5,
              children: [
                Text(
                  album.album,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  '${album.numOfSongs} $songLocalized',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.textTheme.bodyMedium?.color?.withValues(
                      alpha: 0.76,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Icon(
            isRtl ? Icons.chevron_left_rounded : Icons.chevron_right_rounded,
            color: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }
}

class _LibraryIconBadge extends StatelessWidget {
  const _LibraryIconBadge({
    required this.icon,
    required this.companionIcon,
    required this.size,
  });

  final IconData icon;
  final IconData companionIcon;
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isDark = theme.brightness == Brightness.dark;
    final primary = theme.colorScheme.primary;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: [
            primary.withValues(alpha: isDark ? 0.36 : 0.22),
            const Color(0xFF00BFA6).withValues(alpha: isDark ? 0.24 : 0.18),
            if (isDark) const Color(0xFF202124) else Colors.white,
          ],
        ),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.12)
              : primary.withValues(alpha: 0.16),
        ),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: isDark ? 0.18 : 0.12),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            icon,
            size: size * 0.54,
            color: isDark
                ? Colors.white.withValues(alpha: 0.92)
                : const Color(0xFF202124),
          ),
          PositionedDirectional(
            end: 7,
            bottom: 7,
            child: Container(
              width: size * 0.34,
              height: size * 0.34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark ? const Color(0xFF202124) : Colors.white,
                border: Border.all(
                  color: primary.withValues(alpha: 0.38),
                ),
              ),
              child: Icon(
                companionIcon,
                size: size * 0.2,
                color: primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
