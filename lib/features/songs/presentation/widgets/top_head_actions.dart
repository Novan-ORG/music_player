import 'package:flutter/material.dart';

typedef OnSortSongs = void Function(SortType sortType);

enum SortType {
  recentlyAdded,
  dateAdded,
  duration,
  size,
  ascendingOrder,
  descendingOrder,
}

class TopHeadActions extends StatelessWidget {
  const TopHeadActions({
    super.key,
    required this.songCount,
    required this.onShuffleAll,
    required this.onSortSongs,
    required this.sortType,
  });

  final int songCount;
  final VoidCallback onShuffleAll;
  final OnSortSongs onSortSongs;
  final SortType sortType;

  String _sortTypeLabel(SortType type) {
    switch (type) {
      case SortType.recentlyAdded:
        return 'Recent';
      case SortType.dateAdded:
        return 'Date Added';
      case SortType.duration:
        return 'Duration';
      case SortType.size:
        return 'Size';
      case SortType.ascendingOrder:
        return 'Ascending';
      case SortType.descendingOrder:
        return 'Descending';
    }
  }

  IconData _sortTypeIcon(SortType type) {
    switch (type) {
      case SortType.recentlyAdded:
        return Icons.fiber_new;
      case SortType.dateAdded:
        return Icons.event;
      case SortType.duration:
        return Icons.timer;
      case SortType.size:
        return Icons.sd_storage;
      case SortType.ascendingOrder:
        return Icons.arrow_upward;
      case SortType.descendingOrder:
        return Icons.arrow_downward;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.cardColor,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Row(
            children: [
              Icon(Icons.library_music, color: theme.primaryColor),
              const SizedBox(width: 8),
              Text(
                'Songs: $songCount',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Spacer(),
          Tooltip(
            message: 'Shuffle All Songs',
            child: IconButton(
              style: IconButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                backgroundColor: theme.colorScheme.secondaryContainer,
                foregroundColor: theme.colorScheme.onSecondaryContainer,
              ),
              icon: const Icon(Icons.shuffle),
              onPressed: onShuffleAll,
            ),
          ),
          const Spacer(),
          PopupMenuButton<SortType>(
            initialValue: sortType,
            padding: EdgeInsets.zero,
            menuPadding: EdgeInsets.zero,
            tooltip: 'Sort Songs',
            icon: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Icon(_sortTypeIcon(sortType), color: theme.primaryColor),
                const SizedBox(width: 4),
                Text(
                  _sortTypeLabel(sortType),
                  style: theme.textTheme.titleSmall,
                ),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
            onSelected: onSortSongs,
            itemBuilder: (BuildContext context) => <PopupMenuEntry<SortType>>[
              PopupMenuItem<SortType>(
                value: SortType.recentlyAdded,
                child: Row(
                  children: [
                    Icon(_sortTypeIcon(SortType.recentlyAdded)),
                    const SizedBox(width: 8),
                    Text(_sortTypeLabel(SortType.recentlyAdded)),
                  ],
                ),
              ),
              PopupMenuItem<SortType>(
                value: SortType.dateAdded,
                child: Row(
                  children: [
                    Icon(_sortTypeIcon(SortType.dateAdded)),
                    const SizedBox(width: 8),
                    Text(_sortTypeLabel(SortType.dateAdded)),
                  ],
                ),
              ),
              PopupMenuItem<SortType>(
                value: SortType.duration,
                child: Row(
                  children: [
                    Icon(_sortTypeIcon(SortType.duration)),
                    const SizedBox(width: 8),
                    Text(_sortTypeLabel(SortType.duration)),
                  ],
                ),
              ),
              PopupMenuItem<SortType>(
                value: SortType.size,
                child: Row(
                  children: [
                    Icon(_sortTypeIcon(SortType.size)),
                    const SizedBox(width: 8),
                    Text(_sortTypeLabel(SortType.size)),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem<SortType>(
                value: SortType.ascendingOrder,
                child: Row(
                  children: [
                    Icon(_sortTypeIcon(SortType.ascendingOrder)),
                    const SizedBox(width: 8),
                    Text(_sortTypeLabel(SortType.ascendingOrder)),
                  ],
                ),
              ),
              PopupMenuItem<SortType>(
                value: SortType.descendingOrder,
                child: Row(
                  children: [
                    Icon(_sortTypeIcon(SortType.descendingOrder)),
                    const SizedBox(width: 8),
                    Text(_sortTypeLabel(SortType.descendingOrder)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
