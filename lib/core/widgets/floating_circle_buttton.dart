import 'package:flutter/material.dart';
import 'package:music_player/extensions/context_ex.dart';

class FloatingAddButton extends StatelessWidget {
  const FloatingAddButton({
    required this.onPressed,
    this.icon = Icons.add,
    super.key,
    this.radius = 30,
  });

  final double radius;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FloatingActionButton(
      backgroundColor: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      onPressed: onPressed,
      tooltip: context.localization.createPlaylist,
      child: Icon(
        icon,
        color: theme.colorScheme.primary,
        size: 38,
      ),
    );
  }
}
