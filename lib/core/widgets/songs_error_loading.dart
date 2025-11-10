import 'package:flutter/material.dart';
import 'package:music_player/core/constants/constants.dart';
import 'package:music_player/extensions/extensions.dart';

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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          ImageAssets.errorLoadSongs,
          width: 85,
        ),
        const SizedBox(height: 16),
        Text(
          message,
          style: context.theme.textTheme.titleMedium?.copyWith(
            color: Colors.grey,
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
    );
  }
}
