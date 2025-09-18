import 'package:flutter/material.dart';

class MoreActionButtons extends StatelessWidget {
  const MoreActionButtons({
    super.key,
    this.onAddToPlaylistPressed,
    this.onSharePressed,
    this.onMusicQueuePressed,
  });

  final VoidCallback? onAddToPlaylistPressed;
  final VoidCallback? onSharePressed;
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
          icon: Icon(Icons.queue_music_rounded),
        ),
        IconButton(icon: const Icon(Icons.share), onPressed: onSharePressed),
      ],
    );
  }
}
