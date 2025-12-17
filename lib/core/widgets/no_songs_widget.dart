import 'package:flutter/material.dart';
import 'package:music_player/core/constants/constants.dart';
import 'package:music_player/extensions/extensions.dart';

class NoSongsWidget extends StatelessWidget {
  const NoSongsWidget({
    super.key,
    this.message = 'No Songs in Your Library',
    this.onRefresh,
  });

  final String message;
  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            ImageAssets.emptySongs,
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
            'Your music library is empty',
            textAlign: TextAlign.center,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(
                alpha: 0.8,
              ),
            ),
          ),
          if (onRefresh != null) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRefresh,
              icon: const Icon(Icons.refresh),
              label: Text(context.localization.refresh),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
