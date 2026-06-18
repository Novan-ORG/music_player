import 'package:flutter/material.dart';
import 'package:music_player/core/widgets/widgets.dart';
import 'package:music_player/extensions/extensions.dart';

class SelectionMoreButton extends StatelessWidget {
  const SelectionMoreButton({
    required this.onAddToPlaylist,
    required this.onDelete,
    required this.onShare,
    required this.selectedCount,
    super.key,
  });

  final VoidCallback onAddToPlaylist;
  final VoidCallback onDelete;
  final VoidCallback onShare;
  final int selectedCount;

  @override
  Widget build(BuildContext context) {
    return AppPopupMenuButton<_SelectionAction>(
      compact: true,
      enabled: selectedCount > 0,
      tooltip: context.localization.moreOptions,
      items: [
        AppPopupMenuEntry(
          value: _SelectionAction.addToPlaylist,
          label: context.localization.addToPlaylist,
          icon: Icons.playlist_add_rounded,
          iconColor: Colors.green,
        ),
        AppPopupMenuEntry(
          value: _SelectionAction.share,
          label: context.localization.share,
          icon: Icons.share_rounded,
          iconColor: Colors.blue,
        ),
        AppPopupMenuEntry(
          value: _SelectionAction.delete,
          label: context.localization.delete,
          icon: Icons.delete_outline_rounded,
          isDestructive: true,
        ),
      ],
      onSelected: (value) {
        switch (value) {
          case _SelectionAction.addToPlaylist:
            onAddToPlaylist();
            return;
          case _SelectionAction.share:
            onShare();
            return;
          case _SelectionAction.delete:
            onDelete();
            return;
        }
      },
    );
  }
}

enum _SelectionAction {
  addToPlaylist,
  share,
  delete,
}
