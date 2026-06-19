import 'package:flutter/material.dart';
import 'package:music_player/core/widgets/app_state_view.dart';
import 'package:music_player/extensions/extensions.dart';

class FavoriteEmptyWidget extends StatelessWidget {
  const FavoriteEmptyWidget({
    super.key,
    this.onRefresh,
    this.maxWidth = 820,
  });

  final VoidCallback? onRefresh;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return AppStateView(
      eyebrow: context.localization.favoriteSongs,
      title: context.localization.noFavoriteSong,
      message: context.localization.favoriteSongsPage,
      actionLabel: context.localization.refresh,
      onAction: onRefresh,
      accentColor: context.theme.colorScheme.primary,
      illustration: Icon(
        Icons.favorite_border_rounded,
        size: 54,
        color: context.theme.colorScheme.primary,
      ),
      maxWidth: maxWidth,
    );
  }
}
