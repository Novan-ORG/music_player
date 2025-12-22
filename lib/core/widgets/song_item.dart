import 'package:flutter/material.dart';
import 'package:music_player/core/domain/entities/song.dart';
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
    this.margin = const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
    this.padding = const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
    this.borderRadius = 32,
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
    // Common row content used by both blurred and plain variants
    final content = Row(
      children: [
        ArtImageWidget(id: track.id, size: songImageSize),
        const SizedBox(width: 12),
        Expanded(child: _buildTitleAndArtist(context)),
        const SizedBox(width: 8),
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
        child: Card(
          color: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Padding(padding: EdgeInsets.zero, child: content),
        ),
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
        child: Padding(
          padding: padding,
          child: content,
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
        ArtistWidget(
          artist: track.artist,
          isCurrentTrack: isCurrentTrack,
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
            message: isPlayingNow ? 'Pause' : 'Play',
            child: IconButton(
              icon: Icon(
                isPlayingNow ? Icons.pause : Icons.play_arrow,
                color: context.theme.colorScheme.primary,
              ),
              onPressed: onPlayPause,
            ),
          )
        else
          Tooltip(
            message: isFavorite ? 'Unlike' : 'Like',
            child: IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: context.theme.primaryColor,
              ),
              onPressed: onFavoriteToggle,
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
        ),
      ],
    );
  }
}
