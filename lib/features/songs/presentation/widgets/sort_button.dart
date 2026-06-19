import 'package:flutter/material.dart';
import 'package:music_player/core/widgets/widgets.dart';
import 'package:music_player/extensions/extensions.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({
    super.key,
    this.onTap,
    this.iconOnly = false,
  });

  final VoidCallback? onTap;
  final bool iconOnly;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final content = iconOnly
        ? Icon(
            Icons.tune_rounded,
            size: 18,
            color: theme.colorScheme.primary,
          )
        : Row(
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
          );

    return Tooltip(
      message: context.localization.sortSongs,
      child: GlassCard(
        onTap: onTap,
        borderRadius: const BorderRadius.all(Radius.circular(18)),
        padding: EdgeInsets.symmetric(
          horizontal: iconOnly ? 11 : 12,
          vertical: 9,
        ),
        child: content,
      ),
    );
  }
}
