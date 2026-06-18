import 'package:flutter/material.dart';
import 'package:music_player/core/widgets/widgets.dart';
import 'package:music_player/extensions/extensions.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return GlassCard(
      onTap: onTap,
      borderRadius: const BorderRadius.all(Radius.circular(18)),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 9,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 7,
        children: [
          Icon(
            Icons.tune_rounded,
            size: 18,
            color: theme.colorScheme.primary,
          ),
          Text(
            context.localization.sortSongs,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
