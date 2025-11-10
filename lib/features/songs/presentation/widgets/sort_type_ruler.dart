import 'package:flutter/material.dart';
import 'package:music_player/core/domain/enums/enums.dart';
import 'package:music_player/extensions/extensions.dart';

class SortTypeRuler extends StatelessWidget {
  const SortTypeRuler({
    required this.currentSortType,
    super.key,
    this.onSortTypeChanged,
  });

  final SongsSortType currentSortType;
  final void Function(SongsSortType sortType)? onSortTypeChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sortTypes = [
      SongsSortType.recentlyAdded,
      SongsSortType.dateAdded,
      SongsSortType.duration,
      SongsSortType.size,
    ];
    final labels = [
      context.localization.recent,
      context.localization.dateAdded,
      context.localization.duration,
      context.localization.size,
    ];

    return DefaultTabController(
      length: sortTypes.length,
      initialIndex: sortTypes.indexOf(currentSortType),
      child: TabBar(
        onTap: (index) => onSortTypeChanged?.call(sortTypes[index]),
        indicatorWeight: 3,
        dividerHeight: 1.5,
        labelColor: theme.primaryColor,
        unselectedLabelColor: theme.textTheme.bodyMedium?.color?.withValues(
          alpha: 0.7,
        ),
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        tabs: labels.map((label) => Tab(text: label)).toList(),
      ),
    );
  }
}
