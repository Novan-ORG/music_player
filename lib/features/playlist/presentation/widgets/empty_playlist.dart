import 'package:flutter/material.dart';
import 'package:music_player/core/constants/image_assets.dart';
import 'package:music_player/core/widgets/app_state_view.dart';
import 'package:music_player/extensions/extensions.dart';

class EmptyPlaylist extends StatelessWidget {
  const EmptyPlaylist({
    super.key,
    this.title,
    this.message,
    this.onAddPressed,
  });

  final String? title;
  final String? message;
  final VoidCallback? onAddPressed;

  @override
  Widget build(BuildContext context) {
    return AppStateView(
      eyebrow: context.localization.playlists,
      title: title ?? context.localization.emptyPlaylistsTitle,
      message: message ?? context.localization.emptyPlaylistsMessage,
      illustration: Image.asset(
        ImageAssets.emptyPlaylists,
        width: 84,
      ),
      actionLabel: onAddPressed != null
          ? context.localization.createFirstPlaylist
          : null,
      onAction: onAddPressed,
      actionIcon: Icons.playlist_add_rounded,
      accentColor: const Color(0xFF00BFA6),
    );
  }
}
