import 'package:flutter/material.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/songs/domain/enums/enums.dart';

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
      SongsSortType.dateAdded,
      SongsSortType.duration,
      SongsSortType.size,
      SongsSortType.title,
      SongsSortType.album,
      SongsSortType.artist,
    ];
    final labels = [
      context.localization.dateAdded,
      context.localization.duration,
      context.localization.size,
      context.localization.title,
      context.localization.album,
      context.localization.artist,
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
