import 'package:flutter/material.dart';
import 'package:music_player/core/constants/constants.dart';
import 'package:music_player/core/widgets/app_state_view.dart';
import 'package:music_player/extensions/extensions.dart';

/// Empty state widget shown when no songs are available.
///
/// Displays:
/// - Empty state image
/// - Customizable message text
/// - Optional refresh button
class NoSongsWidget extends StatelessWidget {
  const NoSongsWidget({
    super.key,
    this.title,
    this.message,
    this.eyebrow,
    this.onRefresh,
    this.actionLabel,
  });

  final String? title;
  final String? message;
  final String? eyebrow;
  final VoidCallback? onRefresh;
  final String? actionLabel;

  @override
  Widget build(BuildContext context) {
    return AppStateView(
      eyebrow: eyebrow,
      title: title ?? context.localization.emptyLibraryTitle,
      message: message ?? context.localization.emptyLibraryMessage,
      actionLabel: onRefresh != null
          ? actionLabel ?? context.localization.refresh
          : null,
      onAction: onRefresh,
      illustration: Image.asset(
        ImageAssets.emptySongs,
        width: 72,
      ),
    );
  }
}
