import 'package:flutter/material.dart';
import 'package:music_player/core/constants/constants.dart';
import 'package:music_player/extensions/extensions.dart';

/// Error state widget displayed when songs fail to load.
///
/// Shows:
/// - Error image placeholder
/// - Error message text
/// - Optional retry button
class SongsErrorLoading extends StatelessWidget {
  const SongsErrorLoading({
    super.key,
    this.message = 'Failed to load songs',
    this.onRetry,
  });
  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            ImageAssets.errorLoadSongs,
            width: 97,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(
                alpha: 0.8,
              ),
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: Text(context.localization.retry),
            ),
          ],
        ],
      ),
    );
  }
}
