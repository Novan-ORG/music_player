import 'package:flutter/material.dart';
import 'package:music_player/core/widgets/widgets.dart';
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
    final theme = context.theme;
    final selectionColor = theme.colorScheme.primary;
    final selectedLabel =
        selectedCount == 1 ||
            Localizations.localeOf(context).languageCode == 'fa'
        ? context.localization.song
        : context.localization.songs;

    return GlassCard(
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          selectionColor.withValues(alpha: 0.1),
          theme.colorScheme.surface.withValues(alpha: 0.94),
        ],
      ),
      borderColor: selectionColor.withValues(alpha: 0.12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selectionColor.withValues(alpha: 0.12),
            ),
            child: Icon(
              isAllSelected ? Icons.done_all_rounded : Icons.checklist_rounded,
              color: selectionColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$selectedCount '
                  '$selectedLabel '
                  '${context.localization.selected}',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$totalCount ${context.localization.songs}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.64),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          FilledButton.tonalIcon(
            onPressed: isAllSelected ? onDeselectAll : onSelectAll,
            icon: Icon(
              isAllSelected
                  ? Icons.remove_done_rounded
                  : Icons.select_all_rounded,
              size: 18,
            ),
            label: Text(
              isAllSelected
                  ? context.localization.deselectAll
                  : context.localization.selectAll,
            ),
            style: FilledButton.styleFrom(
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              textStyle: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
