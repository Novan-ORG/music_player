import 'package:flutter/material.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/songs/domain/enums/enums.dart';

typedef OnSortSongsCallback = void Function(SongsSortType);

class SongsAppbar extends StatelessWidget implements PreferredSizeWidget {
  const SongsAppbar({
    this.onSearchButtonPressed,
    super.key,
  });

  final VoidCallback? onSearchButtonPressed;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: Text(
        context.localization.appTitle,
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: onSearchButtonPressed,
          tooltip: context.localization.searchSongs,
          icon: const Icon(
            Icons.search,
          ),
        ).paddingSymmetric(horizontal: 6),
      ],
    );
  }
}
