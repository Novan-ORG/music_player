import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_player/core/widgets/songs_count.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/songs/presentation/widgets/songs_appbar.dart';

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
    required this.songCount,
    required this.onShuffleAll,
    required this.onSortSongs,
    required this.sortType,
    super.key,
  });

  final int songCount;
  final VoidCallback? onShuffleAll;
  final OnSortSongsCallback? onSortSongs;
  final SortType sortType;

  String _sortTypeLabel(BuildContext context, SortType type) {
    switch (type) {
      case SortType.recentlyAdded:
        return context.localization.recent;
      case SortType.dateAdded:
        return context.localization.dateAdded;
      case SortType.duration:
        return context.localization.duration;
      case SortType.size:
        return context.localization.size;
      case SortType.ascendingOrder:
        return context.localization.ascending;
      case SortType.descendingOrder:
        return context.localization.descending;
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
        return FontAwesomeIcons.arrowUpAZ;
      case SortType.descendingOrder:
        return FontAwesomeIcons.arrowDownAZ;
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
          SongsCount(songCount: songCount),
          const Spacer(),
          Tooltip(
            message: context.localization.shuffleAllSongs,
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
            tooltip: context.localization.sortSongs,
            icon: Row(
              children: [
                Icon(_sortTypeIcon(sortType), color: theme.primaryColor),
                const SizedBox(width: 4),
                Text(
                  _sortTypeLabel(context, sortType),
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
                    Text(_sortTypeLabel(context, SortType.recentlyAdded)),
                  ],
                ),
              ),
              PopupMenuItem<SortType>(
                value: SortType.dateAdded,
                child: Row(
                  children: [
                    Icon(_sortTypeIcon(SortType.dateAdded)),
                    const SizedBox(width: 8),
                    Text(_sortTypeLabel(context, SortType.dateAdded)),
                  ],
                ),
              ),
              PopupMenuItem<SortType>(
                value: SortType.duration,
                child: Row(
                  children: [
                    Icon(_sortTypeIcon(SortType.duration)),
                    const SizedBox(width: 8),
                    Text(_sortTypeLabel(context, SortType.duration)),
                  ],
                ),
              ),
              PopupMenuItem<SortType>(
                value: SortType.size,
                child: Row(
                  children: [
                    Icon(_sortTypeIcon(SortType.size)),
                    const SizedBox(width: 8),
                    Text(_sortTypeLabel(context, SortType.size)),
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
                    Text(_sortTypeLabel(context, SortType.ascendingOrder)),
                  ],
                ),
              ),
              PopupMenuItem<SortType>(
                value: SortType.descendingOrder,
                child: Row(
                  children: [
                    Icon(_sortTypeIcon(SortType.descendingOrder)),
                    const SizedBox(width: 8),
                    Text(_sortTypeLabel(context, SortType.descendingOrder)),
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
