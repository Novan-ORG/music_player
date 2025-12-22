import 'package:flutter/material.dart';
import 'package:music_player/extensions/extensions.dart';

enum _MenuAction {
  addToPlaylist,
  removeFromPlaylist,
  share,
  delete,
  setAsRingtone,
}

/// Context menu widget for song actions.
///
/// Provides options to:
/// - Add/remove from playlists
/// - Share song
/// - Delete song
/// - Set as ringtone
/// - Toggle favorite
/// - Play/pause current track
class SongItemMoreOptionMenu extends StatelessWidget {
  const SongItemMoreOptionMenu({
    required this.isInPlaylist,
    required this.isCurrentTrack,
    super.key,
    this.onAddToPlaylist,
    this.onDelete,
    this.onFavoriteToggle,
    this.onPlayPause,
    this.onRemoveFromPlaylist,
    this.onSetAsRingtone,
    this.onShare,
  });

  final bool isInPlaylist;
  final bool isCurrentTrack;
  //
  final VoidCallback? onPlayPause;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onDelete;
  final VoidCallback? onSetAsRingtone;
  final VoidCallback? onAddToPlaylist;
  final VoidCallback? onRemoveFromPlaylist;
  final VoidCallback? onShare;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_MenuAction>(
      icon: Icon(
        Icons.more_vert,
        color: isCurrentTrack ? context.theme.colorScheme.primary : null,
      ),
      tooltip: 'More options',
      elevation: 10,
      onSelected: (action) {
        switch (action) {
          case _MenuAction.addToPlaylist:
            onAddToPlaylist?.call();
            return;
          case _MenuAction.removeFromPlaylist:
            onRemoveFromPlaylist?.call();
            return;
          case _MenuAction.share:
            onShare?.call();
            return;
          case _MenuAction.delete:
            onDelete?.call();
            return;
          case _MenuAction.setAsRingtone:
            onSetAsRingtone?.call();
            return;
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
