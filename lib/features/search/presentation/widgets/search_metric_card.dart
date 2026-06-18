import 'package:flutter/material.dart';
import 'package:music_player/extensions/extensions.dart';

class SearchMetricCard extends StatelessWidget {
  const SearchMetricCard({
    required this.icon,
    required this.value,
    required this.label,
    this.compact = false,
    this.isAccent = false,
    super.key,
  });

  final IconData icon;
  final String value;
  final String label;
  final bool compact;
  final bool isAccent;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Container(
      constraints: BoxConstraints(minWidth: compact ? 104 : 116),
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 12 : 14,
        vertical: compact ? 10 : 12,
      ),
      decoration: BoxDecoration(
        color: isAccent
            ? theme.colorScheme.primary.withValues(alpha: 0.12)
            : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 6,
        children: [
          Icon(
            icon,
            color: isAccent
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface.withValues(alpha: 0.76),
            size: compact ? 16 : 18,
          ),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: isAccent
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.58),
            ),
          ),
        ],
      ),
    );
  }
}
