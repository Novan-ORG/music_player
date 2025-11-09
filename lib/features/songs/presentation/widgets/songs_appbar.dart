import 'package:flutter/material.dart';
import 'package:music_player/core/domain/enums/enums.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/songs/presentation/constants/constants.dart';

typedef OnSortSongsCallback = void Function(SongsSortType);

class SongsAppbar extends StatelessWidget implements PreferredSizeWidget {
  const SongsAppbar({
    required this.numOfSongs,
    this.onSearchButtonPressed,
    super.key,
  });

  final int numOfSongs;
  final VoidCallback? onSearchButtonPressed;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: Text(
        context.localization.allSongs(numOfSongs),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: onSearchButtonPressed,
          tooltip: context.localization.searchSongs,
          icon: const Icon(
            Icons.search,
            size: SongsPageConstants.searchIconSize,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
