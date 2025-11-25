import 'package:flutter/material.dart';
import 'package:music_player/extensions/extensions.dart';

class SelectionActionBar extends StatelessWidget {
  const SelectionActionBar({
    required this.selectedCount,
    required this.totalCount,
    required this.onSelectAll,
    required this.onDeselectAll,
    super.key,
  });

  final int selectedCount;
  final int totalCount;
  final VoidCallback onSelectAll;
  final VoidCallback onDeselectAll;

  bool get isAllSelected => selectedCount == totalCount && totalCount > 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.only(left: 8),
      decoration: BoxDecoration(
        color: context.theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: context.theme.colorScheme.surface,
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
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
          Row(
            children: [
              Text(
                isAllSelected
                    ? context.localization.deselectAll
                    : context.localization.selectAll,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Checkbox(
                value: isAllSelected,
                onChanged: (value) {
                  if (isAllSelected) {
                    onDeselectAll();
                  } else {
                    onSelectAll();
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
