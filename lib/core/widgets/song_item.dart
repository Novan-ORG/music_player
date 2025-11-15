import 'package:flutter/material.dart';
import 'package:music_player/core/domain/entities/song.dart';
import 'package:music_player/core/widgets/widgets.dart';
import 'package:music_player/extensions/extensions.dart';

class SongItem extends StatelessWidget {
  const SongItem({
    required this.track,
    this.margin = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    this.padding = const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
    this.borderRadius = 32,
    this.onTap,
    this.onLongPress,
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
    return GlassCard(
      margin: margin,
      borderRadius: borderRadius,
      padding: padding,
      onTap: onTap,
      onLongPress: onLongPress,
      child: Row(
        children: [
          SongImageWidget(songId: track.id, size: 54),
          const SizedBox(width: 12),
          Expanded(child: _buildTitleAndArtist(context)),
          const SizedBox(width: 8),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildTitleAndArtist(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          track.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 4,
          children: [
            const Icon(Icons.person, size: 14, color: Colors.grey),
            Text(
              track.artist,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
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
            message: isPlayingNow ? 'Pause' : 'Play',
            child: IconButton(
              icon: Icon(isPlayingNow ? Icons.pause : Icons.play_arrow),
              onPressed: onPlayPause,
            ),
          )
        else
          Tooltip(
            message: isFavorite ? 'Unlike' : 'Like',
            child: IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.grey,
              ),
              onPressed: onFavoriteToggle,
            ),
          ),
        _buildOptionsMenu(context),
      ],
    );
  }

  // Use an enum for menu actions to make intent explicit
  PopupMenuButton<_MenuAction> _buildOptionsMenu(BuildContext context) {
    return PopupMenuButton<_MenuAction>(
      icon: const Icon(Icons.more_vert),
      tooltip: 'More options',
      onSelected: (action) {
        switch (action) {
          case _MenuAction.addToPlaylist:
            onAddToPlaylist?.call();
          case _MenuAction.removeFromPlaylist:
            onRemoveFromPlaylist?.call();
          case _MenuAction.share:
            onShare?.call();
          case _MenuAction.delete:
            onDelete?.call();
          case _MenuAction.setAsRingtone:
            onSetAsRingtone?.call();
        }
      },
      itemBuilder: (context) => [
        if (isInPlaylist)
          PopupMenuItem(
            value: _MenuAction.removeFromPlaylist,
            child: Row(
              spacing: 8,
              children: [
                const Icon(Icons.playlist_remove, color: Colors.orange),
                Text(context.localization.removeFromPlaylist),
              ],
            ),
          )
        else
          PopupMenuItem(
            value: _MenuAction.addToPlaylist,
            child: Row(
              spacing: 8,
              children: [
                const Icon(Icons.playlist_add, color: Colors.green),
                Text(context.localization.addToPlaylist),
              ],
            ),
          ),
        PopupMenuItem(
          value: _MenuAction.share,
          child: Row(
            spacing: 8,
            children: [
              const Icon(Icons.share, color: Colors.blue),
              Text(context.localization.share),
            ],
          ),
        ),
        PopupMenuItem(
          value: _MenuAction.delete,
          child: Row(
            spacing: 8,
            children: [
              const Icon(Icons.delete, color: Colors.red),
              Text(context.localization.deleteFromDevice),
            ],
          ),
        ),
        PopupMenuItem(
          value: _MenuAction.setAsRingtone,
          child: Row(
            spacing: 8,
            children: [
              const Icon(Icons.music_note, color: Colors.blue),
              Text(context.localization.setAsRingtone),
            ],
          ),
        ),
      ],
    );
  }
}

enum _MenuAction {
  addToPlaylist,
  removeFromPlaylist,
  share,
  delete,
  setAsRingtone,
}
