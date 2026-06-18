import 'package:flutter/material.dart';
import 'package:music_player/extensions/extensions.dart';

class SearchActionButton extends StatelessWidget {
  const SearchActionButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.compact = false,
    this.isAccent = false,
    super.key,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final bool compact;
  final bool isAccent;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Tooltip(
      message: tooltip,
      child: IconButton.filledTonal(
        onPressed: onPressed,
        icon: Icon(icon),
        style: IconButton.styleFrom(
          minimumSize: Size.square(compact ? 40 : 44),
          backgroundColor: isAccent
              ? theme.colorScheme.primary.withValues(alpha: 0.12)
              : theme.colorScheme.surface,
          foregroundColor: isAccent
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurface.withValues(alpha: 0.78),
          elevation: 0,
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
