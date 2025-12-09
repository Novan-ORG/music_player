import 'package:flutter/material.dart';
import 'package:music_player/extensions/extensions.dart';

class CategoryTabbar extends StatelessWidget {
  const CategoryTabbar({
    required this.tabController,
    super.key,
    this.onTabChanged,
  });

  final TabController tabController;
  final void Function(int index)? onTabChanged;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final labels = [
      context.localization.albums,
      context.localization.artists,
      context.localization.allSongs,
    ];

    return TabBar(
      controller: tabController,
      onTap: (index) => onTabChanged?.call(index),
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
    );
  }
}
