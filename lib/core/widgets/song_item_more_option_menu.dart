import 'package:flutter/material.dart';
import 'package:music_player/core/widgets/widgets.dart';
import 'package:music_player/extensions/extensions.dart';

enum SongItemMenuAction {
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
class SongItemMoreOptionMenu extends StatelessWidget {
  const SongItemMoreOptionMenu({
    required this.isInPlaylist,
    required this.isCurrentTrack,
    super.key,
    this.showShare = true,
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
  final bool showShare;
  final VoidCallback? onPlayPause;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onDelete;
  final VoidCallback? onSetAsRingtone;
  final VoidCallback? onAddToPlaylist;
  final VoidCallback? onRemoveFromPlaylist;
  final VoidCallback? onShare;

  @override
  Widget build(BuildContext context) {
    final items = <AppPopupMenuEntry<SongItemMenuAction>>[
      if (isInPlaylist)
        AppPopupMenuEntry(
          value: SongItemMenuAction.removeFromPlaylist,
          label: context.localization.removeFromPlaylist,
          icon: Icons.playlist_remove_rounded,
          iconColor: Colors.orange,
        )
      else
        AppPopupMenuEntry(
          value: SongItemMenuAction.addToPlaylist,
          label: context.localization.addToPlaylist,
          icon: Icons.playlist_add_rounded,
          iconColor: Colors.green,
        ),
      if (showShare)
        AppPopupMenuEntry(
          value: SongItemMenuAction.share,
          label: context.localization.share,
          icon: Icons.share_rounded,
          iconColor: Colors.blue,
        ),
      AppPopupMenuEntry(
        value: SongItemMenuAction.delete,
        label: context.localization.deleteFromDevice,
        icon: Icons.delete_rounded,
        isDestructive: true,
      ),
      AppPopupMenuEntry(
        value: SongItemMenuAction.setAsRingtone,
        label: context.localization.setAsRingtone,
        icon: Icons.music_note_rounded,
        iconColor: Colors.blue,
      ),
    ];

    return AppPopupMenuButton<SongItemMenuAction>(
      items: items,
      tooltip: context.localization.moreOptions,
      isHighlighted: isCurrentTrack,
      highlightColor: context.theme.colorScheme.primary,
      onSelected: (action) {
        switch (action) {
          case SongItemMenuAction.addToPlaylist:
            onAddToPlaylist?.call();
            return;
          case SongItemMenuAction.removeFromPlaylist:
            onRemoveFromPlaylist?.call();
            return;
          case SongItemMenuAction.share:
            onShare?.call();
            return;
          case SongItemMenuAction.delete:
            onDelete?.call();
            return;
          case SongItemMenuAction.setAsRingtone:
            onSetAsRingtone?.call();
            return;
        }
      },
    );
  }
}
