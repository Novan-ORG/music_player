import 'package:flutter/material.dart';
import 'package:music_player/extensions/extensions.dart';

class SelectionActionBar extends StatelessWidget {
  const SelectionActionBar({
    required this.selectedCount,
    required this.totalCount,
    required this.onAddToPlaylist,
    required this.onDelete,
    required this.onShare,
    required this.onSelectAll,
    required this.onDeselectAll,
    required this.onClearSelection,
    this.onRemoveFromPlaylist,
    this.isInPlaylist = false,
    super.key,
  });

  final int selectedCount;
  final int totalCount;
  final VoidCallback onAddToPlaylist;
  final VoidCallback? onRemoveFromPlaylist;
  final VoidCallback onDelete;
  final VoidCallback onShare;
  final VoidCallback onSelectAll;
  final VoidCallback onDeselectAll;
  final VoidCallback onClearSelection;
  final bool isInPlaylist;

  bool get isAllSelected => selectedCount == totalCount && totalCount > 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: onClearSelection,
            tooltip: 'Clear selection',
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$selectedCount ${context.localization.song}'
              '${selectedCount > 1 ? context.localization.s : ''} '
              '${context.localization.selected}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: IconButton(
              key: ValueKey(isAllSelected),
              icon: Icon(
                isAllSelected ? Icons.deselect : Icons.select_all,
              ),
              onPressed: isAllSelected ? onDeselectAll : onSelectAll,
              tooltip: isAllSelected ? 'Deselect all' : 'Select all',
            ),
          ),
          PopupMenuButton(
            enabled: selectedCount > 0,
            itemBuilder: (context) => [
              if (isInPlaylist)
                PopupMenuItem(
                  value: 'remove_from_playlist',
                  child: Row(
                    children: [
                      const Icon(Icons.playlist_remove, color: Colors.orange),
                      const SizedBox(width: 8),
                      Text(context.localization.removeFromPlaylist),
                    ],
                  ),
                )
              else
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
                case 'remove_from_playlist':
                  onRemoveFromPlaylist?.call();
                case 'share':
                  onShare();
                case 'delete':
                  onDelete();
              }
            },
          ),
        ],
      ),
    );
  }
}
