import 'package:flutter/material.dart';
import 'package:music_player/core/constants/constants.dart';
import 'package:music_player/core/widgets/app_state_view.dart';
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
    this.title,
    this.message,
    this.eyebrow,
    this.onRetry,
  });
  final String? title;
  final String? message;
  final String? eyebrow;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return AppStateView(
      eyebrow: eyebrow ?? context.localization.error,
      accentColor: context.theme.colorScheme.error,
      title: title ?? context.localization.libraryLoadErrorTitle,
      message: message ?? context.localization.libraryLoadErrorMessage,
      actionLabel: onRetry != null ? context.localization.retry : null,
      onAction: onRetry,
      illustration: Image.asset(
        ImageAssets.errorLoadSongs,
        width: 74,
      ),
    );
  }
}
