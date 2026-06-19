import 'package:flutter/material.dart';
import 'package:music_player/core/domain/entities/song.dart';
import 'package:music_player/core/theme/app_themes.dart';
import 'package:music_player/core/widgets/widgets.dart';
import 'package:music_player/extensions/extensions.dart';

/// Reusable song list tile widget.
///
/// Displays a song with:
/// - Album thumbnail/cover art
/// - Song title and artist
/// - Duration
/// - Favorite toggle button
/// - Optional actions menu
/// - Visual indication of current playing song
class SongItem extends StatelessWidget {
  const SongItem({
    required this.track,
    this.margin = const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
    this.padding = const EdgeInsets.symmetric(vertical: 8, horizontal: 9),
    this.borderRadius = 24,
    this.songImageSize = 54,
    this.onTap,
    this.onLongPress,
    this.blurBackground = true,
    this.isCurrentTrack = false,
    this.isPlayingNow = false,
    this.isFavorite = false,
    this.onPlayPause,
    this.onFavoriteToggle,
    this.onDelete,
    this.onSetAsRingtone,
    this.onAddToPlaylist,
    this.onRemoveFromPlaylist,
    this.onShare,
    this.isInPlaylist = false,
    super.key,
  });

  final Song track;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final double borderRadius;
  final double songImageSize;
  final bool blurBackground;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  // Playback / state flags
  final bool isCurrentTrack;
  final bool isPlayingNow;

  // Like / favorite
  final bool isFavorite;

  // Callbacks
  final VoidCallback? onPlayPause;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onDelete;
  final VoidCallback? onSetAsRingtone;
  final VoidCallback? onAddToPlaylist;
  final VoidCallback? onRemoveFromPlaylist;
  final VoidCallback? onShare;

  final bool isInPlaylist;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isDark = theme.brightness == Brightness.dark;
    final primary = theme.colorScheme.primary;
    final highlightGradient = isCurrentTrack
        ? LinearGradient(
            begin: AlignmentDirectional.centerStart,
            end: AlignmentDirectional.centerEnd,
            colors: [
              primary.withValues(
                alpha: isDark ? 0.2 : 0.18,
              ),
              const Color(0xFF00BFA6).withValues(alpha: 0.16),
              if (isDark)
                theme.colorScheme.surface.withValues(alpha: 0.58)
              else
                const Color(0xFFFFFBF2),
            ],
          )
        : null;
    final idleLightGradient = !isCurrentTrack && !isDark
        ? const LinearGradient(
            begin: AlignmentDirectional.topStart,
            end: AlignmentDirectional.bottomEnd,
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFF9FBF3),
            ],
          )
        : null;
    final cardGradient = highlightGradient ?? idleLightGradient;
    final borderColor = isCurrentTrack
        ? primary.withValues(alpha: isDark ? 0.56 : 0.62)
        : !isDark
        ? const Color(0xFFE0E2D9)
        : null;
    final borderWidth = isCurrentTrack ? 1.15 : (!isDark ? 0.9 : null);
    final cardShadow = isCurrentTrack
        ? [
            BoxShadow(
              color: primary.withValues(alpha: isDark ? 0.22 : 0.18),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.28 : 0.08),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ]
        : !isDark
        ? [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, 9),
            ),
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.8),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ]
        : null;
    // Common row content used by both blurred and plain variants
    final content = Row(
      children: [
        _SongArtwork(
          id: track.id,
          size: songImageSize,
          isCurrentTrack: isCurrentTrack,
          isPlayingNow: isPlayingNow,
        ),
        const SizedBox(width: 10),
        Expanded(child: _buildTitleAndArtist(context)),
        const SizedBox(width: 6),
        _buildActionButtons(context),
      ],
    );

    if (blurBackground) {
      // GlassCard already provides padding, tap and highlight behaviour.
      return GlassCard(
        margin: margin,
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        padding: padding,
        onTap: onTap,
        onLongPress: onLongPress,
        gradient: cardGradient,
        borderColor: borderColor,
        borderWidth: borderWidth,
        boxShadow: cardShadow,
        child: content,
      );
    }

    // Plain card without blur
    return Card(
      color: Colors.transparent,
      margin: margin,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        onTap: onTap,
        onLongPress: onLongPress,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            border: borderColor != null && borderWidth != null
                ? Border.all(color: borderColor, width: borderWidth)
                : null,
            gradient: cardGradient,
          ),
          child: Padding(
            padding: padding,
            child: content,
          ),
        ),
      ),
    );
  }

  Widget _buildTitleAndArtist(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        Text(
          track.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: isCurrentTrack ? context.theme.colorScheme.primary : null,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: ArtistWidget(
                artist: track.artist,
                isCurrentTrack: isCurrentTrack,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              track.duration.format(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.theme.textTheme.labelSmall?.copyWith(
                color: context.theme.textTheme.bodyMedium?.color?.withValues(
                  alpha: 0.72,
                ),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isCurrentTrack)
          Tooltip(
            // When current track is playing, action is to pause; otherwise play
            message: isPlayingNow
                ? context.localization.pause
                : context.localization.play,
            child: IconButton(
              icon: Icon(
                isPlayingNow ? Icons.pause : Icons.play_arrow,
                color: context.theme.colorScheme.primary,
              ),
              onPressed: onPlayPause,
              padding: EdgeInsets.zero,
              splashRadius: 18,
              constraints: const BoxConstraints.tightFor(width: 36, height: 36),
              visualDensity: VisualDensity.compact,
            ),
          )
        else
          Tooltip(
            message: isFavorite
                ? context.localization.unlike
                : context.localization.like,
            child: IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite
                    ? context.theme.primaryColor
                    : AppDarkColors.accent,
              ),
              onPressed: onFavoriteToggle,
              padding: EdgeInsets.zero,
              splashRadius: 18,
              constraints: const BoxConstraints.tightFor(width: 36, height: 36),
              visualDensity: VisualDensity.compact,
            ),
          ),
        SongItemMoreOptionMenu(
          onAddToPlaylist: onAddToPlaylist,
          onDelete: onDelete,
          onFavoriteToggle: onFavoriteToggle,
          onPlayPause: onPlayPause,
          onRemoveFromPlaylist: onRemoveFromPlaylist,
          onSetAsRingtone: onSetAsRingtone,
          onShare: onShare,
          isInPlaylist: isInPlaylist,
          isCurrentTrack: isCurrentTrack,
          compact: true,
        ),
      ],
    );
  }
}

class _SongArtwork extends StatelessWidget {
  const _SongArtwork({
    required this.id,
    required this.size,
    required this.isCurrentTrack,
    required this.isPlayingNow,
  });

  final int id;
  final double size;
  final bool isCurrentTrack;
  final bool isPlayingNow;

  @override
  Widget build(BuildContext context) {
    final primary = context.theme.colorScheme.primary;
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: size + 4,
          height: size + 4,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: isCurrentTrack
                ? LinearGradient(
                    colors: [
                      primary,
                      const Color(0xFF00BFA6),
                    ],
                  )
                : null,
          ),
          alignment: Alignment.center,
          child: ArtImageWidget(id: id, size: size),
        ),
        if (isCurrentTrack)
          Container(
            width: size + 4,
            height: size + 4,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withValues(alpha: isPlayingNow ? 0.3 : 0.18),
            ),
            child: Icon(
              isPlayingNow
                  ? Icons.graphic_eq_rounded
                  : Icons.play_arrow_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
      ],
    );
  }
}
