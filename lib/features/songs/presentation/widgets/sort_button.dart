import 'package:flutter/material.dart';
import 'package:music_player/core/widgets/widgets.dart';
import 'package:music_player/extensions/extensions.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 2,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 3,
        children: [
          const Icon(Icons.sort_rounded),
          Text(
            context.localization.sortSongs,
            style: context.theme.textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}
