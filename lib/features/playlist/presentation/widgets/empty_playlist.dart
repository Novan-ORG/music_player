import 'package:flutter/material.dart';
import 'package:music_player/core/constants/image_assets.dart';

class EmptyPlaylist extends StatelessWidget {
  const EmptyPlaylist({
    super.key,
    this.message = 'No playlist in your library',
    this.onAddPressed,
  });

  final String message;
  final VoidCallback? onAddPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            ImageAssets.emptyPlaylists,
            width: 97,
          ),
          const SizedBox(height: 20),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(
                alpha: 0.8,
              ),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Your library is empty',
            textAlign: TextAlign.center,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(
                alpha: 0.8,
              ),
            ),
          ),
          // ElevatedButton.icon(
          //   icon: const Icon(Icons.add),
          //   label: Text(context.localization.createFirstPlaylist),
          //   onPressed: onAddPressed,
          //   style: ElevatedButton.styleFrom(
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(8),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
