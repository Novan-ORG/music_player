import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Songs: $songCount'),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.shuffle),
          onPressed: onShuffleAll,
          tooltip: 'Shuffle All Songs',
        ),
        PopupMenuButton<SortType>(
          icon: const Icon(Icons.sort),
          onSelected: onSortSongs,
          itemBuilder: (BuildContext context) => <PopupMenuEntry<SortType>>[
            PopupMenuItem<SortType>(
              value: SortType.recentlyAdded,
              child: Text('Recently Added'),
            ),
            PopupMenuItem<SortType>(
              value: SortType.dateAdded,
              child: Text('Date Added'),
            ),
            PopupMenuItem<SortType>(
              value: SortType.duration,
              child: Text('Duration'),
            ),
            PopupMenuItem<SortType>(value: SortType.size, child: Text('Size')),
            const PopupMenuDivider(),
            PopupMenuItem<SortType>(
              value: SortType.ascendingOrder,
              child: Text('Ascending Order'),
            ),
            PopupMenuItem<SortType>(
              value: SortType.descendingOrder,
              child: Text('Descending Order'),
            ),
          ],
        ),
      ],
    );
  }
}
