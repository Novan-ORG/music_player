import 'package:flutter/material.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/songs/presentation/helpers/helpers.dart';
import 'package:music_player/features/songs/presentation/widgets/widgets.dart';

typedef OnSortSongsCallback = void Function(SortType);

class SongsAppbar extends StatelessWidget implements PreferredSizeWidget {
  const SongsAppbar({
    required this.numOfSongs,
    required this.sortType,
    this.onSortSongs,
    this.onSearchButtonPressed,
    this.onShuffleAll,
    super.key,
  });

  final int numOfSongs;
  final SortType sortType;
  final VoidCallback? onShuffleAll;
  final OnSortSongsCallback? onSortSongs;
  final VoidCallback? onSearchButtonPressed;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight * 2);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: SongsPageConstants.appBarColor,
      elevation: 0,
      title: Text(
        context.localization.allSongs,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: SongsPageConstants.appBarFontSize,
          letterSpacing: SongsPageConstants.appBarLetterSpacing,
        ),
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
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Column(
          children: [
            TopHeadActions(
              songCount: numOfSongs,
              onShuffleAll: onShuffleAll,
              onSortSongs: onSortSongs,
              sortType: sortType,
            ),
          ],
        ),
      ),
    );
  }
}
