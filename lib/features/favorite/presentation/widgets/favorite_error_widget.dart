import 'package:flutter/material.dart';
import 'package:music_player/core/widgets/app_state_view.dart';
import 'package:music_player/extensions/extensions.dart';

class FavoriteErrorWidget extends StatelessWidget {
  const FavoriteErrorWidget({
    required this.message,
    super.key,
    this.onRetry,
    this.maxWidth = 820,
  });

  final String message;
  final VoidCallback? onRetry;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return AppStateView(
      eyebrow: context.localization.favoriteSongs,
      title: context.localization.libraryLoadErrorTitle,
      message: message,
      actionLabel: context.localization.refresh,
      onAction: onRetry,
      accentColor: context.theme.colorScheme.error,
      illustration: Icon(
        Icons.error_outline_rounded,
        size: 54,
        color: context.theme.colorScheme.error,
      ),
      maxWidth: maxWidth,
    );
  }
}
