import 'package:flutter/material.dart';
import 'package:music_player/core/constants/image_assets.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/songs/domain/enums/enums.dart';

typedef OnSortSongsCallback = void Function(SongsSortType);

class PlaylistAppbar extends StatelessWidget implements PreferredSizeWidget {
  const PlaylistAppbar({
    this.onSearchButtonPressed,
    super.key,
  });

  final VoidCallback? onSearchButtonPressed;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
            onTap: onSearchButtonPressed,
            child: Image.asset(
              ImageAssets.search,
              color: isDark ? Colors.white : Colors.black,
              height: 18,
              width: 18,
            ),
          ),
        ),
      ],
    );
  }
}
