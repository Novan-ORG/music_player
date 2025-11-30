import 'package:flutter/material.dart';
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
    return PopupMenuButton(
      enabled: selectedCount > 0,
      icon: const Icon(Icons.more_vert),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'add_to_playlist',
          child: Row(
            children: [
              const Icon(Icons.playlist_add, color: Colors.green),
              const SizedBox(width: 8),
              Text(context.localization.addToPlaylist),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'share',
          child: Row(
            children: [
              const Icon(Icons.share),
              const SizedBox(width: 8),
              Text(context.localization.share),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              const Icon(Icons.delete),
              const SizedBox(width: 8),
              Text(context.localization.delete),
            ],
          ),
        ),
      ],
      onSelected: (value) {
        switch (value) {
          case 'add_to_playlist':
            onAddToPlaylist();
          case 'share':
            onShare();
          case 'delete':
            onDelete();
        }
      },
    );
  }
}
