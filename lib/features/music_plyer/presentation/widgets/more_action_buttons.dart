import 'package:flutter/material.dart';

class MoreActionButtons extends StatelessWidget {
  const MoreActionButtons({
    super.key,
    this.onAddToPlaylistPressed,
    this.onMusicQueuePressed,
  });

  final VoidCallback? onAddToPlaylistPressed;
  final VoidCallback? onMusicQueuePressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.playlist_add_outlined),
          onPressed: onAddToPlaylistPressed,
        ),
        IconButton(
          onPressed: onMusicQueuePressed,
          icon: const Icon(Icons.queue_music_rounded),
        ),
      ],
    );
  }
}
