import 'package:flutter/material.dart';
import 'package:music_player/core/widgets/widgets.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/songs/domain/entities/entities.dart';

/// Artist card widget for displaying artist information.
///
/// Shows artist name, number of songs and albums.
class ArtistItem extends StatelessWidget {
  const ArtistItem({required this.artist, this.onTap, super.key});

  final Artist artist;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final songLocalized = artist.numberOfTracks > 1
        ? context.localization.songs
        : context.localization.song;
    return GlassCard(
      margin: const EdgeInsets.only(left: 16, right: 16, top: 10),
      padding: const EdgeInsets.all(10),
      borderRadius: const BorderRadius.all(Radius.circular(22)),
      onTap: onTap,
      child: Row(
        children: [
          const _ArtistIconBadge(
            size: 64,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 5,
              children: [
                Text(
                  artist.artist,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  '${artist.numberOfTracks} $songLocalized',
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

class _ArtistIconBadge extends StatelessWidget {
  const _ArtistIconBadge({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isDark = theme.brightness == Brightness.dark;
    final primary = theme.colorScheme.primary;
    const teal = Color(0xFF00BFA6);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: [
            teal.withValues(alpha: isDark ? 0.28 : 0.2),
            primary.withValues(alpha: isDark ? 0.34 : 0.2),
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
            color: teal.withValues(alpha: isDark ? 0.16 : 0.12),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.person_rounded,
            size: size * 0.5,
            color: isDark
                ? Colors.white.withValues(alpha: 0.92)
                : const Color(0xFF202124),
          ),
          PositionedDirectional(
            end: 5,
            bottom: 7,
            child: Container(
              width: size * 0.34,
              height: size * 0.34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark ? const Color(0xFF202124) : Colors.white,
                border: Border.all(
                  color: teal.withValues(alpha: 0.42),
                ),
              ),
              child: Icon(
                Icons.graphic_eq_rounded,
                size: size * 0.19,
                color: primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
