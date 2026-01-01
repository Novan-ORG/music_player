import 'package:flutter/material.dart';
import 'package:music_player/core/widgets/widgets.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/songs/domain/entities/entities.dart';
import 'package:music_player/features/songs/domain/enums/enums.dart';

class SongsSortBottomSheet extends StatelessWidget {
  const SongsSortBottomSheet._(
    this.selectedSortConfig,
  );

  final SortConfig selectedSortConfig;

  static Future<SortConfig?> show({
    required BuildContext context,
    SortConfig selectedSortConfig = const SortConfig(),
  }) {
    return showModalBottomSheet<SortConfig>(
      context: context,
      builder: (_) => SongsSortBottomSheet._(selectedSortConfig),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetBaseWidget(
      title: context.localization.sortSongs,
      body: Column(
        children: [
          ...SongsSortType.values.map(
            (sortType) {
              final isSelected = sortType == selectedSortConfig.sortType;
              return ListTile(
                leading: Icon(
                  sortType.toIconData(),
                  color: isSelected ? context.theme.primaryColor : null,
                ),
                title: Text(
                  sortType.toLocalizationString(context),
                  style: context.theme.textTheme.bodyLarge?.copyWith(
                    color: isSelected ? context.theme.primaryColor : null,
                  ),
                ),
                trailing: isSelected
                    ? Icon(Icons.check, color: context.theme.primaryColor)
                    : null,
                onTap: () {
                  Navigator.of(context).pop(
                    selectedSortConfig.copyWith(
                      sortType: sortType,
                    ),
                  );
                },
              );
            },
          ),
          const Divider(),
          ...SortOrderType.values.map(
            (sortOrderType) {
              final isSelected = sortOrderType == selectedSortConfig.orderType;
              return ListTile(
                leading: Icon(
                  sortOrderType.toIconData(),
                  color: isSelected ? context.theme.primaryColor : null,
                ),
                title: Text(
                  sortOrderType.toLocalizationString(context),
                  style: context.theme.textTheme.bodyLarge?.copyWith(
                    color: isSelected ? context.theme.primaryColor : null,
                  ),
                ),
                trailing: isSelected
                    ? Icon(Icons.check, color: context.theme.primaryColor)
                    : null,
                onTap: () {
                  Navigator.of(
                    context,
                  ).pop(selectedSortConfig.copyWith(orderType: sortOrderType));
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
