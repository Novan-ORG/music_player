import 'package:flutter/material.dart';
import 'package:music_player/extensions/extensions.dart';

/// Section header widget for grouping related settings.
///
/// Displays a titled header for organizing setting items visually.
class SectionTitle extends StatelessWidget {
  const SectionTitle({required this.title, super.key});
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4, right: 4),
      child: Text(
        title,
        style: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.58),
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
