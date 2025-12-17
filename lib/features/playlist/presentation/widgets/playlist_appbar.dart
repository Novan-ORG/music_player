import 'package:flutter/material.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/songs/domain/enums/enums.dart';

typedef OnSortSongsCallback = void Function(SongsSortType);

class PlaylistAppbar extends StatelessWidget implements PreferredSizeWidget {
  const PlaylistAppbar({
    this.onActionPressed,
    super.key,
  });

  final VoidCallback? onActionPressed;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      elevation: 0,
      title: Text(
        context.localization.playlists,
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 24, top: 2),
          child: GestureDetector(
            onTap: onActionPressed,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                Icons.add,
                color: theme.colorScheme.primary,
                size: 28,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
