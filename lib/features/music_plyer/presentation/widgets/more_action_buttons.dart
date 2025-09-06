import 'package:flutter/material.dart';

class MoreActionButtons extends StatelessWidget {
  const MoreActionButtons({super.key, this.onAddToPlaylistPressed});

  final VoidCallback? onAddToPlaylistPressed;

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
          icon: const Icon(Icons.lyrics),
          onPressed: () {
            // Handle lyrics action
          },
        ),
      ],
    );
  }
}
